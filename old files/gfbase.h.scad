// gfbase.h.scad -- 

include <gridfinity.h.scad> // includes math, etc

                                         /*^^^^^^^^^^^^^^^^*\
========================================/ profile generators \=========================================*/
// profiles are generated in XY.Q1, to be extruded along +Z axis

module profile(ptlist=BPP) {poly(pts=ptlist);}  // basic profile generator, defaults to gridfinity 

module hk(ks=KS, dk=dKS, ksb=KSB,kst=KST) {     // "half key" -- fundamental 2D snap key profile
        move(-3*[eps,eps]) {square(ks+2*eps*[0,1]); square(ks+dk+2*$eps); };// slots -- upper, widened lower
        move(ksb.y) circle(ksb.x+eps);                                      // add the bulge
        move(ks) rotate((kst.x)*$z) square(kst.y);                          // add upper right tangent square
}
//hk();
/*==================================================================================================
gridfinity baseplate stuff

modules for constructing gridfinity baseplates,including snap connections for joining them. 
(I'll be using a 5 x 6 cell grid as the basic sonfiguration.)

TODO:  create lip & lid profiles; incorporate them in main profile(s)

==================================================================================================*/

module _edge(sz=U, ptlist=BPP) { extrude(sz) poly(pts=ptlist);} 
//_edge();

//=======================================================================================================
// snap connections



module sk() { hk(); mirror($left) hk(); }   // full "key" profile

module sh(sz=[URC.x/2,URC.y]){ hh(sz); mirror($left) hh(sz); }  // full "keyhole" profile


module hsc(sz=URC, ks=KS, dk=dKS, ksb=KSB, kst=KST, chamfer=true) {  // snap connector's right half 
    urc=[sz.x/2, sz.y, sz.z/2]; // adjusted upper right corner
    module cubie(s=[[2,2,.75], .9*urc+[0,.5,-.1]])//chamfer parameters -- [size, back-off ratio+delta]
        {move(s[1]) rotate(90, wedge([sz.x,sz.y,0],sz)) rotate(36*$x) cube(s[0], true); }
    module xsc(sz=URC, ks=KS, dk=dKS, ksb=KSB, kst=KST, chamfer=true)  // 1/4 connector, extruded & chamfered 
        { difference() { cube(urc); extrude(urc.z) hk(ks,dk,ksb,kst); if (chamfer) cubie(); ;} ;}
    xsc(sz,ks,dk,ksb,kst, chamfer); mirror($z) xsc(sz,ks,dk,ksb,kst, chamfer);  // double up
}
hsc();

module sc(sz=URC, ks=KS, dk=dKS, ksb=KSB, kst=KST, chamfer=true) // full snap connector
    { hsc(sz, ks, dk, ksb, kst, chamfer); mirror($x) hsc(sz, ks, dk, ksb, kst, chamfer); } // re-double
sc(); //chamfer=false);
    
module _ec() {difference() { gfprof(); union() { move([0,0.2]) hk(); square([BPW, 0.2]); }; };}

module ec(L=0) { if (L>0) extrude(L) _ec(); else _ec(); }
//ec();

module edge(L=U, snap=zero) // snap = [width, offset]
    { difference() { _edge(L); move([0,0,(snap[1]-SCL/2)]) ec(snap[0]); }; }


//.........................................................................................
// move([0,0,SCL/2]) sc();                      // uncomment for printing 1 connector
// array(4,3,SCW*1.25) move([0,0,SCL/2]) sc();  // uncomment for printing 12 connector array


                                              /*^^^^^^^*\                                         
=============================================/ TODO List \==================================================

    - beveled ends to edge, eg for mitered corners; 
    - add rounding with specified radius to beveled corners
    - add filleted corners, accounting for margins & fudge factor as needed
 


                                           /*^^^^^^^^^^^^^^^^*\                                      
==========================================/ CONSTRUCTION ZONE  \==========================================*/
//  brute force solution:
module cell(L=U, snap=zero) {
    module edges(s=L,sn=snap) { edge(s,sn);  move([s, 0, 0]) mirror($x) edge(s,sn);} 
    edges(L,snap);  move([L, 0, 0]) rotate(-90,$y) edges(L,snap); 
}
// alternate brute force method; could also try recursion  
    /*vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
    module edges(s=L,sn=snap) { edge(s,sn);  move([0, 0, s]) rotate(90, $y) edge(s,sn);} 
    edges(L,snap); mirror(-$x+$z) edges(L,snap);
   //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*/ 



    

//ZX2XY() cell(U);//, [4,U/2]);
//array(3,4,U) move([0, U, 0]) rotate(90, $x) cell(snap=[4,U/2]); // places cell in Q1, resting on x-y plane
   
module __edge(L=U) { 
    move(-$z*L/2) 
    union(){ 
        edge(L/2);
        turn() gfprof();
    };
}

// echo(xp([[1,2,3]]));

//negative(BPP,[1.2, .25],.75);


//========================================================================================================*/

//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
// backups, discard when aged out
/*
*/









