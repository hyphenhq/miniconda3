FROM frolvlad/alpine-miniconda3:latest

RUN apk update

RUN conda install python=3.7.5

RUN conda update conda
RUN conda config --add channels conda-forge
RUN conda install -c conda-forge rtree deap osmnx
RUN pip install networkx geopy sklearn
RUN conda install --channel conda-forge --override-channels "gdal>2.2.4"

RUN conda install -c cvxgrp cvxpy

RUN CVXOPT_BUILD_GLPK=1
RUN CVXOPT_GLPK_LIB_DIR=/path/to/glpk-X.X/lib
RUN CVXOPT_GLPK_INC_DIR=/path/to/glpk-X.X/include
RUN pip install cvxopt

RUN conda install numpy
# if this leads to cvxpy not working, try RUN pip install -U numpy

RUN apk add --no-cache bash

RUN conda config --add channels pkgw-forge
RUN conda config --add channels ostrokach-forge
# RUN conda install -c pkgw-forge gtk3
RUN conda install -c pkgw/label/superseded gtk3
RUN conda install -c conda-forge pygobject
RUN conda install -c conda-forge matplotlib
RUN conda install -c ostrokach-forge graph-tool

RUN conda config --set show_channel_urls true 
RUN conda config --prepend channels conda-forge 
# RUN conda update --strict-channel-priority --yes -n base conda 
# RUN conda install --strict-channel-priority --update-all --force-reinstall --yes osmnx python-igraph 

RUN conda install -c conda-forge osmnx
RUN conda install -c conda-forge python-igraph

RUN conda clean --yes --all 
RUN conda info --all 
RUN conda list

RUN conda install mpi4py geos

RUN apk add --no-cache --virtual build-base postgresql-dev libffi-dev gcc libc-dev linux-headers bash \
    jpeg-dev zlib-dev

RUN echo "http://mirror.leaseweb.com/alpine/edge/community" >> /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk add --virtual .build-deps \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
    --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
    gcc libc-dev geos-dev geos && \
    runDeps="$(scanelf --needed --nobanner --recursive /usr/local \
    | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
    | xargs -r apk info --installed \
    | sort -u)" && \
    apk add --virtual .rundeps $runDeps