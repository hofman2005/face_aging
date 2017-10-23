function [data, index_data, pair_info, age_data, age_diff, id_hash_table] = ...
    FGNET_Loader_vHbl_subset(info_file, pair_list_file, load_type, data_prefix, old_id_hash_table)

% FGNET loader using Haibin Ling's protocol.

fprintf('Using FGNET Loader subset protocol from Haibin Ling: \n');
fprintf('  Info file: %s\n', info_file);
fprintf('  Pair list: %s\n', pair_list_file);
fprintf('  Load type: %s\n', load_type);

%% parameters
if ~exist('data_prefix', 'var') || isempty(data_prefix)
    prefix = '/home/taowu/work/data/fgnet-dataset/';
else
    prefix = data_prefix;
end

image_prefix = 'images/';
pts_prefix = 'pts/';

%% Load info
fid = fopen(pair_list_file, 'r');
pairs = textscan(fid, '%d', 'Delimiter', ' ');
pairs = reshape(pairs{1}, [2, length(pairs{1})/2]);
fclose(fid);
fid = fopen(info_file, 'r');
image_names = textscan(fid, '%s', 'Delimiter', ' ');
image_names = image_names{1}(1:end);
fclose(fid);

%% Load images and pts
if ~exist('old_id_hash_table', 'var') || isempty(old_id_hash_table)
    id_hash_table = sparse(100000, 1);
else
    id_hash_table = old_id_hash_table;
end

siz = 256;
ratio = 140/128;
% [index, ii, jj] = unique(pairs);

age_data = zeros(length(image_names), 1);
index_data = zeros(length(image_names), 1);
pair_info = zeros(numel(pairs), 1);

for i = 1 : length(image_names)
    age_data(i) = str2double(image_names{i}(5:6));
end

if strcmp(load_type, 'shape')
    data = zeros(68, 2, length(image_names));
    for i = 1 : length(image_names)
        filename = strcat(prefix, pts_prefix, image_names{i}(1:end-3), 'pts');
        fid = fopen(filename, 'r');
        pts = textscan(fid, '%f', 'Delimiter', ' ');
        pts = reshape(pts{1}, [2, length(pts{1})/2]);
        data(:,:,i) = pts';
        [new_id, id_hash_table] = Assign_ID(str2double(image_names{i}(1:3)), id_hash_table);
        index_data(i) = new_id;
        fclose(fid);
               
%         pair_info(jj==i) = i;
    end
end

if strcmp(load_type, 'image')
    data = zeros(round(siz*ratio), siz, length(image_names));
    for i = 1 : length(image_names)        
        filename = strcat(prefix, image_prefix, image_names{i});
        img = imread(filename);
        if size(img, 3) > 1
            img = rgb2gray(img);
        end
        src_eye = [pts(1,32), pts(2,32); pts(1,37), pts(2,37)];
        img = crop_use_eye(src_eye, img, siz, ratio);
        data(:,:,i) = img;
        
%         pair_info(jj==i) = i;
    end
end

% pair_info = reshape(pair_info, [2, length(pair_info)/2]);
% pair_info = pair_info';
pair_info = pairs';

age_diff = zeros(size(pair_info, 1), 1);
for i = 1 : size(pair_info, 1)
    age1 = str2double(image_names{pair_info(i,1)}(5:6));
    age2 = str2double(image_names{pair_info(i,2)}(5:6));
    age_diff(i) = abs(age1 - age2);
end

%% Old version
% if ~exist('old_id_hash_table', 'var') || isempty(old_id_hash_table)
%     id_hash_table = sparse(100000, 1);
% else
%     id_hash_table = old_id_hash_table;
% end
% 
% siz = 256;
% ratio = 140/128;
% [index, ii, jj] = unique(pairs);
% 
% age_data = zeros(length(index), 1);
% index_data = zeros(length(index), 1);
% pair_info = zeros(numel(pairs), 1);
% 
% for i = 1 : length(index)
%     age_data(i) = str2double(image_names{index(i)}(5:6));
% end
% 
% if strcmp(load_type, 'shape')
%     data = zeros(68, 2, length(index));
%     for i = 1 : length(index)
%         filename = strcat(prefix, pts_prefix, image_names{index(i)}(1:end-3), 'pts');
%         fid = fopen(filename, 'r');
%         pts = textscan(fid, '%f', 'Delimiter', ' ');
%         pts = reshape(pts{1}, [2, length(pts{1})/2]);
%         data(:,:,i) = pts';
%         [new_id, id_hash_table] = Assign_ID(str2double(image_names{index(i)}(1:3)), id_hash_table);
%         index_data(i) = new_id;
%         fclose(fid);
%                
%         pair_info(jj==i) = i;
%     end
% end
% 
% if strcmp(load_type, 'image')
%     data = zeros(round(siz*ratio), siz, length(index_gallery));
%     for i = 1 : length(index)        
%         filename = strcat(prefix, image_prefix, image_names{index(i)});
%         img = imread(filename);
%         if size(img, 3) > 1
%             img = rgb2gray(img);
%         end
%         src_eye = [pts(1,32), pts(2,32); pts(1,37), pts(2,37)];
%         img = crop_use_eye(src_eye, img, siz, ratio);
%         data(:,:,i) = img;
%         
%         pair_info(jj==i) = i;
%     end
% end
% 
% pair_info = reshape(pair_info, [2, length(pair_info)/2]);
% pair_info = pair_info';
% 
% age_diff = zeros(size(pair_info, 1), 1);
% for i = 1 : size(pair_info, 1)
%     age1 = str2double(image_names{pair_info(i,1)}(5:6));
%     age2 = str2double(image_names{pair_info(i,2)}(5:6));
%     age_diff(i) = abs(age1 - age2);
% end
