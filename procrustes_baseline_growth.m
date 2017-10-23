function [res, index_pair_test] = procrustes_baseline_growth(fea, fea_id, pair_info, age_test, pts_train, index_train, age_train)

res = zeros(size(pair_info,1), 1);
index_pair_test = zeros(size(pair_info,1), 1);
growth_model_cache = cell(80,80);

for i = 1 : size(pair_info,1)
    x1 = fea(:,:,pair_info(i,1));
    x2 = fea(:,:,pair_info(i,2));
    
    %%%%%%%%%%%%%%%%%%%
    % Growth
    age1 = age_test(pair_info(i,1));
    age2 = age_test(pair_info(i,2));
    % Change age resolution for adults
    resolution = 10;
    if age1 > 18
        age1 = ceil(age1/resolution)*resolution;
    end
    if age2 > 18
        age2 = ceil(age2/resolution)*resolution;
    end
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
        growth_model = learn_growth_model(pts_train, index_train, age_train, age1, age2);
        growth_model_cache{age1+1, age2+1} = growth_model;
    else
        growth_model = growth_model_cache{age1+1, age2+1};
    end
    x2 = predict_growth_model(x2, growth_model);
    
    res(i) = -procrustes(x1, x2, 'Reflection', false);
    
    if fea_id(pair_info(i,1)) == fea_id(pair_info(i,2))
        index_pair_test(i) = 1;
    else
        index_pair_test(i) = -1;
    end
end