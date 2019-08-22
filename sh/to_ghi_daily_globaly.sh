#!/bin/ksh -x
#SBATCH --qos=normal
#SBATCH --job-name=ghi_daily
#SBATCH --output=/home/ms/ro/roq/scripts/era5/logs/to_ghi_daily%N.%j.out
#SBATCH --error=/home/ms/ro/roq/scripts/era5/logs/to_ghi_daily%N.%j.out
#SBATCH --workdir=/scratch/ms/ro/roq/radiation
#SBATCH --time=23:30:00

export PATH=$PATH:.             
set -xv

cd $SCRATCH/radiation

module load cdo
cdo setgridtype,regular ghi.grb  output_ghi.grb
cdo -f nc -t ecmwf setgridtype,regular output_ghi.grb output_ghi.nc
rm output_ghi.grb
cdo shifttime,-1hour output_ghi.nc ghi_shift1h.nc
rm output_ghi.nc
cdo daymean ghi_shift1h.nc ghi_daily.nc
rm ghi_shift1h.nc
