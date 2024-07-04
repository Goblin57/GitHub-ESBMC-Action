FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive



RUN git clone https://github.com/janislley/lsverifier.git && cd LSVerifier && pip3 install .



COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]