#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#
# create a conda environment
ENV="$1"

if [ "$ENV-" == "-" ]; then
    #CDIR="$(basename "$PWD")"
    ENV="$(basename "$0" .sh)"
fi

set  -o pipefail
if conda env list | grep ".*${ENV}.*" >/dev/null 2>&1; then
    echo "conda $ENV already exists, skipping creation..."
else
    echo "env $ENV does not exist, creating it..."
    conda create -n "$ENV" python=2.7 -y
fi

# Next line is needed in otder to be able to activate the environment
CUR_SHELL=shell.$(basename -- "${SHELL}")
eval "$(conda "$CUR_SHELL" hook)"

set -e
conda activate "$ENV"
echo "INFO: conda environment $ENV created and activated"

# Include usual repositories
REPOS=(-c r -c conda-forge -c bioconda)

git clone https://git.metabarcoding.org/obitools/obitools.git
cd obitools
pip install jinja2
pip install -U setuptools
pip install sphinx
pip install "cython<3.0.0"
python setup.py build
python setup.py install

echo "Created the following conda environments: $ENV"
echo "All done."

exit 0