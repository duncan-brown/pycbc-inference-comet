export OMP_NUM_THREADS=1
export LD_LIBRARY_PATH=/opt/mvapich2-2.1/lib
export PATH=${PATH}:/opt/mvapich2-2.1/bin

/srv/mpi-demo.py
