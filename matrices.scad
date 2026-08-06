// matrices.scad


function $I(N=3)            = [for (i=[1:N]) $e(i,N)];      // identity matrix in N-space
