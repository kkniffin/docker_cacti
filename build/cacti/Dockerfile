FROM phusion/baseimage:latest

# Set Variables
ENV DEBIAN_FRONTEND noninteractive
ENV CACTI_DL_FILE "cacti-0.8.8h.tar.gz"
ENV SPINE_DL_FILE "cacti-spine-0.8.8h.tar.gz"
ENV CACTI_MYSQL_USERNAME "root"
ENV CACTI_MYSQL_PASSWORD "cactipw!"
ENV CACTI_MYSQL_HOST "mysql"
ENV CACTI_MYSQL_DATABASE "cacti"
ENV CACTI_HOSTNAME 'localhost'
ENV CACTI_MAILHOST 'mail.changeme.com'

# Enable Repositories and Upgrade
RUN apt-add-repository multiverse\
    && apt-get -qq update \
    && apt-get -y upgrade -o Dpkg::Options::="--force-confold" \
    && apt-get -y dist-upgrade

# Install Required Packages
RUN apt-get install -y curl \
    ntp \
    ntpdate \
    tzdata \
    apache2 \
    wget \
    rrdtool \
    ttf-mscorefonts-installer \
    net-tools \
    build-essential \
    automake \
    libtool \
    libmysqlclient-dev \
    libsnmp-dev \
    unzip \
    ssmtp \
    php \
    php-mysql \
    php-cli \
    libapache2-mod-php \
    php-ldap \
    php-gd \
    php-snmp \
    libphp-adodb \
    git \
    mysql-client \
    php-xml \
    php-gmp \
    php-mbstring \
    snmp

# Install Cacti
WORKDIR /opt
RUN git clone https://github.com/Cacti/cacti.git \
    && echo '*/5 * * * * root php /opt/cacti/poller.php > /dev/null 2>&1' > /etc/cron.d/cacti \
    && ln -s /opt/cacti /var/www/html/cacti \
    && cp /opt/cacti/include/config.php.dist /opt/cacti/include/config.php \
    && chown www-data.www-data /opt/cacti/resource/snmp_queries \
    && chown www-data.www-data /opt/cacti/resource/script_server \
    && chown www-data.www-data /opt/cacti/resource/script_queries

# Install Spine
WORKDIR /usr/local/src
RUN wget http://www.cacti.net/downloads/spine/${SPINE_DL_FILE} \
    && tar zxvf ${SPINE_DL_FILE} \
    && rm ${SPINE_DL_FILE} \
    && cd cacti-spine* \
    && ln -s /usr/lib/x86_64-linux-gnu/libmysqlclient.so /usr/lib/x86_64-linux-gnu/libmysqlclient_r.so; \
    LDFLAGS="-L/usr/lib -L/usr/lib/x86_64-linux-gnu/" ./configure --prefix=/usr --sysconfdir=/etc \
    && make \
    && make install \
    && cp /etc/spine.conf.dist /etc/spine.conf

# Setup Apache
RUN a2enmod ssl \
    && rm /etc/apache2/sites-enabled/* \
    && a2ensite default-ssl \
    && ln -s /opt/cacti /var/www/html/cacti \
    && rm -rf /var/www/html/index.html \
    && mkdir -p /etc/apache2/ssl \
    && cp /usr/share/ssl-cert/ssleay.cnf /usr/local/src \
    && sed -i 's/^default_bits.*/default_bits\t\t= 4096/' /usr/local/src/ssleay.cnf \
    && sed -i "s/^commonName.*/commonName\t\t= ${CACTI_HOSTNAME}/" /usr/local/src/ssleay.cnf \
    && make-ssl-cert /usr/local/src/ssleay.cnf /etc/ssl/certs/ssl-cert-snakeoil.pem --force-overwrite

# Copy Startup Scripts to Run
COPY ./my_init.d/* /etc/my_init.d/
COPY ./service/ /etc/service/
