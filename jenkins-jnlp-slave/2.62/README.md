# pinterb/jenkins-jnlp-slave  

[`pinterb/jenkins-jnlp-slave`][1] is a [docker][2] image that bundles the following:  
* **[Jenkins JNLP-enabled slave v2.62][3]:** The leading open source automation, CI/CD server.

## Details
* This image is intended to be run on [Kubernetes][4]. It extends the base image by installing gcloud sdk, kubectl, and helm.

## Usage 
Deploy this image via the official Kubernetes [Jenkins chart][5]:

````
$ helm install --name my-release -f values.yaml stable/jenkins
		
````

## Misc. Info 
* Latest version: 2.62  
* Built on: 2016-11-18T17:52:26Z   
* Base image: jenkinsci/jnlp-slave   


[1]: https://hub.docker.com/r/pinterb/jenkins-jnlp-slave/   
[2]: https://docker.com 
[3]: https://jenkins.io/ 
[4]: http://kubernetes.io/ 
[5]: https://github.com/kubernetes/charts/tree/master/stable/jenkins 
