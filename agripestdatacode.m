clc;
clear all;
close all;
addpath ('subcode');
addpath ('comparisoncode');
addpath comparisoncode;
fprintf('Running Code.m...\n'); 


%% LOAD INPUT DATA

infolder = 'F:\Nisha\Nisha\2024\Rooks projcts\projeect3((pest identification)\pestdetectioncode\agripestdata\test';    
imgFiles = dir([infolder,filesep,'im' ,num2str(i),'.jpg']) ; 
N = length(imgFiles) ;   
for i = 1:N
    thisFile = [infolder,filesep,imgFiles(i).name] ;   % 
    [filepath,name,ext] = fileparts(thisFile) ;  
    I = imread(thisFile) ;   
end
n=5;a=4;b=2;

for i = 1:n
    figure;
    subplot(1,3,1)
    m=imread(['F:\Nisha\Nisha\2024\Rooks projcts\projeect3((pest identification)\pestdetectioncode\agripestdata\test\ants\ants' num2str(i) '.jpg']);
    imshow(m);
    title('Input Image');

%% PRE PROCESSING

    num_iter = 10;
    de_t = 1/7;
    ka = 15;
    opt = 2;
    disp('Preprocessing image please wait . . .');
    inp = adap_ST_filter(m,num_iter,de_t,ka,opt);
    inp = uint8(inp);
    subplot(1,3,2);
    imshow(inp);
    title('Filtered Image');

%% FEATURE EXTRACTION

   p = logical(not(m));
   [~, AOH, PhiOH] = Zernikmoment(p,a,b);      % Call Zernikemoment fuction
%    disp(['A = ' num2str(AOH)]); 
%    disp (['\phi = ' num2str(PhiOH)]);
   T = graythresh(inp);
   km = im2bw(inp,T);
   lImage = bwlabel(km);
   measurements = regionprops(lImage, 'Area');
   allAreas = [measurements.Area];
   [bArea, indexOfBiggest] = sort(allAreas, 'descend');
   bBlob = ismember(lImage, indexOfBiggest(1));
   bBlob = bBlob > 0;
  [f1 f2 f3 f4 f5 f6 f7 f8 f9 f10]=feat(bBlob);
  Inpc=[f1 f2 f3 f4 f5 f6 f7 f8 f9 f10];
  Target=ones(size(bBlob,1),1);
  [XTrain,YTrain] = digitTrain4DArrayData;
  cnnlayer(XTrain,YTrain);
  [nColors cidx c_center nrows ncols I]=stoerwagner(m);
  pixel_labels = reshape(cidx,nrows,ncols);
  s_images = cell(1,3);
  rgb_label = repmat(pixel_labels,[1,1,3]);

for k = 1:nColors
    colors = I;
    colors(rgb_label ~= k) = 0;
    s_images{k} = colors;
end

inp = uint8(s_images{2});
inp=imresize(inp,[256,256]);
if size(inp,3)>1
    inp=rgb2gray(inp);
end   
sout=imresize(inp,[256,256]);
t0=60;
th=t0+((max(inp(:))+min(inp(:)))./2);
for i=1:1:size(inp,1)
    for j=1:1:size(inp,2)
        if inp(i,j)>th
            sout(i,j)=1;
        else
            sout(i,j)=0;
        end
    end
end

sout=imresize(inp,[256,256]);
t0=60;
th=t0+((max(inp(:))+min(inp(:)))./2);
for i=1:1:size(inp,1)
    for j=1:1:size(inp,2)
        if inp(i,j)>th
            sout(i,j)=1;
        else
            sout(i,j)=0;
        end
    end
end

label=bwlabel(sout);
stats=regionprops(logical(sout),'Solidity','Area','BoundingBox');
density=[stats.Solidity];
area=[stats.Area];
high_dense_area=density>0.1;
max_area=max(area(high_dense_area));
t_label=find(area==max_area);
pest=ismember(label,t_label);

subplot(1,3,3);
imshow(s_images{3});
title('Pest Detected');

end

[precision,specificity,Acc,f1score]= perf(Inpc,Target);
disp('========= Performance Analysis  ========')
fprintf('\n')
disp(['Precision = ' num2str(precision)])
fprintf('\n')
disp(['Specificity = ' num2str(specificity)])
fprintf('\n')
disp(['Accuracy = ' num2str(Acc)])
fprintf('\n')
disp(['F1score = ' num2str(f1score)])


[precision,specificity,Acc,f1score] = DeepLearning(Inpc,Target);

disp('========= Performance Analysis of DeepLearning ========')
fprintf('\n')
disp(['Precision = ' num2str(precision)])
fprintf('\n')
disp(['Specificity = ' num2str(specificity)])
fprintf('\n')
disp(['Accuracy = ' num2str(Acc)])
fprintf('\n')
disp(['F1score = ' num2str(f1score)])

[precision,specificity,Acc,f1score]= Annagri(Inpc,Target);
disp('========= Performance Analysis of ANN ========')
fprintf('\n')
disp(['Precision = ' num2str(precision)])
fprintf('\n')
disp(['Specificity = ' num2str(specificity)])
fprintf('\n')
disp(['Accuracy = ' num2str(Acc)])
fprintf('\n')
disp(['F1score = ' num2str(f1score)])
