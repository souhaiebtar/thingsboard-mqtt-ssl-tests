# One/Two way ssl test for thingsboard



before starting with this

run those command 
```SHELL
git clone https://github.com/souhaiebtar/thingsboard_cassandra
cd thingsboard_cassandra
mkdir certificate
docker-compose up -d tb cassandra
```

now you should have a thingsboard version running locally, the webui url is `http://localhost:8081` and the mqtt port used is `18832`

now clone the project using

```SHELL
git clone https://github.com/souhaiebtar/thingsboard-mqtt-ssl-tests
cd thingsboard-mqtt-ssl-tests
```

then run `make generate-keys`
copy the file `mqttserver.jks` from the `keyFiles` folder inside `certificate` folder of the `thingsboard_cassandra` folder that we used before.
now from inside `thingsboard_cassandra` folder, run the command `docker cp certificate/mqttserver.jks thingsboard_cassandra_tb_1:/etc/thingsboard/conf/mqttserver.jks`

> N.B: if you got an error when copying file, check the name of the running container( using docker ps) and run the `docker cp ...` command again with the new name,

### How to run one way ssl
create a new Device using the webUI, and under Details->Manage credentials->Access Token
copy/paste `VHmfuIy92oTiRa9pDyvx` (or you can copy the generated token and replace `VHmfuIy92oTiRa9pDyvx` on line '31')

now run `make run-oneway`

using mosquitto_pub

```SHELL
mosquitto_pub -d -h "localhost" -p 1883 --tls-version tlsv1.2 -t "v1/devices/me/telemetry" --cafile mqttserver.pub.pem -u "l5rjpJmZgATHDY4j2aXO" -m \
"{\"4CH1_120\": 4,\"4CH1_121\": 0.02,\"4CH1_130\": 0.02}"
```

### How to run two way ssl

from inside the folder `keyFiles` copy the content of the file `mqttclient.pub.pem` and create/modify a new device using the webUI, and under Details->Manage credentials->choose `X.509 certificate` under credentials type, paste the content that we copied from `mqttclient.pub.pem` and save 

now run `make run-twoway`


> N.B: all of this was tested against the official release 2.0.3 of thingsboard.

> you can generate a **.key** file from *.p12* using: [1][1]

>	```SHELL
> 	openssl pkcs12 -in mqttclient.p12 -nocerts -nodes -out mqttclient.key
> 	``` 

to use open running the following command to test two way ssl

```SHELL
mosquitto_pub -h "127.0.0.1" -p 1883 --tls-version tlsv1.2 -t "v1/devices/me/telemetry" --cafile mqttserver.pub.pem --key mqttclient.key --cert mqttclient.nopass.pem -m '{"temperature":12.3, "humidity":45.6}'
```

[1]: https://serverfault.com/questions/715827/how-to-generate-key-and-crt-file-from-jks-file-for-httpd-apache-server