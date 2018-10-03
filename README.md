# Face Detection with HOG+SVM

This project is about face detection, by hybrid of feature extraction and supervised learning. The feature extraction used is Histogram of Oriented Gradients (HOG) and linear Support Vector Machine (linear SVM) is used as supervised learning. Both HOG and SVM are VLFeat implemented function on MATLAB.

The training of SVM is as follow:
. Extracting HOG feature vectors from positive images (image only contain face, size in 36*36)
. Extracting HOG feature vectors from negative images (scene images, each samples are 36*36 sub-images)
. Label positive feature vectors as +1, and negative feature vectors as -1
. Put both positive and negative feature vectors and corresponding label to SVM


Requirement:
------------
VLFeat:
http://www.vlfeat.org/install-matlab.html
