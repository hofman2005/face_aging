function find_best_growth_model()

pts_test_normalized = reshape(fea_img_test, [size(fea_img_test,1)/2, 2, size(fea_img_test,2)]);

k = 20;
pts_1 = pts_test_normalized(:,:,pair_info_test(k,1));
pts_2 = pts_test_normalized(:,:,pair_info_test(k,2));

value = zeros(size(growth_model_cache));
for i = 1 : size(growth_model_cache,1)
    for j = 1 : size(growth_model_cache,2)
        growth_model = growth_model_cache{i,j};
        if ~isstruct(growth_model)
            continue;
        end
        new_pts_2 = predict_growth_model(pts_2, growth_model);
        value(i,j) = procrustes(pts_1, new_pts_2, 'Reflection', false);
    end
end