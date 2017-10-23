function FGNET_vHbL_generator()

%% Generate subset list files according to his description

%% Load training set
for fold = 1 : 3
    info_file = 'loader/fgnet/hbling_fgnet_all.list';
    pair_list_file = sprintf('loader/fgnet/FGNET_all_988_image_pairs_fold3_train_%d.txt', fold);
    load_type = 'shape';
    data_prefix = '/home/taowu/work/data/fgnet-dataset/';
    
    [pts_train, index_train, pair_info_train, age_train, age_diff_train, id_hash_table] = FGNET_Loader_vHbl_subset(info_file, pair_list_file, load_type, data_prefix);
    
    
    %% Load testing set
    pair_list_file = sprintf('loader/fgnet/FGNET_all_988_image_pairs_fold3_test_%d.txt', fold);
    [pts_test, index_test, pair_info_test, age_test, age_diff_test, id_hash_table] = FGNET_Loader_vHbl_subset(info_file, pair_list_file, load_type, data_prefix, id_hash_table);
    
    %% FGNET-8
    %  290 images from 74 subjects in range [0, 8]
    %  580 intra-person and 6000 extra-person pairs total
%     age_low = 0;
%     age_high = 8;
%     new_pair_info_train = build_subset(index_train, pair_info_train, age_train, age_low, age_high);
%     new_pair_info_test = build_subset(index_test, pair_info_test, age_test, age_low, age_high);    
%     pair_list_file = sprintf('loader/fgnet/FGNET_8_image_pairs_fold3_train_%d.txt', fold);
%     write_list(new_pair_info_train, pair_list_file);
%     pair_list_file = sprintf('loader/fgnet/FGNET_8_image_pairs_fold3_test_%d.txt', fold);
%     write_list(new_pair_info_test, pair_list_file);
    
    %% FGNET-18
    %  311 images from 79 subjects in range [8, 18]
    %  577 intra-person and 6000 extra-person pairs total
%     age_low = 8;
%     age_high = 18;
%     new_pair_info_train = build_subset(index_train, pair_info_train, age_train, age_low, age_high);
%     new_pair_info_test = build_subset(index_test, pair_info_test, age_test, age_low, age_high);    
%     pair_list_file = sprintf('loader/fgnet/FGNET_18_image_pairs_fold3_train_%d.txt', fold);
%     write_list(new_pair_info_train, pair_list_file);
%     pair_list_file = sprintf('loader/fgnet/FGNET_18_image_pairs_fold3_test_%d.txt', fold);
%     write_list(new_pair_info_test, pair_list_file);

    %% FGNET-whole
    %  all images from 82 subjects in range [0, max]
    %  577 intra-person and 12000 extra-person pairs total
    age_low = 0;
    age_high = 100;
    new_pair_info_train = build_subset(index_train, pair_info_train, age_train, age_low, age_high);
    new_pair_info_test = build_subset(index_test, pair_info_test, age_test, age_low, age_high);    
    pair_list_file = sprintf('loader/fgnet/FGNET_wv2_image_pairs_fold3_train_%d.txt', fold);
    write_list(new_pair_info_train, pair_list_file);
    pair_list_file = sprintf('loader/fgnet/FGNET_wv2_image_pairs_fold3_test_%d.txt', fold);
    write_list(new_pair_info_test, pair_list_file);
end

function write_list(pair_info, filename)
    fid = fopen(filename, 'w');
    for i = 1 : size(pair_info, 1)
        fprintf(fid, '%d %d\n', pair_info(i,1), pair_info(i,2));
    end
    fclose(fid);

function new_pair_info = build_subset(index, pair_info, age, age_low, age_high)
    same_index = index(pair_info(:,1)) == index(pair_info(:,2));
    diff_index = index(pair_info(:,1)) ~= index(pair_info(:,2));

    o1 = age(pair_info(:,1))>=age_low & age(pair_info(:,1))<=age_high;
    o2 = age(pair_info(:,2))>=age_low & age(pair_info(:,2))<=age_high;
    o = o1 & o2;
    
    new_same_pair = pair_info(same_index & o, :);
    new_diff_pair = pair_info(diff_index & o, :);
    
    num = 2000;
    if size(new_diff_pair, 1) > num
        I = randperm(size(new_diff_pair, 1));
        new_diff_pair = new_diff_pair(I(1:num),:);
    end
    
    new_pair_info = cat(1, new_same_pair, new_diff_pair);