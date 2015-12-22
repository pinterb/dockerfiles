# pinterb/ansible  

[`pinterb/ansible`][1] is a [docker][2] image that bundles the following:  
* **[Ansible v2.0.0-0.3.beta1][3]:** A radically simple IT automation system. It handles configuration-management, application deployment, cloud provisioning, ad-hoc task-execution, and multinode orchestration - including trivializing things like zero downtime rolling updates with load balancers. Ansible is written in [Python](https://www.python.org/).    
* **[geerlingguy.ntp][4]:** An ansible-galaxy role written by [Jeff Geerling][5].  This role installs and configures NTP.  

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

## Usage 
This image can easily be extended.  But to run your Ansible playbooks:

````
docker run -it --rm \
	-v $(SSH_DIR):/home/dev/.ssh \
	-v $(CURRENT_DIR):/state:rw \
	-v $(PLAYBOOK_DIR):/ansible:rw \
	--entrypoint="/opt/ansible/bin/ansible-playbook" \
	pinterb/ansible:0.0.15 site.yml
		
````

## Misc. Info 
* Latest version: 0.0.15   
* Built on: 2015-12-22T15:55:30EST   
* Base image: pinterb/base:alpine   


[1]: https://hub.docker.com/r/pinterb/ansible/   
[2]: https://docker.com 
[3]: http://www.ansible.com/home  
[4]: https://galaxy.ansible.com/list#/roles/464    
[5]: https://github.com/geerlingguy