import sktime
import os
import numpy as np
import argparse
import time

parser = argparse.ArgumentParser()

# dataset settings
parser.add_argument('--data_path', type=str, default='/Users/mojtabaaskarzadeh/Library/CloudStorage/GoogleDrive-ma00048@mix.wvu.edu/My Drive/1-time-series classification in manufacturing/Datasets',
                    help='the path of data.')
parser.add_argument('--dataset', type=str, default='Etching_Dataset', #Etching
                    help='time series dataset. Options: See the datasets list')

# Training parameter settings
parser.add_argument('--n_kernel', type=int, default=500,
                    help= "Number of kernels of the transformer " )
                    



args = parser.parse_args()

# Load the dataset
path = args.data_path + "/" + args.dataset + "/"
X_train = np.load(path + 'X_train.npy')
X_test = np.load(path + 'X_test.npy')
y_train = np.load(path + 'y_train.npy').reshape((-1,))
y_test = np.load(path + 'y_test.npy').reshape((-1,))
ts = np.concatenate((X_train, X_test), axis=0)

print(f"\n The dataset shape is:{ts.shape}")
print(f"\n The number of data samples (N) is:{ts.shape[0]}")
print(f"\n The number of TS length (T) is:{ts.shape[1]}")
print(f"\n The number of TS dimention (M) is:{ts.shape[2]}")

##Swzp axis
X_train = np.swapaxes(X_train, 1,2)
X_test = np.swapaxes(X_test, 1,2)

## Classification
import numpy as np
from sklearn.linear_model import RidgeClassifierCV
from sklearn.pipeline import make_pipeline
from sklearn.utils.multiclass import class_distribution

from sktime.classification.base import BaseClassifier
from sktime.transformations.panel.rocket import Rocket

## Implement the Rocket classifier

class ROCKETClassifier(BaseClassifier):
    """Classifier wrapped for the ROCKET transformer using RidgeClassifierCV.

    Parameters
    ----------
    num_kernels             : int, number of kernels for ROCKET transform
    (default=10,000)
    n_jobs                  : int, optional (default=1)
    The number of jobs to run in parallel for both `fit` and `predict`.
    ``-1`` means using all processors.
    random_state            : int or None, seed for random, integer,
    optional (default to no seed)

    Attributes
    ----------
    classifier              : ROCKET classifier
    n_classes               : extracted from the data

    Notes
    -----
    @article{dempster_etal_2019,
      author  = {Dempster, Angus and Petitjean, Francois and Webb,
      Geoffrey I},
      title   = {ROCKET: Exceptionally fast and accurate time series
      classification using random convolutional kernels},
      year    = {2019},
      journal = {arXiv:1910.13051}
    }

    Java version
    https://github.com/uea-machine-learning/tsml/blob/master/src/main/java/
    tsml/classifiers/shapelet_based/ROCKETClassifier.java
    """

    _tags = {
        "capability:multivariate": True,
        "capability:unequal_length": False,
        "capability:missing_values": False,
        "capability:train_estimate": False,
        "capability:contractable": False,
    }

    def __init__(
        self,
        num_kernels=10000,
        n_jobs=1,
        random_state=None,
    ):
        self.num_kernels = num_kernels
        self.n_jobs = n_jobs
        self.random_state = random_state

        self.classifier = None

        self.n_classes = 0
        self.classes_ = []
        self.class_dictionary = {}

        super(ROCKETClassifier, self).__init__()

    def _fit(self, X, y):
        """Build a pipeline containing the ROCKET transformer and RidgeClassifierCV.

        Parameters
        ----------
        X : nested pandas DataFrame of shape [n_instances, 1]
            Nested dataframe with univariate time-series in cells.
        y : array-like, shape = [n_instances] The class labels.

        Returns
        -------
        self : object
        """
        self.n_classes = np.unique(y).shape[0]
        self.classes_ = class_distribution(np.asarray(y).reshape(-1, 1))[0][0]
        for index, classVal in enumerate(self.classes_):
            self.class_dictionary[classVal] = index

        self.classifier = rocket_pipeline = make_pipeline(
            Rocket(
                num_kernels=self.num_kernels,
                random_state=self.random_state,
                n_jobs=self.n_jobs,
            ),
            RidgeClassifierCV(alphas=np.logspace(-3, 3, 10), normalize=True), verbose=True
        )
        rocket_pipeline.fit(X, y)

        return self

    def _predict(self, X):
        """Find predictions for all cases in X.

        Parameters
        ----------
        X : The training input samples. array-like or pandas data frame.
        If a Pandas data frame is passed, a check is performed that it only
        has one column.
        If not, an exception is thrown, since this classifier does not yet have
        multivariate capability.

        Returns
        -------
        output : array of shape = [n_test_instances]
        """
        return self.classifier.predict(X)

    def _predict_proba(self, X):
        """Find probability estimates for each class for all cases in X.

        Parameters
        ----------
        X : The training input samples. array-like or sparse matrix of shape
        = [n_test_instances, series_length]
            If a Pandas data frame is passed (sktime format) a check is
            performed that it only has one column.
            If not, an exception is thrown, since this classifier does not
            yet have
            multivariate capability.

        Returns
        -------
        output : array of shape = [n_test_instances, num_classes] of
        probabilities
        """
        dists = np.zeros((X.shape[0], self.n_classes))
        preds = self.classifier.predict(X)
        for i in range(0, X.shape[0]):
            dists[i, np.where(self.classes_ == preds[i])] = 1

        return dists


t_total = time.time() ##Start timing

classifier = ROCKETClassifier(num_kernels= args.n_kernel ,n_jobs=-1)
classifier.fit(X_train, y_train)

print("\n The classifier is fitted")
y_pred = classifier.predict(X_test)

from sklearn.metrics import confusion_matrix, classification_report
cm = confusion_matrix(y_test, y_pred)
print(cm)
print(classification_report(y_test, y_pred))

print(" Finished!")
print("Total time elapsed: {:.4f}s".format(time.time() - t_total))