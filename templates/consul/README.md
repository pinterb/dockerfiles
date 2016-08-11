# ###-->ZZZ_IMAGE<--###  

[`###-->ZZZ_IMAGE<--###`][1] is a [docker][2] image that bundles the following:  
* **[Consul v###-->ZZZ_CONSUL_VERSION<--###][3]:** A distributed, highly available tool for service discovery, configuration, etc.  

## Details
* The container currently runs as root, BUT this is subject to change.
* The following volumes exist (and are owned by dev):  
  - /consul/data
  - /consul/config
* / is your default workdir.   

## Usage 
This image can easily be extended.  But to run Consul:

````
docker run -it --rm \
	-v /var/lib/data:/consul/data:rw \
	-v $(CONSUL_CONFIG_DIR):/consul/config:rw \
	###-->ZZZ_IMAGE<--###:###-->ZZZ_CONSUL_VERSION<--### agent -config-dir=/consul/config  
		
````

## Misc. Info 
* Latest version: ###-->ZZZ_CURRENT_VERSION<--###  
* Built on: ###-->ZZZ_DATE<--###   
* Base image: ###-->ZZZ_BASE_IMAGE<--###   


[1]: https://hub.docker.com/r/###-->ZZZ_IMAGE<--###/   
[2]: https://docker.com 
[3]: https://consul.io/  
