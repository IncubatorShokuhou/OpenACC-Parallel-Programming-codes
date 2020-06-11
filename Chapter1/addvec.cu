#include<stdio.h>
#define N 64

__global__ void add( int *a_d, int *b_d, int *c_d ) {
    int tid = blockIdx.x * blockDim.x + threadIdx.x;
    if (tid < N) c_d[tid] = a_d[tid] + b_d[tid];
}
int main() 
{
    int a[N], b[N], c[N];
    int *a_d, *b_d, *c_d;
    cudaMalloc((void**)&a_d, N * sizeof(int));
    cudaMalloc((void**)&b_d, N * sizeof(int));
    cudaMalloc((void**)&c_d, N * sizeof(int));
    for(int i = 0; i < N; i++)
    {
        a[i] = 1;
        b[i] = 2;
    }
    cudaMemcpy(a_d, a, N*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(b_d, b, N*sizeof(int), cudaMemcpyHostToDevice);
    dim3 block(32,1,1), grid;
    grid.x = (N+block.x-1)/block.x;
    add<<<grid, block>>>(a_d, b_d, c_d);
    cudaMemcpy(c,c_d,N*sizeof(int), cudaMemcpyDeviceToHost);

    for(int i=0; i<N; i++)
        printf("%2d +%2d =%2d\n",a[i],b[i],c[i]);
    cudaFree(a_d);
    cudaFree(b_d);
    cudaFree(c_d);
return 0;
}