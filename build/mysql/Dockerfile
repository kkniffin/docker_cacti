FROM mariadb:latest

# Use rc.local as script wrapper
RUN sed -i '1a/etc/my_init.d/*' /usr/local/bin/docker-entrypoint.sh


# Copy Startup Scripts to Run
COPY ./my_init.d/* /etc/my_init.d/
