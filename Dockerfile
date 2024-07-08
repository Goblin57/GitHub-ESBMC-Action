FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && apt-get install -y python3-pip git wget universal-ctags

RUN git clone https://github.com/janislley/lsverifier.git && cd lsverifier && pip3 install . --break-system-packages


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]