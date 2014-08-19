# pinterb/ubuntu-perl-mojo
#
# VERSION     0.0.9
#
# CREATED ON  2014-08-15T19:43:09CDT

FROM pinterb/ubuntu-perl:0.0.9

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive

## Install Perl's Mojolicious along with some testing support
WORKDIR /build
RUN echo 'requires "Mojolicious", "5.27";' > cpanfile && \
 echo 'requires "Test::BDD::Cucumber", "0.26";' >> cpanfile && \
 echo 'requires "Module::Path", "0.13";' >> cpanfile && \
 echo 'requires "Method::Signatures", "20140224";' >> cpanfile && \
 echo 'requires "Test::HTTP", "0.18";' >> cpanfile && \
 perl /usr/local/bin/cpanm --force --installdeps .

### define default command.
CMD ["/bin/bash"]
