# pinterb/jenkins-master-k8s  

[`pinterb/jenkins-master-k8s`][1] is a [docker][2] image that bundles the following:  
* **[Jenkins v2.19.1][3]:** The leading open source automation, CI/CD server.

## Details
* This image is intended to be run on [Kubernetes][4]. It extends the base image by installing the kubernetes plugin along with a few other complementary plugins.

## Usage 
Deploy this image via the official Kubernetes [Jenkins chart][5]:

````
$ helm install --name my-release -f values.yaml stable/jenkins
		
````

## Misc. Info 
* Latest version: 2.19.1  
* Built on: 2016-11-18T21:07:30Z   
* Base image: jenkins   


[1]: https://hub.docker.com/r/pinterb/jenkins-master-k8s/   
[2]: https://docker.com 
[3]: https://jenkins.io/ 
[4]: http://kubernetes.io/ 
[5]: https://github.com/kubernetes/charts/tree/master/stable/jenkins 
