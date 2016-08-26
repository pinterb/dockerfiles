# ###-->ZZZ_IMAGE<--###  

[`###-->ZZZ_IMAGE<--###`][1] is a [docker][2] image that bundles the following:  
* **[swagger-codegen v###-->ZZZ_SWAGGER_CODEGEN_VERSION<--###][3]:** Swagger Codegen command-line tool. The swagger codegen 
project, which allows generation of API client libraries, server stubs and documentation automatically given an [OpenAPI Spec][4].

## Details
* By default, he container runs as "dev" user (i.e. UID 1000). But the UID/GID can be can be overridden by setting the PUID/PGID environment variables. *Please keep this in mind as you mount volumes!* 
* The following volumes exist (and are owned by dev):  
  - /data
  - /output
  - /state
  - /config
* /data is your default workdir.   

## Usage 
This image can easily be extended.  But to generate a sample client library:  

````
docker run -it --rm \
	-v $(SSH_DIR):/home/dev/.ssh \
	-v $(SWAGGER_SPECS_ROOT_DIR):/data:rw \
	-v $(SWAGGER_CODEGEN_OUTPUT_DIR):/output:rw \
	###-->ZZZ_IMAGE<--###:###-->ZZZ_SWAGGER_CODEGEN_VERSION<--### generate \
	-i /data/swagger.json \ 
	-l java \ 
	-o /output/client/petstore/java  
````


## Misc. Info 
* Latest version: ###-->ZZZ_CURRENT_VERSION<--###  
* Built on: ###-->ZZZ_DATE<--###   
* Base image: ###-->ZZZ_BASE_IMAGE<--###   


[1]: https://hub.docker.com/r/###-->ZZZ_IMAGE<--###/   
[2]: https://docker.com 
[3]: http://swagger.io/swagger-codegen/  
[4]: https://github.com/OAI/OpenAPI-Specification    
