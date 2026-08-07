// misc_ops.scad
include <oscad.scad>

 /*^^^^^^^^^^^^^^^^^^^^*\
/ misc simple operations \===============================================================================*/

module unscale(s=$fs) { scale(1/s) children(); } // !>: assert s!=0 

// scale & move an object to ensure it connects its neighbors through trivial overlap
module adjust(e = eps) { move(-e) scale((ones(len(e))+2*e)) children(); }

// add mirrored duplicate of each child along vector 'v'
module dup(v=$x) { children();  mirror(v) children(); } 

// wraps x, in either direction, around to [0..N-1]
function mod(x,N) = ((x%N)+N)%N;

// dimensions of matrix (only tested for 2D matrices)
function dim(M, d=[]) = is_undef(M) ? undef : is_undef(M[0]) ? d : dim(M[0], concat(d, [len(M)])) ; 

// polar to rectangular conversion
function P2R(pt) = [pt[0]*cos(pt[1]), pt[0]*sin(pt[1])];    // [r, θ] => [x, y] 

function ctr(L,R) = [(R+L)/2, (R-L)/2];
function spread(center, delta) = [center-delta, center+delta];

//echo(spread(5,1));

 /*^^^^^^^^^^^^^^*\
/ aliases & extras \======================================================================================*/

// !>: add the additional argument defaults
module move(r) {translate(r) children();}   // r is element of RN, N= 2|3

// move to polar coordinate z = '[r,w]'  !>: need to add 2D | 3D tests
module move_p(z, rot=true) { move(P2R(z)) rotate(rot ? z[1]:0) children();}

// !>: add the additional argument defaults
module poly(points, origin=$origin(2)) { move(origin) polygon(points); } 

// arrange children in an MxN rectangular grid w/ 2-D spacing 'S'
module grid(M=1, N=1, S=U*[$x,$y],center=false) {
    let (ML = center? -(M-1)/2 : 0, MR = center?  (M-1)/2 : M-1,
         NB = center? -(N-1)/2 : 0,  NT = center? (N-1)/2 : N-1) 
    for(i=[ML:MR], j=[NB:NT]) move((i*S[0] +j*S[1])) children(); 
}

module grid_p(R0,dR,M,N,center=true) {
    let( LR = center? ctr(0,M-1) : [0,M], BT = center? ctr(0,N-1) : [0,N] ) 
    {
        for (i=[LR[0]-LR[1]:(LR[0]+LR[1])], j=[BT[0]-BT[1]:BT[0]+BT[1]])
        let( r=[R0[0]+j*dr[0], R0[1]+i*dR[1]])  move_p(r) children();
    }
}
     
// instantiate 'N' children along an arc, from R0 in increments of dR (all in polar form)
module arcn(R0,dR,N,rot=true){ for(i=[0:N-1]) move_p(R0+i*dR, rot)children();}

// instantiate children along an arc, from R0  to RN, with spacing dR (all in polar form)
module arcl(R0,dR,RN,rot=true){ arcn(R0, dR, (RN[1]-R0[1])/dr[1],rot) children();}


module fan(R0,dR,RN,center=true) 
    { let (M=(RN[1]-R0[1])/dR[1]+1, N=((RN[0]-R0[0])/dR[0]+1)) grid_p(R0,dR,M,N,center) children();}
    
     
     
     
      
    
/*
   
}
*/


r0=[1, 45]; rN=[2,135]; dr = [.25,10]; N=(rN[1]-r0[1])/dr[1];

//arcl(r0,dr,rN) square([.2,.1],center=true);
//arcn (r0, dr, N) square([.2,.1],center=true);
//grid_p(r0,dr,5,4) square([.1,.1],center=true);

 
/* TODO:    1) centering option 
            2) args: start, finish, delta
    Rf, dR




*/