# pinterb/vault  

[`pinterb/vault`][1] is a [docker][2] image that bundles the following:  
* **[Vault v0.6.1][3]:** A tool that secures, stores, and tightly controls access to tokens, passwords, certificates, API keys, and other secrets in modern computing.

## Details
* This image only exposes the /vault/config directory from the base HashiCorp image.

## Usage 
This image can easily be extended.  But to run vault:

````
docker run -it --rm \
	-v $(LOCAL_CONFIG_DIR):/vault/config \
	--cap-add=IPC_LOCK \
	pinterb/vault:0.6.1 server
		
````

## Misc. Info 
* Latest version: 0.6.1  
* Built on: 2016-09-13T15:50:32EDT   
* Base image: vault:0.6.1   


[1]: https://hub.docker.com/r/pinterb/vault/   
[2]: https://docker.com 
[3]: https://www.vaultproject.io/  