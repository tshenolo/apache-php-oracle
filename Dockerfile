FROM php:8.2-apache

# Install system packages and PHP extensions
RUN apt-get update && \
    apt-get install -y libaio1 unzip vim && \
    docker-php-ext-install pdo pdo_mysql

# Install Oracle Instant Client
ADD instantclient-basic-linux.x64-19.20.0.0.0dbru.zip /tmp/
ADD instantclient-sdk-linux.x64-19.20.0.0.0dbru.zip /tmp/

RUN mkdir -p /usr/local/ && \
    unzip /tmp/instantclient-basic-linux.x64-19.20.0.0.0dbru.zip -d /usr/local/ && \
    unzip /tmp/instantclient-sdk-linux.x64-19.20.0.0.0dbru.zip -d /usr/local/ && \
    rm -rf /tmp/instantclient-*.zip && \
    echo /usr/local/instantclient_19_20 > /etc/ld.so.conf.d/oracle-instantclient.conf && \
    ldconfig

# Enable Oracle extensions
RUN echo 'instantclient,/usr/local/instantclient_19_20' | pecl install oci8-3.0.1 && \
    echo "extension=oci8.so" > /usr/local/etc/php/conf.d/oci8.ini

# Copy the PHP application into the image
COPY ./src /var/www/html/

# Allow Apache to rewrite requests (for clean URLs)
RUN a2enmod rewrite

# Change the Apache port in the default site configuration to 8080
RUN echo "Listen 8080" > /etc/apache2/ports.conf && \
    sed -i 's/*:80>/*:8080>/' /etc/apache2/sites-enabled/000-default.conf

# Indicate that the container listens on port 8080
EXPOSE 8080

# Change the ownership of the application files
RUN chown -R www-data:www-data /var/www/html

# Set the user to a non-root user (Apache user)
USER www-data
