
function [RecogRateVote, RecogRateDst, RecogRateDstNorm, result]= MBGC_vote_plain_script(session, videos, mask_MBGC, Dist_options)



for n=1:length(session)
    
 index_gallery(n)=str2num(session{n}(1:5));
 I=imread(['H:\Processed\frgcstyle_crop_portal\',session{n}]); 
 gallery(n, :)=reshape(I, 1, []);

end

 gallery=gallery(:, mask_MBGC);
 gallery=double(gallery);
 
gallery=gallery-repmat(mean(gallery,2), 1, size(gallery,2));
gallery=gallery./repmat(std(gallery, 0, 2), 1, size(gallery, 2));


RecogRateVote=0;
RecogRateDst=0;
RecogRateDstNorm=0;


for n=1:length(videos)
    n
result(n) = MBGCvoteplain(gallery, index_gallery, videos{n}, mask_MBGC, Dist_options);
RecogRateVote=RecogRateVote+result(n).voteCorrect;
RecogRateDst=RecogRateDst+result(n).minDstCorrect;
RecogRateDstNorm=RecogRateDstNorm+result(n).minDstNormCorrect;

end


