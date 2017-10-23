function main(fold)
% function main(fold, mae)
% Verification experiment

diary_file = 'run_log';
diary(diary_file);
fprintf('*******************************\n');
fprintf('Run on %s\n', datestr(now, 'yyyy-mm-dd HH:MM:ss'));

%% Set parameters
tmp_prefix = '/tmp/';
classifier_filename = 'classifier';
result_filename = 'result';
growth_model_filename = 'growth_model';
name_prefix = 'FGNET_manifold_';
% fold = 3;

%% Auto set parameters
classifier_fullname = strcat(tmp_prefix, name_prefix, classifier_filename, sprintf('_fold_%d.mat', fold));
result_fullname = strcat(tmp_prefix, name_prefix, result_filename, sprintf('_fold_%d.mat', fold));
growth_model_fullname = strcat(tmp_prefix, name_prefix, growth_model_filename, sprintf('_fold_%d.mat', fold));
% result_fullname = strcat(tmp_prefix, name_prefix, result_filename, sprintf('_fold_%d_mae_%d.mat', fold,mae));

%% Load data
% [img_train, index_train, img_gallery, index_gallery, img_probe, index_probe] = MORPH_CD1_Loader('M', 1, 1);
% [img_train, index_train, img_test, index_test, pair_info_train, pair_info_test] = MORPH_CD2_Loader_for_training(0);
% [img_train, index_train, img_test, index_test, pair_info_train, pair_info_test] = MORPH_CD1_Loader('M', 1, 3);
% [img_train, index_train, img_test, index_test, pair_info_train, pair_info_test, pts_train, pts_test] = FGNET_Loader_vHbL(fold);
% [img_train, index_train, img_test, index_test, pair_info_train, pair_info_test, pts_train, pts_test] = FGNET_Loader_vHbL_v2(fold);
[pts_train, index_train, age_train, pts_test, index_test, age_test, pair_info_train, pair_info_test, age_diff_train, age_diff_test] = FGNET_Loader_vHbL_shape_only(fold);
% [img_train, index_train, img_test, index_test, pair_info_train, pair_info_test] = GBU_Loader_for_verify(0);
% [img_train, index_train, img_test, index_test, pair_info_train, pair_info_test] = BEST_Loader_for_verify(0);
% [img_train, index_train, pair_info_train] = merge_training_set();
% [img_train, index_train, img_test, index_test, pair_info_train, pair_info_test, pts_train, pts_test] = FERET_Loader_for_verify(0);
% [img_train, index_train, img_test, index_test, pair_info_train, pair_info_test, pts_train, pts_test] = MUCT_Loader(fold, 0);

%% Noise on the age
% mae = 5;
% fprintf('Add normal noise over ages on the testing set, MAE = %d\n', mae);
% age_error = randn(size(age_test)) * mae / 0.8;
% age_error = round(age_error);
% age_test_min = 18;%min(age_test);
% age_test_max = 69;%max(age_test);
% age_test = age_test + age_error;
% age_test(age_test<age_test_min) = age_test_min;
% age_test(age_test>age_test_max) = age_test_max;

%% Training stage
fprintf('Training stage:\n');
% Extract image features
% fea_img_train = extract_img_features(img_train);
fea_img_train = extract_img_features(pts_train);

% Extract verification features
[fea_pair_train, index_pair_train, growth_model_cache] = extract_verify_feature_growth(fea_img_train, age_train, index_train, pair_info_train, fea_img_train);

% Train classifier
% if mae == 1
classifier = classifier_train(fea_pair_train, index_pair_train);

% Save classifier
save(classifier_fullname, 'classifier');
fprintf('Training done.\n');

% else
load(classifier_fullname);
% end

%% Testing stage
fprintf('Testing stage:\n');
% Extract image features
% fea_img_test = extract_img_features(img_test);
fea_img_test = extract_img_features(pts_test);

% Load classifier
fprintf('Loading classifier ...\n');
load(classifier_fullname);

% index_pair_test = zeros(size(pair_info_test, 1), 1);
% res = zeros(size(pair_info_test, 1), 1);
batch_size = 2000;
diary off;
%for i = 1 : batch_size : size(pair_info_test,1)
n_batch = floor(size(pair_info_test,1) / batch_size);
res = zeros(batch_size, n_batch);
index_pair_test = zeros(batch_size, n_batch);
for i = 1 : n_batch
    fprintf('Testing complete %f%%\n', (i-1)*batch_size/size(pair_info_test,1)*100);
    b_start = (i-1)*batch_size+1;
%     b_end = min(i+batch_size-1, size(pair_info_test, 1));
    b_end = i*batch_size;
    
    % Extract verification features
    [fea_pair_test, index_pair_test_b, growth_model_cache] = extract_verify_feature_growth(fea_img_test, age_test, index_test, pair_info_test(b_start:b_end, :), fea_img_train, growth_model_cache);
    
    % Verification result
    res(:,i) = classifier_test(classifier, fea_pair_test);
    index_pair_test(:,i) = index_pair_test_b;
end
res = res(:);
index_pair_test = index_pair_test(:);
b_start = n_batch * batch_size + 1;
b_end = size(pair_info_test, 1);
[fea_pair_test, index_pair_test_b, growth_model_cache] = extract_verify_feature_growth(fea_img_test, age_test, index_test, pair_info_test(b_start:b_end, :), fea_img_train, growth_model_cache);
res_b = classifier_test(classifier, fea_pair_test);
index_pair_test = cat(1, index_pair_test, index_pair_test_b);
res = cat(1, res, res_b);

diary(diary_file);

%% Save result
o1 = zeros(size(growth_model_cache));
o2 = zeros(size(growth_model_cache));
for i = 1 : size(o1,1)
    for j = 1 : size(o1,2)
        o1(i,j) = isstruct(growth_model_cache{i,j});
        o2(i,j) = isnumeric(growth_model_cache{i,j}) & ~isempty(growth_model_cache{i,j});
    end
end
fprintf('Learned %d of %d growth models.\n', sum(o1(:)), sum(o1(:))+sum(o2(:)));
save(result_fullname, 'res', 'index_pair_test');
save(growth_model_fullname, 'growth_model_cache');
fprintf('Testing done.\n');

%% Analysis the result
load(result_fullname);
[fpr, tpr] = roc_analysis(res, index_pair_test);
% accuracy = accuracy_analysis(res, pair_info_test, index_test);
% accuracy = accuracy_analysis_half(res, pair_info_test, index_test);

%%
diary off;