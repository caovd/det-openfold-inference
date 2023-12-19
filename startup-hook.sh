apt-get update && apt-get install awscli aria2 rsync -y
bash scripts/install_third_party_dependencies.sh

# installing into the base environment since the docker container wont do anything other than run openfold
mamba env create -n openfold_env -f environment.yml
conda activate openfold_env

wget -q -P /openfold/resources \
    https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt

patch -p0 -d /opt/conda/lib/python3.9/site-packages/ < ./lib/openmm.patch

python3 setup.py install

# cp openfold /opt/openfold/openfold
# cp scripts /opt/openfold/scripts
# cp run_pretrained_openfold.py /opt/openfold/run_pretrained_openfold.py
# cp train_openfold.py /opt/openfold/train_openfold.py
# cp setup.py /opt/openfold/setup.py
# cp lib/openmm.patch /opt/openfold/lib/openmm.patch
# wget -q -P /opt/openfold/openfold/resources \
#     https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt
# patch -p0 -d /opt/conda/lib/python3.9/site-packages/ < /opt/openfold/lib/openmm.patch
# cd /opt/openfold
# python3 setup.py install