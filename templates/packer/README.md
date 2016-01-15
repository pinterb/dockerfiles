# ###-->ZZZ_IMAGE<--###  

[`###-->ZZZ_IMAGE<--###`][1] is a [docker][2] image that bundles the following:  
* **[Packer v###-->ZZZ_PACKER_VERSION<--###][3]:** An open source tool for creating identical machine images for multiple platforms from a single source configuration.  
* **[packer-azure][4]:** An Azure plugin for Packer to enable Microsoft Azure users to build custom images given an Azure image.    

## Details
* The container runs as "dev" user (i.e. UID 1000). *Please keep this in mind as you mount volumes!* 
* The following volumes exist (and are owned by dev):  
  - /data
  - /ansible (Hint: use this with the [ansible provisioner][5] by mounting your Ansible playbooks here)
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
	-v $(ANSIBLE_PLAYBOOK_DIR):/ansible:rw \
	###-->ZZZ_IMAGE<--###:###-->ZZZ_PACKER_VERSION<--### version   
		
````

## Misc. Info 
* Latest version: ###-->ZZZ_CURRENT_VERSION<--###   
* Built on: ###-->ZZZ_DATE<--###  
* Base image: ###-->ZZZ_BASE_IMAGE<--###  


[1]: https://hub.docker.com/r/###-->ZZZ_IMAGE<--###/   
[2]: https://docker.com 
[3]: https://packer.io/  
[4]: https://github.com/MSOpenTech/packer-azure
[5]: https://packer.io/docs/provisioners/ansible-local.html
