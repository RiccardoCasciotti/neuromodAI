#!/bin/bash
#SBATCH --gres=gpu:1
#SBATCH --nodes=1                    # 1 node
#SBATCH --ntasks-per-node=1         # 32 tasks per node
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00               # time limits: 1/2 hour
#SBATCH --error=IMG_C100/job.err            # standard error file
#SBATCH --output=IMG_C100/job.out           # standard output file
#SBATCH --account=IscrC_CATASTRO     # account name
module load profile/deeplrn
module av cineca-ai
module load anaconda3

cd $WORK/rcasciot/neuromodAI/SoftHebb-main
rm -rf -d Training/results/hebb/result/network/ImageNette_CIFAR100_CL
cp -r Training/results/hebb/result/network/ImageNette_Best Training/results/hebb/result/network/ImageNette_CIFAR100_CL
rm -rf -d Training/results/hebb/result/network/ImageNette_CIFAR100_CL/models
mkdir Training/results/hebb/result/network/ImageNette_CIFAR100_CL/models
cp Training/results/hebb/result/network/ImageNette_CIFAR100_CL/checkpoint.pth.tar Training/results/hebb/result/network/ImageNette_CIFAR100_CL/models/checkpoint.pth.tar
conda run -n softhebb python continual_learning.py --preset 6SoftHebbCnnImNet --resume all --model-name 'ImageNette_CIFAR100_CL' --dataset-unsup-1 ImageNette_1 --dataset-sup-1 ImageNette_200aug --dataset-unsup-2 CIFAR100_1 --dataset-sup-2 CIFAR100_50 --continual_learning True --skip-1 True --evaluate True
