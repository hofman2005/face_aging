#include "mex.h"


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]){

 if(nrhs != 1)
        mexErrMsgTxt("Check number of input parameters ");
 if(nlhs != 1)
        mexErrMsgTxt("Check number of output parameters");

 int nrow=(int)mxGetM(prhs[0]);
 int ncol=(int)mxGetN(prhs[0]);
 unsigned char *ptr = (unsigned char *)mxGetPr(prhs[0]);

 mwSize DstDim[2]={(mwSize)(nrow-2), (mwSize)(ncol-2)};
 plhs[0] = mxCreateNumericArray(2, DstDim, mxUINT8_CLASS, mxREAL);

unsigned char * output=(unsigned char *)mxGetPr(plhs[0]);

int i,j;
unsigned char center, surround;
 for(i=1;i<nrow-1;i++)
 {
	 for(j=1;j<ncol-1;j++)
	 {
		 center=ptr[j*nrow+i]*(128+64+32+16+8+4+2+1);
         surround=ptr[(j-1)*nrow+(i-1)]*128+ptr[j*nrow+(i-1)]*64+ptr[(j+1)*nrow+(i-1)]*32+ptr[(j+1)*nrow+i]*16+ptr[(j+1)*nrow+i+1]*8+ptr[j*nrow+i+1]*4+ptr[(j-1)*nrow+i+1]*2+ptr[(j-1)*nrow+i];
         output[(j-1)*(nrow-2)+i-1]=center^surround;
	 }
 }
}