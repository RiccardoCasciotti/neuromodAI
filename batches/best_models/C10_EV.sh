#!/bin/bash
#SBATCH --partition=boost_usr_prod

#SBATCH --account=IscrC_CATASTRO     # account name
#SBATCH --gres=gpu:1
#SBATCH --nodes=1                    # 1 node
#SBATCH --ntasks-per-node=1         # 32 tasks per node
#SBATCH --cpus-per-task=4
#SBATCH --time=20:30:00               # time limits: 1/2 hour
#SBATCH --error=C10_EV/job.err            # standard error file
#SBATCH --output=C10_EV/job.out         # standard output file
#--resume all         
#SBATCH --mail-type=END
#SBATCH --mail-user=riccardo.casciotti@mail.polimi.it

module load profile/deeplrn
module av cineca-ai
module load anaconda3

cd $WORK/rcasciot/neuromodAI/SoftHebb-main
cp -r Training/results/hebb/result/network/CIFAR10_Best Training/results/hebb/result/network/C10_EV
rm -rf -d Training/results/hebb/result/network/C10_EV/models
mkdir Training/results/hebb/result/network/C10_EV/models
cp Training/results/hebb/result/network/C10_EV/checkpoint.pth.tar Training/results/hebb/result/network/C10_EV/models/checkpoint.pth.tar
conda run -n softhebb python multi_layer.py --preset 4SoftHebbCnnCIFAR  --model-name 'C10_EV' --dataset-unsup CIFAR10_1 --dataset-sup CIFAR10_1 --evaluate False 
