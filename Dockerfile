FROM mongo

RUN apt-get update
RUN apt-get install -y python-pip
RUN pip install awscli
RUN apt-get install -y vim
RUN mkdir -p /backup/data
RUN apt-get install -y dnsutils
RUN apt-get install wget -y
RUN wget -O- -q http://s3tools.org/repo/deb-all/stable/s3tools.key | apt-key add -
RUN wget -O/etc/apt/sources.list.d/s3tools.list http://s3tools.org/repo/deb-all/stable/s3tools.list
RUN apt-get update && apt-get install s3cmd -y

ADD run /backup/run
WORKDIR /backup

RUN chmod +x ./run

ENTRYPOINT ["./run"]
CMD ["backup"]
