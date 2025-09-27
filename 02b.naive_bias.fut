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
