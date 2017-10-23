function [pair_info_train, pair_info_test] = pair_generator()

%% Output prefix
% output_prefix = 'loader/fgnet/fgnet_all

%%
info_file = 'loader/fgnet/hbling_fgnet_all.list';
fid = fopen(info_file, 'r');
image_names = textscan(fid, '%s', 'Delimiter', ' ');
image_names = image_names{1}(1:end);
fclose(fid);

ids = zeros(length(image_names), 1);
ages = zeros(length(image_names), 1);
for i = 1 : length(image_names)
    id = str2double(image_names{i}(1:3));
    age = str2double(image_names{i}(5:6));
    ids(i) = id;
    ages(i) = age;
end

%% Select age subset
age_start = 0;
age_end = 70;
selected_index = find(ages>=age_start & ages<=age_end);

ids = ids(selected_index);
ages = ages(selected_index);

fold = 3;
[pair_info_train, pair_info_test] = generate_folds(ids, fold);

%% Save
% TODO

function [pair_info_train, pair_info_test] = generate_folds(ids, fold)

unique_ids = unique(ids);
uniqueids_I = randperm(length(unique_ids));
uniqueids_I_cut = 1 : round(length(unique_ids)/fold) : length(unique_ids);
if uniqueids_I_cut(end) ~= length(unique_ids)
    uniqueids_I_cut = [uniqueids_I_cut length(unique_ids)];
end

pair_info_train = cell(fold, 1);
pair_info_test = cell(fold, 1);
for i = 1 : fold
    test_unique_ids = unique_ids(uniqueids_I(uniqueids_I_cut(i):uniqueids_I_cut(i+1)));
    train_unique_ids = setdiff(unique_ids, test_unique_ids);  
    
    index = find(ismember(ids, train_unique_ids));
    pair_info = generate_pairs(ids(index));
    pair_info = index(pair_info);
    pair_info_train{i} = pair_info;
    
    index = find(ismember(ids, test_unique_ids));
    pair_info = generate_pairs(ids(index));
    pair_info = index(pair_info);
    pair_info_test{i} = pair_info;
end

function pair_info = generate_pairs(ids)
num_pos_pairs = 1000;
num_neg_pairs = 2000;
% Same pair
pos_pair = [];
for i = 1 : length(ids)
    for j = i+1 : length(ids)
        if ids(i)==ids(j)
            pos_pair = cat(1, pos_pair, [i,j]);
        end
    end
end
selected = randperm(size(pos_pair,1));
selected = selected(1:num_pos_pairs);
pos_pair = pos_pair(selected,:);

% Diff pair
neg_pair = [];
count = 0;
while count < num_neg_pairs;
    index1 = round(rand(1)*(length(ids)-1))+1;
    index2 = round(rand(1)*(length(ids)-1))+1;
    
    if ids(index1) == ids(index2)
        continue;
    end
    neg_pair = cat(1, neg_pair, [index1, index2]);
    count = count + 1;
end

pair_info = [pos_pair; neg_pair];