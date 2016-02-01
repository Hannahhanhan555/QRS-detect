# QRS-detect
A single scan algorithm for QRS-detection and feature extraction 

Algorithm works as FIR filter. Parametres values are obtained experimentaly and correspond to mammals QRS detection.
It works for signals sampled by frequency of 250Hz and if you have signal sampled on another frequency you must to resampling
in Matlab. In this works I used signals sampled by frequency of 360Hz from MITB BH database and all works perfectly!
This is intelligent algorithm because if isn't detect any QRS complex after 2 seconds algorith will change minimum and maximum value for 
treshold. Minimum treshold value will be decrease for 1/16 of critical value and maximum treshold value will be increase for 1/16 of 
critical value.
