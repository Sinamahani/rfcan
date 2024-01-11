from tensorflow.keras import layers, models
from tensorflow.keras.models import Sequential
import tensorflow as tf
from tensorflow.keras.callbacks import EarlyStopping
import numpy as np
import pandas as pd
import obspy
import matplotlib.pyplot as plt
import os
# from codes_RF.dpqc_models import *



def seq_model(input_shape, activation, kernel_size, kernel_grad):
    #model definition
    
    model = Sequential([
        tf.keras.layers.Conv1D(filters=120, kernel_size=kernel_size, activation=activation, input_shape=input_shape),
        tf.keras.layers.MaxPooling1D(pool_size=2),
        tf.keras.layers.BatchNormalization(),
        tf.keras.layers.Conv1D(filters=100, kernel_size=kernel_size - kernel_grad, activation=activation),
        tf.keras.layers.MaxPooling1D(pool_size=2),
        tf.keras.layers.BatchNormalization(),
        tf.keras.layers.Conv1D(filters=50, kernel_size=kernel_size - kernel_grad * 2, activation=activation),
        tf.keras.layers.MaxPooling1D(pool_size=2),
        tf.keras.layers.BatchNormalization(),
        tf.keras.layers.Flatten(),
        tf.keras.layers.Dense(64, activation=activation),
        tf.keras.layers.Dropout(0.3),
        tf.keras.layers.BatchNormalization(),
        tf.keras.layers.Dense(32, activation=activation),
        tf.keras.layers.Dropout(0.4),
        tf.keras.layers.Dense(16, activation=activation),
        tf.keras.layers.Dropout(0.5),
        tf.keras.layers.Dense(1, activation='sigmoid')
        ])    
    return model


def unet_model(input_shape, initializer, kernel_size=3, activation='relu'):
    inputs = tf.keras.Input(shape=input_shape)

    from keras.initializers import GlorotUniform, Ones, Zeros, RandomNormal, he_normal, he_uniform
    if initializer == 'he_normal':
        initializer = he_normal(seed=10001)
    elif initializer == 'glorot_uniform':
        initializer = GlorotUniform(seed=10001)
    elif initializer == 'ones':
        initializer = Ones()
    elif initializer == 'zeros':
        initializer = Zeros()
    elif initializer == 'random_normal':
        initializer = RandomNormal(mean=0.0, stddev=0.05, seed=10001)
    elif initializer == 'he_uniform':
        initializer = he_uniform(seed=10001)
    else:
        raise Exception("initializer not found")
    



    # Encoder
    conv1 = layers.Conv1D(32, kernel_size, activation=activation, padding='same', kernel_initializer=initializer)(inputs)
    conv1 = layers.Conv1D(32, kernel_size, activation=activation, padding='same', kernel_initializer=initializer)(conv1)
    pool1 = layers.MaxPooling1D(pool_size=2)(conv1)

    conv2 = layers.Conv1D(64, kernel_size, activation=activation, padding='same', kernel_initializer=initializer)(pool1)
    conv2 = layers.Conv1D(64, kernel_size, activation=activation, padding='same', kernel_initializer=initializer)(conv2)
    pool2 = layers.MaxPooling1D(pool_size=2)(conv2)

    conv3 = layers.Conv1D(128, kernel_size, activation=activation, padding='same', kernel_initializer=initializer)(pool2)
    conv3 = layers.Conv1D(128, kernel_size, activation=activation, padding='same', kernel_initializer=initializer)(conv3)
    pool3 = layers.MaxPooling1D(pool_size=2)(conv3)

    # Middle
    conv4 = layers.Conv1D(256, kernel_size, activation=activation, padding='same', kernel_initializer=initializer)(pool3)
    conv4 = layers.Conv1D(256, kernel_size, activation=activation, padding='same', kernel_initializer=initializer)(conv4)

    # Decoder
    up5 = layers.UpSampling1D(size=2)(conv4)
    concat5 = layers.Concatenate()([conv3, up5])
    conv5 = layers.Conv1D(128, kernel_size, activation=activation, padding='same', kernel_initializer=initializer)(concat5)
    conv5 = layers.Conv1D(128, kernel_size, activation=activation, padding='same', kernel_initializer=initializer)(conv5)

    up6 = layers.UpSampling1D(size=2)(conv5)
    concat6 = layers.Concatenate()([conv2, up6])
    conv6 = layers.Conv1D(64, kernel_size, activation=activation, padding='same', kernel_initializer=initializer)(concat6)
    conv6 = layers.Conv1D(64, kernel_size, activation=activation, padding='same', kernel_initializer=initializer)(conv6)

    up7 = layers.UpSampling1D(size=2)(conv6)
    concat7 = layers.Concatenate()([conv1, up7])
    conv7 = layers.Conv1D(32, 3, activation='relu', padding='same', kernel_initializer=initializer)(concat7)
    conv7 = layers.Conv1D(32, 3, activation='relu', padding='same', kernel_initializer=initializer)(conv7)

    # Output
    flat1 = layers.Flatten()(conv7)
    dense1 = layers.Dense(32, activation='relu', kernel_initializer=initializer)(flat1)
    dense2 = layers.Dense(16, activation='relu', kernel_initializer=initializer)(dense1)
    output = layers.Dense(1, activation='sigmoid', kernel_initializer=initializer)(dense2)
    # output = layers.Conv1D(1, 1, activation='sigmoid')(dense3)

    model = models.Model(inputs=inputs, outputs=output)

    return model

