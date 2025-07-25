#!/bin/bash
set -x

apt-get update && \
apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        \
        librdmacm1t64 \
        libibverbs1 \
        \
        ibverbs-providers \
        net-tools \
        netcat-traditional \
        \
        inetutils-ping \
        hping3 \
        \
        nmap \
        nload \
        iftop \
        && \
    apt-get clean 

