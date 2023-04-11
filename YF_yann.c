/* Version moderne : reprojection et précalcul*/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include "mex.h"
#define  max(a,b)  (a>b?a:b)
#define  min(a,b) (a<b?a:b)



void iinitialise(int* X,int dim)
{
  int i;
  for(i =0; i<dim;i++)
    {
      X[i] = 0;
    }
}

void dinitialise(double* X,int dim)
{
  int i;
  for(i =0; i<dim;i++)
    {
      X[i] = 0;
    }
}


void correction(double* input, double* first_step, double* output, int x_lim, int y_lim, int search_radius,  double threshold)
{
  int p,q,i,j,pos1,pos2;
  int* normalisation_matrix;
  int size = x_lim*y_lim;
  int search_heigth= x_lim*search_radius;
  normalisation_matrix = malloc(size*sizeof(int));
  iinitialise(normalisation_matrix,size);
  dinitialise(output,size);
  for(q = -search_heigth; q <=0; q+=x_lim)
    {
      for(p = -search_radius; p <= search_radius; p++)
	{
	  for( j = -q; j < size;j+=x_lim)
	    {
	      for( i=max(0,-p); i<min(x_lim-p,x_lim); i++)
		{
		  pos1=i+j;
		  pos2=pos1+p+q;
		  if (abs(first_step[pos1]-first_step[pos2]) < threshold)
		    {
		      
		      output[pos1]+=input[pos2];
		      normalisation_matrix[pos1]++;
		      if(q!=0)
			{
			  output[pos2]+=input[pos1];
			  normalisation_matrix[pos2]++;
			}
		    }
		}
	    }
	}
    }
  for( i=0; i< size;i++)
    {
      output[i]= output[i]/normalisation_matrix[i]; 
    }
}

   


/*The function to interface with Mathlab*/
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{

    double *entree_av;
    double *entree_ress;
    double *sortie;
    double *matrice_normalisation;
    int r1, x_lim,y_lim, w;
    double   seuil;
    entree_av =(double*)mxGetPr(prhs[0]);
    entree_ress=(double*)mxGetPr(prhs[1]);
    r1 = mxGetScalar(prhs[2]);
    seuil = mxGetScalar(prhs[3]);

    x_lim = mxGetM(prhs[0]);
    y_lim = mxGetN(prhs[0]);



    plhs[0] = mxCreateNumericMatrix(x_lim, y_lim, mxDOUBLE_CLASS, mxREAL);
    sortie = (double*) mxGetData(plhs[0]);

    plhs[1] = mxCreateNumericMatrix(x_lim, y_lim, mxDOUBLE_CLASS, mxREAL);
    matrice_normalisation = (double*) mxGetData(plhs[1]);

    correction(entree_av,entree_ress,sortie, x_lim, y_lim, r1, seuil);   
}

