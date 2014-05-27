## Just some sample commands ('till I'm more familar with Docker syntax)

docker run -P -it -v /tmp/dockertest:/src:rw -w /home/app/src pinterb/phusion-jvm /sbin/my_init -- /bin/bash -l
