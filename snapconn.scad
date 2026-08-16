//snapconn.oscad

include <gridfinity.scad>

                                            /*^^^^^^^^^*\
===========================================/ DESCRIPTION \=================================================

    snap connector modules for interconnecting gridfinity base grid sections
    
    possibly also for securing bins in the grid


                                         /*^^^^^^^^^^^^^^*\
========================================/ GENERAL CONCEPTS \===============================================

There are two ways to approach making snappable grids
    1. build the grids out of individually styled 'edges'
    2. build a grid with vanilla edges, then subtract the edge grid pattern you want.
    
    gonna go with approach '2'.
    
=========================================================================================================*/

// make connection points for left & right grid edges
module pairsLR(xz, S=1) { M=xz[0]; N=xz[1];  // ([M,N], scale factor)
    module pairLR(xz,S=1) {x=S*xz[0]-8*eps; z=S*xz[1]-SCL/2; duplet() move([x,0,z])  children(); }
    if (N%2==0) pairLR([-M/2,0],S) ecm();
    n0=(N%2==0)?0:.5;  
    for (n=[n0:(N-1-n0)/2]) if (n!=0) duplet($z) pairLR([-M/2,-n],S) ecm();
}
    
// make connection points for bottom& top grid edges
module pairsBT(xz, S=1) { M=xz[0]; N=xz[1];// ([M,N], scale factor)
    module pairBT(xz,S=1) {x=S*xz[0]+SCL/2; z=S*xz[1]-8*eps; duplet($z) move([x,0,z]) RY(-90) children(); }
    if (M%2==0) pairBT([0,-N/2],S) ecm();
    m0=(M%2==0)?0:.5;  
    for (m=[m0:(M-1-m0)/2]) if (m!=0) duplet() pairBT([-m,-N/2],S) ecm();
}

module conxns(xz, S=1) {ZX2XY() { pairsLR(xz,S);  pairsBT(xz,S); } }

module mkgrid(xy,L=gf_U,mink=false) {
    module _grid (xy,L=gf_U) {ZX2XY() array(xy[0],xy[1]) cell(L);}
    if (mink) { $fn=20; minkowski() { _grid(xy,L); cylinder(r=.25,h=.125); } }
    else _grid(xy,L);
}

module snapgrid(xy,L=U,mink=false) {RZ() difference() {mkgrid(xy,L,mink); conxns(xy,L);} }
// mink screws up the connection points; need to rework it

mkgrid(5,4);


















