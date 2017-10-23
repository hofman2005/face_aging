function [fpr, tpr, ERR] = roc_analysis(res, gt)
% main_analysis

%% ROC curve
% thres = min(res):(max(res)-min(res))/1000:max(res);
thres = max(res):-(max(res)-min(res))/1000:min(res);
if max(res) == min(res)
    warning('Result is a straight line. Something must be wrong.');
    thres = max(res) * ones(length(res), 1);
end
fpr = zeros(length(thres),1);
tpr = zeros(length(thres),1);
for i = 1 : length(thres)
    %tpr(i) = sum((result.dist<thres(i)) & (result.res==1) & (result.gt==1));
    %fpr(i) = sum((result.dist<thres(i)) & (result.res==1) & (result.gt==0));
    tpr(i) = sum((res>=thres(i)) & (gt==1));
    fpr(i) = sum((res>=thres(i)) & (gt==-1));
%     if strfind(conf.classifier, 'svm')
%         fpr(i) = sum((res<thres(i)) & (gt==-1));
%     else
%         fpr(i) = sum((res<thres(i)) & (gt==0));
%     end
end
tpr = tpr / max(tpr);
fpr = fpr / max(fpr);

%% Check tpr at a given fpr
fix_fpr = 0.1;
i1 = find(fpr <= fix_fpr);
i2 = find(fpr >= fix_fpr);
i1 = i1(end);
i2 = i2(1);
if i1 > i2 % Special case
    i1 = i2;
end
if fpr(i1) == fpr(i2)
    target_tpr = mean([tpr(i1), tpr(i2)]);
else
    target_tpr = tpr(i1) + (tpr(i2)-tpr(i1))/(fpr(i2)-fpr(i1))*(fix_fpr-fpr(i1));
end
fprintf('TPR = %f when FPR = %f\n', target_tpr, fix_fpr);

%% EER
rr = fpr + tpr;
i1 = find(fpr + tpr <= 1);
i2 = find(fpr + tpr >= 1);
[y1, ii1] = sort(rr(i1));
[y2, ii2] = sort(rr(i2));
i1 = i1(ii1(end));
i2 = i2(ii2(1));
if i1==i2
    ERR = fpr(i1);
elseif i1 > i2
    ERR = fpr(round(mean([i1,i2])));
else
    o = [fpr(i1), tpr(i1); fpr(i2), tpr(i2)] \ [1; 1];
    ERR = (1-o(2)) / (o(1)-o(2));
end
fprintf('ERR = %f\n', ERR);
% save(conf.result_file, 'conf', 'result', 'tpr', 'fpr', 'ERR');

%% Check TPR-FPR of the output
%     res_tpr = sum((result.res == 1) & (result.gt == 1)) / sum(result.gt==1);
%     res_fpr = sum((result.res == 1) & (result.gt == -1)) / sum(result.gt==-1);
%     fprintf('For the classifier decision: tpr = %f, fpr = %f\n', res_tpr,
%     res_fpr);

