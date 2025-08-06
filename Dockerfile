FROM ubuntu:24.04
WORKDIR /

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y sudo wget unzip dos2unix python-is-python3 python3-dev mariadb-server cron && \
    apt-get clean
    
RUN wget http://launchpadlibrarian.net/475574732/libssl1.1_1.1.1f-1ubuntu2_amd64.deb && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
    dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
    dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb

# Copy original xui.one & cracking file
COPY . .

RUN wget http://launchpadlibrarian.net/475574732/libssl1.1_1.1.1f-1ubuntu2_amd64.deb && \
    wget http://archive.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
    wget  http://archive.ubuntu.com/ubuntu/pool/main/c/curl/libcurl4t64_8.5.0-2ubuntu10.6_amd64.deb && \
    cd /etc/apt && \
    mv sources.list sources.list.old && \
    wget https://gist.githubusercontent.com/hakerdefo/8d0cac9fa3aa0a632216742590e3e441/raw/44f9a88c4e8f085fc210bfb8a8f9f85d6674e89f/sources.list && \
    cd / && \
    dpkg -i libcurl4t64_8.5.0-2ubuntu10.6_amd64.deb && \
    dpkg -i libssl1.1_1.1.0g-2ubuntu4_amd64.deb && \
    dpkg -i libssl1.1_1.1.1f-1ubuntu2_amd64.deb
    
# Create a wrapper script that checks for installation
RUN echo '#!/bin/bash\n\
    if [ -f "/home/xui/status" ]; then\n\
        echo "XUI already installed, starting service..."\n\
        service mariadb start\n\
        /home/xui/service start\n\
    else\n\
        echo "Starting fresh installation..."\n\
        apt install nano cron libcurl4 -y  && bash /install.sh\n\
    fi\n\
    tail -f /dev/null' > /wrapper.sh && \
    chmod +x /wrapper.sh

VOLUME ["/home/xui", "/var/lib/mysql"]
EXPOSE 80

ENTRYPOINT ["/wrapper.sh"]
