// gridfinity.scad


include <math.scad>   // which includes oscad.scad
 
                                           /*^^^^^^^^^*\
==========================================/ DESCRIPTION \=================================================
 based on https://gridfinity.xyz/specification/

    > defines constants and various useful primitives
    
    constant / function / module name abbreviations, e.g., 'gfbp_h' denotes gridfinity baseplate height
        gf..    <==> 'gridfinity'
        ..bp..  <==> 'baseplate'; 'gfbp' is implied
        ..[w|W] <==> 'width' ('x' size)
        ..[l|L] <==> 'length'('y' size)
        ..[h|H] <==> 'height'('z' size)
        ..p     <==> 'profile'
        ..pl    <==> 'point list'
        ..r     <==> 'radius'
        ..d     <==> 'diameter'or 'depth', depending on context
        ..box   <==> 'containing box', as a 3- vector: [w, d, h]
        --[u|U] <==> 'unit'
        ..t     <==> 'thickness'


                                               /*^^*\
==============================================/ TODO \====================================================

    >: bins: lid, bottom, stacking lip


 /*^^^^^^^^^^^^^^^^^^^^*\
/ constants & parameters \==============================================================================*/
gf_u    = 7;
gf U    = 6 * gf_u; // standard width & length unit size
gf_H    = gf_u;     // standard height unit size
gf_W    = gf_U;
gf_L    = gf_U;
gf_box  = [gf_W, gf_L, gf_H];

 /*^^^^^^^^^^^^^^^^^^*\
/ baseplate parameters \--------------------------------------------------------------------------------*/
bp_h1 = u/10;       // 0.7  - all based on 'u'
bp_h2 = u*9/35;     // 1.8
bp_h3 = u*43/140;   // 2.15
bp_h4 = u*19/70;    // 1.9
bp_w  = h1+h3;      // baseplate width
bp_h  = h1+h2+h3;   // baseplate height
bp_H  = 5.0;        // specified total height of baseplate cell wall; top gets beveled in practice

//------------------------------
/*

BPP = [zero, [BPW,0], [h3,h1], [h3,h1+h2], [0,BPH]]; 
gclc    = .25;          // gridfinity 'clearance' (& thickness of lid's top layer)
gmgn    = sqrt(gclc);   // around borders of mating parts = 
gtop    = 5.0;          // total 'top' height
gflr    = 2*gclc;       // bottom floor layerthickness
gltp    = 5.0-gclc;    // top thickness
GFT = .5;    // floor thickness (work on this)

 /*^^^^^^^^^^^^^^^^*\
/ profile parameters \==================================================================================*/
/*
// taken from design reference at https://gridfinity.xyz/assets/img/spec_draft_willtree8.jpg
// units are in millimeters (mm)
u   = 7;    // standard height unit
U   = 6*u;	// standard horizontal unit
ptol = 0.25;         // profile 'tolerance'        

h0 = 5.0;           // total height of baseplate cell wall
h1 = u/10;          // 0.7  - all referred to 'u'
h2 = u*9/35;        // 1.8
h3 = u*43/140;      // 2.15
h4 = u*19/70;       // 1.9

BPH = h1+h2+h3;  // baseplate height
BPW = h1+h3;     // baseplate width
BPC = [BPW, BPH, BPW]*1.5;  // size of the corner block

BPP = [zero, [BPW,0], [h3,h1], [h3,h1+h2], [0,BPH]];                // baseplate profile points
//GLP = [zero, [0,h1], 

BPL = concat([for (i=[0:1:len(BPP)-2]) BPP[i]], [[0,h1+h2+h4]]);    // ?!?!  stacking lip points

 /*^^^^^^^^^^^^^^^^^^^^^^^^*\
/ snap connection parameters \==========================================================================*/
/*
SCW = 4.3/2;  SCH = 3.45; SCL = 4.0;  //[width, height,length]
URC = [SCW*2, SCH, SCL];    // upper right corner point of connector
KS  = [0.78, 1.8];          // [width, height] of main key slot
dKS = [.02,-1.3];           // "delta" to widen lower slot component
KSB = [0.65, [.65, 1,0 ]];  // [radius, [center point]] of bulge's circle 
KST = [224, .46];           // [angle, side] of tangent square 


/*
P       = URC/2;            // connector center point
R       = [P.x, P.y,0];     // P's projection onto x-y plane
TS      = [1.5, 1.9];       // [backoff%, ,size] of corner trim square
P_c     = E2C(P);
*/
 /*^^^^^^^^^^^^^^^^*\
/ profile generators \==================================================================================*/

