# Multi-view Hand Posture Recognition

## 1. Descriptions
In our experiments, we tested different CNN models for posture recognition in three different views which are front, left and right respectively.
___

## 2. Experimental Results
The results shown as Table 1 are the top-1 accuracy for different CNN model combined with three views.

| Model          | Top-1 Accuracy | Download |
|----------------|----------------|-------|
| HandNet        | 90.86%         |   https://drive.google.com/open?id=1D9sCSEwz49mz77xm41ErB-K7yrRq_BxD    |
| AlexNet        | 83.56%         |   https://drive.google.com/open?id=1Ks_LssRAB6MkaIgmmPwTJjBGVtGJU5r0    |
| GoogLeNet      | 83.82%         |   https://drive.google.com/open?id=14PbxlCXGlDeWOkUmzXEc0Xc4oAF0JQEv    |
| ResNet-50      | 88.93%         |   https://drive.google.com/open?id=1JdsdrDw0L8lUaIcVdBAbE0Z7gVlpN7QP    |
| Multi-Channel  | 86.52%         |   https://drive.google.com/open?id=1Qf5FhjJVuU4fYJfZS0nYW-B8salEu-Tw    |
| 3D Convolution | 58.47%         |   https://drive.google.com/open?id=1kagMj2oECOcI4Z2nJyI9Ypwi2DA_TDSn    |
| LeNet          | 84.74%         |   https://drive.google.com/open?id=1h8pInoW3N4zM8ZWUISfxKkvOhG3HwxSk    |

*Table 1*

The results shown as Table 2. are the top-1 accuracy for HandNet in different combination of two views.

| Views | Top-1 Accuracy | Prototxt |
|-------|----------------|----------|
| F+L   | 84.26%         |          |
| F+R   | 90.62%         |          |
| L+R   | 87.59%         |          |

*Table 2*

-Download Dataset-

*For 3D Convolution: https://drive.google.com/open?id=1TRJ7Rsh_dbHVXz0xqPhQKZbaft8iQFIL*

*The Dataset for 3D convolution is using sequential frames and merge into 1 picture sample, we use 3 frames to merge for our case*

*For Multi-channel: https://drive.google.com/open?id=16oTrdU9vpjFXV2FpXDqC933A_v90IOHj*

*The 3-channel input image for multi-channel is sobel-X, sobel-Y and greyscale.*

*For Others: https://drive.google.com/open?id=1q5N5omTiRUPSpoPA4pqUWWZwe_O5FE07*


- Other Tested Models:

    - Inner product layer for fusion: https://drive.google.com/open?id=1j3OFh77Y_kGr8TiVpPIJxbNMBfTe3ZKF
    - Element-wise summation for fusion: https://drive.google.com/open?id=1-ysmUKUwQoX9RF0WuhS9MMdUt_-oRWeI
    - Prototxt for F+L: https://github.com/geoffrey0822/mview/blob/master/FL.prototxt
    - Prototxt for F+R: https://github.com/geoffrey0822/mview/blob/master/FR.prototxt
    - Prototxt for L+R: https://github.com/geoffrey0822/mview/blob/master/LR.prototxt

    

___

## 3. Step to execute the program
1. Download & Install Caffe [git clone https://github.com/geoffrey0822/caffe_dev.git].
2. Download Nvidia DIGITS [git clone https://github.com/NVIDIA/DIGITS].
3. Download Pretrained Models from Table 1.
4. Import pretrained model into DIGITS

* Parameters for solver:

___
## 4. Publications
___