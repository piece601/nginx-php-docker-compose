FROM centos:7

RUN yum -y update

RUN yum -y upgrade

RUN yum install -y epel-release vim wget libaio libaio-devel npm

# install php73
RUN rpm -ivh https://rpms.remirepo.net/enterprise/remi-release-7.rpm

RUN yum install -y  php73 \
                    php73-php-bcmath \
                    php73-php-fpm \
                    php73-php-gd \
                    php73-php-intl \
                    php73-php-json \
                    php73-php-mbstring \
                    php73-php-odbc \
                    php73-php-opcache \
                    php73-php-pdo \
                    php73-php-pecl-amqp \
                    php73-php-pecl-apcu \
                    php73-php-pecl-igbinary \
                    php73-php-pecl-mcrypt \
                    php73-php-pecl-memcache \
                    php73-php-soap \
                    php73-php-tidy \
                    php73-php-xml \
                    php73-php-pecl-zip \
                    php73-php-pecl-xdebug \
                    php73-xhprof.noarch \
                    php73-php-pecl-redis \
                    php-mongo \
        ; exit 0;

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN . /opt/remi/php73/enable && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

RUN sed -i 's/listen = 127.0.0.1:9000/listen = \/var\/run\/php73-fpm.sock/g'  /etc/opt/remi/php73/php-fpm.d/www.conf && \
    sed -i 's/;listen.owner = nobody/listen.owner = apache/g'  /etc/opt/remi/php73/php-fpm.d/www.conf && \
    sed -i 's/;listen.group = nobody/listen.group = apache/g'  /etc/opt/remi/php73/php-fpm.d/www.conf

# install nginx
RUN yum install -y nginx
COPY nginx.conf /etc/nginx/nginx.conf

# clear cache
RUN yum clean all && \
    rm -rf /var/cache/yum

ENV PATH=/opt/remi/php73/root/usr/bin:/opt/remi/php73/root/usr/sbin${PATH:+:${PATH}}
ENV LD_LIBRARY_PATH=/opt/remi/php73/root/usr/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
ENV MANPATH=/opt/remi/php73/root/usr/share/man:${MANPATH}

WORKDIR /var/www

# set entry point
COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 9000
EXPOSE 80

CMD ["/run.sh"]
