function ml-links() {
    cat <<EOM
Textbook 'Hands-On Machine Learning with Scikit-Learn, Keras & TensorFlow
- https://github.com/ageron/handson-ml3.git
- Jupyter Notebook: https://homl.info/colab3


Popular open data repositories:
- https://openml.org
- https://kaggle.com/datasets
- https://paperswithcode.com/datasets
- https://archive.ics.uci.edu/ml
- Amazon's AWS datasets: https://registry.opendata.aws
- TensorFlow datasets: https://tensorflow.org/datasets

Meta portals (they list open data repositroies):
- dataportals.org
- opendatamonitor.eu

Other pages listing many popular open data repositories:
- Wikipedia's list of machine learning datasets: https://homl.info/9
- Quora.com: https://homl.info/10
- The datasets subreddit https://reddit.com/r/datasets

EOM
}

function ml-python-env() {
    f=$HOME/machine-learning/bin/activate
    if [[ -f $f ]] ; then 
        source $f
    else
        p=$(realpath $0)
        d=$(dirname $p)
        $d/install-python3-venv-machine-learning.sh && source $f
    fi
}

function ml-header() {
    cat <<EOM 

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt 
import seaborn as sns 
sns.set()


EOM
}

function ml-sklearn-linear-regression() {
  ml-header
  cat <<EOM
from sklearn.linear_model import LinearRegression
EOM
}
