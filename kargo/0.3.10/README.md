# pinterb/kargo  

[`pinterb/kargo`][1] is a [docker][2] image that bundles the following:  
* **[Kargo 0.3.10][4]:** A tool that helps to deploy a kubernetes cluster (using Ansible).  

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
	pinterb/kargo:0.3.10 site.yml
		
````

## Misc. Info 
* Latest version: 0.3.10   
* Built on: 2016-08-08T19:48:58UTC   
* Base image: pinterb/base:alpine ([dockerfile][6])  
* [Dockerfile][7]

[1]: https://hub.docker.com/r/pinterb/kargo/   
[2]: https://docker.com 
[3]: http://www.ansible.com/home  
[4]: https://github.com/kubespray/kargo-cli
