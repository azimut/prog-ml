def average (xs: []f64) : f64 =
  f64.sum xs / f64.i64 (length xs)

def features : [30]f64 = [13.0, 2, 14, 23, 13, 1, 18, 10, 26, 3, 3, 21, 7, 22, 2, 27, 6, 10, 18, 15, 9, 26, 8, 15, 10, 21, 5, 6, 13, 13]
def pizzas : [30]f64 = [33.0, 16, 32, 51, 27, 16, 34, 17, 29, 15, 15, 32, 22, 37, 13, 44, 16, 21, 37, 30, 26, 34, 23, 39, 27, 37, 17, 18, 25, 23]

def predict [n] (feats: [n]f64) (weight: f64) (bias: f64) : [n]f64 =
  map (\x -> x * weight + bias) feats

def loss (feats: []f64) (truths: []f64) (weight: f64) (bias: f64) : f64 =
  predict feats weight bias
  |> map2 (-) truths
  |> map (** 2)
  |> average

def gradient [n] (feats: [n]f64) (truths: [n]f64) (weight: f64) (bias: f64) : (f64, f64) =
  let predictions = predict feats weight bias
  let predict_minus_truth = map2 (-) predictions truths
  let w_gradient = predict_minus_truth |> map2 (*) feats |> average |> (* 2)
  let b_gradient = predict_minus_truth |> average |> (* 2)
  in (w_gradient, b_gradient)

def train [n] (feats: [n]f64) (truths: [n]f64) (iters: i64) (lrate: f64) : (f64, f64) =
  loop (weight, bias) = (0.0, 0.0)
  for _i < iters do
    let (w_gradient, b_gradient) = gradient feats truths weight bias
    in ( weight - (w_gradient * lrate)
       , bias - (b_gradient * lrate)
       )

def main [n] (reservations: [n]f64) (pizzas: [n]f64) : (f64, f64) =
  train reservations pizzas 20000 0.001

-- End of chapter's code. Start of plotting code.

-- > train features pizzas 20000 0.001

def xys = (features, pizzas)

-- > :gnuplot { input=xys };
-- set title "03b.gradient\\_bias.fut"
-- weight = 1.0811301699901938; bias = 13.172267656369339;
-- unset border; set grid; set monochrome; set key bottom right;
-- set yrange [0:*]
-- set xlabel "reservations"; set ylabel "pizzas";
-- f(x) = weight * x + bias
-- plot input w p pt 3 title "", f(x) title sprintf("f(x) = %.3f * x + %.3f", weight, bias)

def linspace (n: i64) (start: f64) (end: f64) : [n]f64 =
  tabulate n (\i -> start + f64.i64 i * ((end - start) / f64.i64 n))

def wxs = linspace 200 (-1.0) 4.0
def wxys = (wxs, loop losses = [] for i < (length wxs) do (losses ++ [(loss features pizzas wxs[i] 0.0)]))

-- Losses (y-axis) over weights (x-axis). With 0 bias.

-- > :plot2d wxys

type measure = {current: f64, max: f64, min: f64}

def new_measure : measure = {current = 0.0, min = 1000000, max = -1000000}

def update_measure (new: f64) (measure: measure) : measure =
  let new_max = f64.max new measure.max
  let new_min = f64.min new measure.min
  in {current = new, max = new_max, min = new_min}

def train_history [n] (feats: [n]f64) (truths: [n]f64) (iters: i64) (lrate: f64) : [6]f64 =
  let (w, b) =
    loop (weight, bias) = (new_measure, new_measure)
    for _i < iters do
      let (w_gradient, b_gradient) = gradient feats truths weight.current bias.current
      let new_weight = weight.current - (w_gradient * lrate)
      let new_bias = bias.current - (b_gradient * lrate)
      in ( update_measure new_weight weight
         , update_measure new_bias bias
         )
  in [w.current, w.min, w.max, b.current, b.min, b.max]

-- NOTE: futhark-literate can't show records (?

-- > train_history features pizzas 10000 0.001

def history = train_history features pizzas 10000 0.001
def sxw = linspace 80 history[1] history[2]
def syb = linspace 80 history[4] history[5]
def szl = loop losses = [] for i < 80 do losses ++ [(loss features pizzas sxw[i] syb[i])]

def sxyz = (sxw, syb, szl)

-- > :gnuplot { sxyz=sxyz };
-- set terminal pngcairo size 720,720
-- set size square
-- set multiplot layout 2,2
-- set xlabel "Weight"; set ylabel "Bias"; set zlabel "Loss";
-- unset border
-- set grid
-- set hidden3d
-- set dgrid3d 20,20
-- set monochrome
-- set view 50,30   ,1.3,1.3; splot sxyz u 1:2:3 w l notitle
-- set view 50,130 ,1.3,1.3; splot sxyz u 1:2:3 w l notitle
-- set view 80,30   ,1.3,1.3; splot sxyz u 1:2:3 w l notitle
-- set view 100,130 ,1.3,1.3; splot sxyz u 1:2:3 w l notitle
