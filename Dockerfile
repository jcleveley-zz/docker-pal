FROM tianon/centos:5.9
MAINTAINER Simon Thulbourn <simon+github@thulbourn.com>

EXPOSE 22 80 6081

ADD runlist.json /tmp/runlist.json
ADD solo.rb /tmp/solo.rb
ADD dev.bbc.co.uk.pem /tmp/dev.bbc.co.uk.pem

RUN rpm -ivh http://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm
RUN yum install -y curl git
RUN curl https://www.opscode.com/chef/install.sh | bash
RUN git clone --depth=1 https://github.com/sthulb/chef-cookbooks.git /tmp/chef
RUN /opt/chef/bin/chef-solo --log_level debug -c /tmp/solo.rb -j /tmp/runlist.json

CMD ["/usr/bin/supervisord"]