def load_best_model(key):
    import os
    path = "DATA/DEEP_QC/"
    all = os.listdir(path)
    all = [[i, float(i.split("_")[2].split(".h5")[0])] for i in all if key in i]
    # sorting based on the second element of the list
    all.sort(key=lambda x: x[1])
    best_model = all[-1][0]
    model = tf.keras.models.load_model(path + best_model)
    print("Loaded model: ", best_model)
    return model

def deep_rf_qc_model(train_data, train_labels, validation_data, validation_labels, patience, min_delta, callbacks, initializer, model_type = 'unet',
                     kernel_size = 10, epoch = 30, kernel_grad=2, activation='relu', batch_size = 128, lr=0.001, decay=0.00002, ):

    early_stopping_callback = EarlyStopping(
    monitor='val_accuracy',  # The metric to monitor (usually validation accuracy)
    patience=patience,  # Number of epochs with no improvement before stopping
    min_delta=min_delta,  # Minimum change in monitored metric to be considered an improvement
    mode='auto',  # 'auto', 'min', or 'max' based on whether you want to minimize or maximize the metric
    verbose=1  # 0: silent, 1: update messages
    )

    if model_type == 'seq':
        input_shape = train_data.shape[1:]
        model = seq_model(input_shape, kernel_size=kernel_size, kernel_grad=kernel_grad, activation=activation)
    elif model_type == 'unet':
        input_shape = train_data.shape[1:]
        model = unet_model(input_shape, initializer, kernel_size=kernel_size, activation=activation)
    elif model_type == 'pre-unet':
        model = load_best_model(key="unet") 
    elif model_type == 'pre-seq':
        model = load_best_model(key="seq")


    # Compile the model with an appropriate optimizer and loss function
    model.compile(optimizer=tf.keras.optimizers.legacy.Adam(learning_rate=lr, decay=decay),
                loss='mean_squared_error',
                metrics=['accuracy'])
    

    # Train the model and assign training meta-data to a variable
    history = model.fit(train_data, train_labels, epochs=epoch, batch_size=batch_size, validation_data=(validation_data, validation_labels), callbacks=[early_stopping_callback, callbacks])
    return history, model


