%% Show some intermediate result

% [fea_pair_test, index_pair_test_b, growth_model_cache] = extract_verify_feature_growth(fea_img_test, age_test, index_test, pair_info_test(b_start:b_end, :), fea_img_train, growth_model_cache);

id = 32;

% ages = [9, 12, 15, 18];
ages = [8,9,10,11,12,13,14,15,16,17,18];

% index = zeros(size(ages));
index = find(and(age_test==8, index_test == id));

style = {'c-+', 'r-+', 'm-+', 'k-+', 'b-+', 'g-+'};
% style = {'c+', 'r+', 'm+', 'k+', 'g+', 'b+'};

% for i = 1 : length(ages)
%     index(i) = find(and(age_test==ages(i), index_test==id));
%     
%     shape = fea_img_test(:, index(i));
%     shape = reshape(shape, [length(shape)/2, 2]);
%     
%     % Plot shape
%     figure(1) % subplot(1, length(ages), i);
%     plot(shape(:,1), -shape(:,2), style{i});
%     hold on
% end

shape = fea_img_test(:, index(1));
shape = reshape(shape, [length(shape)/2, 2]);
new_shape = shape;
for i = 1 : length(ages) - 1
    
    % Grown
    h = figure(2); % subplot(1, length(ages), i);
    model = growth_model_cache{ages(i)+1, ages(i+1)+1};
    new_shape = predict_growth_model(new_shape, model);
    % plot(new_shape(:,1), -shape(:,2), style{mod(i, length(style))+1}, 'MarkerSize', 10);
    plot(new_shape(:,1), -shape(:,2), 'b-+', 'MarkerSize', 10);
    xlim([-2.5, 2.5])
    % hold on
    saveas(h, sprintf('/tmp/age_%2.2d.png', i));
end

%% Find an example
for i = 1 : 82
    o = age_test(index_test==i);
    if size(find(o==9), 1) > 0 
        if size(find(o==12), 1) > 0
            if size(find(o==15), 1) > 0
                if size(find(o==18), 1) > 0
                    disp(i);
                end
            end
        end
    end
end