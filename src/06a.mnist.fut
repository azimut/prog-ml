def parse_field (xs: []u8) : i64 =
  (i64.u8 xs[0] << 24) + (i64.u8 xs[1] << 16) + (i64.u8 xs[2] << 8) + (i64.u8 xs[3] << 0)

entry parse_header (xs: []u8) : (i64, i64, i64, i64) =
  (parse_field xs[0:4], parse_field xs[4:8], parse_field xs[8:12], parse_field xs[12:16])

def parse_labels (xs: []u8) : (i64, []u8) =
  let (_, n_labels, _, _) = parse_header xs
  in (n_labels, xs[8:])

def parse_images (xs: []u8) : (i64, i64, i64, [][]u8) =
  let (_, n_imgs, n_rows, n_cols) = parse_header xs
  let n_pixels = n_rows * n_cols
  in (n_imgs, n_rows, n_cols, unflatten (xs[16:] :> [n_imgs * n_pixels]u8))

def get_nth_image (n: i64) (data: (i64, i64, i64, [][]u8)) : [][]u8 =
  let (_, n_rows, n_cols, pixels) = data
  in unflatten (pixels[n] :> [n_rows * n_cols]u8)

def get_nth_label (n: i64) (data: (i64, []u8)) : u8 =
  let (_, labels) = data
  in head (drop (n - 1) labels)

-- > :img get_nth_image 1000 (parse_images ($loadbytes "data/t10k-images-idx3-ubyte"))

-- > get_nth_label 1000 (parse_labels ($loadbytes "data/t10k-labels-idx1-ubyte"))

--
-- ==
-- entry: parse_header
-- script input { $loadbytes "../data/t10k-images-idx3-ubyte" }
-- output {  2051i64 10000i64 28i64 28i64  }
-- script input { $loadbytes "../data/t10k-labels-idx1-ubyte" }
-- output {  2049i64 10000i64 117571840i64 67175433i64 }
