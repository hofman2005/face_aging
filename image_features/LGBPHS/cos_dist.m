function distance_matrix=cos_dist(probe_mat, gallery_mat)

[row1,col1]=size(probe_mat);
[row2,col2]=size(gallery_mat);
for i=1:row1
    for j=1:row2
     distance_matrix(i,j)=acos((probe_mat(i,:)*gallery_mat(j,:)')/(norm(probe_mat(i,:)*norm(gallery_mat(j,:)))));
    end
end