// profiles are generated in XY.Q1, for extrusion along +Z axis
/*
module ep(ptlist=BPP) { poly(pts=ptlist); } // basic edge profile generator; defaults to gridfinity 


module hk(ks=KS, dk=dKS, ksb=KSB,kst=KST) { // "half key" profile -- for snap connector
    move([-2*eps,0]) {
        square(ks+eps*[0,4]);              // upper slot
        square(ks+dk);                   // widened lower slot 
        move(ksb.y) circle(ksb.x+eps);      // add the bulge
        move(ks) rotate((kst.x)*$z) square(kst.y);  // add upper right tangent square
    };
}

module sk() { duplet() hk(); }         // full "snap key" profile
module hh() { invert([SCW,BPH]) hk(); } // half "keyhole" profile
module sh() { duplet() hh(); }         // full "keyhole" profile

module ek() { 
    let ( basew=SCW+BPW-(SCW-h1+ptol), baseh=h1-ptol)//BPH-(SCH+ptol) ) 
    {
        //:! edge key depth = BPW -(SCW + ptol); floor height = h0 -(SCH +ptol)   
        move([0,baseh-2*eps]) hk(); square([basew, baseh]); 
    };  // edge key profile
}
//ek();

 /*^^^^^^^^^^^^^^^^*\
/ general primitives \====================================================================================*/
/*
// create a profile extrusion
module edge(length=U, points=BPP) { 
    //move(-(length+eps)*$z/2)
    extrude(length+2*eps) ep(points);
}

module test_ec(L=16) { 
    ZX2XY() 
    difference() {  
        edge(L);
        move([0, 0, (L-SCL)/2]) ecm();
    }
}
//test_ec();


module cell(sz=U) { // create a single cell in {XxZ}; use 'array' to make a grid
    module mk2() {duplet() move(-sz*($x+$z)/2) extrude(sz) ep(); }
    mk2(); RY() mk2(); 
}
 

 /*^^^^^^^^^^^^^^*\
/ snap connections \======================================================================================*/
/*
//rework this stuff to use 'doublet' & 'quad'

// right half of snap connector
module hsc(sz=URC, ks=KS, dk=dKS, ksb=KSB, kst=KST, chamfer=true) { 
    urc=[sz.x/2, sz.y, sz.z/2]; // adjusted upper right corner
    module cubie(s=[[2,2,.75], .9*urc+[0,.5,-.1]])//chamfer parameters -- [size, back-off ratio+delta]
            {move(s[1]) rotate(90, wedge([sz.x,sz.y,0],sz)) RX(36) cube(s[0], true); }
    module xsc(sz=URC, ks=KS, dk=dKS, ksb=KSB, kst=KST, chamfer=true)  // 1/4 connector, extruded & chamfered 
            { difference() { cube(urc); extrude(urc.z) hk(ks,dk,ksb,kst); if (chamfer) cubie(); ;} ;}
    duplet($z)xsc(sz,ks,dk,ksb,kst, chamfer);  // double up
}

//hsc();
// full snap connector -- TODO: work on the 'adjusting' functionality!!!
module sc(sz=URC, ks=KS, dk=dKS, ksb=KSB, kst=KST, chamfer=true)    
    { duplet($x) hsc(sz, ks, dk, ksb, kst, chamfer); }             // re-double

module ec (L=SCL) {extrude(L) ek(); }           // snappable edge connection
module ecm(L=SCL) {extrude(L) invert() ek();  } // snappable edge connection mold  

module imprint(P=U/2) {difference() {children(1); move([0,0,P-eps]) children(0); }; }

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

module mkgrid(xy,L=U,mink=false) {
    module _grid (xy,L=U) {ZX2XY() array(xy[0],xy[1]) cell(L);}
    if (mink) { $fn=20; minkowski() { _grid(xy,L); cylinder(r=.25,h=.125); } }
    else _grid(xy,L);
}

module snapgrid(xy,L=U,mink=false) {RZ() difference() {mkgrid(xy,L,mink); conxns(xy,L);} }
// mink screws up the connection points; need to rework it

                                                 /*^^*\                                         
================================================/ DONE \====================================================
    
    √: grid edge connection points.


                                          /*^^^^^^^^^^^^^^^^*\                                      
=========================================/ CONSTRUCTION ZONE  \===========================================*/

// >: create a lid by subtracting a base cell from a GFU 'cube', removing outeer 'collar
//ZX2XY() 
/*
difference() 
{ 
    dejust() 
    cube([U-,u+h1,U], center=true);  // in Z-X plane, 'Y' is up
    adjust(.025*ONES) cell(); 
}

*/



                                               /*^^^^^^*\                                      
==============================================/ SANDBOX  \================================================*/

/* OBE

//mgn     = MGN/2;
//MARGIN  = MGN*[1, 1,0];

// standard gridfinity units (in mm)
//GFU = [U,U,u];

*/
















