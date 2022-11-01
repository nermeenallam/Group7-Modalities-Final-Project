folder="E:/CUFE/Fall_2022/Imaging Modalities/Project/PhaseOne/VHF-Head/Head";

%reads data set of DICOM slices and returns a volume of the img
V = dicomreadVolume(folder);                          %V is of size 512x512x1x234
%whos V;
V = squeeze(V);                                       %returns V of size 512x512x512 - removes anything of 1 dimensions
V = padarray(V,[0 0 139],0,'both');                   %padded with zeroes so frame size is the same for all planes
%whos V;

Video = VideoWriter('Phase One.avi', 'MPEG-4');       %saves matrix and creates a video of it rotating
Video.FrameRate = 30; %frames/sec
open(Video);

%Axial (XY)
for i = 140:size(V, 3)-139 
    %loop in z 
    writeVideo(Video,mat2gray(V(:,:,i))); %x, y, z
end

%Sagittal (XZ)
for i = 1:size(V, 2)  
    %rotate matrix & loop in y
    writeVideo(Video,mat2gray(rot90(permute(V(:,i,:),[1 3 2])))); %x, z, y
end

%Coronal (YZ)
for i = 1:size(V, 1)  
    %rotate matrix & loop in x
    writeVideo(Video,mat2gray(rot90(permute(V(i,:,:),[2 3 1])))); %y, z, x
end

close(Video);
% volumeViewer(V);