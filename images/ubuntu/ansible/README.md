# pinterb/ansible 

[`pinterb/ansible`](https://index.docker.io/u/pinterb/ansible) is a [docker](https://docker.io) image that bundles the following:  
 
* **[Ansible v1.9 (devel 019f74dced) ](http://www.ansible.com/home):** A radically simple IT automation system. It handles configuration-management, application deployment, cloud provisioning, ad-hoc task-execution, and multinode orchestration - including trivializing things like zero downtime rolling updates with load balancers. Ansible is written in [Python](https://www.python.org/).    

## Usage 
This image can easily be extended.  But to run your Ansible playbooks:
````
docker run --rm -it pinterb/ansible:0.0.11 ansible --version
````

## Misc. Info 
* Latest version: 0.0.11
* Built on: 2015-02-06T14:06:52CST
* Base image: pinterb/json:0.0.10

