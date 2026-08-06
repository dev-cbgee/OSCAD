// oscad.h.scad - main header for Open SCAD 


                                            /*^^^^^^^^^*\
===========================================/ DESCRIPTION \================================================

The tools in this script facilitate simple operations that might otherwise call for confusing raw SCAD code
    - they require less interpretation, making things more readable -- hence readily understandable.

                                         /*^^^^^^^^^^^^^^*\
========================================/ GENERAL CONCEPTS \===============================================
    
SOME USEFUL PERSPECTIVES:
    1) The X-Y plane is the ground plane, on which everything rests; "Z" is "up"
    2) All extrusion occurs "Z-ward". Create first, then rotate and move to final location.
    3) A simple scope enclosure, '{ ... }', can often replace 'union(){ ... }'
    4) Remember that operations proceed from right to left; rightmost operation happens first. order matters.

    define constants and various useful primitives
    
                                   /*^^^^^^^^^^^^^^^^^^^^^^^^^^*\
==================================/ general Open SCAD parameters ========================================*/

$fn     = 60;       // default # of segments in 360 degrees for rotate_extrude
$sf     = 1;        // 1:$sf scale factor, i.e., 1 SCAD unit = $sf physical units.
$max    = 10000;    // 10^4 (10 METERS)
eps     = 1/$max;   // ε, Open SCAD offset to connect adjacent objects through a trivial overlap

CW  = true; // "clockwise"
CCW = !CW;  // "counter-clockwise"


                                             /*^^^^^*\
============================================/ vectors \===================================================*/

$e1  = [1,0,0];   $x = $e1; $y2z = $x;  $right = $x;   $left = -$right;
$e2  = [0,1,0];   $y = $e2; $z2x = $y;  $fwd   = $y;   $back = -$fwd; 
$e3  = [0,0,1];   $z = $e3; $x2y = $z;  $up    = $z;   $down = -$up;

// recursively create vector of 'N' values, 'val'. NB: 'val need not be only a number
function nvec(N, val, R=[], n=0) = (N<1)? undef : (n>=N)? R : nvec(N,val, concat(R,[val]), n+1);
function zeros(n) = nvec(n,0);  
function zeros1(n) = (n<2)? [1] : concat(zeros(n-1), [1]);
zero    = zeros(2);     ones    = nvec(2,1);  // 2D
ZERO    = zeros(3);     ONES    = nvec(3,1);  // 3D
origin  = zero;         ORIGIN  = ZERO;
$eps    = eps*ONES;


// scale & move an object so that it will overlap its neighbors
module adjust(e = $eps) { translate(-e) scale((ONES+2*e)) children(); }
module dejust(e = $eps) { scale((ONES-2*e)/(1-e*e*1.4)) translate(e) children();} // 1.4 is finagled
module readjust(e=$eps) { dejust(e) adjust(e) children(); }


                                                /*^^^*\
===============================================/ LISTS \==================================================*/

function first(list)    = list[0];
function last(list)     = list[len(list)-1];

function roll(v,n,i=0,R=[]) = // circular shift of all list elements;
    let(N=len(v), modsum=(i+n)%N, nxti= (modsum>=0)? modsum : (N+modsum))
    (is_undef(N)||(N==0))? undef : n==0? v : i>=N? R : roll(v,n,i+1,concat(R,v[nxti%N]))
;

// adds 'base' item to each list element, if '+' is defined for them
function displace(list, base, cursor=0, R=[]) = let (N = len(list))
(is_undef(N)||(N==0))? undef : cursor>=N? R : displace(list, base, cursor+1, concat(R, [list[cursor]+base] ));

// append L2 to L1, treating last(L1) as L2's relative origin
// (lets you build a polygon from two segments)
function append(L1, L2) = concat(L1,  displace(L2, last(L1) ));   


//L1 = [1,2,3,4]; L2=[1,2,3];

                                             /*^^^^^^^^^*\
============================================/ POINT LISTS \===============================================*/


function top(pts,n=0,x=0)   = (n>=(len(pts))) ? x : top(pts,n+1, max(x,pts[n][1]));
function left(pts,n=0,x=0)  = (n>=(len(pts))) ? x : left(pts,n+1, min(x,pts[n][0]));
function right(pts,n=0,x=0) = (n>=(len(pts))) ? x : right(pts,n+1, max(x,pts[n][0]));
function bottom(pts,n=0,x=0)= (n>=(len(pts))) ? x : bottom(pts,n+1, min(x,pts[n][1]));
function displacement(pts)  = [left(pts), bottom(pts)];
function extent(pts)        = [right(pts), top(pts)];
function range(pts)         = [displacement(pts), extent(pts)];
function size(pts)          = extent(pts) - displacement(pts);
function center(pts)        = displacement(pts)+size(pts)/2;
function centroid(pts,n=0,sum=zero) = 
    (len(pts)<=0) ? undef : (n>=len(pts)) ? sum/len(pts) : centroid(pts,n+1, sum+pts[n]);

module bounds(pts)      { move(displacement(pts)) square(size(pts)); } // point list's bounding rectangle

module negative(pts)    { difference() {bounds(pts); poly(pts);}; }   // 'photo' negative, within its bounds




                                             /*^^^^^^^^\
============================================/ rotations \=================================================*/

// rotate around a given axis
module ROT(angle=90,axis=$z)  {rotate(angle, axis) children(); }
module RX(angle=90) { rotate(angle, $x) children();}
module RY(angle=90) { rotate(angle, $y) children();}
module RZ(angle=90) { rotate(angle, $z) children(); }

