function plot_roc()

result1 = 'output/growth_manifold_fgnet_adult_res10_fold3/';
result2 = 'output/manifold_fgnet_adult_fold3/';
result3 = 'output/procrustes_fgnet_adult_fold3/';

[fpr1, tpr1] = merge_result(result1);
[fpr2, tpr2] = merge_result(result2);
[fpr3, tpr3] = merge_result(result3);

plot(tpr1, 1-fpr1, 'r-', 'LineWidth', 2);
hold on;
plot(tpr2, 1-fpr2, 'b--', 'LineWidth', 2);
plot(tpr3, 1-fpr3, 'm-.', 'LineWidth', 2);

result4 = 'output/hbling_fgnet_adult_roc.mat';
res = load(result4);
plot(res.tpr, 1-res.fpr, 'k--', 'LineWidth', 2);

grid on;
legend('Proposed', 'Manifold', 'Procrustes', 'GOP', 'location', 'SouthWest');
xlabel('correct acceptance rate');
ylabel('correct rejection rate');

save_figure('output/figure/growth_manifold_fgnet_adult.dat', fpr1, tpr1);
save_figure('output/figure/manifold_fgnet_adult.dat', fpr2, tpr2);
save_figure('output/figure/procrustes_fgnet_adult.dat', fpr3, tpr3);
save_figure('output/figure/hbling_fgnet_adult.dat', res.fpr, res.tpr);

%% Save
function save_figure(filename, fpr, tpr)
fid = fopen(filename, 'w');
for i = 1 : length(fpr)
    fprintf(fid, '%d %d\n', fpr(i), tpr(i));
end
fclose(fid);

function [fpr, tpr] = merge_result(path)
list = dir(strcat(path, '*result*.mat'));
res = [];
index = [];
for i = 1 : length(list)
    o = load(strcat(path, list(i).name));
    res = cat(1, res, o.res);
    index = cat(1, index, o.index_pair_test);
end
[fpr, tpr] = roc_analysis(res, index);