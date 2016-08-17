# ###-->ZZZ_IMAGE<--###  

[`###-->ZZZ_IMAGE<--###`][1] is a [docker][2] image that bundles the following:  
* **[swagger-cli v###-->ZZZ_SWAGGER_VERSION<--###][3]:** Swagger 2.0 command-line tool.  Features include:
  - Validate Swagger 2.0 APIs in JSON or YAML format
  - Supports multi-file APIs via $ref pointers
  - Bundle multiple Swagger files into one combined Swagger file
  - Built-in HTTP server to serve your REST API — great for testing!

## Details
* The container runs as "dev" user (i.e. UID 5000). *Please keep this in mind as you mount volumes!* 
* The following volumes exist (and are owned by dev):  
  - /data
  - /output
  - /state
  - /config
  - /home/dev/.ssh
* /data is your default workdir.   
* /home/dev is $HOME  

## Usage 
This image can easily be extended.  But to run swagger validate:  

````
docker run -it --rm \
	-v $(SSH_DIR):/home/dev/.ssh \
	-v $(SWAGGER_SPECS_ROOT_DIR):/data:rw \
	-v $(SWAGGER_SPECS_OUTPUT_DIR):/output:rw \
	-p 8080:8080 \
	###-->ZZZ_IMAGE<--###:###-->ZZZ_SWAGGER_VERSION<--### validate /data/swagger.yaml  
````

To run swagger bundle:  

````
docker run -it --rm \
	-v $(SSH_DIR):/home/dev/.ssh \
	-v $(SWAGGER_SPECS_ROOT_DIR):/data:rw \
	-v $(SWAGGER_SPECS_OUTPUT_DIR):/output:rw \
	-p 8080:8080 \
	###-->ZZZ_IMAGE<--###:###-->ZZZ_SWAGGER_VERSION<--### bundle --dereference --outfile /output/swagger.yaml /data/swagger.yaml  
````


## Misc. Info 
* Latest version: ###-->ZZZ_CURRENT_VERSION<--###  
* Built on: ###-->ZZZ_DATE<--###   
* Base image: ###-->ZZZ_BASE_IMAGE<--###   


[1]: https://hub.docker.com/r/###-->ZZZ_IMAGE<--###/   
[2]: https://docker.com 
[3]: https://github.com/BigstickCarpet/swagger-cli  