//single rotations, axis to axis:  X --> Y -->Z --> X...
module RXY(angle=90) {RZ(angle) children();}    module RYX(a=90) {RXY(-angle) children();} 
module RYZ(angle=90) {RX(angle) children();}    module RZY(a=90) {RZY(-angle) children();} 
module RZX(angle=90) {RY(angle) children();}    module RXZ(a=90) {RZX(-angle) children();} 

// duplet rotations, plane to plane:  XY --> YZ --> ZX -> XY ...  preserves RH rule
module XY2YZ() { RZX() RXY() children(); }      module ZX2XY() { XY2YZ() children();}   // equivqlents
module YZ2ZX() { RXY() RYZ() children(); }      module ZX2YZ() { YZ2ZX() children();}   // equivqlents
module XY2ZX() { RXZ() RZY() children(); }      module YZ2XY() { XY2ZX() children();}   // equivqlents

                                        /*^^^^^^^^^^^^^^^^^*\
=======================================/ boolean exstensions \=============================================*/

/* doesnt seem to work...
module EVERYTHING(size=MAXIMUM) { cube(size*ONES, center=true);}
module NOT(size=MAXIMUM) { difference(){  EVERYTHING(size); children(); }; }
module AND() {intersection() children(); }
module OR()  { union() { children(); };  }
module XOR() 
    { union() { difference() {children(0); children(1); }; difference() { children(1); children(O); }; }; }
         
         
module NOR() { NOT() union()  { children(); }; }
module NAND(){ NOT(){ intersection() { children(); };}; }

XOR{ {move($left) sphere(2);}; {move($right) sphere(2);}; };
*/

                                        /*^^^^^^^^^^^^^^^^^*\
=======================================/ utilities & aliases ==============================================*/

function circpt(w,r=1) = P2R(r,w);                  // returns point on circle at (r,w)

function arcpts(N=$fn, W=360, w=0, r=1, R=[]) =     // returns [[r,w_0]..[r,w_N]], covering a 'W' degree arc
    (w < W) ? arcpts(N, W, w+W/N, r, concat(R, [P2R([r,w])])) : R ;
 
module array(M=1, N=1, axes=U*[$x,$z])    // arrange child objects in an MxN ARRAY
{ for (i=[-(M-1)/2:(M-1)/2]) for (j=[-(N-1)/2:(N-1)/2]) translate(((i)*axes[0] +(j)*axes[1])) children(); }

module move(amt) {translate(amt+[eps,eps,eps]) children();}

module poly(pts, origin=[0,0], s=1)
    { move(origin) scale(s)if (is_num(pts)) circle($fn=pts); else if (is_list(pts)) polygon(pts); }
    
module extrude(amt=1, dir=$up, center=false)  //TODO: lotsa stuff...
   { move([0,0,-eps]) linear_extrude(height=amt+2*eps, dir, center) children(); }

// turn, as on a lathe, to form a wedge of angle 'a' shaped by child profile in the x-y plane 
module turn(dw=90, w0=0) { RZ(w0) rotate_extrude(angle=dw) {children();};}

// invert the child profile -- subtract it from a given larger rectangle
module invert(context=[3,5]){ difference() {square(context); children();}; } 

module duplet(dir=$left) { children(); move(eps*dir) mirror(dir) children(); }           // original+ left-mirrored image

module perplet(cw=true,axis=$z) { children(); rotate(cw ? 90: -90, axis) children(); }// original + ┴ image

module quad(first=$x, second=$z) {duplet(second) duplet(first) children();}  // mirror a duplet 

// remove, from the child object, a box at location 'posn' 
module erase(posn=ORIGIN, box=ONES) { difference() { children(0); move(posn) cube(box);}; }

// impress an object mold (child 0) onto an extruded target object at coordinate z = P.  
module imprint(P=0) {difference() {children(1); move([0,0,P-eps]) children(0); }; }


/*============================================/ TODO List \===================================================

    >!: make an 'append' operator to entrain a series of point lists, lik'union' does for objects

    >!: // >: extend point list operations to 3D?

    >?: can one also define 'adjust' as a function to 'operate' on points & lists?

    >!: find proper way to define a 'bounds' for 'invert'

    >:  make a version of 'snippet' that operates on 2D objects instead of polygon point lists 
            ?: call it 'snip'? 
    >!: part of bounds remains when calling snippet (top line)
        - perhaps problem lies with 'invert'
    ?:  extend bounds when pts are 1) in R^N; 2) matrices?  

    ?: how to properly handle mating parts? 

    ?: investigate recursive possibilities for arranging objects
    
 ------------------------------------------------- DONE ----------------------------------------------------   

    √: define 'adjust(scale_factor, eps)' function? operator? (done as an operator)
    √: 'center(pts)  locates center of bounds(pts)
    √: centroid(pts) renturns average [x,y] of pts
    X:'center()' operator moves 'pts' center to the origin
         - cannot operate on a value; must use a function call to compute it 
    


                                           /*^^^^^^^^^^^^^^^^*\                                      
==========================================/ CONSTRUCTION ZONE  \==========================================*/

// construct part of the pts list bounded by some rect(sz) at offset llc
// module snippet(pts, llc=zero, sz= [1,1]) { /*difference() { */move(llc) square(sz); invert() poly(pts); }//; }

//points=[[0,1],[1,2],[2,3]];






                                               /*^^^^^^*\                                      
==============================================/ SANDBOX  \================================================*/













