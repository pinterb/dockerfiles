# pinterb/jo  

[`pinterb/jo`][1] is a [docker][2] image that bundles the following:  
* **[jo][3]:** A shell command to create JSON.  

## Usage  
````
docker run -i pinterb/jo:1.0 prince="party like it's 1999" michael="billy jean" "stone temple pilots"="sex type thing" > music-themes.json

cat music-themes.json
{"prince":"party like it's 1999","michael":"billy jean","stone temple pilots":"sex type thing"}
    
````

## Misc. Info   
* Latest version: 1.0  
* Built on: 2016-05-13T13:51:44EDT  
* Base image: pinterb/base:alpine   


[1]: https://hub.docker.com/r/pinterb/jo/   
[2]: https://docker.com 
[3]: http://jpmens.net/2016/03/05/a-shell-command-to-create-json-jo/ 
