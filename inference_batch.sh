#!/usr/bin/bash                                                         
for sub_fasta_dir in 10 20 40
do 
    python3 run_pretrained_openfold.py \
        /nvmefs1/daniel.cao/openfold/data/fasta_dir/$sub_fasta_dir \
        /nvmefs1/daniel.cao/openfold/data/pdb_mmcif/data/files \
        --uniref90_database_path /nvmefs1/daniel.cao/openfold/data/uniref90/uniref90.fasta \
        --mgnify_database_path /nvmefs1/daniel.cao/openfold/data/mgnify/mgy_clusters_2018_12.fa \
        --pdb70_database_path /nvmefs1/daniel.cao/openfold/data/pdb70/pdb70 \
        --uniclust30_database_path /nvmefs1/daniel.cao/openfold/data/uniclust30/uniclust30_2018_08 \
        --output_dir /nvmefs1/daniel.cao/openfold/output \
        --bfd_database_path /nvmefs1/daniel.cao/openfold/data/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt \
        --model_device "cuda:0" \
        --jackhmmer_binary_path lib/conda/envs/openfold_venv/bin/jackhmmer \
        --hhblits_binary_path lib/conda/envs/openfold_venv/bin/hhblits \
        --hhsearch_binary_path lib/conda/envs/openfold_venv/bin/hhsearch \
        --kalign_binary_path lib/conda/envs/openfold_venv/bin/kalign \
        --config_preset "model_1_ptm" \
        --openfold_checkpoint_path openfold/resources/openfold_params/finetuning_ptm_2.pt
done