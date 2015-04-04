%John R Evans
%CS 494- Image Processing
%Fall 2013
%5 December 2013
%Description: Shock Graph Demo

clear all, close all; 

%Read in the image
I=imread('Cat054.gif'); 
 
%Change the type of I into double for computation 
I=double(I); 
 
%Calculate the size of input image 
[M,N]=size(I); 
 
%Change the max of the input image into 255 
if max(max(I))==1 
    I=255.*I; 
end 
 
%Show the input image 
figure(1);
imshow(I); 
 
%Convert the image to a binary image where the foreground object is
%black and the background is white
I=xor(I,ones(M,N)); 

%Calculate the distances of the binary image using Euclidean distance
%D is a resulting distance matrix that is the same size as I, and L is a matrix of the number of
%elements in I represented as a double
[D,L]=bwdist(I); 
L=double(L); 

%Create a 4x4 lowpass filter to smooth the image
G=fspecial('gaussian',[4 4],.75); 

%Apply filter to resulting distance matrix D 
SD=imfilter(D,G); 

%Determine the equivalent supscript values given the number of elements in
%L
[r,c]=ind2sub([M N], L);

%Preallocation Step
delDx=zeros(M,N); 
delDy=zeros(M,N); 

%Create a meshgrid
[X,Y]=meshgrid(1:1:N,1:1:M); 

%Calculate the vector field
    for i=1:1:M 
         for j=1:1:N 
             if SD(i,j) ~= 0 
                 delDx(i,j)=-1*(c(i,j)-j)/SD(i,j); 
                 delDy(i,j)=-1*(r(i,j)-i)/SD(i,j); 
             end 
         end
    end

%Display as Quiver Graph
figure(2); 
quiver(X,Y,delDx,delDy); 

%Preallocation Step
FluxP=zeros(M,N); 

%Calculate the divergence (ie flux) of the vector field
FluxP=divergence(X,Y,delDx,delDy); 

%Display Flux Graph
figure(3); 
surface(FluxP); 

%Preallocation step
result=255.*ones(M,N); 

%Calculate the resulting shock graph
for i=1:M 
     for j=1:N 
         if I(i,j)==0 
         result(i,j)=128; 
         end 
     end 
end 
 
%Overlay the Shockgraph onto the original image 
for i=1:M 
     for j=1:N 
         if FluxP(i,j) < -0.3 
            result(i,j)=0; 
         else 
            continue;
         end 
     end 
end 

%Display image with shock graph overlay
figure(4); 
imshow(uint8(result)); 

%Construct shockgraph using MATLAB's bwmorph command
skeletalResult=bwmorph(result,'skel');

%Display MATLAB's resulting shockgraph
figure(5); 
imshow(skeletalResult); 
    
