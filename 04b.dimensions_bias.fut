import "utils"

def predict = matmul

def loss [n] [m] (features: [n][m]f64) (truths: [n][1]f64) (weights: [m][1]f64) : f64 =
  predict features weights
  |> (\xss -> matsub xss truths)
  |> flatten
  |> map (** 2)
  |> average

def gradient [n] [m] (features: [n][m]f64) (truths: [n][1]f64) (weights: [m][1]f64) : [m][1]f64 =
  matmul (transpose features) (matsub (predict features weights) truths)
  |> (\xss -> matsmul xss 2)
  |> (\xss -> matsdiv xss (f64.i64 n))

def train [n] [m] (features: [n][m]f64) (truths: [n][1]f64) (iterations: i64) (lrate: f64) : [m][1]f64 =
  loop weights: [m][1]f64 = unflatten ((replicate m 0.0) :> [m * 1]f64)
  for _i < iterations do
    matsub weights (matsmul (gradient features truths weights) lrate)

def main [n] [m] (features: [n][m]f64) (pizzas: [n][1]f64) : [1 + m][1]f64 =
  let with_bias = transpose ([(replicate n 1.0)] ++ (transpose features))
  in train with_bias pizzas 100000 0.001
