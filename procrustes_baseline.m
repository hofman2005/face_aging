function [res, index_pair_test] = procrustes_baseline(fea, fea_id, pair_info)

res = zeros(size(pair_info,1), 1);
index_pair_test = zeros(size(pair_info,1), 1);
for i = 1 : size(pair_info,1)
    x1 = fea(:,:,pair_info(i,1));
    x2 = fea(:,:,pair_info(i,2));
    res(i) = -procrustes(x1, x2, 'Reflection', false);
    
    if fea_id(pair_info(i,1)) == fea_id(pair_info(i,2))
        index_pair_test(i) = 1;
    else
        index_pair_test(i) = -1;
    end
end