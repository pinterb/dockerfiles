# pinterb/swagger  

[`pinterb/swagger`][1] is a [docker][2] image that bundles the following:  
* **[swagger-cli v1.0.0-beta.2][3]:** Swagger 2.0 command-line tool.  Features include:
  - Validate Swagger 2.0 APIs in JSON or YAML format
  - Supports multi-file APIs via $ref pointers
  - Bundle multiple Swagger files into one combined Swagger file
  - Built-in HTTP server to serve your REST API — great for testing!

## Details
* By default, the container runs as "dev" user (i.e. UID 1000). But the UID/GID can be can be overridden by setting the PUID/PGID environment variables. *Please keep this in mind as you mount volumes!* 
* The following volumes exist (and are owned by dev):  
  - /data
  - /output
  - /state
  - /config
* /data is your default workdir.   

## Usage 
This image can easily be extended.  But to run swagger validate:  

````
docker run -it --rm \
	-v $(SSH_DIR):/home/dev/.ssh \
	-v $(SWAGGER_SPECS_ROOT_DIR):/data:rw \
	-v $(SWAGGER_SPECS_OUTPUT_DIR):/output:rw \
	-e "PGID=$(id -g)" -e "PUID=$(id -u)" \
	-p 8080:8080 \
	pinterb/swagger:1.0.0-beta.2 validate /data/swagger.yaml  
````

To run swagger bundle:  

````
docker run -it --rm \
	-v $(SSH_DIR):/home/dev/.ssh \
	-v $(SWAGGER_SPECS_ROOT_DIR):/data:rw \
	-v $(SWAGGER_SPECS_OUTPUT_DIR):/output:rw \
	-e "PGID=$(id -g)" -e "PUID=$(id -u)" \
	-p 8080:8080 \
	pinterb/swagger:1.0.0-beta.2 bundle --dereference --outfile /output/swagger.yaml /data/swagger.yaml  
````


## Misc. Info 
* Latest version: 1.0.0-beta.2  
* Built on: 2016-11-28T15:42:49Z   
* Base image: pinterb/base:alpine   


[1]: https://hub.docker.com/r/pinterb/swagger/   
[2]: https://docker.com 
[3]: https://github.com/BigstickCarpet/swagger-cli  
