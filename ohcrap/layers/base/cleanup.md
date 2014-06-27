

### clean-up a bit
RUN apt-get clean && \
 rm -rf /var/lib/apt/lists/* && \
 env --unset=DEBIAN_FRONTEND