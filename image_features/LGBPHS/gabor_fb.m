function gabor_kernel=gabor_fb(size)

sigma=2*pi;
fmax=pi/2;
%fmax=pi;
halfsize=floor(size/2);
[y,x]=meshgrid(-halfsize:halfsize, -halfsize:halfsize);
%[x,y]=meshgrid(-halfsize:halfsize, halfsize:-1:-halfsize);
tmp=x.*x+y.*y;
for v=0:4
 kv=fmax/(2^(0.5*v));
 tmp1=kv*kv/(sigma*sigma);
   for u=0:7
     phi=u*pi/8;
     
      gabor_kernel(:,:,v*8+u+1)=tmp1*exp(-0.5*tmp1*tmp).*(exp(i*(kv*cos(phi)*x+kv*sin(phi)*y))-exp(-0.5*sigma*sigma));
      %gabor_kernel(:,:,v*8+u+1)=(kernel-mean2(kernel))/std2(kernel);
   end
end

