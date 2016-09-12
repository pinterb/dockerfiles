# ###-->ZZZ_IMAGE<--###  

[`###-->ZZZ_IMAGE<--###`][1] is a [docker][2] image that bundles the following:  
* **[Vault v###-->ZZZ_VAULT_VERSION<--###][3]:** A tool that secures, stores, and tightly controls access to tokens, passwords, certificates, API keys, and other secrets in modern computing.

## Details
* This image only exposes the /vault/config directory from the base HashiCorp image.

## Usage 
This image can easily be extended.  But to run vault:

````
docker run -it --rm \
	-v $(LOCAL_CONFIG_DIR):/vault/config \
	--cap-add=IPC_LOCK \
	###-->ZZZ_IMAGE<--###:###-->ZZZ_VAULT_VERSION<--### server
		
````

## Misc. Info 
* Latest version: ###-->ZZZ_CURRENT_VERSION<--###  
* Built on: ###-->ZZZ_DATE<--###   
* Base image: ###-->ZZZ_BASE_IMAGE<--###   


[1]: https://hub.docker.com/r/###-->ZZZ_IMAGE<--###/   
[2]: https://docker.com 
[3]: https://www.vaultproject.io/  