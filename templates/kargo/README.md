# ###-->ZZZ_IMAGE<--###  

[`###-->ZZZ_IMAGE<--###`][1] is a [docker][2] image that bundles the following:  
* **[Kargo ###-->ZZZ_KARGO_VERSION<--###][4]:** A tool that helps to deploy a kubernetes cluster (using Ansible).  

## Details
* The container runs as "dev" user (i.e. UID 1000). *Please keep this in mind as you mount volumes!* 
* The following volumes exist (and are owned by dev):  
  - /data
  - /ops
  - /state
  - /ansible
  - /home/dev/.ssh
* /ansible is your default workdir. *Knowing this will be helpful when you're mounting your playbooks for execution.*   
* /home/dev is $HOME
* The entrypoint for this image is ***/usr/bin/kargo***.  This should be sufficient for most use cases.

## Usage 
This image can easily be extended.  But to run your Ansible playbooks:

````
docker run -it --rm \
	-v $(SSH_DIR):/home/dev/.ssh \
	-v $(CURRENT_DIR):/state:rw \
	-v $(PLAYBOOK_DIR):/ansible:rw \
	###-->ZZZ_IMAGE<--###:###-->ZZZ_VERSION<--### site.yml
		
````

## Misc. Info 
* Latest version: ###-->ZZZ_CURRENT_VERSION<--###   
* Built on: ###-->ZZZ_DATE<--###   
* Base image: ###-->ZZZ_BASE_IMAGE<--### ([dockerfile][6])  
* [Dockerfile][7]

[1]: https://hub.docker.com/r/###-->ZZZ_IMAGE<--###/   
[2]: https://docker.com 
[3]: http://www.ansible.com/home  
[4]: https://github.com/kubespray/kargo-cli
