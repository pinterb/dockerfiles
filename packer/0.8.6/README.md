# pinterb/packer  

[`pinterb/packer`][1] is a [docker][2] image that bundles the following:  
* **[Packer v0.8.6][3]:** An open source tool for creating identical machine images for multiple platforms from a single source configuration.  
* **[packer-azure][4]:** An Azure plugin for Packer to enable Microsoft Azure users to build custom images given an Azure image.    

## Details
* The container runs as "dev" user (i.e. UID 1000). *Please keep this in mind as you mount volumes!* 
* The following volumes exist (and are owned by dev):  
  - /data
  - /ops
  - /state
  - /home/dev/.ssh
* /data is your default workdir.   
* /home/dev is $HOME  

## Usage 
This image can easily be extended.  But to run Packer:

````
docker run -it --rm \
	-v $(SSH_DIR):/home/dev/.ssh \
	-v $(CURRENT_DIR):/state:rw \
	-v $(PROVISION_CONFIG_DIR):/data:rw \
	pinterb/packer:0.8.6 version   
		
````

## Misc. Info 
* Latest version: 0.8.6   
* Built on: 2015-10-20T10:42:47EDT   
* Base image: pinterb/base:alpine   


[1]: https://hub.docker.com/r/pinterb/packer/   
[2]: https://docker.com 
[3]: https://packer.io/  
[4]: https://github.com/MSOpenTech/packer-azure  