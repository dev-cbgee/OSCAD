// math.scad

                                        /*^^^^^^^^^^^^^^^^^*\
=======================================/ SUMMARY DESCRIPTION \============================================


 /*^^^^^^^*\
/ bit flags \======================================================================================*/

// using simple integer as a set of binary flags.
function is_set(flag,n)     = (floor(flag)/2^n)%2==1;
function bit_set(flag,n)    = floor(flag) + (is_set(flag,n)? 0 : 2^n);  
function bit_clr(flag,n)    = floor(flag) - (is_set(flag,n)? 2^n : 0);
function bit_flip(flag,n)   = floor(flag) + (is_set(flag,n)? -2^n : 2^n);

// extract a flag subgroup freom within the overall flag: mmmmnnn==> mmmm, m in [0|1]
function bit_grp(flag,m,n)  = floor(floor(flag)/(2^n)%(2^m)); // the 'n' bits before the last 'm' bits
//echo(bit_grp(64+32+8+2+1, 4, 3));  // 1101011 ==> 13 (dec)  <--> '1101' (binary)

 /*^^^^^^^^^^^^^^*\
/ simple ops & fcns\====================================================================================*/

// wraps x, in either direction, back to [0..N-1]
function mod(x,N)   = ((x%N)+N)%N;

//_interval conversions___________________________________________________________________________________
function LR2LD(LR)  = [LR[0], LR[1]-LR[0]];                         // interval --> left,delta
function LR2CD(LR)  = [(LR[0]+LR[1]), (LR[1]-LR[0])]/2;             // interval --> center+/-delta
function CD2LR(CD)  = [CD[0]-CD[1], CD[0]+CD[1]];                   // center+/-delta --> interval
function LD2LR(LD)  = [LD[0], LD[0]+LD[1]];                         // left,delta --> interval
function LD2CD(LD)  = LR2CD(LD2LR(LD));
function CD2LD(CD)  = LR2LD(CD2LR(CD));

//_coordinate transformations_____________________________________________________________________________

// R2: rectangular <--> polar: [x, y]<-->[r, θ]
function R2P(pt) = [norm(pt), atan(pt.y/pt.x)];
function P2R(pt) = [pt.x*cos(pt.y), pt.x*sin(pt.y)];

// R3: euclidean <--> cylindrical coordinates: [x, y, z]<-->[ρ, φ, z]
function E2C(pt) = [norm([pt.x, pt.y]), atan(pt.y/pt.x), pt.z] ;
function C2E(pt) = [pt.x*cos(pt.y),pt.x*sin(pt.y),pt.z];

// R3: euclidean <--> spherical coordinates: [x, y, z]<-->[r, θ, φ]
function E2S(pt) = [norm(pt), acos(pt.z/norm(pt)), atan(pt.y/pt.x)] ;
                   // [x, y, z] = [rsin(Φ)cos(θ), rsin(Φ)sin(θ), rcos(Φ)]
function S2E(pt) = [pt.x*sin(pt.z)*cos(pt.y) ,pt.x*sin(pt.z)*sin(pt.y), pt.x*cos(pt.z)];

 /*^^^^^^^^^^^^^^^^^\
/ rotation operators \___________________________________________________________________________________*/

// rotate around a given axis
module ROT(angle=90,axis=$z)  {rotate(angle, axis) children(); }
module RX(angle=90) { rotate(angle, $x) children();}
module RY(angle=90) { rotate(angle, $y) children();}
module RZ(angle=90) { rotate(angle, $z) children(); }

//single rotations, axis to axis:  X --> Y -->Z --> X...
module RXY(angle=90) {RZ(angle) children();}    module RYX(a=90) {RXY(-angle) children();} 
module RYZ(angle=90) {RX(angle) children();}    module RZY(a=90) {RZY(-angle) children();} 
module RZX(angle=90) {RY(angle) children();}    module RXZ(a=90) {RZX(-angle) children();} 

// double rotations, plane to plane:  XY --> YZ --> ZX -> XY ...  preserves RH rule
module XY2YZ() { RZX() RXY() children(); }      module ZX2XY() { XY2YZ() children();}   // equivqlents
module YZ2ZX() { RXY() RYZ() children(); }      module ZX2YZ() { YZ2ZX() children();}   // equivqlents
module XY2ZX() { RXZ() RZY() children(); }      module YZ2XY() { XY2ZX() children();}   // equivqlents


 /*^^^^^^^^^^^^^*\
/ complex numbers \_____________________________________________________________________________________*/

function cmpl(z)   = [z.y,z.x] ;                // complement:  [x,y] -> [y,x] <==> [r,w] -> [r,90-w]
function conj(z)   = [z.x,-z.y];                // conjugate:   z -> z*, <==> [x,y] -> [x,-y]
function cprd(u,v) = [conj(u)*v, cmpl(u)*v];    // complex product



 /*^^^^^^^^^^^^^^^^^^^^*\
/ R2, R3, Rn vectors ... \============================================================================*/









 /*^^^^^^^^^^^^^^^*\
/ geometric algebra \=================================================================================*/
 
// vectors & conversionss

// transform to unit vector 
function normalize(pt) = pt/norm(pt);

// products

function wedge(v,w) = (v[1]*w[2]-v[2]*w[1])*$e1 + (v[2]*w[0]-v[0]*w[2])*$e2 + (v[0]*w[1]-v[1]*w[0])*$e3; 

function geoprod(v,w) = [v*w, wedge(v,w)]; // produces a bivector: [s,[e1,e2,e3]]

function is_bivector(v) = ((len(v)==2) && (is_num(v[0])) && (len(v[1])==3) ) ; // use 'dim' function for test?

function unorm(v,w) = normalize(wedge(v,w));// to unit normal vector



                                              /*^^^^^^*\
//===========================================/ matrices \================================================*/


/*
*/

function transpose(M, R=[], col=0) = (is_undef(M)) ? undef : (col >= dim(M)[1])? R     // done!
    :  transpose(M, concat(R, [col2row(getcol(M,col))]), col+1)                       // append next row
;


                                             /*^^^^^^^*\                                         
============================================/ TODO List \===================================================
 
    √: OBE:  '*' operator already handles matrix multiplication OBE:fix 'matprod'

    !: make this stuff multi-dimensional, 
        - e.g, matrices with each element a vector or matrix, etc...
        - may put in own GA script file later
    ?: find way to make wedge an aperation; us 'Ʌ' (latin turned V in UTF-8); also greek capital lambda 
//========================================================================================================*/

                                           /*^^^^^^^^^^^^^^^^*\                                      
==========================================/ CONSTRUCTION ZONE  \==========================================*/


                                               /*^^^^^^*\                                      
==============================================/ SANDBOX  \================================================*/

/*========================================================================================================*/

