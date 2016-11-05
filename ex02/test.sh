#!/usr/bin/env bash
#SBATCH -J gpucomp_ex
#SBATCH -p hpc
#SBATCH --nodes=1
#SBATCH --gres=gpu
#SBATCH --time=00:30:00
#SBATCH --output=test.out

module load cuda/7.0

./nullKernelAsync
./nullKernelSync
./nullKernelMultiThreads
./nullKernelAsyncWait
./cudaMemcpyTest

exit
