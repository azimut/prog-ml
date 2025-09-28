def average (xs: []f64) : f64 =
  f64.sum xs / f64.i64 (length xs)

def predict [n] (feats: [n]f64) (weight: f64) (bias: f64) : [n]f64 =
  map (\x -> x * weight + bias) feats

-- 2 * np.average(X * (predict(X,w,0) - Y))
def gradient [n] (feats: [n]f64) (truths: [n]f64) (weight: f64) (bias: f64) : f64 =
  predict feats weight bias
  |> (\xs -> map2 (-) xs truths)
  |> map2 (*) feats
  |> average
  |> (* 2)

-- bias=0
def train [n] (feats: [n]f64) (truths: [n]f64) (iters: i64) (lrate: f64) : f64 =
  loop w = 0.0
  for _i < iters do
    w - (lrate * (gradient feats truths w 0.0))

def main [n] (reservations: [n]f64) (pizzas: [n]f64) : f64 =
  train reservations pizzas 1000 0.001

-- 1.843692870201097f64
