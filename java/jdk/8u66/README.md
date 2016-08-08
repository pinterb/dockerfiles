# pinterb/jdk  

[`pinterb/jdk`][1] is a [docker][2] image that bundles the following:  
* **[Oracle JDK v8u66][3]:** Java Platform, Standard Edition (Java SE) lets you develop and deploy Java applications on desktops and servers, as well as embedded environments.  

## Details
* The container runs as "dev" user (i.e. UID 1000). *Please keep this in mind as you mount volumes!* 
* The following volumes exist (and are owned by dev):  
  - /data
  - /ops
  - /state
  - /home/dev/.ssh
* /data is your default workdir.   
* /home/dev is $HOME  
* /opt/jdk is $JAVA_HOME  

## Usage 
This image can easily be extended.  But to run jdk commands:

````
docker run -it --rm \
	-v $(SSH_DIR):/home/dev/.ssh \
	-v $(PWD):/data:rw \
	pinterb/jdk:8u66 java -version
		
````

## Misc. Info 
* Latest version: 8u66  
* Built on: 2016-08-08T19:48:58UTC   
* Base image: pinterb/base:alpine   


[1]: https://hub.docker.com/r/pinterb/jdk/   
[2]: https://docker.com 
[3]: http://www.oracle.com/technetwork/java/javase/overview/index.html