## pinterb/phusion-base serverspec test(s)

Some [Serverspec](http://serverspec.org/) tests for this Docker image.

### Prerequisites
Before running the tests you'll need the following:   
* Install [Vagrant](http://www.vagrantup.com/) (version 1.6 or later).   
* Install the [Vagrant-Serverspec](https://github.com/jvoorhis/vagrant-serverspec) plugin.   
* Modify your ~/.ssh/config to prevent Vagrant from updating your known_hosts file:

     ```
     Host 172.17.0.2
        StrictHostKeyChecking no
        UserKnownHostsFile=/dev/null
     ```

**Note**: This has only been tested on Ubuntu 14.04

### Running the tests
Nothing too complicated here.  Just run the following:   

`./verify.sh`
