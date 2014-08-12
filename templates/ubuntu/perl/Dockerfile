# ###-->ZZZ_IMAGE<--###
#
# VERSION     ###-->ZZZ_VERSION<--###
#
# CREATED ON  ###-->ZZZ_DATE<--###

FROM ###-->ZZZ_BASE_IMAGE<--###

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV PERL_INSTALL_VERSION ###-->ZZZ_PERL_VERSION<--###

ENV DEBIAN_FRONTEND noninteractive

### install packages require to compile perl
RUN apt-get install -y \
 gcc make

### make debian interactive...
RUN env --unset=DEBIAN_FRONTEND

RUN mkdir -p /usr/src/perl \
	&& curl -SL http://www.cpan.org/src/5.0/perl-$PERL_INSTALL_VERSION.tar.gz \
		| tar -xz --strip-components=1 -C /usr/src/perl

WORKDIR /usr/src/perl
RUN ./Configure -der
RUN make
RUN make test
RUN make install

ENV PERL_CPANM_OPT --verbose
RUN curl -SL http://cpanmin.us | perl - App::cpanminus

### define default command.
CMD ["/bin/bash"]
