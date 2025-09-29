set xrange [0:*]
unset border
set grid
set tics nomirror scale 0
set monochrome
set size square
set multiplot layout 2,3 title 'pizza\_3\_vars.txt'
set xlabel "Reservations" ; set ylabel "Pizzas"     ; plot "data/pizza_3_vars.txt" u 1:4 notitle
set xlabel "Temperature"  ; set ylabel "Pizzas"     ; plot "" u 2:4 notitle
set xlabel "Tourists"     ; set ylabel "Pizzas"     ; plot "" u 3:4 notitle
set xlabel "Reservations" ; set ylabel "Temperature"; plot "" u 1:2 notitle
set xlabel "Reservations" ; set ylabel "Tourists"   ; plot "" u 1:3 notitle
set xlabel "Temperature"  ; set ylabel "Tourists"   ; plot "" u 2:3 notitle
