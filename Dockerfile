FROM ubuntu:18.04
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
WORKDIR /gitlab

RUN apt-get update && apt-get upgrade -y
RUN apt-get install git -y

RUN git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git
WORKDIR /gitlab/openairinterface5g
RUN git checkout develop

RUN /bin/bash -c 'source oaienv'

WORKDIR /gitlab/openairinterface5g/cmake_targets

RUN ./build_oai -I && ./build_oai --gNB --nrUE

WORKDIR /gitlab/openairinterface5g/cmake_targets/ran_build/build

RUN make rfsimulator

RUN ln -s librfsimulator.so liboai_device.so