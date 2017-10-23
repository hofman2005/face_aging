function growth_model = learn_growth_model(pts_train, index_train, age_train, age_start, age_end)

% %% Assumption !!
% %  Two eye are aligned to (-1,0) and (1,0)
% 
% %% Eye position
% eyes = [32, 37];

%% Model:
%   y2_i = betta_i * y1_i;
%   x2_i = gamma_i * y2_i - a;
%        = gamma_i * betta_i * y1_i - a;
%        = betta_i * (x1_i+a) - a;

%% Solve for gamma and a
A = zeros(size(pts_train,1) * size(pts_train,3), size(pts_train,1) + 1); 
A(:,end) = -ones(size(pts_train,1) * size(pts_train,3), 1);
b = zeros(size(pts_train,1) * size(pts_train,3), 1);

pos = 1;
for i = 1 : size(pts_train, 3)
    for j = 1 : size(pts_train, 1)
        A(pos, j) = pts_train(j, 1, i);
        b(pos) = pts_train(j, 2, i);
        pos = pos + 1;
    end
end

res = A\b;

gamma = res(1:end-1);
a = res(end);

%% Solve for betta
%  betta depends on age
% parameters
age1 = age_start;
age2 = age_end;

%% Different resolution for children and adults
% For children
% if age1 < 20
%     raw_index_age1 = find(age_train == age1);
% end
% if age2 < 20
%     raw_index_age2 = find(age_train == age2);
% end
if age1 < 20
    raw_index_age1 = find(abs(age_train - age1)<3);
end
if age2 < 20
    raw_index_age2 = find(abs(age_train - age2)<3);
end
% For adult
resolution = 10;
if age1 == 20
    raw_index_age1 = find(age_train >=18 & age_train <= age1);
elseif age1 > 20
    raw_index_age1 = find(age_train > age1-resolution & age_train <= age1);
end
if age2 == 20
    raw_index_age2 = find(age_train >=18 & age_train <= age2);
elseif age2 > 20
    raw_index_age2 = find(age_train > age2-resolution & age_train <= age2);
end

id_age1 = index_train(raw_index_age1);
id_age2 = index_train(raw_index_age2);
ids = intersect(id_age1, id_age2);

% Assume only one data for each person at each age. 
% TODO expand to multiple data for each person at each age.
% index_age1 = raw_index_age1(ismember(id_age1, ids));
% index_age2 = raw_index_age2(ismember(id_age2, ids));
% if length(index_age1) ~= length(index_age2)
%     error('Multiple data for each peron at each age. Not supported.');
% end
index_age1 = [];
index_age2 = [];
for i = 1 : length(id_age1)
    o = find(id_age2 == id_age1(i));
%     assert(length(o)<=1);
%     if ~isempty(o)
%         index_age1 = cat(1, index_age1, raw_index_age1(i));
%         index_age2 = cat(1, index_age2, raw_index_age2(o(1)));
%     end
    if ~isempty(o)
        index_age1 = cat(1, index_age1, raw_index_age1(i) * ones(size(o)));
        index_age2 = cat(1, index_age2, raw_index_age2(o));
    end
end

thres = 1;
if length(index_age1) < thres
%     warning('Too few training samples for growth model.');
    growth_model = -1;
    return;
end
% % Use both same person and different people pairs
% siz1 = length(raw_index_age1);
% siz2 = length(raw_index_age2);
% siz = min(siz1, siz2);
% index_age1 = raw_index_age1(1:siz);
% index_age2 = raw_index_age2(1:siz);

pts_1 = pts_train(:,:,index_age1);
pts_2 = pts_train(:,:,index_age2);

%% Review pts
% for i = 1 : size(pts_1, 3)
%     plot(pts_1(:,1,i), -pts_1(:,2,i), 'r-+');
%     hold on;
%     plot(pts_2(:,1,i), -pts_2(:,2,i), 'b-+');
%     hold off;
%     title( sprintf('%d of %d', i, size(pts_1,3)) );
%     pause;
% end

%%
betta = zeros(size(pts_1, 1), 1);
for i = 1 : size(pts_1, 1)
    A = [pts_1(i, 1, :); pts_1(i,2,:)+a];
    A = A(:);
    b = [pts_2(i, 1, :); pts_2(i,2,:)+a];
    b = b(:);
    betta(i) = A\b;
end

%% output
growth_model.betta = betta;
growth_model.gamma = gamma;
growth_model.a = a;
