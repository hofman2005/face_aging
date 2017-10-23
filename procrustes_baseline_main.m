function procrustes_baseline_main(fold)

%% Set parameters
tmp_prefix = 'output/';
classifier_filename = 'classifier';
result_filename = 'result';
name_prefix = 'FGNET_procrustes_';
% fold = 3;

%% Auto set parameters
classifier_fullname = strcat(tmp_prefix, name_prefix, classifier_filename, sprintf('_fold_%d.mat', fold));
result_fullname = strcat(tmp_prefix, name_prefix, result_filename, sprintf('_fold_%d.mat', fold));

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

%%
fea_img_train = extract_img_features(pts_train);
fea_img_train = reshape(fea_img_train, [size(fea_img_train, 1)/2, 2, size(fea_img_train,2)]);
fea_img_test = extract_img_features(pts_test);
fea_img_test = reshape(fea_img_test, [size(fea_img_test, 1)/2, 2, size(fea_img_test,2)]);

%% Distance
[res, index_pair_test] = procrustes_baseline(fea_img_test, index_test, pair_info_test);
% [res, index_pair_test] = procrustes_baseline_growth(fea_img_test, index_test, pair_info_test, age_test, fea_img_train, index_train, age_train);
save(result_fullname, 'res', 'index_pair_test');
fprintf('Testing done.\n');

%% Analysis the result
load(result_fullname);
[fpr, tpr] = roc_analysis(res, index_pair_test);
