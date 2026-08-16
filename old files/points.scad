// points.scad
use <math.scad>


/*^^^^^^^^^^^^*\
/ 2D point lists \=======================================================================================*/

function corners(points) = 
    let(
        Xs=getcol(points,0), L=min(Xs), R=max(Xs), 
        Ys=getcol(points,1), B=min(Ys), T=max(Ys)
    ) 
    [ [L,B], [R,T] ]
;

function size(points) = let (C = corners(points)) C[1]-C[0]; 

// make the box that enfolds 'points'
module box(points) { let (B=corners(points)) move(B[0]) square(B[1]-B[0]);}

// creates profile negative of a points poly within its box
module inverse(points) {difference() {box(points); poly(points);}}


function centroid(points) = avg(points);
function center(points) = [let(Bx=box(points), base=Bx[0], size=Bx[1]-Bx[0]) base+ size/2];


                                             /*^^^^^^^^^*\
============================================/ POINT LISTS \===============================================*/
// find corners of a bounding box for points

function centroid(pts,n=0,sum=zero) = 
    (len(pts)<=0) ? undef : (n>=len(pts)) ? sum/len(pts) : centroid(pts,n+1, sum+pts[n]);

module negative(pts)    { difference() {bounds(pts); poly(pts);}; }   // 'photo' negative, within its bounds



                                        /*^^^^^^^^^^^^^^^^^*\
=======================================/ utilities & aliases ==============================================*/

function circpt(w,r=1) = P2R(r,w);                  // returns point on circle at (r,w)

function arcpts(N=$fn, W=360, w=0, r=1, R=[]) =     // returns [[r,w_0]..[r,w_N]], covering a 'W' degree arc
    (w < W) ? arcpts(N, W, w+W/N, r, concat(R, [P2R([r,w])])) : R ;
 
module array(M=1, N=1, axes=gf_U*[$x,$z])    // arrange child objects in an MxN ARRAY
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

    > there are three ways to represent an interval: [start, end], [start, width] and [center, +/-delta]
        >? how to transform among them?


    >!: make an 'append' operator to entrain a series of point lists, lik'union' does for objects
            'union' name can be reused, as it will be a function, not an operator.

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














