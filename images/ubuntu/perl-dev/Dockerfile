# pinterb/ubuntu-perl
#
# VERSION     0.0.6
#
# CREATED ON  2014-08-11T19:20:53CDT

FROM pinterb/ubuntu-perl:0.0.6

MAINTAINER Brad Pinter brad.pinter@gmail.com

ENV HOME /root
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV PERL_STABLE 5.20.0

### install plenv
# check out plenv into ~/.plenv
RUN git clone git://github.com/tokuhirom/plenv.git ~/.plenv && \
 echo 'export PATH="$HOME/.plenv/bin:$PATH"' >> ~/.profile && \
 echo 'eval "$(plenv init -)"' >> ~/.profile

# check out perl-build into ~/.plenv
RUN git clone git://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build/

### install a version of Perl under plenv
RUN ~/.plenv/bin/plenv install $PERL_STABLE && \
 ~/.plenv/bin/plenv rehash && \
 ~/.plenv/bin/plenv install-cpanm && \
 cpanm Carton

### define default command.
CMD ["/bin/bash"]
