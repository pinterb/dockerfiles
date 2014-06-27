### prepare system
# Create a user for logging.
RUN addgroup --gid 9998 log && \
 adduser --uid 9998 --gid 9998 --disabled-password --no-create-home --gecos "Logger" log && \
 usermod -L log