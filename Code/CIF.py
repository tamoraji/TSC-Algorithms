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
parser.add_argument('--est', type=str, default=500,
                    help= "Number of estimators to build for the ensemble " )
                    
parser.add_argument('--att', type=str, default=8,
                    help= "Number of catch22 or summary statistic attributes to subsample per tree" )


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

## Input "n" series with "d" dimensions of length "m" . default config  based on [4] is : 
## Default (trees: n_estimators = 500, intervals: n_intervals = sqrt(m) × sqrt(d), att_subsample_size = 8 attributes per tree)

## Implement the CanonicalIntervalForest classifier
n_intervals = int(np.floor(np.sqrt(ts.shape[2])* np.sqrt(ts.shape[1])))
t_total = time.time() ##Start timing
from sktime.classification.interval_based import CanonicalIntervalForest
classifier = CanonicalIntervalForest(n_estimators=args.est, n_intervals= n_intervals, att_subsample_size=args.att, n_jobs=-1)
classifier.fit(X_train, y_train)
print("\n The classifier is fitted")
y_pred = classifier.predict(X_test)

from sklearn.metrics import confusion_matrix, classification_report
cm = confusion_matrix(y_test, y_pred)
print(cm)
print(classification_report(y_test, y_pred))

print(" Finished!")
print("Total time elapsed: {:.4f}s".format(time.time() - t_total))