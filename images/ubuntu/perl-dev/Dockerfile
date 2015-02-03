# pinterb/ubuntu-perl-dev
#
# VERSION     0.0.11
#
# CREATED ON  2015-02-03T16:34:04CST

FROM pinterb/ubuntu-perl:0.0.11

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
