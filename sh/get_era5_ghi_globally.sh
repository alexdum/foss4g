#!/bin/ksh -x
#SBATCH --qos=normal
#SBATCH --job-name=get_era5
#SBATCH --output=/home/ms/ro/roq/scripts/era5/logs/get_era5%N.%j.out
#SBATCH --error=/home/ms/ro/roq/scripts/era5/logs/get_era5%N.%j.out
#SBATCH --workdir=/scratch/ms/ro/roq/radiation
#SBATCH --time=23:30:00

export PATH=$PATH:.             
set -xv

cd $SCRATCH/radiation

f_marsReq=marsreq.tmp
f_logMars=marsreq.log


cat >${f_marsReq} <<EOF

retrieve,
class=ea,
date=2005-12-30/to/2016-01-01,
expver=1,
levtype=sfc,
param=169.128,
stream=oper,
time=06:00:00/18:00:00,
type=fc,
step=1/2/3/4/5/6/7/8/9/10/11/12,
grid=0.28125/0.28125,
target="ghi.grb"


EOF
#area N/W/S/E
#-- Perform MARS request in one go
export MARS_MULTITARGET_STRICT_FORMAT=1
mars < ${f_marsReq} > ${f_logMars}
