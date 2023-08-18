FROM debian:stable-slim

ENV VERSION latest

RUN echo "*** updating system packages ***" && \ 
    apt-get -qq update

RUN echo "*** prepare build environment ***" && \
    apt-get -qq --no-install-recommends -y install \
    wget devscripts build-essential qtbase5-dev qttools5-dev-tools

WORKDIR /tmp    
RUN echo "*** fetch jamulus source ***" && \
    wget https://github.com/jamulussoftware/jamulus/archive/${VERSION}.tar.gz && \
    tar xzf latest.tar.gz
    
WORKDIR /tmp/jamulus-${VERSION}   
RUN echo "*** compile jamulus ***" && \
   qmake "CONFIG+=nosound headless serveronly" Jamulus.pro && \
   make clean && \
   make && \
   cp Jamulus /usr/local/bin/jamulus-headless

RUN echo "*** clean up build environment ***" && \
   rm -rf /tmp/* && \
   apt-get -qq clean && \
   apt-get -qq --purge wget devscripts build-essential qtbase5-dev qttools5-dev-tools && \
   apt-get -qq --purge autoremove -y
   
RUN echo "*** prepare run environment ***" && \
   apt-get -qq --no-install-recommends -y install \
   tzdata libqt5core5a libqt5network5 libqt5xml5

ENTRYPOINT ["jamulus-headless"]
RUN renice -20 1
RUN ionice -c 1 -p 1
