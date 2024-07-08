FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive


RUN apt-get update && apt-get install -y python3-pip git wget universal-ctags

# RUN wget https://github.com/universal-ctags/ctags-nightly-build/releases/download/2024.07.02%2B7cc5308a41787419fd08a73196aeb05672687c66/uctags-2024.07.02-linux-x86_64.tar.gz -O ctags.tar.gz && \
# tar -xf ctags.tar.gz && cd uctags-2024.07.02-linux-x86_64 && ls && mv uctags-2024.07.02-linux-x86_64 /usr/bin/ctags

RUN git clone https://github.com/janislley/lsverifier.git && cd lsverifier && pip3 install . --break-system-packages


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]