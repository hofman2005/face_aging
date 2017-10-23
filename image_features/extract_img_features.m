function fea = extract_img_features(img)

%% Build mask
% siz = size(img);
% [x, y] = meshgrid(1:siz(2), 1:siz(1));
% mask = ((y-siz(1)/2).^2/(1.5*siz(1)/siz(2)*256/280) + (x-siz(2)/2).^2) < (siz(1)/2*13/14)^2;

%% Blur (denoise)
% fprintf('Blur (denoise).\n');
% H = fspecial('gaussian', [3,3], 0.5);
% parfor i = 1 : size(img,3)
%     img(:,:,i) = imfilter(img(:,:,i), H, 'replicate');
% end

%% Downsample
% new_size = [128, 128];
% fprintf('Downsample to [%d,%d].\n', new_size(1), new_size(2));
% temp = zeros(new_size(1), new_size(2), size(img,3));
% parfor i = 1 : size(img,3)
%     temp(:,:,i) = imresize(img(:,:,i), new_size);
% end
% fea = reshape(temp, size(temp,1)*size(temp,2), size(temp,3));
% img = temp;
% mask = imresize(mask, new_size);

%% Self quotient image
% fprintf('Calculating self quotient image.\n');
% temp = zeros(size(img));
% parfor i = 1 : size(img,3)
% %     img2 = imfilter(img(:,:,i), H, 'replicate');
% %     img2 = img(:,:,i) ./ img2;
% % %     temp(:,:,i) = img2;
% %     
% %     img3 = (img2 - min(img2(:))) / (max(img2(:))-min(img2(:))) * 255;
% %     img3 = imadjust(uint8(img3));
% %     temp(:,:,i) = img3;
%     temp(:,:,i) = self_quotient(img(:,:,i));
% end
% fea = reshape(temp, size(temp,1)*size(temp,2), size(temp,3));
% img = temp;

%% Image normalize
% fprintf('Image normalize. (mean=0, var=1).\n');
% temp = zeros(size(img));
% for i = 1 : size(img,3)
%     img2 = img(:,:,i);
%     img2 = img2 - mean(img2(:));
%     img2 = img2 / std(img2(:));
%     temp(:,:,i) = img2;
% end
% fea = reshape(temp, size(temp,1)*size(temp,2), size(temp,3));
% img = temp;

%% Downsample
% new_size = [38,38];
% fprintf('Downsample to [%d,%d].\n', new_size(1), new_size(2));
% temp = zeros(new_size(1), new_size(2), size(img,3));
% parfor i = 1 : size(img,3)
%     temp(:,:,i) = imresize(img(:,:,i), new_size);
% end
% fea = temp;
% img = temp;
% mask = imresize(mask, new_size);


%% Vectorize
% fprintf('Vectorizing the images.\n');
% fea = reshape(img, size(img,1)*size(img,2), size(img,3));
% mask
% fprintf('Masking.\n');
% fea= fea(mask(:)==1, :);
 
%% GOP features
% fprintf('Extracting GOP features.\n');
% fea = GOP(img);

%% PHOW features
% step = 6;
% sizes = [1 2 3];
% fprintf('Extracting PHOW features. step = %d\n', step);
% [f,o] = vl_phow(single(img(:,:,1)), 'step', step, 'sizes', sizes);
% temp = zeros(numel(o), size(img,3));
% parfor i = 1 : size(img, 3)
%     [frames, descr] = vl_phow(single(img(:,:,i)), 'step', step, 'sizes', sizes);
%     temp(:,i) = descr(:);
% end
% % fea = [fea; temp];
% fea = temp;

%% SIFT features
% step = 5;
% fprintf('Extracting SIFT features. step = %d\n', step);
% [f,o] = vl_dsift(single(img(:,:,1)), 'step', step);
% temp = zeros(numel(o), size(img,3));
% parfor i = 1 : size(img, 3)
%     [frames, descr] = vl_dsift(single(img(:,:,i)), 'step', step);
%     temp(:,i) = descr(:);
% end
% % fea = [fea; temp];
% fea = temp;

%% Gradient
% fprintf('Extract gradient.\n');
% siz = [size(img,1)*size(img,2)*2, size(img,3)];
% % siz = [size(img,1)*size(img,2), size(img,3)];
% fea = zeros(siz);
% for i = 1 : size(img,3)
%     [x,y] = gradient(img(:,:,i));
%     fea(1:siz(1)/2, i) = x(:);
%     fea(siz(1)/2+1:end, i) = y(:);
% end

%% Added on 2/18/2012, try with the log growth model
% %     Needs to run before Grassmann manifold
%% Normalize against eyes
fprintf('Aligning eyes centers.\n');
for i = 1 : size(img, 3)
    pts = img(:,:,i);
    src_eye = [pts(32,1), pts(32,2); pts(37,1), pts(37,2)];
    target_eye = [-1 0; 1 0];
    t = cp2tform(src_eye, target_eye, 'nonreflective similarity');
    
    [x,y] = tformfwd(t, pts(:,1), pts(:,2));
    
    img(:,:,i) = [x,y];
end
fea = reshape(img, [size(img,1)*size(img,2), size(img,3)]);

%% Log facial shapes
% temp = img(:,1,:);
% img(:,1,:) = sign(temp).*log(abs(temp));
% temp = img(:,2,:);
% offset = 1.8;
% img(:,2,:) = sign(temp+offset).*log(abs(temp+offset));
% fea = img;

%% Simple remove non stable points across aging
% img = img(10:40, :, :);

%% Grassmann manifold
% fea = zeros(size(img,1)*size(img,2), size(img,3));
% fprintf('Calculating the representation on Grassmann manifold.\n');
% for i = 1 : size(img, 3)
%     temp = img(:,:,i);
%     temp = bsxfun(@minus, temp, mean(temp));
%     [U,S,V] = svd(temp);
%     temp = U(:,1:2);
%     fea(:,i) = temp(:);
% end


