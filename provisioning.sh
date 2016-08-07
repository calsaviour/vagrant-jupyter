# Configure environment
export CONDA_DIR=/opt/conda
export PATH=$CONDA_DIR/bin:$PATH
export SHELL=/bin/bash
export DEBIAN_FRONTEND=noninteractive

# Install dependencies
apt-get update
apt-get install -yq --no-install-recommends \
git \
vim \
wget \
build-essential \
python-dev \


# Install conda
mkdir -p $CONDA_DIR
echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh
wget https://repo.continuum.io/miniconda/Miniconda3-3.9.1-Linux-x86_64.sh
chmod +x Miniconda3-3.9.1-Linux-x86_64.sh
/bin/bash Miniconda3-3.9.1-Linux-x86_64.sh -f -b -p $CONDA_DIR
rm Miniconda3-3.9.1-Linux-x86_64.sh
$CONDA_DIR/bin/conda install --yes conda==3.14.1

# Install Jupyter notebook
conda install --yes 'notebook=4.0*' terminado
conda clean -yt

#Create Jupyter working folders
mkdir /root/work
mkdir /root/.jupyter
mkdir /root/.local

# Install Python packages
conda install --yes 'ipython=4.0*' 'ipywidgets=4.0*' 'pandas=0.16*' 'matplotlib=1.4*' 'scipy=0.15*' 'seaborn=0.6*' 'scikit-learn=0.16*' 'ipython-sql=0.3.4' pyzmq
conda clean -yt

#Jupyter added in logon script rc.local (executed before login as root)
echo '#!/bin/sh -e' > /etc/rc.local
echo 'export CONDA_DIR=/opt/conda' >> /etc/rc.local
echo 'export PATH=$CONDA_DIR/bin:$PATH' >> /etc/rc.local
echo "jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --notebook-dir='/home/vagrant' & " >> /etc/rc.local
echo 'exit 0' >> /etc/rc.local

#bash script to start Jupyter (in case the logon script doesn't work)
cp /vagrant/startJupyter.sh /
