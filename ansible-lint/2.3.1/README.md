# pinterb/ansible-lint  

[`pinterb/ansible-lint`][1] is a [docker][2] image that bundles the following:  
* **[ansible-lint 2.3.1][3]:** Checks [Ansible][4] playbooks for practices and behaviour that could potentially be improved.    

## Details
* The container runs as "dev" user (i.e. UID 1000). *Please keep this in mind as you mount volumes!* 
* The following volumes exist (and are owned by dev):  
  - /data
  - /ops
  - /state
  - /ansible
  - /home/dev/.ssh
* /ansible is your default workdir. *Knowing this will be helpful when you're mounting your playbook for linting.*   
* /home/dev is $HOME
* The entrypoint for this image is ***/usr/bin/ansible-lint***.  This should be sufficient for most use cases.

## Usage 
This image can easily be extended.  But to analyze your Ansible playbooks:

````
docker run -it --rm \
	-v $(PLAYBOOK_DIR):/ansible \
	pinterb/ansible-lint:2.3.1 site.yml
		
````

## Misc. Info 
* Latest version: 2.3.1   
* Built on: 2016-08-03T11:38:50EDT   
* Base image: pinterb/base:alpine ([dockerfile][6])  
* [Dockerfile][7]

[1]: https://hub.docker.com/r/pinterb/ansible-lint/   
[2]: https://docker.com 
[3]: https://github.com/willthames/ansible-lint  
[4]: http://www.ansible.com/  
[6]: https://github.com/pinterb/dockerfiles/blob/master/base/alpine
[7]: https://github.com/pinterb/dockerfiles/tree/master/ansible-lint