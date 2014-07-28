#e phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM edwin3000/lemp:1.0.1
MAINTAINER 'Edwin Joassart <edwin@3kd.be>'

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

#install tools
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -q -y wget unzip

#get latest piwik
RUN /usr/bin/wget http://builds.piwik.org/piwik.zip -O /tmp/piwik.zip
RUN /usr/bin/unzip /tmp/piwik.zip -d /tmp/piwik

#install
RUN /bin/mv /tmp/piwik/* /var/www/
RUN mkdir -p /var/www/piwik/tmp/assets
RUN mkdir /var/www/piwik/tmp/cache/
RUN mkdir /var/www/piwik/tmp/logs/
RUN mkdir /var/www/piwik/tmp/tcpdf/
RUN mkdir /var/www/piwik/tmp/templates_c/
RUN chmod -R 0755 /var/www/piwik/tmp
RUN chown -R www-data:www-data /var/www

#make the volume persistant
VOLUME /var/www

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
CMD ["/sbin/my_init"]
