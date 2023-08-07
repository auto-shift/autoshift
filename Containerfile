FROM registry.access.redhat.com/ubi9:9.2-696

RUN dnf -y install git unzip \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python3 get-pip.py --user

RUN python3 -m pip install --user \
    ansible \
    boto3 \
    boto \
    openshift \
    oauthlib==3.2.0

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

WORKDIR /ansible