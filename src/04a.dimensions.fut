import "utils"
import "../data/pizza_3_vars_fix"

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

def init_weights (m: i64) : [m][1]f64 =
  unflatten ((replicate m 0.0) :> [m * 1]f64)

def train [n] [m] (features: [n][m]f64) (truths: [n][1]f64) (iterations: i64) (lrate: f64) : [m][1]f64 =
  loop weights = init_weights m
  for _i < iterations do
    matsub weights (matunary (* lrate) (gradient features truths weights))

entry test = (\features pizzas -> train features pizzas 100000 0.001)

def main [n] [m] (features: [n][m]f64) (pizzas: [n][1]f64) : [][]f64 =
  let weights = #[trace] test features pizzas
  let predictions = predict features weights
  in loop result: [][]f64 = []
     for i < i64.min 5 (length pizzas) do
       result ++ [[predictions[i][0], pizzas[i][0]]]

-- With iters=100000 lrate=0.001
-- ==
-- entry: test
-- compiled input @ data/pizza_2_vars_fix.txt
-- output { [[ 0.25032208429987246 ],[ 1.5632873204761812 ]] }
-- compiled input @ data/pizza_3_vars_fix.txt
-- output { [[ 1.1655612622487832  ],[ 0.14250111584252093 ],[ 3.099359590851483 ]] }

def pxys = (iota (length (flatten truths)), predict features (train features truths 10000 0.001) |> flatten)
def txys = (iota (length (flatten truths)), truths |> flatten)

-- > :gnuplot { truth=txys , prediction=pxys };
-- set title "04a.dimensions.fut"
-- set monochrome
-- unset border
-- set grid
-- plot truth with points pt 2, prediction with points pt 3