class DeepQC():
    """
    This is the main class for the DeepQC package.
    """
    def __init__(self):
        """
        Initialize the DeepQC class.
        :param data_path: path to the data
        :param model_path: path to the model
        """

        self.data_path = "DATA/RF"
        self.list_all = pd.read_csv("DATA/waveforms_list.csv")
        self.list_df = self.list_all[self.list_all.rf_quality.isin([0,1])].copy()

    def load_data(self, label_keyword=["X5"]):
        """
        Load the data.
        :return: None
        """
        label_keyword = "|".join(label_keyword)
        train_list_df = self.list_df[~self.list_df.file_name.str.contains(label_keyword, regex=True)].copy()
        test_list_df = self.list_df[self.list_df.file_name.str.contains(label_keyword, regex=True)].copy()
        train_data_np = []
        test_data_np = []
        for i in range(len(train_list_df)):
            file_path = f"{self.data_path}/{train_list_df.iloc[i].file_name}.pkl"
            st = obspy.read(file_path).select(channel="RFR")                      
            train_data_np.append([st[0].data, train_list_df.iloc[i].rf_quality])
        
        for i in range(len(test_list_df)):
            file_path = f"{self.data_path}/{test_list_df.iloc[i].file_name}.pkl"
            st = obspy.read(file_path).select(channel="RFR")                      
            test_data_np.append([st[0].data, test_list_df.iloc[i].rf_quality])

        self.train_data_np = train_data_np
        self.train_input = np.array([i[0] for i in train_data_np if i[0].shape[0] == 426])[:,1:-1]
        self.train_input = np.expand_dims(self.train_input, axis=2)                                     # add a dimension to the data
        self.train_label = np.array([i[1] for i in train_data_np if i[0].shape[0] == 426]).reshape(-1,1)
        self.test_input = np.array([i[0] for i in test_data_np if i[0].shape[0] == 426])[:,1:-1]
        self.test_label = np.array([i[1] for i in test_data_np if i[0].shape[0] == 426]).reshape(-1,1)
        self.test_input = np.expand_dims(self.test_input, axis=2)                                       # add a dimension to the data

        print(f"the folowing are the dataset accessable:\n train_input: {self.train_input.shape}\n train_label: {self.train_label.shape}\n test_input: {self.test_input.shape}\n test_label: {self.test_label.shape}")
        
    
    def stats(self):
        """
        plotting a histogram of the labels to see the data distribution.
        """
        bins = [-0.5, 0.5, 1.5]
        plt.hist(self.train_label, color="blue", bins= bins, label="train_label", alpha=0.5, rwidth=0.5)
        plt.xlabel("label")
        plt.ylabel("count")
        # plt.subplot(1,2,2)
        plt.hist(self.test_label, color="red", bins= bins, label="test_label", alpha=0.5, rwidth=0.5)
        plt.legend(loc="upper right")
        plt.xticks([0, 1])
        # plt.title("test_label")
        # plt.xlabel("label")
        plt.show()

    class DataAugmentation():
    def augmentation(self, noise_factor=0.01):
        """
        Augment the data.
        :param noise_factor: the factor of the noise to be added to the data
        :return: None
        """
        # add noise to the data
        train_input = self.train_data_np
        train_input_good = np.array([i[0] for i in train_input if i[0].shape[0] == 426])[:,1:-1] # good data
        train_input_good = np.expand_dims(train_input_good, axis=2)                                     # add a dimension to the data
        train_label_good = np.array([i[1] for i in train_input]).reshape(-1,1) # good data

        noise = np.random.randn(train_input_good.shape[0], train_input_good.shape[1], train_input_good.shape[2])
        train_input_noise = train_input_good + noise_factor * noise
        # concatenate the original data and the noise data
        self.train_input = np.concatenate((self.train_input, train_input_noise), axis=0)
        self.train_label = np.concatenate((self.train_label, train_label_good), axis=0)
        
        print(f"the folowing are the dataset accessable:\n train_input: {self.train_input.shape}\n train_label: {self.train_label.shape}\n test_input: {self.test_input.shape}\n test_label: {self.test_label.shape}")

    


    def train(self, initializer = "zeros", model_type="unet", kernel_size = 3, epochs=10, batch_size=32, verbose=1, lr=0.01,
              decay=0.001, plot_history=True, patience = 10, min_delta=0.001, target_accuracy = 0.92):
        
               
        # initialize the callbacks
        callbacks = CustomCallback(target_accuracy)
        
        #train the model
        self.history, self.model = deep_rf_qc_model(self.train_input, self.train_label, self.test_input, self.test_label, patience, min_delta, initializer = initializer, model_type = model_type, kernel_size = kernel_size, epoch = epochs,
                kernel_grad=2, activation='relu', batch_size = batch_size, lr=lr, decay=decay, callbacks=callbacks)
        if plot_history and self.history.history["val_accuracy"][-1] > 0.85:
            plt.plot(self.history.history['val_accuracy'], label='validation accuracy')
            plt.plot(self.history.history['accuracy'], label='train accuracy')
            plt.xlabel("epoch")
            plt.ylabel("accuracy")
            plt.legend(loc="lower right")
            #save the model
            if not os.path.exists("DATA/DEEP_QC"):
                os.makedirs("DATA/DEEP_QC")
            self.model.save(f"DATA/DEEP_QC/{model_type}_model_{round(self.history.history['val_accuracy'][-1],3)}.h5", save_format='h5')
        val_accuracy = round(self.history.history['val_accuracy'][-1],3)
        return val_accuracy

    # Define a custom callback
class CustomCallback(tf.keras.callbacks.Callback):
    def __init__(self, target_accuracy):
        super(CustomCallback, self).__init__()
        self.target_accuracy = target_accuracy

    def on_epoch_end(self, epoch, logs=None):
        current_accuracy = logs.get('val_accuracy')  # Replace with 'acc' if using older Keras versions

        if current_accuracy is not None and current_accuracy >= self.target_accuracy:
            self.model.stop_training = True
            print(f"\nReached target accuracy ({self.target_accuracy}%)! Stopping training.")
