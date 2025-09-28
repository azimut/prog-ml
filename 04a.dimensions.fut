def average (xs: []f64) : f64 =
  f64.sum xs / f64.i64 (length xs)

def dotprod [n] (xs: [n]f64) (ys: [n]f64) : f64 =
  f64.sum (map2 (*) xs ys)

def matmul [n] [m] [p] (A: [n][m]f64) (B: [m][p]f64) : [n][p]f64 =
  map (\A_row -> map (dotprod A_row) (transpose B)) A

def matsub [n] [m] (A: [n][m]f64) (B: [n][m]f64) : [n][m]f64 =
  map2 (\A_row B_row -> map2 (-) A_row B_row) A B

def matsmul [n] [m] (A: [n][m]f64) (by: f64) : [n][m]f64 =
  map (\A_row -> map (* by) A_row) A

def matsdiv [n] [m] (A: [n][m]f64) (by: f64) : [n][m]f64 =
  map (\A_row -> map (\x -> x / by) A_row) A

def predict = matmul

def loss [n] [m] (features: [n][m]f64) (truths: [n][1]f64) (weights: [m][1]f64) : f64 =
  predict features weights
  |> (\xss -> matsub xss truths)
  |> flatten
  |> map (** 2)
  |> average

-- def gradient(X,Y,w): # no change
--     return 2 * np.matmul(X.T, (predict(X,w)-Y)) / X.shape[0]
def gradient [n] [m] (features: [n][m]f64) (truths: [n][1]f64) (weights: [m][1]f64) : [m][1]f64 =
  matmul (transpose features) (matsub (predict features weights) truths)
  |> (\xss -> matsmul xss 2)
  |> (\xss -> matsdiv xss (f64.i64 n))

def train [n] [m] (features: [n][m]f64) (truths: [n][1]f64) (iterations: i64) (lrate: f64) : [m][1]f64 =
  loop weights: [m][1]f64 = unflatten ((replicate m 0.0) :> [m * 1]f64)
  for _i < iterations do
    matsub weights (matsmul (gradient features truths weights) lrate)

def main [n] [m] (features: [n][m]f64) (pizzas: [n][1]f64) : [m][1]f64 =
  train features pizzas 100000 0.001
