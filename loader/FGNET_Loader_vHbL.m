% function [img_train, index_train, img_gallery, index_gallery, img_probe, index_probe, pts_train, pts_gallery, pts_probe] = FGNET_Loader_vHbL(fold)
function [img_train, index_train, img_test, index_test, pair_info_train, pair_info_test, pts_train, pts_test, age_diff_train, age_diff_test] = FGNET_Loader_vHbL(fold)

% FGNET loader using Haibin Ling's protocol.

fprintf('Using FGNET Loader the adult protocol from Haibin Ling, fold = %d\n', fold);

%% parameters
prefix = '/home/taowu/work/data/fgnet-dataset/';

image_prefix = 'images/';
pts_prefix = 'pts/';

info_file = 'loader/fgnet/hbling_fgnet_images.list';


train_list_file = 'loader/fgnet/FGNET_Adult_272_image_pairs_18_100_fold3_train_%d.txt';
test_list_file = 'loader/fgnet/FGNET_Adult_272_image_pairs_18_100_fold3_test_%d.txt';

train_list_file = sprintf(train_list_file, fold);
test_list_file = sprintf(test_list_file, fold);

%% Load info
fid = fopen(train_list_file, 'r');
train_pairs = textscan(fid, '%d', 'Delimiter', ' ');
train_pairs = reshape(train_pairs{1}, [2, length(train_pairs{1})/2]);
fclose(fid);
fid = fopen(test_list_file, 'r');
test_pairs = textscan(fid, '%d', 'Delimiter', ' ');
test_pairs = reshape(test_pairs{1}, [2, length(test_pairs{1})/2]);
fclose(fid);
fid = fopen(info_file, 'r');
image_names = textscan(fid, '%s', 'Delimiter', ' ');
image_names = image_names{1}(1:2:end);
fclose(fid);

%% Load images and pts
id_hash_table = sparse(100000, 1);
siz = 256;
ratio = 140/128;
[index, ii, jj] = unique(train_pairs);

pts_gallery = zeros(68, 2, length(index));
index_gallery = zeros(length(index), 1);
img_gallery = zeros(round(siz*ratio), siz, length(index_gallery));
pair_info_train = zeros(numel(train_pairs), 1);
for i = 1 : length(index)
    filename = strcat(prefix, pts_prefix, image_names{index(i)}(1:end-3), 'pts');
    fid = fopen(filename, 'r');
    pts = textscan(fid, '%f', 'Delimiter', ' ');
    pts = reshape(pts{1}, [2, length(pts{1})/2]);
    pts_gallery(:,:,i) = pts';
    [new_id, id_hash_table] = Assign_ID(str2double(image_names{index(i)}(1:3)), id_hash_table);
    index_gallery(i) = new_id;
    fclose(fid);
    
    filename = strcat(prefix, image_prefix, image_names{index(i)});
    img = imread(filename);
    if size(img, 3) > 1
        img = rgb2gray(img);
    end
    src_eye = [pts(1,32), pts(2,32); pts(1,37), pts(2,37)];
    img = crop_use_eye(src_eye, img, siz, ratio);
    img_gallery(:,:,i) = img;
    
    pair_info_train(jj==i) = i;
end
pair_info_train = reshape(pair_info_train, [2, length(pair_info_train)/2]);
pair_info_train = pair_info_train';

age_diff_train = zeros(size(pair_info_train, 1), 1);
for i = 1 : size(pair_info_train, 1)
    age1 = str2double(image_names{pair_info_train(i,1)}(5:6));
    age2 = str2double(image_names{pair_info_train(i,2)}(5:6));
    age_diff_train(i) = abs(age1 - age2);
end

[index, ii, jj] = unique(test_pairs);
pts_probe = zeros(68, 2, length(index));
index_probe = zeros(length(index), 1);
img_probe = zeros(round(siz*ratio), siz, length(index_probe));
pair_info_test = zeros(numel(test_pairs), 1);
for i = 1 : length(index)
    filename = strcat(prefix, pts_prefix, image_names{index(i)}(1:end-3), 'pts');
    fid = fopen(filename, 'r');
    pts = textscan(fid, '%f', 'Delimiter', ' ');
    pts = reshape(pts{1}, [2, length(pts{1})/2]);
    pts_probe(:,:,i) = pts';
    [new_id, id_hash_table] = Assign_ID(str2double(image_names{index(i)}(1:3)), id_hash_table);
    index_probe(i) = new_id;
    fclose(fid);

    filename = strcat(prefix, image_prefix, image_names{index(i)});
    img = imread(filename);
    if size(img, 3) > 1
        img = rgb2gray(img);
    end
    src_eye = [pts(1,32), pts(2,32); pts(1,37), pts(2,37)];
    img = crop_use_eye(src_eye, img, siz, ratio);
    img_probe(:,:,i) = img;
    
    pair_info_test(jj==i) = i;
end
pair_info_test = reshape(pair_info_test, [2, length(pair_info_test)/2]);
pair_info_test = pair_info_test';

age_diff_test = zeros(size(pair_info_test, 1), 1);
for i = 1 : size(pair_info_test, 1)
    age1 = str2double(image_names{pair_info_test(i,1)}(5:6));
    age2 = str2double(image_names{pair_info_test(i,2)}(5:6));
    age_diff_test(i) = abs(age1 - age2);
end

img_train = img_gallery;
pts_train = pts_gallery;
index_train = index_gallery;

%% Output as only training and testing set, for verification experiment.
img_test = img_probe;
pts_test = pts_probe;
index_test = index_probe;
