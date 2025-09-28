def average (xs: []f64) : f64 =
  f64.sum xs / f64.i64 (length xs)

def dotprod [n] (xs: [n]f64) (ys: [n]f64) : f64 =
  f64.sum (map2 (*) xs ys)

def matmul [n] [m] [p] (A: [n][m]f64) (B: [m][p]f64) : [n][p]f64 =
  map (\A_row -> map (dotprod A_row) (transpose B)) A

def matsmul [n] [m] (A: [n][m]f64) (by: f64) : [n][m]f64 =
  map (\A_row -> map (* by) A_row) A

def matsdiv [n] [m] (A: [n][m]f64) (by: f64) : [n][m]f64 =
  map (\A_row -> map (\x -> x / by) A_row) A

def matunary [n] [m] (op: f64 -> f64) (A: [n][m]f64) : [n][m]f64 =
  map (\A_row -> map op A_row) A

def matop [n] [m] (op: f64 -> f64 -> f64) (A: [n][m]f64) (B: [n][m]f64) : [n][m]f64 =
  map2 (\A_row B_row -> map2 op A_row B_row) A B

def matadd = matop (+)
def matsub = matop (-)
