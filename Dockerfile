FROM ubuntu

RUN apt update 

RUN apt install -y \
    traceroute \
    netcat \
    net-tools \
    curl \
    telnet \
    wget \
    postgresql-client 
	
RUN rm -rf /var/lib/apt/lists/*
RUN apt clean


CMD [ "sleep", "1d" ]
