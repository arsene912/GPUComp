/*
 *
 * Modified from nullKernelAsync.cu
 *
 * Microbenchmark for throughput of asynchronous kernel launch.
 *
 * Build with: nvcc -I ../chLib <options> nullKernelAsync.cu
 * Requires: No minimum SM requirement.
 *
 * Copyright (c) 2011-2012, Archaea Software, LLC.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions 
 * are met: 
 *
 * 1. Redistributions of source code must retain the above copyright 
 *    notice, this list of conditions and the following disclaimer. 
 * 2. Redistributions in binary form must reproduce the above copyright 
 *    notice, this list of conditions and the following disclaimer in 
 *    the documentation and/or other materials provided with the 
 *    distribution. 
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS 
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
 * BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT 
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
 * ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 * POSSIBILITY OF SUCH DAMAGE.
 *
 */

#include <stdio.h>

#include "chTimer.h"

__global__
void
NullKernel()
{
}

int
main( int argc, char *argv[] )
{
	const int cIterations = 1000000;
    double microseconds, usPerLaunch;

    chTimerTimestamp start, stop;
    
    printf( "Asynchronous kernel statup:\n" ); fflush(stdout);
    for ( int n = 1; n < 1025; n = n*2 ) {
        chTimerGetTime( &start );
        for ( int i = 0; i < cIterations; i++ ) {
            NullKernel<<<1,n>>>();
        }
        cudaThreadSynchronize();
        chTimerGetTime( &stop );

        microseconds = 1e6*chTimerElapsedTime( &start, &stop );
        usPerLaunch = microseconds / (float) cIterations;

        printf( "%d threads; %.2f us\n", n, usPerLaunch ); fflush(stdout);
    }
    
    printf( "Synchronous kernel startup:\n" ); fflush(stdout);
    for ( int n = 1; n < 1025; n = n*2 ) {
        chTimerGetTime( &start );
        for ( int i = 0; i < cIterations; i++ ) {
            NullKernel<<<1,n>>>();
            cudaThreadSynchronize();
        }
        chTimerGetTime( &stop );

        microseconds = 1e6*chTimerElapsedTime( &start, &stop );
        usPerLaunch = microseconds / (float) cIterations;

        printf( "%d threads; %.2f us\n", n, usPerLaunch ); fflush(stdout);
    }

    return 0;
}
