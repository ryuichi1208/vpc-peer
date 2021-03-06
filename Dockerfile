FROM python:3.6

ARG pip_installer="https://bootstrap.pypa.io/get-pip.py"
ARG awscli_version="1.16.168"
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

COPY ./src /root/src
COPY ./docker/terraform/.aws /root/.aws
COPY ./docker/terraform/init.sh /root/init.sh

RUN pip install awscli==${awscli_version}
RUN pip install --user --upgrade aws-sam-cli
ENV PATH $PATH:/root/.local/bin
RUN apt-get update && apt-get install -y less vim wget unzip
RUN wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip && \
    unzip ./terraform_0.11.13_linux_amd64.zip -d /usr/local/bin/
RUN chmod +x /root/init.sh && /root/init.sh

WORKDIR /root/src
