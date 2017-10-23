function new_pts = predict_best_growth_model(pts_1, pts_2, growth_model_cache)

value = zeros(size(growth_model_cache));
for i = 1 : size(growth_model_cache,1)
    for j = 1 : size(growth_model_cache,2)
        growth_model = growth_model_cache{i,j};
        if ~isstruct(growth_model)
            continue;
        end
        new_pts_2 = predict_growth_model(pts_2, growth_model);
%         value(i,j) = procrustes(pts_1, new_pts_2, 'Reflection', false);
        value(i,j) = grassmann_geodesic_length(pts_1, new_pts_2);
    end
end

[x,y] = find(value == min(value(:)), 1);

new_pts = predict_growth_model(pts_2, growth_model_cache{x,y});


function value = grassmann_geodesic_length(x1, x2)

x1 = bsxfun(@minus, x1, mean(x1));
[U,S,V] = svd(x1);
x1 = U(:,1:2);

x2 = bsxfun(@minus, x2, mean(x2));
[U,S,V] = svd(x2);
x2 = U(:,1:2);
    
o = x1'*x2;
[u, s, v] = svd(o);

theta = acos(diag(s));

% % Arc length
% value = sqrt(sum(theta.^2));

% % Fubini
% value = acos(prod(cos(theta)));

% F-norm
value = sqrt(sum(sin(theta).^2));