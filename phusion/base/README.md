# pinterb/phusion-base

A docker image based on phusion/baseimage.  Currently this is an Ubuntu 14.04 image.

Features include:
- some handy packages installed
- ntp installed with new timezone

To pull this image:
`docker pull pinterb/phusion-base`

Or better yet, to look around a bit:
`docker run --rm -t -i pinterb/phusion-base /sbin/my_init -- bash -l`
