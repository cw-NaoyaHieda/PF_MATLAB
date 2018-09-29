reset
set datafile separator ','
set grid lc rgb 'white' lt 2
set border lc rgb 'white'
set border lc rgb 'white'
set cblabel 'Weight' tc rgb 'white' font ', 30'
set palette rgbformulae 22, 13, -31
set obj rect behind from screen 0, screen 0 to screen 1, screen 1
set object 1 rect fc rgb '#333333 ' fillstyle solid 1.0
set key textcolor rgb 'white'
set size ratio 1/3
plot 'plot_particle.csv' using 1:3:5:4 with circles notitle fs transparent solid 0.65 lw 2.0 pal
set datafile separator ','
replot 'plot_filter_mean.csv' using 1:2 with lines linetype 1 lw 2.0 linecolor rgb '#ffff00 ' title 'Filter'
set datafile separator ','
replot 'plot_smoothing_mean.csv' using 1:2 with lines linetype 3 lw 2.0 linecolor rgb 'white ' title 'Smoother'
set datafile separator ','
replot 'DR_plot.csv' using 1:2 with lines linetype 3 lw 2.0 linecolor rgb 'blue ' title 'DR'
set datafile separator ','
replot 'X_plot.csv' using 1:2 with lines linetype 3 lw 2.0 linecolor rgb 'red ' title 'Answer'
