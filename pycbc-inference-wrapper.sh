#!/bin/bash -v

pycbc_config_file=/srv/inference_chi_0.4.ini
pycbc_output_file=/srv/inference_chi_04.hdf

echo "Using ${pycbc_config_file} as configuration file"
echo "Writing output to ${pycbc_output_file}"

pycbc_seed=11185

export PYTHON_EGG_CACHE=$( mktemp -d )
echo $PYTHON_EGG_CACHE

XDG_CACHE_HOME=/srv/$(mktemp -p . -d)/xdg-cache
export XDG_CACHE_HOME
mkdir -p ${XDG_CACHE_HOME}/astropy
tar -C ${XDG_CACHE_HOME}/astropy -zxvf /srv/astropy.tar.gz &>/dev/null
echo "XDG_CACHE_HOME set to ${XDG_CACHE_HOME} which contains" `ls ${XDG_CACHE_HOME}`

astropy_cache=`python -c 'import astropy; print astropy.config.get_cache_dir()'`
echo "Astropy is using ${astropy_cache} which contains" `ls ${astropy_cache}`

echo "Fixing astropy cache to use condor cached data for timing"
python -c 'import os; import shelve; import astropy.utils.data ; datadir, shelveloc = astropy.utils.data._get_download_cache_locs(); db = shelve.open(shelveloc); hashname = os.path.basename(db["http://maia.usno.navy.mil/ser7/finals2000A.all"]); db["http://maia.usno.navy.mil/ser7/finals2000A.all"] = os.path.join(datadir,hashname); db.close()'

export OMP_NUM_THREADS=1
export LD_LIBRARY_PATH=/opt/mvapich2-2.1/lib
export PATH=${PATH}:/opt/mvapich2-2.1/bin

pycbc_inference --verbose \
    --use-mpi \
    --seed ${pycbc_seed} \
    --instruments H1 L1 V1 \
    --gps-start-time 1187008691 \
    --gps-end-time 1187008891 \
    --frame-files H1:/srv/H-H1_LOSC_CLN_16_V1-1187007040-2048.gwf L1:/srv/L-L1_LOSC_CLN_16_V1-1187007040-2048.gwf V1:/srv/V-V1_LOSC_CLN_16_V1-1187007040-2048.gwf \
    --channel-name H1:LOSC-STRAIN L1:LOSC-STRAIN V1:LOSC-STRAIN \
    --strain-high-pass 15 \
    --pad-data 8 \
    --psd-start-time 1187007048 \
    --psd-end-time 1187008680 \
    --psd-estimation mean \
    --psd-segment-length 16 \
    --psd-segment-stride 8 \
    --psd-inverse-length 8 \
    --sample-rate 4096 \
    --data-conditioning-low-freq 20 \
    --config-file ${pycbc_config_file} \
    --output-file ${pycbc_output_file} \
    --processing-scheme cpu \
    --nprocesses 48
