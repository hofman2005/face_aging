
function [RecogRateVote, RecogRateSim, RecogRateSimNorm, result]= MBGC_vote_HGPP_script(session, videos, mask_MBGC)

fb=gabor_fb(65);

for n=1:length(session)
    
 index_gallery(n)=str2num(session{n}(1:5));
 I=imread(['H:\Processed\frgcstyle_crop_portal\',session{n}]);

 I=double(I);
 
 I=(I-mean(I(mask_MBGC)))/(std(I(mask_MBGC)));
 I(~mask_MBGC)=0;
  I=imresize(I, [128, 128]);
 [GGPP_r, GGPP_i, LGPP_r, LGPP_i]=HGPP(I, fb);
 HGPP_gallery(:,:,n)=extractHGPP(GGPP_r, GGPP_i, LGPP_r, LGPP_i, 16, 16);

end



RecogRateVote=0;
RecogRateSim=0;
RecogRateSimNorm=0;


for n=1:length(videos)
    n
result(n) = MBGCvoteHGPP(fb, HGPP_gallery, index_gallery, videos{n}, mask_MBGC);
RecogRateVote=RecogRateVote+result(n).voteCorrect;
RecogRateSim=RecogRateSim+result(n).maxSimCorrect;
RecogRateSimNorm=RecogRateSimNorm+result(n).maxSimNormCorrect;

end


