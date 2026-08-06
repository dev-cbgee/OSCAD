// gdefs.scad
include <defs.scad>
//include <math.scad>

// ====================================================
// standard gridfinity units (in mm)
u   = 7;
U   = 6*u;	
GFU = [U,U,u];
GFT = .5;    // floor thickness (work on this)
// ====================================================
// profile parameters
h1  = 0.7;  h2 = 1.8;   h3 = 2.15;  h4 = 1.9;  XI = 0.25;

BPH = h1+h2+h3;  // profile height
BPW = h1+h3;     // profile width
BPP = [zero, [BPW,0], [h3,h1], [h3,h1+h2], [0,BPH]];          // baseplate
BPL = concat([for (i=[0:1: len(BPP)-2]) BPP[i]], [[0,h1+h2+h4]]);// stacking lip
    // TODO: bin lid, stacking lip


// ====================================================
// snap connector parameters

SCW = 4.3;  SCH = 3.45; SCL = 4.0;  //[width, height,length]
KS  = [0.78, 1.8];          // [width, height] of main key slot
dKS = [.02,-1.3];           // "delta" to widen lower slot component
KSB = [0.65, [.65, 1,0 ]];  // [radius, [center point]] of bulge's circle 
KST = [224, .46];           // [angle, side] of tangent square 
URC = [SCW, SCH, SCL];      // upper right corner point of connector


P       = URC/2;            // connector center point
R       = [P.x, P.y,0];     // P's projection onto x-y plane
TS      = [1.5, 1.9];       // [backoff%, ,size] of corner trim square
P_c     = E2C(P);

