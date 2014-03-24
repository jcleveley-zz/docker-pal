FROM tianon/centos:5.9
MAINTAINER Simon Thulbourn <simon.thulbourn@bbc.co.uk>

EXPOSE 80

# Directory setup
RUN mkdir -p /var/cache/tmp
RUN mkdir -p /etc/pki

# Base provisioning
RUN touch /etc/mtab
RUN rpm -ivh http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
RUN yum install -y curl git
RUN yum update -y
RUN yum reinstall -y glibc-common
RUN localedef -i en_GB -f UTF-8 en_GB.UTF-8

# Certificates
ADD certificates/ca.pem /etc/ca/ca.pem
ADD certificates/certificate.pem /etc/pki/certificate.pem
RUN mkdir -p /root/.yum
RUN ln -s /etc/pki/certificate.pem /root/.yum/dev.bbc.co.uk.pem
RUN ln -s /etc/pki/certificate.pem /root/.yum/dev.bbc.co.uk.key

# BBC Things
ADD bbc.repo /etc/yum.repos.d/bbc.repo
RUN yum install -y bbc-conf bbc-rpm-sandbox-base
RUN rm -f /etc/yum/bbc.repo
RUN /usr/sbin/reithproxies off

# BBC PAL
RUN yum install -y --skip-broken bbc-news-pal-sandbox || true

# Remove Certs
RUN rm -f /etc/pki/certificate.pem

RUN extaccess pal.docker.simons.computer static.docker.simons.computer:8080 ichef.docker.simons.computer:8080
