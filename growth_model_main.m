% function res = main(fold)
fold = 1;

%% Load
% [img_train, index_train, img_test, index_test, pair_info_train, pair_info_test, pts_train, pts_test, age_diff_train, age_diff_test] = FGNET_Loader_vHbL(fold);
[pts_train, index_train, pair_info_train, age_train, age_train_diff, id_hash_table] = ...
    FGNET_Loader_vHbl_subset('loader/fgnet/hbling_fgnet_all.list', ...
    'FGNET_all_988_image_pairs_fold3_train_same_person_1.txt', ...
    'shape', ...
    '/home/taowu/work/data/fgnet-dataset/');

%%
pts_train_normalized = normalize_shape(pts_train);

%% Show the same guy
id = 2;
index = find(index_train == id);
color = ['b', 'g', 'r', 'c', 'm', 'y', 'k', 'w'];
% for i = 1 : length(index)
%     plot(pts_train_normalized(:,1,index(i)), -pts_train_normalized(:,2,index(i)), '-+');
%     hold on;
% end
plot(shiftdim(pts_train_normalized(:,1,index),2), shiftdim(-pts_train_normalized(:,2,index),2), '-+');
legend('1', '2', '3', '4', '5', '6');

%% learn model
growth_model = learn_growth_model(pts_train_normalized, index_train, age_train);

%% load test data
[pts_test, index_test, pair_info_test, age_test, age_test_diff, id_hash_table] = ...
    FGNET_Loader_vHbl_subset('loader/fgnet/hbling_fgnet_all.list', ...
    'FGNET_all_988_image_pairs_fold3_test_same_person_1.txt', ...
    'shape', ...
    '/home/taowu/work/data/fgnet-dataset/', ...
    id_hash_table);
%%
pts_test_normalized = normalize_shape(pts_test);

%%
new_pts = predict_growth_model(pts, growth_model);