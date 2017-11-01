addpath(genpath(strcat(pwd,'/Functions')))
addpath(genpath(strcat(pwd,'/DATA')))
% addpath(genpath('DATASETPATH'))
% BagF = CODE.codeFROMfile(BPD);

load('BagF.mat')

rng('default');

% KTH subject selection 
% e.g. subject 1 generates index 1 2 3 4
% e.g. subject 25 genrates indes 97 98 99 100
[sbjtr,sbjval,sbjte] = MISC.seedKTH();

words = 1200;C = 1000;

% Bag selection
BagTr = BAG.selectSubBag(BagF,sbjtr,'select');
BagTe = BAG.selectSubBag(BagF,sbjte,'select');

% Select all feature vectors from the training BagTr
X = BAG.Bag2FullMatrix(BagTr);

% Clustering
[~,BOV] = kmeans(X,words,...
 'Start','sample','Distance','hamming','Options',statset('UseParallel',1));
BOV = BOV == 1;

% Histogram and Labels generation
[HTr,LTr] = HIST.Bag2Hist(BagTr,BOV);
[HTe,Gt]  = HIST.Bag2Hist(BagTe,BOV);


% CHI2 SVM generation
rng(1); % For reproducibility
t = templateSVM('KernelFunction','kernel','BoxConstraint',C);

SVMModel = fitcecoc(HTr,LTr,'Learners',t);

% Classification
CMat = confusionmat(Gt,predict(SVMModel,HTe));

fprintf('words: %d\n',words);
fprintf('BoxConstraint: %f\n',C);
fprintf('VectorSize: %dx%d\n',size(X,1),size(X,2));
disp(CMat)
disp(sum(diag(CMat))/sum(sum(CMat)))
disp(datestr(now))
disp('=============================================')

