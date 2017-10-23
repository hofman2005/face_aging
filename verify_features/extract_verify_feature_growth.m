function [new_fea, new_index, growth_model_cache] = extract_verify_feature_growth(fea, age, index, pair_info, pts_train, old_growth_model_cache)

%% Prepare the new index -- Do not change
new_index = zeros(size(pair_info,1), 1);
for i = 1 : size(pair_info,1)
    if index(pair_info(i,1)) == index(pair_info(i,2))
        new_index(i) = 1;
    else
        new_index(i) = -1;
    end
end

%% Concatenate
% fprintf('Concatenate feature pairs.\n');
% new_fea = zeros(size(fea,1)*2, size(pair_info,1));
% new_fea(1:end/2, :) = fea(:, pair_info(:,1));
% new_fea(end/2+1:end, :) = fea(:, pair_info(:,2));

%% Difference
% fprintf('Calculating difference (direct substract).\n');
% new_fea = fea(:, pair_info(:,1)) - fea(:, pair_info(:,2));

%% Procrustes distance
% fprintf('Calculating procrustes distance.\n');
% new_fea = zeros(1, size(pair_info, 1));
% for i = 1 : size(pair_info,1)
%     fea1 = fea(:, pair_info(i,1));
%     fea2 = fea(:, pair_info(i,2));
%     
%     fea1 = reshape(fea1, length(fea1)/2, 2);
%     fea2 = reshape(fea2, length(fea2)/2, 2);
%     
%     d = -procrustes(fea1, fea2);
%     new_fea(i) = d;
% end

%% Chi square
% fprintf('Chi square distance.\n');
% x1 = fea(:, pair_info(:,1) );
% x2 = fea(:, pair_info(:,2) );
% new_fea = (x1-x2).^2./(abs(x1)+abs(x2)+eps);

%% Use GOP difference
% fprintf('Calculating GOP difference.\n');
% x1 = fea(:, pair_info(:,1) );
% x2 = fea(:, pair_info(:,2) );
% x = x1 .* x2;
% x = x(1:end/2, :) + x(end/2+1:end, :);
% new_fea = x;

%% Gradient difference
% fprintf('Calculating gradient difference.\n');
% x1 = fea(:, pair_info(:,1) );
% x2 = fea(:, pair_info(:,2) );
% x = x1 .* x2;
% x = x(1:end/2, :) + x(end/2+1:end, :);
% new_fea = x;

%% Normalize training shapes
% pts_train_normalized = normalize_shape(pts_train);
pts_train = reshape(pts_train, [size(pts_train,1)/2, 2, size(pts_train,2)]);

%% Grassmann manifold
fprintf('Calculating difference on Grassmann manifold. (P1-P2).\n');
siz = [size(fea,1)/2, 2];
new_fea = zeros(siz(1)*siz(1), size(pair_info,1));

if ~exist('old_growth_model_cache', 'var') || isempty(old_growth_model_cache)
    growth_model_cache = cell(max(age)+10, max(age)+10);
else
    growth_model_cache = old_growth_model_cache;
end

for i = 1 : size(pair_info,1)
    if mod(i, 100)==0
        fprintf(' Processing %d of %d\n', i, size(pair_info,1));
    end
    x1 = reshape(fea(:, pair_info(i,1)), siz);
    x2 = reshape(fea(:, pair_info(i,2)), siz);
    
    %%%%%%%%%%%%%%%%%%%
    % Growth
    age1 = age(pair_info(i,1));
    age2 = age(pair_info(i,2));
%     % Change age resolution for adults
%     resolution = 10;
%     if age1 > 18
%         age1 = ceil(age1/resolution)*resolution;
%     end
%     if age2 > 18
%         age2 = ceil(age2/resolution)*resolution;
%     end
    %
    % Change age resolution for children
    resolution = 3;
    if age1 < 18
        age1 = ceil(age1/resolution)*resolution;
    end
    if age2 < 18
        age2 = ceil(age2/resolution)*resolution;
    end
    
    % Learn growth model
    if age1+1 > size(growth_model_cache,1) || age2+1 > size(growth_model_cache,2)
        fprintf('Error age1+1 = %d, age2+1 = %d', age+1, age2+1);
    end
    if isempty(growth_model_cache{age1+1, age2+1})
        fprintf('Learning growth model from age %d to %d.\n', age1, age2);
        growth_model = learn_growth_model(pts_train, index, age, age1, age2);
        growth_model_cache{age1+1, age2+1} = growth_model;
    else
        growth_model = growth_model_cache{age1+1, age2+1};
    end
    x2 = predict_growth_model(x2, growth_model);
%     x2 = predict_best_growth_model(x1, x2, growth_model_cache);

    x1 = bsxfun(@minus, x1, mean(x1));
    [U,S,V] = svd(x1);
    x1 = U(:,1:2);
    
    x2 = bsxfun(@minus, x2, mean(x2));
    [U,S,V] = svd(x2);
    x2 = U(:,1:2);   
    %%%%%%%%%%%%%%%%%%%

%     %%%%%%%%%%%%%%%%%%%
%     % Age invariant
%     offset = 1.9;
%     x1(:,2) = x1(:,2) + offset;
%     x2(:,2) = x2(:,2) + offset;
%     x1 = sign(x1).*log(abs(x1));
%     x2 = sign(x2).*log(abs(x2));
% 
%     x1 = bsxfun(@minus, x1, mean(x1));
%     [U,S,V] = svd(x1);
%     x1 = U(:,1:2);
%     
%     x2 = bsxfun(@minus, x2, mean(x2));
%     [U,S,V] = svd(x2);
%     x2 = U(:,1:2);   
%     %%%%%%%%%%%%%%%%%%%
    
    p1 = x1*x1';
    p2 = x2*x2';
    p = p1-p2;
    new_fea(:, i) = p(:);
end

%% Age invariant
% fprintf('Calculating age invariant difference.\n');
% fprintf('Calculating difference on Grassmann manifold. (P1-P2).\n');
% siz = [size(fea,1)/2, 2];
% new_fea = zeros(siz(1)*siz(2), size(pair_info,1));
% 
% if ~exist('old_growth_model_cache', 'var') || isempty(old_growth_model_cache)
%     growth_model_cache = cell(max(age)+1, max(age)+1);
% else
%     growth_model_cache = old_growth_model_cache;
% end
% 
% for i = 1 : size(pair_info,1)
%     if mod(i, 100)==0
%         fprintf(' Processing %d of %d\n', i, size(pair_info,1));
%     end
%     x1 = reshape(fea(:, pair_info(i,1)), siz);
%     x2 = reshape(fea(:, pair_info(i,2)), siz);
%     
%     offset = 1.9;
%     x1(:,2) = x1(:,2) + offset;
%     x2(:,2) = x2(:,2) + offset;
%     x1 = sign(x1).*log(abs(x1));
%     x2 = sign(x2).*log(abs(x2));
% 
%     p = x2 - x1;
%     new_fea(:, i) = p(:);
% end