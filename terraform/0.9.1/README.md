# pinterb/terraform  

[`pinterb/terraform`][1] is a [docker][2] image that bundles the following:  
* **[Terraform v0.9.1][3]:** A tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.  

## Details
* By default, the container runs as "dev" user (i.e. UID 1000). But the UID/GID can be can be overridden by setting the PUID/PGID environment variables. *Please keep this in mind as you mount volumes!* 
* The following volumes exist (and are owned by dev):  
  - /data
  - /ops
  - /state
* /data is your default workdir.   

## Usage 
This image can easily be extended.  But to run Terraform:

````
docker run -it --rm \
	-v $(SSH_DIR):/home/dev/.ssh \
	-v $(CURRENT_DIR):/state:rw \
	-v $(PROVISION_CONFIG_DIR):/data:rw \
	-e "PGID=$(id -g)" -e "PUID=$(id -u)" \
	pinterb/terraform:0.9.1 apply --var-file=/state/terraform.tfvars -state=/state/terraform.tfstate /data   
		
````

## Misc. Info 
* Latest version: 0.9.1  
* Built on: 2017-03-22T19:12:55Z   
* Base image: pinterb/base:alpine   


[1]: https://hub.docker.com/r/pinterb/terraform/   
[2]: https://docker.com 
[3]: https://terraform.io/  
