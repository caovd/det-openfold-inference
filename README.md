# det-openfold-inference
Run OpenFold inference on HPE Machine Learning Development Environment (aka MLDE)

Advantages of running training/inference processes on MLDE:

- **Simplified environment setting**: Set up a shell config file shell.yaml that provides a readily built docker image by Determined AI (aka MLDE) and available on DockerHub. These docker images are frequently released and users just need to pick and choose the right image which, in this example, requires CUDA 11 and Pytorch 1.12.

- **Containerised environment**: Process environment is isolated from the host OS, so users do have constraint with upgrading/downgrading packages

- **Automated GPU resource procurement** by defining slots number in a config file

- **Automated SSH** to the launched shell environment without the need to manually setup and manage credentials when connecting to a remote cluster

# References: 
1. [OpenFold github repo](https://github.com/aqlaboratory/openfold)
2. [How to start a shell in MLDE](https://hpe-mlde.determined.ai/latest/tools/cli/commands-and-shells.html#shells)

# Method
## Step 1: Launch a MDLE shell
### 1.1 Start a MLDE shell. 

```yaml
description: openfold-inference
environment:
  image: determinedai/environments:cuda-11.3-pytorch-1.12-gpu-mpi-0.26.4
  environment_variables:
    - NCCL_DEBUG=INFO
    # You may need to modify this to match your network configuration.
    #- NCCL_SOCKET_IFNAME=ens,eth,ib
resources:
  slots: 8
  resource_pool: A100
```

```bash
cd /PATH/TO/det-openfold-inference
det -m <MASTER_ADDRESS> shell start --config-file shell.yaml -c .
```
A shell UUID will be provided in the logs and later be used for remote SSH connection.

### 1.2 Open an existing MLDE shell 
```bash
det -m <MASTER_ADDRESS> shell open <SHELL_ID>
```

## Step 2: Setup environment 
```bash
apt-get update && apt-get install awscli aria2 rsync -y
bash scripts/install_third_party_dependencies.sh

mamba env create -n openfold_env -f environment.yml
conda activate openfold_env

exit
```
After reopenning the shell using the step 1.2

```bash
conda activate openfold_env

wget -q -P /openfold/resources \
    https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt

patch -p0 -d /opt/conda/lib/python3.9/site-packages/ < ./lib/openmm.patch

python3 setup.py install
```

Note: Step 2 will be simplified in future release.

## Step 3: Run inference
### 3.1 Create an inference.sh file

```bash
python3 run_pretrained_openfold.py \
    /PATH/TO/openfold/data/fasta_dir \
    /PATH/TO/openfold/data/pdb_mmcif/data/files \
    --uniref90_database_path /PATH/TO/openfold/data/uniref90/uniref90.fasta \
    --mgnify_database_path /PATH/TO/openfold/data/mgnify/mgy_clusters_2018_12.fa \
    --pdb70_database_path /PATH/TO/openfold/data/pdb70/pdb70 \
    --uniclust30_database_path /PATH/TO/openfold/data/uniclust30/uniclust30_2018_08 \
    --output_dir /PATH/TO/openfold/outputs \
    --bfd_database_path /PATH/TO/openfold/data/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt \
    --model_device "cuda:0" \
    --jackhmmer_binary_path lib/conda/envs/openfold_venv/bin/jackhmmer \
    --hhblits_binary_path lib/conda/envs/openfold_venv/bin/hhblits \
    --hhsearch_binary_path lib/conda/envs/openfold_venv/bin/hhsearch \
    --kalign_binary_path lib/conda/envs/openfold_venv/bin/kalign \
    --config_preset "model_1_ptm" \
    --openfold_checkpoint_path openfold/resources/openfold_params/finetuning_ptm_2.pt
```
### 3.2 Run inference
```shell
bash inference.sh
```

## Notes: 
### Input processing
Run the following command for chunking a large input fasta file that contains multiple inputs with different # of residues into individual fasta files.
```shell
python3 /output/fasta_process.py 
```

## Results on 01 Nvidia A100 80GB GPU, without CPU offloading and DeepSpeed
To be updated 

