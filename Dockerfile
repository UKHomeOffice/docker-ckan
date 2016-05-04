FROM quay.io/ukhomeofficedigital/centos-base

ENV CKAN_VERSION ckan-2.5.2
ENV HOME /root
ENV CKAN_HOME /app/ckan
ENV CKAN_CONFIG /etc/ckan/default
ENV CKAN_PLUGINS $CKAN_HOME/plugins
ENV USER_SCRIPT_DIR /userscripts
# NB: Change Volume and Entrypoint if you change these
ENV CKAN_DATA /var/lib/ckan
ENV ENTRYPOINT_SCRIPT_HOME /docker

# Install dependencies
RUN mkdir -p $USER_SCRIPT_DIR $CKAN_HOME $HOME $ENTRYPOINT_SCRIPT_HOME $CKAN_CONFIG $CKAN_DATA && \
    (yum install -y httpd openssl mod_ssl mod_wsgi git libffi-devel postgresql-devel gcc python-devel openssl-devel || yum install -y openssl mod_ssl httpd mod_wsgi git libffi-devel postgresql-devel gcc python-devel openssl-devel) && \
    yum clean all && \
    curl https://bootstrap.pypa.io/ez_setup.py -o - | python && \
    easy_install pip && \
    pip install pyopenssl ndg-httpsclient pyasn1 virtualenv && \
    rm /etc/httpd/conf.d/welcome.conf

# Get CKAN
WORKDIR $CKAN_HOME
RUN git clone https://github.com/ckan/ckan.git $CKAN_HOME && \
    git checkout $CKAN_VERSION

# CKAN Install
RUN virtualenv $CKAN_HOME && \
    . $CKAN_HOME/bin/activate && \
    $CKAN_HOME/bin/pip install pyopenssl ndg-httpsclient pyasn1 && \
    ln -s $CKAN_HOME/ckan/config/who.ini $CKAN_CONFIG/who.ini && \
    $CKAN_HOME/bin/pip install -r $CKAN_HOME/requirements.txt && \
    $CKAN_HOME/bin/pip install -e $CKAN_HOME/

# Cleanup
RUN yum remove -y gcc python-devel openssl-devel postgresql-devel && \
    yum clean all


# Setup Apache
RUN chown -R apache:apache $CKAN_DATA
ADD apache.conf /etc/httpd/conf.d/ckan.conf
ADD apache.wsgi $CKAN_CONFIG/apache.wsgi

RUN sed -i 's/Listen 80/Listen 5000/g' /etc/httpd/conf/httpd.conf

# Setup Entrypoint Scripts
RUN mkdir -p /etc/httpd/ssl
ADD /entrypoint $ENTRYPOINT_SCRIPT_HOME

ENTRYPOINT ["/docker/entrypoint.sh"]

VOLUME ["/var/lib/ckan"]
EXPOSE 8800
