// vectors.scad


function $e(i, N=3) = [for (j=[1:N]) j==i? 1:0];    // unit coordinate vector 'i' in N-space
