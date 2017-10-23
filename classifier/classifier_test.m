function res = classifier_test(classifier, fea)

fprintf('Testing ...\n');

%% Pass through
% fprintf('Distance is already calculated. Pass through.\n');
% res = fea';
 
%% Euclidean distance
% fea1 = fea(1:end/2, :);
% fea2 = fea(end/2+1:end, :);
% fea = fea1 - fea2;
% res = 1./sum(fea.^2, 1);
% res = res';

%% PCA -- on images
% fprintf('Testing PCA on images and repack feature difference.\n');
% W_PCA = classifier.W_PCA;
% fea1 = W_PCA' * fea(1:end/2, :);
% fea2 = W_PCA' * fea(end/2+1:end, :);
% fea = fea1 - fea2;
% % % Euclidean distance
% res = 1./sum(fea.^2, 1);
% res = res';
% % % Cosine distance
% % res = zeros(size(fea,2), 1);
% % for i = 1 : length(res)
% %     d = fea1(:,i)' * fea2(:,i);
% %     d = d / norm(fea1(:,i)) / norm(fea2(:,i));
% %     res(i) = d;
% % end

%% PCA -- after differences
% fprintf('Testing PCA after differences.\n');
% W_PCA = classifier.W_PCA;
% fea = W_PCA' * fea;

%% Fisher LDA
% fprintf('Testing Fisher LDA.\n');
% W_LDA = classifier.W_LDA;
% fea = W_LDA' * fea;

%% ITML
% fprintf('Testing IPML. \n');
% res = zeros(size(fea,2), 1);
% for i = 1 :length(res)
%     x = fea(:,i);
%     res(i) = x' * classifier.model * x;
% end

%% Nearest Neighbor v2
% fprintf('Testing on Nearest Neighbor.\n');
% c1 = classifier.feature(:, classifier.index==1);
% c2 = classifier.feature(:, classifier.index==-1);
% dist1 = pdist2(fea', c1');
% dist2 = pdist2(fea', c2');
% % [Y,I] = sort(dist, 2);
% % res = classifier.index(I(:,1));
% min_dist1 = min(dist1, [], 2);
% min_dist2 = min(dist2, [], 2);
% res = min_dist2 ./ min_dist1;
% % res = zeros(size(fea,2), 1);
% % for i = 1 : size(fea,2)
% %     dist = zeros(size(classifier.feature, 2), 1);
% %     for j = 1 : size(classifier.feature, 2)
% %         temp = fea(:,i) - classifier.feature(:,j);
% %         dist(j) = sum(temp.^2);
% %     end
% %     [Y,I] = sort(dist,2);
% %     res(i) = classifier.index(I(1));
% % end

%% Nearest cluster center
% % fprintf('Testing on nearest cluster center.\n');
% dist = pdist2(fea', classifier.feature');
% % [Y,I] = sort(dist, 2);
% % res = classifier.index(I(:,1));
% res = dist(:,classifier.index==-1) ./ dist(:,classifier.index==1);
% % res = zeros(size(fea,2), 1);
% % for i = 1 : size(fea,2)
% %     dist = zeros(size(classifier.feature, 2), 1);
% %     for j = 1 : size(classifier.feature, 2)
% %         temp = fea(:,i) - classifier.feature(:,j);
% %         dist(j) = sum(temp.^2);
% %     end
% %     [Y,I] = sort(dist,2);
% %     res(i) = classifier.index(I(1));
% % end

%% PLS
% fprintf('Testing PLS.\n');
% res = [ones(size(fea',1),1) fea']*classifier.beta;

%% LIBSVM
fprintf('Testing SVM.\n');
model = classifier.model;
[predicted_label, accuracy, decision_values] = svmpredict(ones(size(fea,2),1), fea', model);
res = decision_values;

%% Dictionary
% fprintf('Testing on dictoinary.\n');
% dist = zeros(size(fea,2), 2);
% for i = 1 : length(classifier.index)
%     recon = classifier.D{i} * classifier.invD{i} * fea;
%     err = recon - fea;
%     dist(:,i) = sum(err.^2, 1);
% end
% % res = 1./res;
% % res = res';
% % res = dist(:,2)./dist(:,1);
% res = 1./dist(:,1);

%% RVM
% fprintf('Testing RVM.\n');
% [y,p] = rvmPredict(classifier.model, fea');
% res = p;

%% SVM pmtk version
% fprintf('Testing SVM, pmtk version.\n');
% [y,p] = svmPredict(classifier.model, fea');
% res = p;

%% discrimAnalysis
% fprintf('Testing discrimAnalysis.\n');
% [y,p] = discrimAnalysisPredict(classifier.model, fea');
% res = p(:,1)./p(:,2);

%% kNN
% fprintf('Testing kNN.\n');
% [y,p] = knnPredict(classifier.model, fea');
% res = p(:,1)./p(:,2);

%% Adaboost
% fprintf('Testing Adaboost.\n');
% res = Classify(classifier.RLearners, classifier.RWeights, fea);

%% LMNN
% fprintf('Testing LMNN.\n');
% [err, yy, Value] = energyclassify(classifier.L, classifier.x, classifier.y, fea, ones(1, size(fea,2)), 3);
% Value = Value';
% res = (Value(:,2)./Value(:,1));
