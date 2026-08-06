// defs.scad - Open SCAD declarations

include <math.scad>
//=======================================================================================================
// define constants

$fn     = 60;       // default # of segments in 360 degrees for rotate_extrude
$sf     = 1;        // scale factor: model units per SCAD unit -- e.g., 1:$sf scale
                    //  lets you calibrate model sizing to physical measurements.
//TODO: figure out how to actually do the parts mating stuff properly
DZ      = .025;     // dead zone between mating parts
MGN     = .177;     // around borders of mating parts = sqrt(2)/4
mgn     = MGN/2;
MARGIN  = MGN*[1, 1,0];
eps     = .001;     // ε, Open SCAD offset to connect touching objects by a trivial overlap
$eps    = [eps, eps, eps];
//=======================================================================================================
// arrangements  TODO: investigate recursive approach


//=======================================================================================================
// circle primitives



//=======================================================================================================
// utilities & aliases for clarity/convenience

function circpt(w,r=1) = P2R(r,w); // returns point on circle at (r,w)


function arcpts(N=$fn, W=360, w=0, r=1, R=[]) = // returns [[r,w_0]..[r,w_N]], covering a 'W' degree arc
    (w < W) ? arcpts(N, W, w+W/N, r, concat(R, [P2R([r,w])])) : R ;

 
module array(M=1, N=1, spacing=U, margin=MARGIN)  // arrange child objects in an MxN ARRAY
    //{ for (i=[1:M], j=[1:N]) translate(spacing*[i-1,j-1, 0]+margin/2) children(); }
    { for (i=[1:nx]) for (j=[1:ny]) translate(spacing*[i-1,j-1, 0]+margin/2) children(); }

module move(amt) {translate(amt+[eps,eps,eps]) children();}

module poly(pts, origin=[0,0], s=1)
    { move(origin) scale(s)if (is_num(pts)) circle($fn=pts); else if (is_list(pts)) polygon(pts); }
    
module extrude(amt=1, dir=$up, center=false)  //TODO: lotsa stuff...
   { move([0,0,-eps]) linear_extrude(height=amt+2*eps, dir, center) children(); }

// turn, as on a potter's wheel, to form a wedge of angle 'a' using the child profile in the x-y plane 
module turn(a=90) 
   {rotate(-90,$x) rotate_extrude(angle=a) children();}

// invert the child profile -- subtract ift from a given larger rectangle
module invert(context=[3,5]){ difference() {square(context); children();}; } 

function MAX(pts, n=0, x=0, y=0) = (n>=(len(pts))) ? [x,y]  //  [rightmost, topmost] coordinate values
    : MAX(pts, n+1, max(x,pts[n][0]), max(y,pts[n][1]))
;

function MIN(pts, n=0, x=0, y=0) = (n>=(len(pts))) ? [x,y]  //  [leftmost, bottom] coordinate values  
    : MIN(pts, n+1, min(x,pts[n][0]), min(y,pts[n][1]))
;
function SIZE(pts) = (MAX(pts)-MIN(pts)) ;                  // bounding corners 

module PALE(pts, origin=[0,0], s=1) 
    { move(origin+MIN(pts)) scale(s) square(SIZE(pts));}    // bounding rectangle

module negative(pts, origin=[0,0], s=1) // 'photo' negative of polygon, within its PALE
    { difference() { PALE(pts, origin, s); poly(pts, origin, s); }; }
//*///=======================================================================================================
/*
TODO:
*/
//==========================================================================================================
//testing...
// profile parameters
h1  = 0.7;  h2 = 1.8;   h3 = 2.15;  h4 = 1.9;  XI = 0.25;

BPH = h1+h2+h3;  // profile height
BPW = h1+h3;     // profile width
BPP = [[0,0], [BPW,0], [h3,h1], [h3,h1+h2], [0,BPH]];          // baseplate

//negative(BPP, [1,1],[.5,1.5]);

poly(5, [1,1],[.75,.5]);
//=======================================================================================================
