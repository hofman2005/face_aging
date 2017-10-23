% function show_growth(database)

% Load database by: 
% load ~/work/aging_shape/ref/FGNET_Database.mat

id = 1;
index = find(database.id==id);
age = database.age(index);
[age,I] = sort(age);
index = index(I);

o = database.pts(index);
shape = zeros(68, 2, length(index));
for i = 1 : length(index)
    shape(:,1,i) = o{i}.x;
    shape(:,2,i) = o{i}.y;
end
normalized_shape = normalize_shape(shape);

for i = 1 : length(index)
    plot(shiftdim(normalized_shape(:,1,i),2), shiftdim(-normalized_shape(:,2,i),2), '-+');
    hold on;
    title(age(i));
%     pause;
end