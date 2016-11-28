FROM phusion/baseimage:latest

ENV DEBIAN_FRONTEND noninteractive
ENV CACTI_DL_FILE "cacti-0.8.8h.tar.gz"
ENV SPINE_DL_FILE "cacti-spine-0.8.8h.tar.gz"
ENV CACTI_MYSQL_USERNAME "root"
ENV CACTI_MYSQL_PASSWORD "cactipw!"
ENV CACTI_MYSQL_HOST "localhost"
ENV CACTI_MYSQL_DATABASE "cacti"

RUN apt-add-repository multiverse\
    && apt-get -qq update \
    && apt-get -y upgrade -o Dpkg::Options::="--force-confold" \
    && apt-get -y dist-upgrade \
    && apt-get install -y curl \
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
    unzip

# Install Cacti
WORKDIR /usr/local/src
RUN wget http://www.cacti.net/downloads/${CACTI_DL_FILE} \
    && tar zxvf ${CACTI_DL_FILE} \
    && rm ${CACTI_DL_FILE} \
    && mv cacti* /opt/cacti \
    && chown -R 664 /opt/cacti/log \
    && chown -R www-data.www-data /opt/cacti/log \
    && echo '*/5 * * * * root php /opt/cacti/poller.php > /dev/null 2>&1' > /etc/cron.d/cacti

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
    && cp /etc/spine.conf.dist /etc/spine.conf \
    && sed -i "s/^DB_Pass.*/DB_Pass\t\t${CACTI_MYSQL_PASSWORD}/" /etc/spine.conf \
    && sed -i "s/^DB_User.*/DB_User\t\t${CACTI_MYSQL_USERNAME}/" /etc/spine.conf \
    && sed -i "s/^DB_Host.*/DB_Host\t\t${CACTI_MYSQL_HOST}/" /etc/spine.conf \
    && sed -i "s/^DB_Database.*/DB_Database\t\t${CACTI_MYSQL_DATABASE}/" /etc/spine.conf

# Setup Apache
RUN a2enmod ssl \
    && rm /etc/apache2/sites-enabled/* \
    && a2ensite default-ssl \
    && ln -s /opt/cacti /var/www/html/cacti \
    && rm -rf /var/www/html/index.html \
    && mkdir -p /etc/apache2/ssl \
    && make-ssl-cert /usr/share/ssl-cert/ssleay.cnf /etc/apache2/ssl/apache.pem \
    && sed -i '/<Directory \/usr\/lib\/cgi-bin>/,/<\/Directory>/d' /etc/apache2/sites-enabled/default-ssl.conf

COPY ./my_init.d/* /etc/my_init.d/
