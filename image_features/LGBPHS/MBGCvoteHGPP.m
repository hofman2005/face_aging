function result = MBGCvoteHGPP(fb, HGPP_gallery, index_gallery, DirName, mask)


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


[imgheight, imgwidth]=size(I);
for n=1:length(ImgNames)
    I=zeros(imgheight, imgwidth);
    I(mask)=probe(n,:);
    I=imresize(I, [128, 128]);
    [GGPP_r, GGPP_i, LGPP_r, LGPP_i]=HGPP(I, fb);
    HGPP_probe=extractHGPP(GGPP_r, GGPP_i, LGPP_r, LGPP_i, 16, 16);
    for m=1:length(index_gallery)        
       Sims(n,m)=compareHGPP(HGPP_probe, HGPP_gallery(:,:,m));
    end
end    
    
[Y, matchRank] = sort(Sims, 2, 'descend');
matchRank_ID=index_gallery(matchRank);

normalizedY = Y./repmat(sum(Y,2), 1, size(Y,2));

[result.maxSim, maxSim_inx]=max(Y(:,1));
result.maxSimID=matchRank_ID(maxSim_inx, 1);

[result.maxSimNorm, maxSim_inx]=max(normalizedY(:,1));
result.maxSimNormID=matchRank_ID(maxSim_inx, 1);

result.maxSimCorrect=(result.maxSimID==gndID);
result.maxSimNormCorrect=(result.maxSimNormID==gndID);

result.vote=zeros(length(index_gallery), 1);



for n=1:length(index_gallery)
    result.vote(n)=sum(matchRank_ID(:,1)==index_gallery(n));
end
result.vote=result.vote/size(probe,1);
[result.voteMax, temp_inx]=max(result.vote);
result.voteCorrect=(index_gallery(temp_inx)==gndID);
result.gnd=gndID;
