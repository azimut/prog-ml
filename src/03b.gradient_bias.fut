def average (xs: []f64) : f64 =
  f64.sum xs / f64.i64 (length xs)

def features : [30]f64 = [13.0, 2, 14, 23, 13, 1, 18, 10, 26, 3, 3, 21, 7, 22, 2, 27, 6, 10, 18, 15, 9, 26, 8, 15, 10, 21, 5, 6, 13, 13]
def pizzas : [30]f64 = [33.0, 16, 32, 51, 27, 16, 34, 17, 29, 15, 15, 32, 22, 37, 13, 44, 16, 21, 37, 30, 26, 34, 23, 39, 27, 37, 17, 18, 25, 23]

def predict [n] (feats: [n]f64) (weight: f64) (bias: f64) : [n]f64 =
  map (\x -> x * weight + bias) feats

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

def loss (feats: []f64) (truths: []f64) (weight: f64) (bias: f64) : f64 =
  predict feats weight bias
  |> map2 (-) truths
  |> map (** 2)
  |> average

def linspace (n: i64) (start: f64) (end: f64) : [n]f64 =
  tabulate n (\i -> start + f64.i64 i * ((end - start) / f64.i64 n))

def wxs = linspace 200 (-1.0) 4.0
def wxys = (wxs, loop losses = [] for i < (length wxs) do (losses ++ [(loss features pizzas wxs[i] 0.0)]))

-- Losses (y-axis) over weights (x-axis). With 0 bias.

-- > :plot2d wxys
