def LR(data_path = '/Users/mojtabaaskarzadeh/Library/CloudStorage/GoogleDrive-ma00048@mix.wvu.edu/My Drive/1-time-series classification in manufacturing/Datasets', 
        dataset = 'Etching_Dataset', C=10):


    import sklearn
    import os
    import numpy as np
    import time


    if os.name == 'posix':
        path_dir = '/Users/mojtabaaskarzadeh/Library/CloudStorage/GoogleDrive-ma00048@mix.wvu.edu/My Drive/1-time-series classification in manufacturing/Datasets'
    elif os.name == 'nt':
        path_dir = 'g:/My Drive/1-time-series classification in manufacturing/Datasets'
    else:
        path_dir = '/Users/mojtabaaskarzadeh/Library/CloudStorage/GoogleDrive-ma00048@mix.wvu.edu/My Drive/1-time-series classification in manufacturing/Datasets'

    print(f'The datasets path directory is:{path_dir}')


    # Load the dataset
    path = data_path + "/" + dataset + "/"
    X_train = np.load(path + 'X_train.npy')
    X_test = np.load(path + 'X_test.npy')
    y_train = np.load(path + 'y_train.npy').reshape((-1,))
    y_test = np.load(path + 'y_test.npy').reshape((-1,))
    ts = np.concatenate((X_train, X_test), axis=0)

    print(f"\n The dataset shape is:{ts.shape}")
    print(f"\n The number of data samples (N) is:{ts.shape[0]}")
    print(f"\n The number of TS length (T) is:{ts.shape[1]}")
    print(f"\n The number of TS dimention (M) is:{ts.shape[2]}")


    ## Classification
    from sklearn.linear_model import LogisticRegression

    t_total = time.time() ##Start timing
    classifier = LogisticRegression(C=C, max_iter=100000)
    classifier.fit(X_train[:,:,0], y_train)


    print("\n The classifier is fitted")
    y_pred = classifier.predict(X_test[:,:,0])

    from sklearn.metrics import confusion_matrix, classification_report
    cm = confusion_matrix(y_test, y_pred)
    print(cm)
    print(classification_report(y_test, y_pred))

    print(" Finished!")
    print("Total time elapsed: {:.4f}s".format(time.time() - t_total))