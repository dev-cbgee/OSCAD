// misc_ops.scad

//include <oscad.scad>  // includes defs file

//!!    > fix centering option 
//!!    > args: start, finish, delta Rf, dR  ???


 
 /*^^^^^^^^^^^^^^^^^^^^*\
/ misc simple ops & fcns\===============================================================================*/

module unscale(s=$fs) assert(s!=0,"scale factore is '0'")  { scale(1/s) children(); }

// scale & move an object to ensure it connects its neighbors through trivial overlap
module adjust(e = eps) { move(-e) scale((ones(len(e))+2*e)) children(); }

// add mirrored duplicate of each child along vector 'v'  (cf stack function 'dup')
module dup(v=$x) { children();  mirror(v) children(); } 

function ctr(L,R) = [(R+L)/2, (R-L)/2];
function spread(center, delta) = [center-delta, center+delta];

//echo(spread(5,1));

 /*^^^^^^^^^^^^^^*\
/ aliases & extras \======================================================================================*/

//!!>   add the additional argument defaults
module move(r) {translate(r) children();}   // r is element of RN, N= 2|3

// move to polar coordinate z = '[r,w]'  !>: need to add 2D | 3D tests
module move_p(z, rot=true) { move(P2R(z)) rotate(rot ? z[1]:0) children();}

// place 'N' children along an arc, starting at R0 in increments of dR (all in polar form)
module arcn(R0,dR,N,rot=true){ for(i=[0:N-1]) move_p(R0+i*dR, rot)children();}

// place children along an arc, from R0  to RN, with spacing dR (all in polar form)
module arcl(R0,dR,RN,rot=true){ arcn(R0, dR, (RN[1]-R0[1])/dR[1],rot) children();}


// arrange an MxN rectangular grid of children w/ vector spacing 'S'
module grid(M=1, N=1, S=[$x,$y],center=false) {
    let (ML = center? -(M-1)/2 : 0, MR = center?  (M-1)/2 : M-1,
         NB = center? -(N-1)/2 : 0, NT = center? (N-1)/2 : N-1) 
    for(i=[ML:MR], j=[NB:NT]) move((i*S[0] +j*S[1])) children(); 
}

//same as 'grid', but with parameters passed on a stack (a list)
module grid_s(stack) { //(M=1, N=1, S=U*[$x,$y],center=false) {
    let (M = stack[0][0], N=stack[0][1], spacing=stack[1],centering=stack[2],
         ML = centering? -(M-1)/2 : 0, MR = centering?  (M-1)/2 : M-1,
         NB = centering? -(N-1)/2 : 0, NT = centering? (N-1)/2 : N-1) 
    for(i=[ML:MR], j=[NB:NT]) move((i*spacing[0] +j*spacing[1])) children(); 
}

// like 'grid', but with R0 & dR in polar coordinates
module grid_p(R0,dR,M,N,center=true) {
    let( LR = center? ctr(0,M-1) : [0,M], BT = center? ctr(0,N-1) : [0,N] ) 
    {
        for (i=[LR[0]-LR[1]:(LR[0]+LR[1])], j=[BT[0]-BT[1]:BT[0]+BT[1]])
        let( r=[R0[0]+j*dr[0], R0[1]+i*dR[1]])  move_p(r) children();
    }
}
     
// make a polar array of children
module fan(R0,dR,RN,center=true){ 
    let (M=1+(RN[1]-R0[1])/dR[1], N=1+((RN[0]-R0[0])/dR[0])) 
    grid_p(R0,dR,M,N,center) children();
}


//!!>: add the extra argument defaults
module poly(points, origin=$origin) { move(origin) polygon(points); } 

// invert the child profiles -- subtract from a given larger rectangle
module invert(context=[3,5]){ difference() {square(context); children();}; } 

module extrude(amt=1, center=false)  //TODO: lotsa stuff...
   { move([0,0,-eps]) linear_extrude(height=amt+2*eps, center=center) children(); }

module extrusion(arg){ // 
    let (h = arg[1], , pts = arg[2]) {
        if (debug) echo(arg[0], arg[1], arg[2]);
        extrude(h) poly(pts);
    };
}

    
module duplet(dir=$x) { children(); move(eps*dir) mirror(dir) children(); }           // original+ left-mirrored image

/*
    - invert the (implicitly) convex profile defined by 'points'; return ts exterior as a profile
    - can't be done using poly; must do in a module by subtracting poly(points) from its bounds
    => need to create points' bounding rectangle

    border(points) = [LL, UR]; where LL & UR are lower left and upper right corners of the bounding rect 

NB: a point list is also a Nx2 matrix.; col2row would be useful


*/

/*************************************************************************************************************/
points = [[1, 1], [3,1], [2,2]];

inverse(points);











