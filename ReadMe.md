# One way ssl test for thingsboard



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

### How to run two way ssl

from inside the folder `keyFiles` copy the content of the file `mqttclient.pub.pem` and create/modify a new device using the webUI, and under Details->Manage credentials->choose `X.509 certificate` under credentials type, paste the content that we copied from `mqttclient.pub.pem` and save 

now run `make run-twoway`


> N.B: all of this was tested against the official release 2.0.3 of thingsboard.