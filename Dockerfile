FROM ubuntu:20.04 AS build

# OBJECTIVE: can I get InVEST to build nicely with ubuntu 20:04 and then run on debian:trixie?
RUN apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y \
        python3-setuptools \
            python3-wheel \
            cython \
            python3-numpy \
            gdal-bin \
            python3-pip \
            build-essential\
        && \
        pip3 wheel --no-deps --wheel-dir=/tmp/ natcap.invest


FROM debian:trixie
COPY --from=build /tmp/*.whl /tmp/
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        python3 \
        python3-gdal \
        python3-shapely \
        python3-wheel \
        python3-numpy \
        python3-scipy \
        build-essential \
        python3-pip \
    && \
    pip3 install /tmp/*.whl && \
    python3 -c "from natcap.invest.sdr import sdr"

