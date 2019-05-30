SHELL:=/bin/bash
.ONESHELL:

clean: 
		## to supress showing command
		@rm -rf keyFiles mqttclient.nopass.pem mqttserver.pub.pem

generate-keys:
		chmod +x server.keygen.sh
		./server.keygen.sh
		chmod +x client.keygen.sh
		./client.keygen.sh
		mkdir -p keyFiles
		mv -ft keyFiles  mqttclient.jks mqttclient.p12 mqttclient.pub.pem mqttclient.pem mqttserver.cer mqttserver.jks 
		echo "before running 'make run' command, make sure you have already copied mqttserver.jks from keyFiles folder inside your running server"
		echo " also make sure you have a device with a token equal to 'VHmfuIy92oTiRa9pDyvx' inside your running server"
		echo " to note the 'one-way-ssl-mqtt-client.py' connect to localhost on port '18832', all of this can be changed by editing the script in line 31 and 33"

requirements:
		## requirements.txt is generated using `pip freeze > requirements.txt`
		ret=$(shell python -c 'import sys; print("%i" % (sys.hexversion<0x03000000))')
		if [ $$ret -ne 0 ]; then
			pip install -r requirements.txt
		else
			echo "we require python version <3"
			echo "you can install pyenv and use it to create a virtualenvs"
			exit
		fi

run-oneway: requirements
		python one-way-ssl-mqtt-client.py;

run-twoway: requirements
		python two-way-ssl-mqtt-client.py;