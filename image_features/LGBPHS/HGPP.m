function [GGPP_r, GGPP_i, LGPP_r, LGPP_i]=HGPP(I, fb)

I=double(I);
num_kernels=size(fb, 3);
gb_result=zeros([size(I), num_kernels]);
for n=1:num_kernels
    gb_result(:,:,n)=conv2(I, fb(:,:,n), 'same');
end

%gb_mag=abs(gb_result);
gb_real=real(gb_result);
gb_img=imag(gb_result);

gb_phase_r=zeros(size(gb_real));
gb_phase_i=zeros(size(gb_img));

gb_phase_r(gb_real>0)=0;
gb_phase_r(gb_real<=0)=1;
gb_phase_i(gb_img>0)=0;
gb_phase_i(gb_img<=0)=1;

GGPP_r=zeros(size(I,1), size(I,2), 5);
GGPP_i=zeros(size(I,1), size(I,2), 5);

gb_phase_r_expand=zeros(size(gb_phase_r,1)+2, size(gb_phase_r,2)+2, size(gb_phase_r, 3));
gb_phase_i_expand=zeros(size(gb_phase_r,1)+2, size(gb_phase_r,2)+2, size(gb_phase_r, 3));

gb_phase_r_expand(2:end-1,2:end-1,:)=gb_phase_r;
gb_phase_i_expand(2:end-1,2:end-1,:)=gb_phase_i;


for v=1:5
    for u=1:8
    GGPP_r(:,:,v)=GGPP_r(:,:,v)+gb_phase_r(:,:,(v-1)*8+u)*2^(8-u);
    GGPP_i(:,:,v)=GGPP_i(:,:,v)+gb_phase_i(:,:,(v-1)*8+u)*2^(8-u);
    LGPP_r(:,:,(v-1)*8+u)=blkxor(uint8(gb_phase_r_expand(:,:,(v-1)*8+u)));
    LGPP_i(:,:,(v-1)*8+u)=blkxor(uint8(gb_phase_i_expand(:,:,(v-1)*8+u)));
    end
end

