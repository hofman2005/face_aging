function [out_img, new_pts] = crop_use_eye(src_eye, in_img, siz, ratio, pts)
target_eye = siz * [1/4 1/3; 3/4 1/3];
t = cp2tform(src_eye, target_eye, 'nonreflective similarity');
out_img = imtransform(in_img, t, 'XData', [1,siz], 'YData', [1,siz*ratio]);

if ~exist('pts', 'var')
    new_pts = [];
else
    [x,y] = tformfwd(t, pts(:,1), pts(:,2));
    new_pts = [x, y];
end