%% Draw age gap figure
function [err_1, err_2, err_3] = draw_age_gap()
% Use [mean(err_1,2), std(err_1,[],2), mean(err_2,2), std(err_2,[],2),mean(err_3,2), std(err_3,[],2)] 
% to analysis the result (calc mean and std)

%% Load 
[pts_train, index_train, age_train, pts_test, index_test, age_test, pair_info_train, pair_info_test, age_diff_train, age_diff_test_1] = FGNET_Loader_vHbL_shape_only(1);
[pts_train, index_train, age_train, pts_test, index_test, age_test, pair_info_train, pair_info_test, age_diff_train, age_diff_test_2] = FGNET_Loader_vHbL_shape_only(2);
[pts_train, index_train, age_train, pts_test, index_test, age_test, pair_info_train, pair_info_test, age_diff_train, age_diff_test_3] = FGNET_Loader_vHbL_shape_only(3);

o1 = load('output/procrustes_fgnet_18_fold3/FGNET_procrustes_result_fold_1.mat');
o2 = load('output/procrustes_fgnet_18_fold3/FGNET_procrustes_result_fold_2.mat');
o3 = load('output/procrustes_fgnet_18_fold3/FGNET_procrustes_result_fold_3.mat');
res_baseline = [o1.res; o2.res; o3.res];
index_pair_test_baseline = [o1.index_pair_test; o2.index_pair_test; o3.index_pair_test];
age_diff_test_baseline = [age_diff_test_1; age_diff_test_2; age_diff_test_3];

err_1 = draw_line(age_diff_test_1, o1.res, o1.index_pair_test);
err_1 = cat(2, err_1, draw_line(age_diff_test_2, o2.res, o2.index_pair_test));
err_1 = cat(2, err_1, draw_line(age_diff_test_3, o3.res, o3.index_pair_test));

o1 = load('output/manifold_fgnet_18_fold3/FGNET_manifold_result_fold_1.mat');
o2 = load('output/manifold_fgnet_18_fold3/FGNET_manifold_result_fold_2.mat');
o3 = load('output/manifold_fgnet_18_fold3/FGNET_manifold_result_fold_3.mat');
res_manifold = [o1.res; o2.res; o3.res];
index_pair_test_manifold = [o1.index_pair_test; o2.index_pair_test; o3.index_pair_test];
age_diff_test_manifold = [age_diff_test_1; age_diff_test_2; age_diff_test_3];

err_2 = draw_line(age_diff_test_1, o1.res, o1.index_pair_test);
err_2 = cat(2, err_2, draw_line(age_diff_test_2, o2.res, o2.index_pair_test));
err_2 = cat(2, err_2, draw_line(age_diff_test_3, o3.res, o3.index_pair_test));

o1 = load('output/growth_manifold_fgnet_18_fold3/FGNET_manifold_result_fold_1.mat');
o2 = load('output/growth_manifold_fgnet_18_fold3/FGNET_manifold_result_fold_2.mat');
o3 = load('output/growth_manifold_fgnet_18_fold3/FGNET_manifold_result_fold_3.mat');
res_proposed = [o1.res; o2.res; o3.res];
index_pair_test_proposed = [o1.index_pair_test; o2.index_pair_test; o3.index_pair_test];
age_diff_test_proposed = [age_diff_test_1; age_diff_test_2; age_diff_test_3];

err_3 = draw_line(age_diff_test_1, o1.res, o1.index_pair_test);
err_3 = cat(2, err_3, draw_line(age_diff_test_2, o2.res, o2.index_pair_test));
err_3 = cat(2, err_3, draw_line(age_diff_test_3, o3.res, o3.index_pair_test));

