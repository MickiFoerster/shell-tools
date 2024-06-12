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

function ml-sklearn-feature_selection() {
  cat <<EOM
from sklearn.feature_selection import f_regression
EOM
}

function ml-sklearn-preprocessing() {
  cat <<EOM

# Feature Scaling
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import PolynomialFeatures

sc = StandardScaler
X_train[:, 3:5] = sc.fit_transform(X_train[:, 3:5])
# Use same scaler as before to test set (no call to fit()!)
X_test[:, 3:5] = sc.transform(X_test[:, 3:5])


# One-Hot-Encoder

from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder

col_to_be_encoded = 0 # first col=0, 2nd col = 1, ...
col_trans = ColumnTransformer(transformers=[('encoder', OneHotEncoder(), [col_to_be_encoded])], remainder='passthrough')
X_one_hot_encoded = col_trans.fit_transform(X)
X_one_hot_encoded

from sklearn.preprocessing import LabelEncoder

le = LabelEncoder()
y = le.fit_transform(y)


EOM
}

function ml-sklearn-model_selection() {
  cat <<EOM
from sklearn.model_selection import train_test_split
EOM
}

function ml-sklearn-test-train-split() {
    cat <<EOM
from sklearn.model_selection import train_test_split

X = df.iloc[:, :-1].values
y = df.iloc[:, -1].values

X_train, X_test, y_train, y_test = train_test_split(X,y, test_size=0.2, random_state=42)

EOM
}

function ml-sklearn-metrics() {
  cat <<EOM
from sklearn import metrics
EOM
}

function ml-sklearn-impute() {
  cat <<EOM
from sklearn.impute import SimpleImputer
EOM
}

function ml-sklearn-missing_values() {
    ml-sklearn-impute
}

function ml-printoptions() {
  cat <<EOM

  np.set_printoptions(precision=2)

EOM
}

