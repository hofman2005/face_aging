function result = MBGCvoteplain(gallery, index_gallery, DirName, mask, Dist_options)


DirPrefix='x:\mbgc\track_0915\';
 
thePath=[DirPrefix, DirName];
ImgNames=dir([thePath, '\','crop*.jpg']);
gndID=str2num(DirName(1:5));
for n=1:length(ImgNames)
    I=imread([thePath, '\', ImgNames(n).name]);
   
    probe(n,:)=reshape(I, 1, []);
end

probe=probe(:, mask);


probe=double(probe);

probe=probe-repmat(mean(probe,2), 1, size(probe,2));
probe=probe./repmat(std(probe, 0, 2), 1, size(probe, 2));




if Dist_options==0
   Dst=cos_dist(probe, gallery);
else
   Dst=euclidean(probe, gallery);
end


[Y, matchRank] = sort(Dst, 2, 'ascend');
matchRank_ID=index_gallery(matchRank);

normalizedY = Y./repmat(sum(Y,2), 1, size(Y,2));

[result.minDst, minDst_inx]=min(Y(:,1));
result.minDstID=matchRank_ID(minDst_inx, 1);

[result.minDstNorm, minDst_inx]=min(normalizedY(:,1));
result.minDstNormID=matchRank_ID(minDst_inx, 1);

result.minDstCorrect=(result.minDstID==gndID);
result.minDstNormCorrect=(result.minDstNormID==gndID);

result.vote=zeros(length(index_gallery), 1);



for i=1:length(index_gallery)
    result.vote(i)=sum(matchRank_ID(:,1)==index_gallery(i));
end
result.vote=result.vote/size(probe,1);
[result.voteMax, temp_inx]=max(result.vote);
result.voteCorrect=(index_gallery(temp_inx)==gndID);
result.gnd=gndID;

