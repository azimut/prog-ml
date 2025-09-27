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
