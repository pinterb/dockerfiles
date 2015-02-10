# pinterb/swagger-ui 

[`pinterb/swagger-ui`](https://index.docker.io/u/pinterb/swagger-ui) is a [docker](https://docker.com) image that bundles the following:  
 
* **[Swagger UI](https://github.com/swagger-api/swagger-ui):** Swagger UI is a dependency-free collection of HTML, Javascript, and CSS assets that dynamically generate documentation from a Swagger-compliant API. [http://swagger.io](http://swagger.io).    

## Usage 
This image can easily be extended.  But to run your Ansible playbooks:
````
docker run --rm -it -v ${PWD}:/swagger-data -p 8080:80 pinterb/swagger-ui:0.0.12
````

## Misc. Info 
* Latest version: 0.0.12
* Built on: 2015-02-10T19:50:10UTC
* Base image: pinterb/json:0.0.11

