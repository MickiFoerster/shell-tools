function ml-plot-file() {
    cat <<EOM
import matplotlib.pyplot as plt
import sys

if len(sys.argv) < 2:
    print(f"Usage: python {sys.argv[0]} <filename with numbers to plot>")
    sys.exit(1)

file_path = sys.argv[1]

with open(file_path, "r") as file:
    data = [float(line.strip()) for line in file.readlines()]

plt.plot(data)
plt.title(f"Plot of Numbers from {file_path}")
plt.xlabel("Index")
plt.ylabel("Value")
plt.show()
EOM
}

function mlflow-local-start() {
    set -x

    cd /tmp/
    #rm -rf /tmp/mlflow-local
    mkdir -p mlflow-local && cd $_ && mkdir -p /tmp/mlflow-local/artifact_store /tmp/mlflow-local/metrics_store
    mlflow server \
        --backend-store-uri sqlite:////tmp/mlflow-local/metrics_store/mlflow.db \
        --default-artifact-root /tmp/mlflow-local/artifact_store \
        --host localhost \
        --port 5000

    set +x
}

function mlflow-docker-start() {
    set -x

    cd /tmp/
    rm -rf /tmp/mlflow-docker
    mkdir -p mlflow-docker && cd $_ && mkdir -p /tmp/mlflow-docker/artifact_store /tmp/mlflow-docker/metrics_store
    chmod 777 /tmp/mlflow-docker -R
    docker pull ghcr.io/mlflow/mlflow
    docker run \
        --user $(id -u) \
        -v /tmp/mlflow-docker/artifact_store:/artifact_store \
        -v /tmp/mlflow-docker/metrics_store:/metrics_store \
        --publish 127.0.0.1:5000:5000 \
        --rm \
        ghcr.io/mlflow/mlflow \
        mlflow server \
        --backend-store-uri sqlite:////metrics_store/mlflow.db \
        --default-artifact-root /tmp/mlflow-docker/artifact_store \
        --host 0.0.0.0 \
        --port 5000

    set +x
}

function ml-tensorflow-show-signature() {
    if ! command -v saved_model_cli; then
        echo "failed to find saved_model_cli: wrong venv activated?"
        exit 1
    fi

    if [ ! -d "$1" ]; then
        echo "$1 is not a directory"
        exit 1
    fi
    if [ ! -f "$1/saved_model.pb" ]; then
        echo "$1 does not contain file saved_model.pb "
        exit 2
    fi

    saved_model_cli show --dir $1 --tag_set serve --signature_def serving_default 2>/dev/null
}

function ml-tensorflow-tfserve() {
    cat <<EOM

# Prework: put model into /tmp/my_mnist_model.tf/0001

MODEL_DIR=/tmp/my_mnist_model.tf  tensorflow_model_server --ort=8500 --rest_api_port=8501 --model_name=my_mnist_model --model_base_path=/tmp/my_mnist_model.tf

# or start docker container 
docker run -it --rm \
    -v "/tmp/my_mnist_model.tf:/models/my_mnist_model" \
    -p 8500:8500 \
    -p 8501:8501 \
    -e MODEL_NAME=my_mnist_model \
    tensorflow/serving



###############################################################################
# Then write query script in Python for REST API:
import json

X_new = x_test[:3]
request_json = json.dumps({
    "signature_name": "serving_default",
    "instances": X_new.tolist(),
})

import requests

server_url = "http://localhost:8501/v1/models/my_mnist_model:predict"
response = requests.post(server_url, data=request_json)
response.raise_for_status()
response = response.json()

import numpy as np

y_proba = np.array(response["predictions"])
y_proba.round(2)


###############################################################################
# Or you write python code to query the gRPC endpoint:
#
!pip install -q -U tensorflow-serving-api

# load model, here 0001 is folder where file saved_model.pb lies
loaded = tf.saved_model.load("/tmp/my_mnist_model.tf/0001")
infer = loaded.signatures["serving_default"]
input_names = list(infer.structured_input_signature[1].keys())
output_names = list(infer.structured_outputs.keys())

from tensorflow_serving.apis.predict_pb2 import PredictRequest

# create gRPC request
request = PredictRequest()
request.model_spec.name = "my_mnist_model"
request.model_spec.signature_name = "serving_default"
#request.inputs[ model.layers[0].name ].CopyFrom(tf.make_tensor_proto(X_new))
request.inputs[ input_names[0] ].CopyFrom(tf.make_tensor_proto(tf.cast(X_new, tf.float32)))

# create connection to gRPC endpoint and send request
import grpc
from tensorflow_serving.apis import prediction_service_pb2_grpc

channel = grpc.insecure_channel('localhost:8500')
predict_service = prediction_service_pb2_grpc.PredictionServiceStub(channel)
response = predict_service.Predict(request, timeout=3.0)

# convert response and show result:
output_name = output_names[0]
outputs_proto = response.outputs[output_name]
y_proba = tf.make_ndarray(outputs_proto)
y_proba.round(2)

###############################################################################


EOM

}

