#!/bin/sh

cp ../result/total.d src/
cp ../result/vel.d src/
cp ../result/theta0.d src/

cd src/

./space.sh

cd ../

gnuplot -persist 1d_num.plt
gnuplot -persist 1d_vel.plt
gnuplot -persist 1d_mass.plt
gnuplot -persist rho.plt
#gnuplot -persist temp.plt
#gnuplot -persist heat.plt
#gnuplot -persist vel.plt
#gnuplot -persist rvel.plt
#gnuplot -persist tvel.plt

