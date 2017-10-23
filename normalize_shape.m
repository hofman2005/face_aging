function pts_all = normalize_shape(pts_all)

% Eye coordinates are 32 and 37 for FGNET

for i = 1 : size(pts_all, 3)
    pts = pts_all(:,:,i);
    src_eye = [pts(32,1), pts(32,2); pts(37,1), pts(37,2)];
    target_eye = [-1 0; 1 0];
    t = cp2tform(src_eye, target_eye, 'nonreflective similarity');
    
    [x,y] = tformfwd(t, pts(:,1), pts(:,2));
    
    pts_all(:,:,i) = [x,y];
end
