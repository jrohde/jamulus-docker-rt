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
   apt-get -qq --purge -y remove wget devscripts build-essential qtbase5-dev qttools5-dev-tools && \
   apt-get -qq --purge -y autoremove
   
RUN echo "*** prepare run environment ***" && \
   apt-get -qq --no-install-recommends -y install \
   tzdata procps libqt5core5a libqt5network5 libqt5xml5

ENTRYPOINT ["/usr/bin/nice -n -20 /usr/bin/ionice -c 1 /usr/local/bin/jamulus-headless -s -n -T -F"]
