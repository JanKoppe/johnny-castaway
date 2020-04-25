FROM ubuntu:20.04

RUN apt update \
 && apt install -y dosbox xvfb ffmpeg pulseaudio pavucontrol

WORKDIR /opt
ADD . /opt

CMD ["/opt/run.sh"]
