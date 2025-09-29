import "data/pizza_3_vars_fix"
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

def init_weights (m: i64) : [m][1]f64 =
  unflatten ((replicate m 0.0) :> [m * 1]f64)

def train [n] [m] (features: [n][m]f64) (truths: [n][1]f64) (iterations: i64) (lrate: f64) : [m][1]f64 =
  loop weights = init_weights m
  for _i < iterations do
    matsub weights (matunary (* lrate) (gradient features truths weights))

def add_bias [n] [m] (features: [n][m]f64) : [n][1 + m]f64 =
  transpose ([(replicate n 1.0)] ++ (transpose features))

def main [n] [m] (features: [n][m]f64) (pizzas: [n][1]f64) : [1 + m][1]f64 =
  train (add_bias features) pizzas 100000 0.001

-- With iters=100000 lrate=0.001
-- ==
-- compiled input @ data/pizza_2_vars_fix.txt
-- output { [[ 2.98247247396205 ],[ 0.32762407248591 ], [ 1.366766794723273 ] ] }
-- compiled input @ data/pizza_3_vars_fix.txt
-- output { [[ 2.411782066212325 ], [ 1.2336839595970703 ],[ -2.689984182418442e-2 ],[ 3.1246055774095582 ] ] }

def pxys = (iota (length (flatten truths)), predict (add_bias features) (train (add_bias features) truths 10000 0.001) |> flatten)
def txys = (iota (length (flatten truths)), truths |> flatten)

-- > :gnuplot { truth=txys , prediction=pxys };
-- set title "04b.dimensions\\_bias.fut"
-- set monochrome
-- unset border
-- set grid
-- plot truth with points pt 2, prediction with points pt 3
