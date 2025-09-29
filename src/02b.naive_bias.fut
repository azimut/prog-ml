def features : [30]f64 = [13.0, 2, 14, 23, 13, 1, 18, 10, 26, 3, 3, 21, 7, 22, 2, 27, 6, 10, 18, 15, 9, 26, 8, 15, 10, 21, 5, 6, 13, 13]
def pizzas : [30]f64 = [33.0, 16, 32, 51, 27, 16, 34, 17, 29, 15, 15, 32, 22, 37, 13, 44, 16, 21, 37, 30, 26, 34, 23, 39, 27, 37, 17, 18, 25, 23]

def predict (feats: []f64) (weight: f64) (bias: f64) : []f64 =
  map (\n -> n * weight + bias) feats

def average (xs: []f64) : f64 =
  f64.sum xs / f64.i64 (length xs)

def loss (feats: []f64) (truths: []f64) (weight: f64) (bias: f64) : f64 =
  predict feats weight bias
  |> map2 (-) truths
  |> map (** 2)
  |> average

def train (feats: []f64) (truths: []f64) (iters: i64) (lrate: f64) : (i64, f64, f64) =
  let (_, ab, weight, bias) =
    loop (i, _, w, b) = (0, 0, 0.0, 0.0)
    while i < iters do
      let current_loss = loss feats truths w b
      in if (loss feats truths (w + lrate) b) < current_loss
         then (i + 1, i, w + lrate, b)
         else if (loss feats truths (w - lrate) b) < current_loss
         then (i + 1, i, w - lrate, b)
         else if (loss feats truths w (b + lrate)) < current_loss
         then (i + 1, i, w, b + lrate)
         else if (loss feats truths w (b - lrate)) < current_loss
         then (i + 1, i, w, b - lrate)
         else (iters, i, w, b)
  in (ab, weight, bias)

def main [n] (reservations: [n]f64) (pizzas: [n]f64) : (i64, f64, f64) =
  train reservations pizzas 10000 0.01

-- ## Plots

-- > train features pizzas 10000 0.01

def xys = (features, pizzas)

-- > :gnuplot { input=xys };
-- weight = 1.1000000000000008; bias = 12.929999999999769;
-- set title "02b.naive\\_bias.fut"
-- unset border; set grid; set monochrome; set key bottom right;
-- set yrange [0:*]
-- set xlabel "reservations"; set ylabel "pizzas";
-- f(x) = weight * x + bias
-- plot input w p pt 3 title "", f(x) title sprintf("f(x) = %.3f * x + %.3f", weight, bias)
