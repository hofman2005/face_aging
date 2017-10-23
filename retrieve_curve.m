function [fpr, tpr] = retrieve_curve(img)

%% Extract the fpr and tpr from a roc image

if size(img,3) > 1
    img = rgb2gray(img);
end

siz = size(img);

if siz(1) ~= siz(2)
    img = imresize(img, [min(siz), min(siz)]);
end
siz = size(img);

fpr = zeros(siz(1),1);
tpr = zeros(siz(2),1);

for i = 1 : siz(2)
    tpr(i) = i / siz(2);
    index = find(img(:,i)<255);
    if ~isempty(index)
        index = mean(index);
        fpr(i) = index / siz(1);
    else
        if tpr(i) < 0.1
            fpr(i) = 0;
        else
            fpr(i) = tpr(i);
            tpr(i) = 1;
        end
    end
    
end