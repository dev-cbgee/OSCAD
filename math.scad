// math.scad
include <oscad.scad>

                                        /*^^^^^^^^^^^^^^^^^*\
=======================================/ SUMMARY DESCRIPTION \============================================




                                           /*^^^^^^^^^^^^^*\
//========================================/ complex numbers \===========================================*/

function cmpl(z)   = [z.y,z.x] ; // complement --swap parts     [x,y] -> [y,x] <==>  [r,w] -> [r,90-w]
function conj(z)   = [z.x,-z.y]; // conjugate  -- z -> z*, <==> [x,y] -> [x,-y]
function cprd(u,v) = [conj(u)*v, cmpl(u)*v];    // complex product

// rectangular <--> polar coordinate conversions: 
function R2P(pt) = [norm(pt), atan(pt.y/pt.x)];         // [x, y] => [r, θ]
function P2R(pt) = [pt.x*cos(pt.y), pt.x*sin(pt.y)];    // [r, θ] => [x, y] 

                                          /*^^^^^^^^^^^^^^^*\
//=======================================/ geometric algebra \==========================================*/
// 
// vectors & conversionss

// transform row vector to column vector
function row2col(v, i=0, R=[]) = (i>=(len(v))) ? R : row2col(v, i+1, concat(R, [[v[i]]])) ;

// transform to unit vector 
function normalize(pt) = pt/norm(pt);

// 3D -- euclidean <--> cylindrical coordinates 
function E2C(pt) = [norm([pt.x, pt.y]), atan(pt.y/pt.x), pt.z] ;       // [x, y, z] => [ρ, φ, z]
function C2E(pt) = [pt.x*cos(pt.y),pt.x*sin(pt.y),pt.z];               // [ρ, φ, z] => [x, y, z]  (cylindrical)

// 3D -- euclidean <--> spherical coordinates
function E2S(pt) = [norm(pt), acos(pt.z/norm(pt)), atan(pt.y/pt.x)] ;  // [x, y, z] => [r, θ, φ]    (spherical)
//       [x, y, z] = [rsin(Φ)cos(θ), rsin(Φ)sin(θ), rcos(Φ)]
function S2E(pt) = [pt.x*sin(pt.z)*cos(pt.y) ,pt.x*sin(pt.z)*sin(pt.y), pt.x*cos(pt.z)];

// products
function cplxprod(u,v) = [(u.x*v.x - v.y*u.y), (u.x*v.y + u.y*v.x)];

function wedge(v,w) = (v[1]*w[2]-v[2]*w[1])*$e1 + (v[2]*w[0]-v[0]*w[2])*$e2 + (v[0]*w[1]-v[1]*w[0])*$e3; 

function geoprod(v,w) = [v*w, wedge(v,w)]; // produces a bivector: [s,[e1,e2,e3]]

function is_bivector(v) = ((len(v)==2) && (is_num(v[0])) && (len(v[1])==3) ) ;

function unorm(v,w) = normalize(wedge(v,w));// to unit normal vector


// transform column vector to row vector
function col2row(v, i=0, R=[]) = (i>=(len(v))) ? R : col2row(v, i+1, concat(R, v[i])) ;

                                              /*^^^^^^*\
//===========================================/ matrices \================================================*/

// curry function to recursively create one row of an NxN identity matrix
function _z1z(N, row, R=[],j=0) = (row>=N) ? undef : (j>=N)? R : _z1z(N, row, concat(R,[(j==row)? 1:0]),j+1); 

// recursivelycreate NxN identity matrix
function IDENTITY(N=3, row=0, R=[]) = (N<1)? undef : (row==N)? R : IDENTITY(N, row+1, concat(R, [_z1z(N,row)]));

// dimensions of matrix (only tested for 2D matrices)
function dim(M, d=[]) = is_undef(M) ? undef : is_undef(M[0]) ? d : dim(M[0], concat(d, [len(M)])) ; 

//returns specified column of matrix M
function matcol(M, col=0, row=0, R=[]) = 
    ( (col<0) || (is_undef(len(M))) || (col>=len(M[0])) ) ?  undef  // => col out of range
    : ( row>=len(M) || is_undef(M[row][col]) ) ? R                  // done ? return result
    : matcol(M, col, row+1, concat(R, [M[row][col]]))               // next col
;

function transpose(M, R=[], col=0) = (is_undef(M)) ? undef : (col >= dim(M)[1])? R     // done!
    :  transpose(M, concat(R, [col2row(matcol(M,col))]), col+1)                       // append next row
;
                                             /*^^^^^^^*\                                         
============================================/ TODO List \===================================================
 
    √: OBE:  '*' operator handles matrix multiplicationfix 'matprod'

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

