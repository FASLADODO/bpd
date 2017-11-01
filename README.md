This is the source code guide for the experimental result in:

A BINARY PAIR-BASED VIDEO DESCRIPTOR FOR ACTION RECOGNITION
http://ieeexplore.ieee.org/document/7533148/

It is publicly available without restrictions. If the code provided here 
is used in any form please cite the corresponding paper.

___________________________________________________________________________________
Usage to reproduce the results:

- Classification with precomputed features.

Open and run KTH.m

- Extract features and run classification.

1 Download from https://www.nada.kth.se/cvap/actions/ the corresponding dataset.
2 Create a folder e.g. KTHdataset with the corresponding videos.

In KTH.m:

3 Comment line 4
4 In line 3 rename "MyPath" with the folder's path of the dataset folder.
5 Uncomment line 5

Save and run KTH.m

___________________________________________________________________________________
Usage to extract a binary feature from a given video volume

input parameters:
- full video sequence.
- scanning pattern.
- interest point.

output:
- 64 logical vector.

example:

set Folder Functions ass current directory.

nvid = VIDEO.readVideo('myvideo.avi');
pttn = BDoG3D.pttnfield();
stip = [50,50,50,8,4]; %y,x,t,sigma,tau

code = BDoG3D.encode(nvid,pttn,stip);

___________________________________________________________________________________
Further considerations 

* Linux systems. In case that MATLAB detect no codec support
we provide the following tool.

VIDEO.readVideo(videofile,codec,stream)

to find your codec support run the following command. e.g.

$ avconv -codecs

The video can be read for instance as follows:

v = VIDEO.readVideo('myvideo.avi','rawvideo','avconv');

If you decide to use lossless bypass video conversion be aware that results
might be different of the reported in the paper.

* This code version was tested on MATLAB 2015a, to our best known, results 
shouldn't be different between earlier or future versions.

* Our experiments was run on the original videos without compression
or pixel format map.

* parallel support is used to code the videos and generate histograms, if don't
wanted rename parfor in CODE.m and HIST.m

* Random clustering lead to small accuracy variations

# bpd
