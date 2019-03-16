FROM frolvlad/alpine-miniconda3:latest

RUN conda config --add channels conda-forge && \
    conda install -c conda-forge rtree deap osmnx && \
    pip install networkx geopy sklearn && \
    conda install --channel conda-forge --override-channels "gdal>2.2.4"

RUN conda install -c cvxgrp cvxpy

RUN CVXOPT_BUILD_GLPK=1 && \
    CVXOPT_GLPK_LIB_DIR=/path/to/glpk-X.X/lib && \
    CVXOPT_GLPK_INC_DIR=/path/to/glpk-X.X/include && \
    pip install cvxopt

RUN conda install numpy
# if this leads to cvxpy not working, try RUN pip install -U numpy

RUN apk add --no-cache bash

RUN conda config --add channels pkgw-forge && \
    conda config --add channels ostrokach-forge && \
    conda install -c pkgw-forge gtk3 && \
    conda install -c conda-forge pygobject && \
    conda install -c conda-forge matplotlib && \
    conda install -c ostrokach-forge graph-tool

RUN conda config --set show_channel_urls true && \
    conda config --prepend channels conda-forge && \
    conda update --strict-channel-priority --yes -n base conda && \
    conda install --strict-channel-priority --update-all --force-reinstall --yes osmnx python-igraph && \
    conda clean --yes --all && \
    conda info --all && \
    conda list
