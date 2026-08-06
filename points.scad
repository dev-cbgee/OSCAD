// points.scad

/*^^^^^^^^^^^^*\
/ 2D point lists \=======================================================================================*/
/*
function bounds_UR(plist) = [max(getcol(plist,0)), max(getcol(plist,1))]; 
function bounds_LL(plist) = [min(getcol(plist,0)), min(getcol(plist,1))]; 
function bounds(plist)    = [bounds_LL(plist), bounds_UR(plist)];

module bounds(plist) { rect(bounds(plist)); }

module rect(points) {move(points[0]) square(sub(points));} // !>: rework: must sub from every pt in ptlist



*/
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














