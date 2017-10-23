function [pts_train, index_train, age_train, pts_test, index_test, age_test, pair_info_train, pair_info_test, age_diff_train, age_diff_test] = FGNET_Loader_vHbL_shape_only(fold)

%% This version only load shapes.

%% Load training set
info_file = 'loader/fgnet/hbling_fgnet_all.list';
% info_file = 'loader/fgnet/hbling_fgnet_images.list'; % For Adult_272 list file
% pair_list_file = sprintf('loader/fgnet/FGNET_all_988_image_pairs_fold3_train_%d.txt', fold);
pair_list_file = sprintf('loader/fgnet/FGNET_18_image_pairs_fold3_train_%d.txt', fold);
% pair_list_file = sprintf('loader/fgnet/FGNET_Adult_272_image_pairs_18_100_fold3_train_%d.txt', fold);
% pair_list_file = sprintf('loader/fgnet/FGNET_whole_pairs_fold3_train_%d.txt', fold);
load_type = 'shape';
data_prefix = '/home/taowu/work/data/fgnet-dataset/';

[pts_train, index_train, pair_info_train, age_train, age_diff_train, id_hash_table] = FGNET_Loader_vHbl_subset(info_file, pair_list_file, load_type, data_prefix);


%% Load testing set
% pair_list_file = sprintf('loader/fgnet/FGNET_all_988_image_pairs_fold3_test_%d.txt', fold);
pair_list_file = sprintf('loader/fgnet/FGNET_18_image_pairs_fold3_test_%d.txt', fold);
% pair_list_file = sprintf('loader/fgnet/FGNET_Adult_272_image_pairs_18_100_fold3_test_%d.txt', fold);
% pair_list_file = sprintf('loader/fgnet/FGNET_whole_pairs_fold3_test_%d.txt', fold);
[pts_test, index_test, pair_info_test, age_test, age_diff_test, id_hash_table] = FGNET_Loader_vHbl_subset(info_file, pair_list_file, load_type, data_prefix, id_hash_table);

%% Select age subset.
% age_low = 0;
% age_high = 8;
% fprintf('Selected age_low = %d, age_high = %d\n', age_low, age_high);
% 
% o1 = age_train(pair_info_train(:,1)) >= age_low & age_train(pair_info_train(:,1)) <= age_high;
% o2 = age_train(pair_info_train(:,2)) >= age_low & age_train(pair_info_train(:,2)) <= age_high;
% o = o1 & o2;
% pair_info_train = pair_info_train(o, :);
% age_diff_train = age_diff_train(o,:);
% 
% o1 = age_test(pair_info_test(:,1)) >= age_low & age_test(pair_info_test(:,1)) <= age_high;
% o2 = age_test(pair_info_test(:,2)) >= age_low & age_test(pair_info_test(:,2)) <= age_high;
% o = o1 & o2;
% pair_info_test = pair_info_test(o, :);
% age_diff_test = age_diff_test(o,:);
