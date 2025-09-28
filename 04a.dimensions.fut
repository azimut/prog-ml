import "utils"

def predict = matmul

def loss [n] [m] (features: [n][m]f64) (truths: [n][1]f64) (weights: [m][1]f64) : f64 =
  matsub (predict features weights) truths
  |> matunary (** 2)
  |> flatten
  |> average

def gradient [n] [m] (features: [n][m]f64) (truths: [n][1]f64) (weights: [m][1]f64) : [m][1]f64 =
  matsub (predict features weights) truths
  |> matmul (transpose features)
  |> matunary (* 2)
  |> matunary (/ (f64.i64 n))

def train [n] [m] (features: [n][m]f64) (truths: [n][1]f64) (iterations: i64) (lrate: f64) : [m][1]f64 =
  loop weights: [m][1]f64 = unflatten ((replicate m 0.0) :> [m * 1]f64)
  for _i < iterations do
    gradient features truths weights
    |> matunary (* lrate)
    |> matsub weights

def main [n] [m] (features: [n][m]f64) (pizzas: [n][1]f64) : [m][1]f64 =
  train features pizzas 100000 0.001

-- With iters=100000 lrate=0.001
-- ==
-- compiled input @ data/pizza_2_vars_fix.txt
-- output { [[ 0.25032208429987246 ],[ 1.5632873204761812 ]] }
-- compiled input @ data/pizza_3_vars_fix.txt
-- output { [[ 1.1655612622487832  ],[ 0.14250111584252093 ],[ 3.099359590851483 ]] }
