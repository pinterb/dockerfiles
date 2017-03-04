# ###-->ZZZ_IMAGE<--###  

[`###-->ZZZ_IMAGE<--###`][1] is a [docker][2] image that bundles the following:  
* **[Jenkins v###-->ZZZ_JENKINS_VERSION<--###][3]:** The leading open source automation, CI/CD server.

## Details
* This image is intended to be run on [Kubernetes][4]. It extends the base image by installing the kubernetes plugin along with a few other complementary plugins.

## Usage 
Deploy this image via the official Kubernetes [Jenkins chart][5]:

````
$ helm install --name my-release -f values.yaml stable/jenkins
		
````

## Misc. Info 
* Latest version: ###-->ZZZ_CURRENT_VERSION<--###  
* Built on: ###-->ZZZ_DATE<--###   
* Base image: ###-->ZZZ_BASE_IMAGE<--###   


[1]: https://hub.docker.com/r/###-->ZZZ_IMAGE<--###/   
[2]: https://docker.com 
[3]: https://jenkins.io/ 
[4]: http://kubernetes.io/ 
[5]: https://github.com/kubernetes/charts/tree/master/stable/jenkins 
