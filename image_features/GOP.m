function fea = GOP(images)
% Extract the gradient orientation pyramid

H = fspecial('gaussian', [3, 3], 0.5);
% Determine size
o = images(:,:,1);
f_x = [];
f_y = [];
for j = 1 : 3
    o = imfilter(o, H);
    [o_x, o_y] = compute_GO(o);
    f_x = cat(1, f_x, o_x(:));
    f_y = cat(1, f_y, o_y(:));
    o = imresize(o, size(o)/2);
end
f = [f_x; f_y];
fea = zeros(length(f), size(images,3));

parfor i = 1 : size(images, 3)
    o = images(:,:,i);  
    f_x = [];
    f_y = [];
    for j = 1 : 3
        o = imfilter(o, H);
        [o_x, o_y] = compute_GO(o);
        f_x = cat(1, f_x, o_x(:));
        f_y = cat(1, f_y, o_y(:));
        o = imresize(o, size(o)/2);
    end
    f = [f_x; f_y];
    
%     if i == 1
%         fea = zeros(length(f), size(images,3));
%     end
    
    fea(:,i) = f;
end

function [o_x, o_y] = compute_GO(o)
    diff_x = o(:, 3:end) - o(:, 1:end-2);
    diff_x = diff_x(2:end-1, :);
    diff_y = o(3:end, :) - o(1:end-2, :);
    diff_y = diff_y(:, 2:end-1);
    mag = sqrt(diff_x.^2 + diff_y.^2);
    
    o_x = diff_x ./ mag;
    o_y = diff_y ./ mag;
    
    thres = 0.2;
    o_x(abs(mag) < thres) = 0;
    o_y(abs(mag) < thres) = 0;