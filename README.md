# Files for running PyCBC Inference on Comet

This repository contains the files necessary for running [PyCBC Inference](https://iopscience.iop.org/article/10.1088/1538-3873/aaef0b/meta) on the SDSC Comet supercomputer using [Singularity](http://singularity.lbl.gov/) to provide the compute environment.

The [Dockerfile](https://github.com/duncan-brown/pycbc-inference-comet/blob/master/Dockerfile) sets up an environment with PyCBC installed. mpi4py is built to use the mvapich2 2.1 installed on Comet.

The `mpi-demo-*` files run a test MPI job using [schwimmbad](https://schwimmbad.readthedocs.io/en/latest/index.html). 
It can be run with `qsub mpi-demo-sub.sh`. 

The `pycbc-inference-*` files run `pycbc_inference` using the [inference_chi_0.4.ini](https://github.com/duncan-brown/pycbc-inference-comet/blob/master/inference_chi_0.4.ini)
The frame files needed by this job can be are available at [LIGO-P1700349](https://dcc.ligo.org/P1700349/public)

Note that `/home/dabrown/pycbc_test` needs to be changed to the directory that you are using.
