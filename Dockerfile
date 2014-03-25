FROM tianon/centos:5.9
MAINTAINER Simon Thulbourn <simon.thulbourn@bbc.co.uk>

EXPOSE 80

# Directory setup
RUN mkdir -p /var/cache/tmp
RUN mkdir -p /etc/pki

# Base provisioning
RUN touch /etc/mtab
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
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

RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# Remove Certs
RUN rm -f /etc/pki/certificate.pem

# serf
RUN curl -L https://dl.bintray.com/mitchellh/serf/0.5.0_linux_amd64.zip -o /tmp/serf.zip
RUN unzip /tmp/serf.zip -d /usr/local/bin
RUN rm -rf /tmp/serf.zip

ADD scripts/serf_runner /usr/local/bin/serf_runner
ADD scripts /etc/serf
RUN chmod +x /etc/serf/router.sh
RUN chmod +x /etc/serf/**/*.sh
RUN chmod +x /usr/local/bin/serf_runner

ENTRYPOINT "serf_runner"
