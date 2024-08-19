function train_models(input_directory,output_directory, verbose)

if verbose>=1
    disp('Finding Challenge data...')
end

% Find the recordings
records=dir(fullfile(input_directory,'**/*.hea'));
num_records = length(records);

if num_records<1
    error('No records were provided')
end

if ~isdir(output_directory)
    mkdir(output_directory)
end

fprintf('Loading data for %d records...\n', num_records)

%%% Steps for classification task

% Set up images and labels using datastores
imds = imageDatastore(input_directory,"FileExtensions",".png", ...
    "IncludeSubfolders",true);

% Requires that you only have 1 .hea files for each .png file
labelds = fileDatastore(input_directory, 'FileExtensions', '.hea', ...
    "ReadFcn", @getLabelsFromHeader, ...
    "IncludeSubfolders",true);

% Augment data - resize and randomly flip
aug = imageDataAugmenter("RandXReflection",true);
imdsAug = augmentedImageDatastore([425, 550], imds);
imdsAug.MiniBatchSize=1;

% To apply custom functions/preprocessing, check out the 'transform' function
% imdsProcessed = transform(imdsAug, @yourFunctionName);

% Combine images and labels
dsAll = combine(imdsAug, labelds);

dsRand = shuffle(dsAll);

% Separate into training and testing data
numObservations = numel(imds.Files);
numTrain = round(0.8 * numObservations);
dsTrain = subset(dsRand, 1:numTrain);
dsVal = subset(dsRand, numTrain+1:numObservations);

if verbose>=1
    disp('Training classification model...')
    trainVerbose = 1;
else
    trainVerbose = 0;
end

% Create layers of network
layers = [
    imageInputLayer([425 550 3]) % This layer normalizes the data
    
    convolution2dLayer(3,16,Padding=1)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,Stride=2)
    
    convolution2dLayer(3,32,Padding=1)
    batchNormalizationLayer
    reluLayer
    
    maxPooling2dLayer(2,Stride=2)
    
    convolution2dLayer(3,64,Padding=1)
    batchNormalizationLayer
    reluLayer
    
    fullyConnectedLayer(11)
    sigmoidLayer];

% Set training options
options = trainingOptions("adam", ...
    InitialLearnRate=0.001, ...
    LearnRateSchedule="piecewise", ...
    LearnRateDropPeriod=7, ...
    LearnRateDropFactor=0.1, ...
    MiniBatchSize=4, ...
    MaxEpochs=10, ...
    ValidationData=dsVal, ...
    Verbose=trainVerbose);

% Train network
classification_model = trainnet(dsTrain,layers,"binary-crossentropy",options);

if verbose>=1
    disp('Saving classification model...')
end

classes = {'NORM', 'Acute MI', 'Old MI', 'STTC', 'CD', 'HYP', 'PAC', 'PVC', 'AFIB/AFL', 'TACHY', 'BRADY'};
save_models(output_directory, classification_model, classes)

if verbose>=1
    disp('Classification model saved!')
end


function save_models(output_directory, classification_model, classes)

filename = fullfile(output_directory,'classification_model.mat');
save(filename,'classification_model','classes','-v7.3');

function image_file=get_image_file(header)

header=strsplit(header,'\n');
image_file=header(startsWith(header,'# Image'));
image_file=strsplit(image_file{1},':');
image_file=strtrim(image_file{2});

function dx=get_labels(header)

header=strsplit(header,'\n');
dx=header(startsWith(header,'# Labels'));
if ~isempty(dx)
    dx=strsplit(dx{1},':');
    dx=strtrim(dx{2});
else
    error('# Labels missing!')
end


function y=one_hot_encoding(dx,classes)

y=zeros(length(dx),length(classes));

for j=1:length(dx)

    y(j,ismember(classes,strtrim(strsplit(dx{j},','))))=1;

end

function encodedLabel = getLabelsFromHeader(filename)
header = fileread(filename);

% Get labels
dx_tmp = get_labels(header);

dx_tmp = strsplit(dx_tmp,',');
dx_tmp = strip(dx_tmp);

% Convert to a binary label, ie: [0 1 0 0 0 0 0 0 1 0 0]
allLabels = {'NORM', 'Acute MI', 'Old MI', 'STTC', 'CD', 'HYP', 'PAC', 'PVC', 'AFIB/AFL', 'TACHY', 'BRADY'};
numClasses = size(allLabels, 2);
encodedLabel = zeros(1, numClasses);

for labelNum = size(dx_tmp, 2)
    labelIdx = strcmp(allLabels, dx_tmp(labelNum));
    encodedLabel(labelIdx) = 1;
end
