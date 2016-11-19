clear all;close all;clc;


base_path = 'C:/Users/mikep/Downloads/23.08-step01-Sanika-20160906T172403Z/'; %PATH TO IMAGES
subjects = dir(base_path);

for k = 1:length(subjects) 
    subject = subjects(k).name;
    if strcmp(subject,'.')==1
        continue
    end
    if strcmp(subject,'..')==1
        continue
    end
    %% Setup
    workingDir = fullfile(base_path, subject)
    %mkdir(workingDir)

    %% Find all the JPEG file names in the images folder. Convert the set of image names to a cell array.

    imageNames = dir(fullfile(workingDir,'*.jpg'))
    imageNames = {imageNames.name}';

    %% Create Video Reader
    %shuttleVideo = VideoReader('shuttle.avi');

    %% Construct a VideoWriter object, which creates a Motion-JPEG AVI file by default.
    outputVideo = VideoWriter(fullfile('C:/Users/mikep/Desktop/',[subject '.avi']),'Uncompressed AVI'); %OUTPUT PATH
    outputVideo.FrameRate = 17;%shuttleVideo.FrameRate;
    open(outputVideo)

    %% Loop through the image sequence, load each image, and then write it to the video.

    for ii = 1:length(imageNames)-1
       img = imread(fullfile(workingDir,'/',imageNames{ii}));
       writeVideo(outputVideo,img)
    end
     close(outputVideo)
end    


