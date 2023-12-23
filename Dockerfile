FROM ubuntu:18.04

ENV DISPLAY :0

ENV USERNAME developer

ENV container docker

ENV PATH /snap/bin:$PATH

ADD snap /usr/local/bin/snap

RUN apt-get update

RUN apt-get install -y snapd sudo

RUN systemctl enable snapd

RUN systemctl enable snapd.apparmor

RUN echo "backus ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN useradd --no-log-init --home-dir /home/$USERNAME --create-home --shell /bin/bash $USERNAME

RUN adduser $USERNAME sudo

STOPSIGNAL SIGRTMIN+3

CMD [ "/sbin/init" ]
