# ###-->ZZZ_IMAGE<--###  

[`###-->ZZZ_IMAGE<--###`][1] is a [docker][2] image that bundles the following:  
* **[Syncthing v###-->ZZZ_SYNCTHING_VERSION<--###][3]:** Syncthing replaces proprietary sync and cloud services with something open, trustworthy and decentralized. Your data is your data alone and you deserve to choose where it is stored, if it is shared with some third party and how it's transmitted over the Internet..  

## Details
* By default, the container runs as "dev" user (i.e. UID 1000). But the UID/GID can be can be overridden by setting the PUID/PGID environment variables. *Please keep this in mind as you mount volumes!* 
* The following volumes exist (and are owned by dev):  
  - /data
  - /ops
  - /state
  - /config
* /data is your default workdir.   
* ***NOTE:*** If you are not using an existing config.xml, Syncthing will create a config for you.  This is default Syncthing behavior.  

## Usage 
This image can easily be extended.  But to run Syncthing:

````
docker run -it --rm \
	-v $(CURRENT_DIR):/state:rw \
	-v $(PROVISION_CONFIG_DIR):/config:rw \
	-v $(PROVISION_DATA_DIR):/data:rw \
	-p 8384:8384 \
	-p 22000:22000 \
	-e "PGID=$(id -g)" -e "PUID=$(id -u)" \
	###-->ZZZ_IMAGE<--###:###-->ZZZ_SYNCTHING_VERSION<--### -home /config -gui-address=https://0.0.0.0:8384 -no-browser    
		
````

## Misc. Info 
* Latest version: ###-->ZZZ_CURRENT_VERSION<--###  
* Built on: ###-->ZZZ_DATE<--###   
* Base image: ###-->ZZZ_BASE_IMAGE<--###   


[1]: https://hub.docker.com/r/###-->ZZZ_IMAGE<--###/   
[2]: https://docker.com 
[3]: https://syncthing.net/  
