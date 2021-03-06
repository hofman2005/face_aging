function HGPP=extractHGPP(GGPP_r, GGPP_i, LGPP_r, LGPP_i, regionsize, nbin)

I=cat(3, GGPP_r, GGPP_i, LGPP_r, LGPP_i);

nrow=size(I, 1);
ncol=size(I, 2);
nFrame=size(I, 3);

rowstart=1:regionsize:nrow;
colstart=1:regionsize:ncol;

if mod(nrow, regionsize)~=0
   rowstart(end)=nrow-regionsize+1; 
end
if mod(ncol, regionsize)~=0;
    colstart(end)=ncol-regionsize+1;
end

nblk=length(rowstart)*length(colstart);
HGPP=zeros(nFrame, nbin*nblk);
histrow=zeros(nblk, nbin);
for m=1:nFrame
    
    for n=1:length(rowstart)
        for k=1:length(colstart)
            block=reshape(I(rowstart(n):rowstart(n)+regionsize-1,colstart(k):colstart(k)+regionsize-1,m), [], 1);
            histrow((n-1)*length(colstart)+k,:)=hist(double(block), nbin);             
        end
    end
    HGPP(m,:)=reshape(histrow', 1, []);
end
