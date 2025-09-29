def features : [30]f64 = [13.0, 2, 14, 23, 13, 1, 18, 10, 26, 3, 3, 21, 7, 22, 2, 27, 6, 10, 18, 15, 9, 26, 8, 15, 10, 21, 5, 6, 13, 13]
def pizzas : [30]f64 = [33.0, 16, 32, 51, 27, 16, 34, 17, 29, 15, 15, 32, 22, 37, 13, 44, 16, 21, 37, 30, 26, 34, 23, 39, 27, 37, 17, 18, 25, 23]

def predict (feats: []f64) (weight: f64) : []f64 =
  map (* weight) feats

def average (xs: []f64) : f64 =
  f64.sum xs / f64.i64 (length xs)

def loss (feats: []f64) (truths: []f64) (weight: f64) : f64 =
  predict feats weight
  |> map2 (-) truths
  |> map (** 2)
  |> average

def train (feats: []f64) (truths: []f64) (iters: i64) (lrate: f64) : (i64, f64) =
  let (_, ab, weight) =
    loop (i, _, w) = (0, 0, 0.0)
    while i < iters do
      let current_loss = loss feats truths w
      in if (loss feats truths (w + lrate)) < current_loss
         then (i + 1, i, w + lrate)
         else if (loss feats truths (w - lrate)) < current_loss
         then (i + 1, i, w - lrate)
         else (iters, i, w)
  in (ab, weight)

def main [n] (reservations: [n]f64) (pizzas: [n]f64) : (i64, f64) =
  train reservations pizzas 10000 0.001

-- ## Plots

-- > train features pizzas 10000 0.001

def xys = (features, pizzas)

-- > :gnuplot { input=xys };
-- weight = 1.8439999999999077
-- set title "02a.naive.fut"
-- unset border; set grid; set monochrome; set key bottom right;
-- set yrange [0:*]
-- set xlabel "reservations"; set ylabel "pizzas";
-- f(x) = weight * x + 0
-- plot input w p pt 3 title "", f(x) title sprintf("f(x) = %.3f * x + 0", weight)
