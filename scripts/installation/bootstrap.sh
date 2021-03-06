#! /bin/bash

apt-get -y update
apt-get install -y python-pip python-dev g++ make libfreetype6-dev \
  libpng-dev libopenblas-dev liblapack-dev gfortran
pip install --use-mirrors setuptools distribute flake8 nose
pip install --use-mirrors numpy

pip install -e git+https://github.com/hackliff/intuition.git@develop#egg=intuition

if [ -n "$FULL_INTUITION" ]; then
  apt-get install -y r-base
  # Otherwize statsmodel fails:
  pip install --use-mirrors scipy patsy
  pip install -e git+https://github.com/hackliff/insights.git@develop#egg=insights-0.0.9
  #FIXME First installation needs to specify lib parameter
  #./scripts/installation/install_r_packages.R
fi