function ml-tensorflow-show-evaluation() {
    cat <<EOM

import matplotlib.pyplot as plt

pd.DataFrame(history.history).plot(figsize=(8, 5))
plt.grid(True)
#plt.gca().set_ylim(0, 1)
plt.show()

EOM
}

function ml-tensorflow-check-GPU() {
    python3 -c 'import tensorflow as tf; print(tf.constant([]).device)'
}

function ml-tensorflow-sequential() {
    cat <<EOM

import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.models import load_model
from tensorflow.keras.layers import Dense, Activation,Dropout
from tensorflow.keras.constraints import max_norm

model = Sequential()
model.add(Dense(32, activation='relu')
model.add(Dropout(0.2))

model.add(Dense(16, activation='relu')
model.add(Dropout(0.2))

model.add(Dense(8, activation='relu')
model.add(Dropout(0.2))

model.add(Dense(units=1, activation='sigmoid')
model.add(Dropout(0.2))

model.compile(loss='binary_crossentropy', optimizer='adam')

early_stop_cb = tf.keras.callbacks.EarlyStopping(patience=10, restore_best_weights=True)

# Train model
model.fit(x=X_train,
          y=y_train,
          epochs=1000,
          validation_data=(X_test, y_test), verbose=1,
          callbacks=[early_stop_cb]
      )

# Save model
model.save('model.keras'))

# evaluation of the model
pd.DataFrame(model.history.history)[['loss', 'val_loss']].plot()

from sklearn.metrics import classification_report,confusion_matrix

predictions = (model.predict(X_test) > 0.5).astype('int32')
print(classification_report(y_test,predictions))
confusion_matrix(y_test,predictions)

# Predict
X_new = X_test[:3]
y_proba = model.predict(X_new)
print(y_proba.round(2))

## Save model
model.save("classification-model", save_format="tf")

## Load model
model = tf.keras.models.load_model("classification-model")
y_proba = model.predict(X_new)
print(y_proba.round(2))

EOM
}

function ml-pandas-one_hot_encoding() {
    cat <<EOM

dummies = pd.get_dummies(df['enumeration_column'], drop_first=True)
# remove old column and add one-hot-encoded columns
df.drop('enumeration_column', axis=1, inplace=True)
df = pd.concat([df, dummies], axis=1)

EOM
}

function ml-pandas-show_object_columns() {
    cat <<EOM

    df.select_dtypes(['object']).columns

EOM
}

function logistic_regression() {
    cat <<EOM
# load dataframe ...
df = ...
# Create a jointplots showing correlations of different feature combinations 
sns.jointplot(x='Age',y='Area Income',data=df)

sns.jointplot(x='Age', y='Daily Time Spent on Site', data=df, kind='kde')

sns.jointplot(x='Daily Time Spent on Site',y='Daily Internet Usage',data=df,color='green')


from sklearn.model_selection import train_test_split

X = df[['Daily Time Spent on Site', 'Age', 'Area Income','Daily Internet Usage', 'Male']]
y = df['Clicked on Ad']

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

logmodel = LogisticRegression()
logmodel.fit(X_train,y_train)

predictions = logmodel.predict(X_test)

from sklearn.metrics import classification_report

print(classification_report(y_test,predictions))

EOM

}

function linear_regression() {
    cat <<EOM

df = pd.read_csv('../USA_Housing_toy.csv')

# Show the first five row.

df.head()

# The isnull() method is used to check and manage NULL values in a data frame.
df.isnull().sum()


# Pandas describe() is used to view some basic statistical details of a data frame or a series of numeric values.
df.describe()

# Pandas info() function is used to get a concise summary of the dataframe.
df.info()

print(df,5)

sns.pairplot(df)

# distribution of target column 'price'
sns.displot(df['Price'])


# Heatmap to see correlated variables
df = df.drop(['Address'], axis=1)
sns.heatmap(df.corr())

# Linear Model
X = df[['Avg. Area Income', 'Avg. Area House Age', 'Avg. Area Number of Rooms',
               'Avg. Area Number of Bedrooms', 'Area Population']]
y = df['Price']

from sklearn.model_selection import train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.4, random_state=101)

from sklearn.linear_model import LinearRegression
lm = LinearRegression()

# print the intercept
print(lm.intercept_)

coeff_df = pd.DataFrame(lm.coef_,X.columns,columns=['Coefficient'])
coeff_df

# Validate model
predictions = lm.predict(X_test)

# real value and predicted values should be linear correlated
plt.scatter(y_test,predictions)

# check residual of difference of ytest and predictions
sns.displot((y_test-predictions),bins=50);

from sklearn import metrics

print('MAE:', metrics.mean_absolute_error(y_test, predictions))
print('MSE:', metrics.mean_squared_error(y_test, predictions))
print('RMSE:', np.sqrt(metrics.mean_squared_error(y_test, predictions)))

EOM

}

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
    if [[ -f $f ]]; then
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
import scipy.stats as stats

sns.set()

EOM
}

function ml-linear-regression() {
    ml-sklearn-linear-regression
}

function ml-sklearn-linear-regression() {
    cat <<EOM
# pip install scikit-learn
import numpy as np
from sklearn.linear_model import LinearRegression

# These are the points we know
years = np.array([2020, 2021, 2022, 2023, 2024]).reshape(-1, 1)
costs = np.array([1000.00, 2000.00, 3000.00, 4000, 5000])

# Create and train a model for predicting future values
model = LinearRegression()
model.fit(years, costs)

# Predict the cost for 2025
future = np.array([2025, 2026, 2027]).reshape(-1, 1)
predicted_costs = model.predict(future)

print(predicted_costs)

EOM
}

function ml-sklearn-feature_selection() {
    cat <<EOM
from sklearn.feature_selection import f_regression
from sklearn.feature_selection import SelectFromModel

from sklearn.linear_model import Lasso

sel = SelectFromModel(Lasso(alpha=0.01, random_state=42))
sel.fit(X_train, y_train)

# get_support() returns array of True (support feature), False (unsupportive)
# the following returns the number of supportive features
sel.get_support().sum()
EOM
}

function ml-sklearn-preprocessing() {
    cat <<EOM

from sklearn.preprocessing import MinMaxScaler

scaler = MinMaxScaler()
X_train = scaler.fit_transform(X_train)
# same as
# scaler.fit(X_train)
# X_train = scaler.transform(X_train)

# DON'T fit validation data!!!
scaler.transform(X_test)

EOM
}

function ml-sklearn-preprocessing() {
    cat <<EOM

# Feature Scaling
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import MinMaxScaler
from sklearn.preprocessing import RobustScaler

from sklearn.preprocessing import PolynomialFeatures

sc = StandardScaler
X_train[:, 3:5] = sc.fit_transform(X_train[:, 3:5])
# Use same scaler as before to test set (no call to fit()!)
X_test[:, 3:5] = sc.transform(X_test[:, 3:5])


# One-Hot-Encoder

from sklearn.compose import ColumnTransformer
from sklearn.preprocessing import OneHotEncoder
from sklearn.preprocessing import OrdinalEncoder

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

# if labels are stored in last column of dataframe:
X = df.iloc[:, :-1].values
y = df.iloc[:, -1].values
# or you split like here
X = df.drop('target_column', axis=1).values
y = df['target_column'].values

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

vars_with_na = [var for var in train.columns if train[var].isnull().sum()>0]

# show percentage of missing values ordered by most missing values first
train[vars_with_na].isnull().mean().sort_values(ascending=False)
# as plot:
train[vars_with_na].isnull().mean().sort_values(ascending=False).plot.bar(figsize=(15,4))
plt.ylabel('Percentage of missing data')
plt.axhline(y=0.9, color='r', linestyle='-')
plt.axhline(y=0.8, color='orange', linestyle='-')
plt.axhline(y=0.5, color='y', linestyle='-')
plt.axhline(y=0.05, color='g', linestyle='-')

def analyse_missing_values(df, var):
    df = df.copy()

    # group given column into two groups: 0 for missing and 1 for available 
    df[var] = np.where(df[var].isnull(), 1, 0)

    # calculate mean and std deviation of target value when value is missing 
    # and when value is present
    tmp = df.groupby(var)[train.columns[-1]].agg(['mean', 'std'])

    # show this difference: if mean and std deviation is almost the same then 
    # feature is not predictive
    tmp.plot(kind="barh", y="mean", legend=False,
             xerr="std", title=train.columns[-1], color='blue')
    plt.show()

for var in vars_with_na:
    analyse_missing_values(data, var)
EOM
}

function ml-sklearn-missing_values() {
    ml-sklearn-impute
}

function ml-printoptions() {
    cat <<EOM

  np.set_printoptions(precision=2)
  pd.pandas.set_option('display.max_columns', None)

EOM
}

function ml-numerical-values() {
    cat <<EOM
train = pd.read_csv('train.csv')
cat_vars = [col for col in train.columns if train[col].dtype == 'object']
# assuming that the last column contains the target values
num_vars = [var for var in train.columns if var not in cat_vars and var != train.columns[-1]]

EOM
}

function ml-tensorflow-mnist() {
    cat <<EOF
import tensorflow as tf

# Load the MNIST dataset
(x_train, y_train), (x_test, y_test) = tf.keras.datasets.mnist.load_data()

# Preprocess the data
x_train, x_test = x_train / 255.0, x_test / 255.0  # Normalize the pixel values to [0, 1]

# Define the model
model = tf.keras.Sequential([
    tf.keras.layers.Flatten(input_shape=(28, 28)),  # Flatten 28x28 images to 784-dimensional vectors
    tf.keras.layers.Dense(128, activation='relu'),  # First dense layer with ReLU activation
    tf.keras.layers.Dense(64, activation='relu'),   # Second dense layer with ReLU activation
    tf.keras.layers.Dense(10, activation='softmax') # Output layer with softmax activation for 10 classes
])

# Compile the model
model.compile(optimizer='adam',                # Optimizer
              loss='sparse_categorical_crossentropy',  # Loss function for multi-class classification
              metrics=['accuracy'])            # Metric to monitor

# Train the model
model.fit(x_train, y_train, epochs=5, validation_data=(x_test, y_test))

# Evaluate the model on test data
test_loss, test_accuracy = model.evaluate(x_test, y_test, verbose=2)
print(f"Test accuracy: {test_accuracy:.4f}")

# Save model 
from pathlib import Path

model_name = "my_mnist_model.tf"
model_version = "0001"
model_path = Path(model_name) / model_version
model.export(model_path)

# ONLY for Google Colab
!zip -r my_mnist_model.zip my_mnist_model.tf
from google.colab import files
files.download("my_mnist_model.zip")

EOF
}

function ml-sklearn-housing_example() {
    cat <<EOM
# pip install pipreqs
# pipreqs .
# ls requirements.txt

from pathlib import Path

import logging
import numpy as np
import pandas as pd
import tarfile
import urllib.request


def load_housing_data():
    tarball_path = Path("datasets/housing.tgz")
    if not tarball_path.is_file():
        Path("datasets").mkdir(parents=True, exist_ok=True)
        url = "https://github.com/ageron/data/raw/main/housing.tgz"
        urllib.request.urlretrieve(url, tarball_path)
        with tarfile.open(tarball_path) as housing_tarball:
            housing_tarball.extractall(path="datasets")

    return pd.read_csv(Path("datasets/housing/housing.csv"))


logging.info("Execution starts ...")

housing = load_housing_data()


from sklearn.model_selection import train_test_split

housing["income_cat"] = pd.cut(housing["median_income"],
                               bins=[0., 1.5, 3.0, 4.5, 6., np.inf],
                               labels=[1, 2, 3, 4, 5])

strat_train_set, strat_test_set = train_test_split(
    housing, test_size=0.2, stratify=housing["income_cat"], random_state=42)

# Stratification: Ensures that each training and test split has approximately
# the same proportion of each class or category as the original dataset.
housing = strat_train_set.drop("median_house_value", axis=1)
housing_labels = strat_train_set["median_house_value"].copy()




from sklearn.impute import SimpleImputer
from sklearn.preprocessing import OneHotEncoder 
from sklearn.preprocessing import StandardScaler 
from sklearn.pipeline import make_pipeline

num_pipeline = make_pipeline(SimpleImputer(strategy="median"), StandardScaler())
cat_pipeline = make_pipeline(SimpleImputer(strategy="most_frequent"), OneHotEncoder(handle_unknown="ignore"))

from sklearn.compose import make_column_selector, make_column_transformer

preprocessing = make_column_transformer(
    (num_pipeline, make_column_selector(dtype_include=np.number)), 
    (cat_pipeline, make_column_selector(dtype_include=object)),
)

housing_prepared = preprocessing.fit_transform(housing)



from sklearn.linear_model import LinearRegression

lin_reg = make_pipeline(preprocessing, LinearRegression())
lin_reg.fit(housing, housing_labels)



# Evaluate your model on the test set

from sklearn.metrics import root_mean_squared_error

X_test = strat_test_set.drop("median_house_value", axis=1)
y_test = strat_test_set["median_house_value"].copy()

evaluation_predictions = lin_reg.predict(X_test)

evaluation_rmse = root_mean_squared_error(y_test, evaluation_predictions)
logging.info(f"evaluation root mean squared error: {evaluation_rmse}")

# Launch, monitor, and maintain your system

# Export model to local system
import joblib
model_name = "model.joblib"
joblib.dump(lin_reg, model_name)

import pickle
with open("model.pkl", "wb") as file:
    pickle.dump(model, file)


logging.info(f"model exported successfully into file {model_name}")

# Upload model to Google Cloud Storage 
from google.cloud import storage 
storage_path = f"gs://ml-playground-441907-linear_regression_bucket/{model_name}"

blob = storage.blob.Blob.from_string(storage_path, client=storage.Client())
blob.upload_from_filename(model_name)

EOM
}
