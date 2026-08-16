// point_ops.scad



 /**********************\
/ misc simple ops & fcns \____________________________________________________________________________*/

module unscale(s=$fs) assert(s!=0,"scale factore is '0'")  { scale(1/s) children(); }

// scale & move an object to ensure it connects its neighbors through trivial overlap
module adjust(e = eps) { move(-e) scale((ones(len(e))+2*e)) children(); }

// add mirrored duplicate of each child along vector 'v'  (cf stack function 'dup')
module dup(v=$x) { children();  mirror(v) children(); } 



 /************\
/ 2D point ops \______________________________________________________________________________________*/

function conj_x(points) = [    // Xi <-- -Xi
    let(N=len(points),R=corners(points)[1][0]) 
    for(i=[0:N-1]) [R-points[i][0], points[i][1]]
];

function corners(points) = // returns lower left and upper right corners of box containing the points
    let(
        Xs=getcol(points,0), L=min(Xs), R=max(Xs), 
        Ys=getcol(points,1), B=min(Ys), T=max(Ys)
    ) 
    [ [L,B], [R,T] ]
;

function size(points) = let (C = corners(points)) C[1]-C[0]; 

function centroid(points)   = avg(points);  // center of "mass" 

// center of the bounding  rectangle
function centrum(points)    = let(base=corners(points)[0], sz=size(points)) base+sz/2;

// place box center at the origin
function centered(points) = [let(N=len(points), C = centrum(points)) for(i=[0:N-1]) points[i]-C];

//place box lower left corner at the origin
function home(points) = [for (N=len(points), i=[0:N-1]) points[i]-corners(points)[0]];

// make the box that enfolds 'points'
module box(points) { translate(corners(points)[0]) square(size(points));}

// creates profile negative of a points poly within its box 'frame'
module inverse(points) {difference() {box(points); polygon(points);}}


 /****************\
/ aliases & extras \____________________________________________________________________________________*/




/*
    - invert the (implicitly) convex profile defined by 'points'; return ts exterior as a profile
    - can't be done using poly; must do in a module by subtracting poly(points) from its bounds
    => need to create points' bounding rectangle

    border(points) = [LL, UR]; where LL & UR are lower left and upper right corners of the bounding rect 

NB: a point list is also a Nx2 matrix.; col2row would be useful


*/

//*************************************************************************************************************/


                                             /*^^^^^^^^^*\
============================================/ POINT LISTS \===============================================*/


                                        /*^^^^^^^^^^^^^^^^^*\
=======================================/ utilities & aliases ==============================================*/

function circpt(w,r=1) = P2R(r,w);                  // returns point on circle at (r,w)

function arcpts(N=$fn, W=360, w=0, r=1, R=[]) =     // returns [[r,w_0]..[r,w_N]], covering a 'W' degree arc
    (w < W) ? arcpts(N, W, w+W/N, r, concat(R, [P2R([r,w])])) : R ;
 
module array(M=1, N=1, axes=gf_U*[$x,$z])    // arrange child objects in an MxN ARRAY
{ for (i=[-(M-1)/2:(M-1)/2]) for (j=[-(N-1)/2:(N-1)/2]) translate(((i)*axes[0] +(j)*axes[1])) children(); }


// turn, as on a lathe, to form a wedge of angle 'a' shaped by child profile in the x-y plane 
module turn(dw=90, w0=0) { RZ(w0) rotate_extrude(angle=dw) {children();};}

// invert the child profile -- subtract it from a given larger rectangle
module invert(context=[3,5]){ difference() {square(context); children();}; } 

//module duplet(dir=$left) { children(); move(eps*dir) mirror(dir) children(); }           // original+ left-mirrored image
module duplet(dir=$left) { children(); mirror(dir) children(); }           // original+ left-mirrored image

module perplet(cw=true,axis=$z) { children(); rotate(cw ? 90: -90, axis) children(); }// original + ┴ image

module quad(first=$x, second=$y) {duplet(second) duplet(first) children();}  // mirror a duplet 

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


//move($x) cylinder(d=gfd_3, h=gf_u);