%% Load LRPCA result
% age_diff_test_lrpca = [];
% res_lrpca = [];
% index_pair_test_lrpca = [];
% for fold = 1 : 3
%     sigset_file = '/home/taowu/work/aging_texture/code/ref/LRPCA/PythonFaceEvaluation2010.0/sigsets/FGNET_Adult_272_image_pairs_18_100_fold3_test_%d.xml';
%     mask_file = '/home/taowu/work/aging_texture/code/ref/LRPCA/PythonFaceEvaluation2010.0/sigsets/FGNET_Adult_272_image_pairs_18_100_fold3_test_%d_mask.mtx';
%     result_file = '/home/taowu/work/aging_texture/code/ref/LRPCA/PythonFaceEvaluation2010.0/matrices/lrpca_fgnet_%d.mtx';
%     
%     sigset_file = sprintf(sigset_file, fold);
%     mask_file = sprintf(mask_file, fold);
%     result_file = sprintf(result_file, fold);
%     
%     %% Load sigset
%     fid = fopen(sigset_file, 'r');
%     content = fscanf(fid, '%s');
%     fclose(fid);
%     pattern = '(?<=file-name=")[^"]*';
%     img_names = regexp(content, pattern, 'match');
%     
%     %% Load mask and result
%     len = length(img_names);
%     fid = fopen(mask_file, 'r');
%     fseek(fid, -len*len, 'eof');
%     mask = fread(fid, len*len, 'uint8');
%     fclose(fid);
%     mask = reshape(mask, [len, len]);
%     
%     fid = fopen(result_file);
%     fseek(fid, -len*len*4, 'eof');
%     result = fread(fid, len*len, 'single');
%     fclose(fid);
%     result = reshape(result, [len, len]);
%     
%     [x,y] = find(mask>0);
%     for i = 1 : length(x)
%         age1 = str2double(img_names{x(i)}(5:6));
%         age2 = str2double(img_names{y(i)}(5:6));
%         age_diff_test_lrpca = cat(1, age_diff_test_lrpca, abs(age1-age2));
%         res_lrpca = cat(1, res_lrpca, result(x(i), y(i)));
%         if mask(x(i), y(i)) == 255
%             index_pair_test_lrpca = cat(1, index_pair_test_lrpca, 1);
%         else
%             index_pair_test_lrpca = cat(1, index_pair_test_lrpca, -1);
%         end
%     end
% end

%% Draw
eer_manifold = draw_line(age_diff_test_manifold, res_manifold, index_pair_test_manifold);
eer_baseline = draw_line(age_diff_test_baseline, res_baseline, index_pair_test_baseline);
eer_proposed = draw_line(age_diff_test_proposed, res_proposed, index_pair_test_proposed);

x = [0.5 2.5 4.5 6.5 8.5 10.5];
plot(x, eer_proposed, 'or-', 'LineWidth', 2);
hold on
plot(x, eer_manifold, '+b-.', 'LineWidth', 2);
plot(x, eer_baseline, 'sm--', 'LineWidth', 2);
xlabel('Age gap');
ylabel('Equal error rate (EER)');
xlim([0, 12]);
ylim([0, 0.5]);
legend('Proposed', 'Manifold', 'Procrustes', 'Location', 'SouthEast');
% legend('Proposed', 'Baseline', 'LRPCA', 'Location', 'SouthEast');

function eer = draw_line(age_diff_test, res, index_pair_test);
% age_diff_test = age_diff_test_lrpca;
% res = res_lrpca;
% index_pair_test = index_pair_test_lrpca;

s = [0; 2; 4; 6; 8; 10];
e = [1; 3; 5; 7; 9; 11];

eer = zeros(length(s), 1);
for i = 1 : length(s)
    index = find(age_diff_test>=s(i) & age_diff_test<=e(i));
    fprintf('# of samples: %d\n', numel(index));
    rr = res(index);
    gt = index_pair_test(index);
    fprintf('# of positive: %d, # of negative: %d\n', sum(gt>0), sum(gt<0));
    if length(gt)>0
        [fpr, tpr, eer_] = roc_analysis(rr, gt);
        eer(i) = eer_;
    else
        eer(i) = eer(i-1);
    end
end

