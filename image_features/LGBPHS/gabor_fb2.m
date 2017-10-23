 
function gabor_kernel=gabor_fb2(fullsize)
  
    
    
    halfsize=floor(fullsize/2);

    [x,y]=meshgrid(-halfsize:halfsize, -halfsize:halfsize);   
 
    WiskottDCFree = 0.0;
    phi=0.0;
    gabor_kernel = ones(size(x, 1),size(x, 2),40);   
      
for u=0:7
         theta=u*pi/8;
         xp =  x*cos(theta)+y*sin(theta);
         yp = -x*sin(theta)+y*cos(theta);
         
     for v=0:4
         lambda=4*2^(0.5*v);
         sigma=lambda;
         tmp1 = -(xp.*xp+yp.*yp)/(2*sigma*sigma); 
         tmp2 = (2*pi*xp/sigma)+phi; 
         kernel = exp(tmp1).*(cos(tmp2)-(phi == 0.0)*(WiskottDCFree)*exp(-sigma*sigma*0.5));      
         gabor_kernel(:,:,v*8+u+1)=(kernel-mean2(kernel))/std2(kernel);
   end
end
    

