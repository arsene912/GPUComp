#include <stdio.h>
#include "chTimer.h"

int main(int argc, char *argv[]) {
    int *dmem, *hpage, *hpin;
    int size = 1024;   // 1kB
    chTimerTimestamp start, stop;
    double microseconds;
    
    for (int i=0; i<21; i++) {
        cudaMalloc((void**)&dmem, size);   // menory on device
        hpage = (int*) malloc(size);   // pageable memory on host
        cudaMallocHost((void**)&hpin, size);   // pinned memory on host
        
        chTimerGetTime( &start );
        cudaMemcpy( dmem, hpage, size, cudaMemcpyHostToDevice );
        chTimerGetTime( &stop );
        microseconds = 1e6*chTimerElapsedTime( &start, &stop );
        printf("%d kB; H2D; pageable; %.2f us\n", size/1024, microseconds); fflush(stdout);
        
        chTimerGetTime( &start );
        cudaMemcpy( dmem, hpin, size, cudaMemcpyHostToDevice );
        chTimerGetTime( &stop );
        microseconds = 1e6*chTimerElapsedTime( &start, &stop );
        printf("%d kB; H2D; pinned; %.2f us\n", size/1024, microseconds); fflush(stdout);
        
        chTimerGetTime( &start );
        cudaMemcpy( hpage, dmem, size, cudaMemcpyDeviceToHost );
        chTimerGetTime( &stop );
        microseconds = 1e6*chTimerElapsedTime( &start, &stop );
        printf("%d kB; D2H; peagable; %.2f us\n", size/1024, microseconds); fflush(stdout);
        
        chTimerGetTime( &start );
        cudaMemcpy( hpin, dmem, size, cudaMemcpyDeviceToHost );
        chTimerGetTime( &stop );
        microseconds = 1e6*chTimerElapsedTime( &start, &stop );
        printf("%d kB; D2H; pinned; %.2f us\n", size/1024, microseconds); fflush(stdout);
        
        cudaFree(dmem); free(hpage); cudaFreeHost(hpin);
        size = size*2;   // double the size
    }
}