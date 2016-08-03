# pinterb/mush  

[`pinterb/mush`][1] is a [docker][2] image that bundles the following:  
* **[mush][3]:** Mustache templates for bash  

## Usage  
As an example, say I want to populate my [Terraform][4] tfvars file with externally sourced secrets.  I'd maybe start
with the following *terraform.tfvars.tmpl* file:  

```sh
azure_settings_file = "{{AZURE_SETTINGS_FILE}}"
azure_subscription_id = "{{AZURE_SUBSCRIPTION_ID}}"
azure_certificate = "{{AZURE_CERT}}"
username = "{{VM_USER}}"
password = "{{VM_PASS}}"
key_fingerprint = "{{AZURE_SUBSCRIPTION_THUMBPRINT}}"
ssh_fingerprint = "{{SSH_FINGERPRINT}}"
region = "{{AZURE_REGION}}"
domain = "{{DOMAIN_NAME}}"
dnsimple_token = "{{DNSIMPLE_API_TOKEN}}"
dnsimple_email = "{{DNSIMPLE_EMAIL_ADDR}}"
```


I keep my secrets is a separate location. The sourceable file contains something like the following:  

```sh
# RSA Fingerprint
export SSH_FINGERPRINT=$(ssh-keygen -lf ~/.ssh/dummy.pub | awk '{print $2}')

# DNSimple API
export DNSIMPLE_EMAIL_ADDR="bart.simpson@foxtv.io"
export DNSIMPLE_API_TOKEN="82Y0nQu238vtrYYMsab1"

# Azure Credentials
export AZURE_SETTINGS="$HOME/.cloudcreds/azure/Pay-As-You-Go-7-01-2010-credentials.publishsettings"
export AZURE_SUBSCRIPTION_ID="7g301c1-n912-7nq7-c238-951x3639-py4ik"
export AZURE_SUBSCRIPTION_THUMBPRINT="5561314766618YWUI39D91YN48QA612PNC"
export AZURE_CERTIFICATE="$HOME/.secrets/azure/azure.cer"
export AZURE_SUBSCRIPTION_EXP="2019-01-01"

# Default Cloud User Credentials
export VM_USER="clouduser"
export VM_PASS="cloudpass"
```


Next, I run my mush container to render my terraform.tfvars:     

```sh
cat $(TEMPLATES_DIR)/terraform.tfvars.tmpl |  docker run -i \
	-v $(CLOUD_CREDS_DIR)/extras:/home/dev/.extra \
	-v $(SSH_CREDS_DIR):/home/dev/.ssh \
	-e MUSH_EXTRA=/home/dev/.extra \
	-e AZURE_SETTINGS_FILE=/home/dev/.azure.settings \
	-e AZURE_CERT=/home/dev/.azure.cer \
	-e AZURE_REGION="West US"  \
	-e DOMAIN_NAME="example.com" \
	pinterb/mush:0.0.15 > $(BUILD_DIR)/terraform.tfvars
```


The rendered output would be:
```sh
azure_settings_file = "/home/dev/.azure.settings"
azure_subscription_id = "7g301c1-n912-7nq7-c238-951x3639-py4ik"
azure_certificate = "/home/dev/.azure.cer"
username = "clouduser"
password = "cloudpass"
key_fingerprint = "5561314766618YWUI39D91YN48QA612PNC"
ssh_fingerprint = "SHA256:dtVP0UIGmAZBeaBX+ICPYyalhhYcDjeWR9vs+j5AoLc"
region = "West US"
domain = "example.com"
dnsimple_token = "82Y0nQu238vtrYYMsab1"
dnsimple_email = "bart.simpson@foxtv.io"
```


## Misc. Info 
* Latest version: 0.0.15   
* Built on: 2016-08-03T11:38:50EDT   
* Base image: pinterb/base:alpine   


[1]: https://hub.docker.com/r/pinterb/mush/   
[2]: https://docker.com 
[3]: https://github.com/pinterb/mush
[4]: https://terraform.io/ 
