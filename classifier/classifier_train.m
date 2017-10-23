function classifier = classifier_train(feature, index)

%% Default: Do nothing
% fprintf('Do not need training.\n');
% classifier = 0;

%% PCA -- work on images
% cutoff = 0.95;
% fprintf('Training PCA on images. cutoff = %f\n', cutoff);
% data = [feature(1:end/2,:), feature(end/2+1:end, :)];
% W_PCA = PCA_Train(data, cutoff);
% classifier.name = 'PCA';
% classifier.W_PCA = W_PCA;
% 
% %% PCA projection
% fprintf('PCA projection. Repack feature difference. \n');
% fea1 = W_PCA' * feature(1:end/2, :);
% fea2 = W_PCA' * feature(end/2+1:end, :);
% feature = fea1 - fea2;

%% PCA -- work after differences
% cutoff = 0.95;
% fprintf('Training PCA after differences. cutoff = %f\n', cutoff);
% W_PCA = PCA_Train(feature, cutoff);
% classifier.name = 'PCA';
% classifier.W_PCA = W_PCA;

%% PCA projection
% fprintf('PCA projection. \n');
% feature = W_PCA' * feature;

%% Fisher LDA
% fprintf('Training FisherLDA.\n');
% index(index==-1) = 2;
% [W,Z] = fisherLdaFit(feature', index);
% classifier.W_LDA = W;
% feature= Z';
% index(index==2) = -1;

%% ITML
% fprintf('Training ITML.\n');
% index(index==-1) = 0;
% model = feval(@(y,X) MetricLearningAutotuneKnn(@ItmlAlg, y, X), index, feature');
% classifier.model = model;

%% Nearest Neighbor
% fprintf('Training Nearest Neighbor classifier.\n');
% classifier.name = 'NN';
% classifier.feature = feature;
% classifier.index = index;

%% Nearest Cluster center
% fprintf('Training nearest class center classifier.\n');
% classifier.name = 'NC';
% fea1 = mean(feature(:,index==1),2);
% fea2 = mean(feature(:,index==-1),2);
% classifier.feature = [fea1, fea2];
% classifier.index = [1;-1];

%% K-means Nearest Cluster center
% K1 = 1;
% K2 = 2;
% fprintf('Training K-means nearest class center classifier. K1 = %d, K2 = %d\n', K1, K2);
% classifier.name = 'K-means NC';
% fea1 = feature(:,index==1);
% fea2 = feature(:,index==-1);
% [idc, c1] = kmeans(fea1', K1);
% [idc, c2] = kmeans(fea2', K2);
% classifier.feature = [c1', c2'];
% classifier.index = [ones(K1,1); -ones(K2,1)];

%% PLS
% ncomp = 200;
% fprintf('Training PLS, ncomp = %d.\n', ncomp);
% if ncomp ~= 0
%     [XL,yl,XS,YS,beta,PCTVAR] = plsregress(feature',index,ncomp);
% else
%     [XL,yl,XS,YS,beta,PCTVAR] = plsregress(feature',index);
% end
% classifier.name = 'PLS';
% classifier.XL = XL;
% classifier.yl = yl;
% classifier.XS = XS;
% classifier.YS = YS;
% classifier.beta = beta;
% classifier.PCTVAR = PCTVAR;

%% LIBSVM
% libsvm_opt = '-s 0 -t 2 -g 0.0001 -r 0 -n 0.5 -c 1 -m 100 -e 1e-5 -h 1 -p -0.1';
% libsvm_opt = '-s 0 -t 1 -d 1 -r 0 -n 0.5 -c 1 -m 100 -e 1e-5 -h 1 -p -0.1';
libsvm_opt = '-s 0 -t 2 -g 80 -r 0 -n 0.5 -c 1 -m 100 -e 1e-5 -h 1 -p -0.1';
fprintf('Training LIBSVM. Option: %s\n', libsvm_opt);
model = svmtrain(index, feature', libsvm_opt);
classifier.name = 'LIBSVM';
classifier.model = model;
classifier.libsvm_opt = libsvm_opt;
 
%% KSVD
% fprintf('Training dictionary.\n');
% id = [1, -1];
% D = cell(length(id), 1);
% invD = cell(length(id), 1);
% for i = 1 : length(id)
%     params.data = feature(:,index==id(i));
%     params.Tdata = size(params.data,2);
%     params.dictsize = 50;
%     params.initdict = feature(:,index==id(i));
%     params.iternum = 30;
%     D{i} = ksvd(params, '');
%     invD{i} = pinv(D{i});
% end
% classifier.D = D;
% classifier.invD = invD;
% classifier.index = id;

%% RVM
% fprintf('Training RVM.\n');
% index(index==-1) = 0;
% model = rvmFit(feature', index);
% classifier.model = model;
 
%% SVM pmtk version
% fprintf('Training SVM, pmtk version.\n');
% index(index==-1) = 0;
% model = svmFit(feature', index);
% classifier.model = model;

%% discrimAnalysis
% fprintf('Training discrimAnalysis.\n');
% index(index==-1) = 2;
% model = discrimAnalysisFit(feature', index, 'RDA', 1);
% classifier.model = model;

%% kNN
% fprintf('Training kNN.\n');
% index(index==-1) = 2;
% model = knnFit(feature', index, 5);
% classifier.model = model;

%% Adaboost
% fprintf('Training Adaboost.\n');
% weak_learner = tree_node_w(3); % pass the number of tree splits to the constructor
% [RLearners RWeights] = RealAdaBoost(weak_learner, feature, index', 100);
% classifier.RLearners = RLearners;
% classifier.RWeights = RWeights;

%% LMNN
% fprintf('Training LMNN.\n');
% L = lmnn(feature, index');
% classifier.L = L;
% classifier.x = feature;
% classifier.y = index';