# pinterb/terraform  

[`pinterb/terraform`][1] is a [docker][2] image that bundles the following:  
* **[Terraform v0.6.7][3]:** A tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.  

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
This image can easily be extended.  But to run Terraform:

````
docker run -it --rm \
	-v $(SSH_DIR):/home/dev/.ssh \
	-v $(CURRENT_DIR):/state:rw \
	-v $(PROVISION_CONFIG_DIR):/data:rw \
	pinterb/terraform:0.6.7 apply --var-file=/state/terraform.tfvars -state=/state/terraform.tfstate /data   
		
````

## Misc. Info 
* Latest version: 0.6.8 
* Built on: 2015-12-30T09:56:00EST   
* Base image: pinterb/base:alpine   


[1]: https://hub.docker.com/r/pinterb/terraform/   
[2]: https://docker.com 
[3]: https://terraform.io/  
