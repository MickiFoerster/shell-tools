#!/bin/bash

set -ex

cd $HOME
t=python3.11-venv-dbt
python3.11 -m venv $t
. $t/bin/activate
pip install --upgrade pip
pip install dbt-snowflake==1.7.1

curl https://raw.githubusercontent.com/fishtown-analytics/dbt-completion.bash/master/dbt-completion.bash >$HOME/bin/dbt-completion.bash

set +ex
