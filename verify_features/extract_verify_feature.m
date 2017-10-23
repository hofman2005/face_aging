function [new_fea, new_index] = extract_verify_feature(fea, index, pair_info)

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

%% Grassmann manifold
fprintf('Calculating difference on Grassmann manifold. (P1-P2).\n');
siz = [size(fea,1)/2, 2];
new_fea = zeros(siz(1)*siz(1), size(pair_info,1));
for i = 1 : size(pair_info,1)
    x1 = reshape(fea(:, pair_info(i,1)), siz);
    x2 = reshape(fea(:, pair_info(i,2)), siz);
    p1 = x1*x1';
    p2 = x2*x2';
    p = p1-p2;
    new_fea(:, i) = p(:);
end