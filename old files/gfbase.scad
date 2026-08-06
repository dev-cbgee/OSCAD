// gfbase.scad -- 
include <gridfinity.h.scad>
                                            /*^^^^^^^^^*\
===========================================/ DESCRIPTION \=================================================

  - modules for constructing gridfinity baseplates,including snap connections for joining them. 
    (I'll be using 5x6 & 5X5 cell grids as my basic grid sonfiguration elements.)

  - includes several supporting functions, modules & operators that should probably be in gridfinity.h.scad


                                                /*^^*\                                         
===============================================/ TODO \====================================================
 
   - beveled ends to edge, eg for mitered corners; 
   - add rounding with specified radius to beveled corners
   - add filleted corners, accounting for margins & fudge factor as needed
 
 
                                           /*^^^^^^^^^^^^^^^^*\                                      
==========================================/ CONSTRUCTION ZONE  \==========================================*/


                                               /*^^^^^^*\                                      
==============================================/ SANDBOX  \================================================*/
//move([SCW/2,0,0]) sc();       // uncomment for printing 1 connector
//array(4,3,SCW*1.25) move([SCW/2,0,0]/*[0,0,SCL/2]*/) sc();  // uncomment for printing 12 connector array
//snapgrid([6,5]);  // uncomment for printing a 6x5 baseplate grid with snap connections

//.........................................................................................................
       
                                                 /*^^*\
================================================/ DONE \====================================================

    √: create 'imprint' operator to imprint a mold object onto an extruded target object
        :: imprint(P) { mold_object(); target_object(); }  
           -- P is the 'z' coordinate of the target location, default=0
           -- the scop braces are necessary! mold is children(0), target is children(1)

   √: create simple grid boundary for a given grid size and spacing, defaults to 5x6 and 'U'
      : create operators to perform desired positioning, orienting and decorating.
      : create grid of snap connector points around the border for imprinting
      : possibly 'flatten' the  grid a bit to soften the sharp corner at the top


                                                 /*^^^\                                      
================================================/ OBE  \====================================================
module bp_boundary(size=[6,5], L=U) { Lx = size[0]*L;  Ly = size[1]*L;
    module mk2(a,b) {move($down*a/2) duplet() move($left*b/2) edge(a);}
    module boundary() { mk2(Ly,Lx);  RY()mk2(Lx,Ly); }
    boundary();
}
//bp_boundary([1,1],U);

module corner_block(dx=BPW, dy=BPH, dz=BPW) { move(-$eps) cube([dx,dy,dz]+2*$eps); }  // <----
//corner_block();

module bp_corner(dw=90, w0=0) {turn(dw, w0) move(BPW*$right) mirror() ep();}
//bp_corner();

module bp_border(M, N, L=U) { X = M*L/2+eps; Z = N*L/2; 
    difference() {{ bp_boundary([M,N],L);} { quad($x,$z) duplet() move(-[X,0,Z]) corner_block();};};
    //quad($x,$z) move(-[X-BPW,0,Z-BPW]) RX(-90) bp_corner(dw=90, w0=90);
}


/*========================================================================================================*/




