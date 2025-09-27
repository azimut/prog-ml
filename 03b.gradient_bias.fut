def average (xs: []f64) : f64 =
  f64.sum xs / f64.i64 (length xs)

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

-- 1.081130169990194f64
-- 13.172267656369339f64
