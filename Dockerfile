FROM ubuntu:focal
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y build-essential git clang libx11-dev tightvncserver xorg openbox xvfb

RUN Xvfb :1 -screen 0 1042x790x16 &> xvfb.log & ps aux | grep X
RUN mkdir ~/.ssh
RUN touch /home/id_rsa
RUN ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts
RUN git clone https://github.com/masinter/maiko.git

WORKDIR /maiko/bin
RUN ./makeright x
RUN ./makeright init

RUN DISPLAY=:1.0
RUN export DISPLAY

COPY . /medley
WORKDIR /medley
#RUN DISPLAY=:1.0 & export DISPLAY & ./scripts/loadup-all.sh 

#RUN Xvfb :99 -screen 0 1440x900x16 &> xvfb.log & ps aux | grep X
#RUN DISPLAY=:99.0 & export DISPLAY 
#RUN export DISPLAY
#RUN ./run-medley
