# VideoAnnotator
A simple and easy to modify video annotation tool in Matlab 

The repository exists of:

1. [VideoMaker.m](https://github.com/MikeMpapa/VideoAnnotator/blob/master/VideoMaker.m) --> A file that generates uncompressed .avi videos given a set of images. Images must be in the same directory and named in ascending order 

2. [AnnotationTool.m](https://github.com/MikeMpapa/VideoAnnotator/blob/master/AnnotationTool.m) --> A tool for annotating video in a frame by frame manner. 

The annotator can navigate back and forth through the frames and assign/change labels at each part of the video. If multiple consecutive frames correspond to the same label the tool assigns that label automatically to all frames until the anotator decides to change the annotation tag. Also the tool aims to protect the user from making annotation errors,by poping appropriate error messages under certain circumstances (multiple or no labels where assigned to a frame). All these parameters are easily modifiable through the code. Annotation prodact, can by saved any time in a .txt file format
