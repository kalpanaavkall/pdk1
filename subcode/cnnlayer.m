function cnnlayer(XTrain,YTrain)

idx = randperm(size(XTrain,4),1000);
XValidation = XTrain(:,:,:,idx);
XTrain(:,:,:,idx) = [];
YValidation = YTrain(idx);
YTrain(idx) = [];
layers = [
    imageInputLayer([28 28 1])
    convolution2dLayer(3,8,Padding="same")
    batchNormalizationLayer
    reluLayer   
    maxPooling2dLayer(2,Stride=2)
    convolution2dLayer(3,16,Padding="same")
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,Stride=2)
    convolution2dLayer(3,32,Padding="same")
    batchNormalizationLayer
    reluLayer
    fullyConnectedLayer(10)
    softmaxLayer
    classificationLayer];
options = trainingOptions("sgdm", ...
    MaxEpochs=5, ...
    ValidationData={XValidation,YValidation}, ...
    ValidationFrequency=30, ...
    Verbose=false, ...
    Plots="training-progress");
% net = trainNetwork(XTrain,YTrain,layers,options);
% YP = classify(net,XValidation);