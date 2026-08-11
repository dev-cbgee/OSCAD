// gridfinity.scad

include <oscad.scad>
//include <math.scad>   // which includes oscad.scad
 
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
        ..p     <==> ''profile'
        ..r     <==> 'radius'
        ..d     <==> 'diameter'or 'depth', depending on context
        ..box   <==> 'containing box', as a 3- vector: [w, d, h]
        --[u|U] <==> 'unit'
        ..t     <==> 'thickness'
        sc..    <==> 'snap connect(or|ion)'
        ec..    <==> 'edge connect(or|ion)'     
        
        
     use 'style' integer as a set of bit flags for various settings 
        -- snap connection, rounding, magnets, screwholes, etc.
        

                                               /*^^*\
==============================================/ TODO \====================================================

    !> bins: lid, bottom, stacking lip
    ?> could snap connections secure bins in baseplate?
    !> add 'style' marker to snappable baseplate edge argument list

 /*^^^^^^^^^^^^^^^^^^^^*\
/ constants & parameters \==============================================================================*/
    
    // 'u' and 'tol' are the only independent values; all others are based on them
    gf_u    = 7;                    // baseline reference unit
    gf_tol  = 2 * $dz;              // tolerance (0.5 mm)
    gf_t    = 1.0;                  // default wall & floor thickness (not in the spec)

    // general parameters (mm)
    gf_U    = 6 * gf_u;             // standard width & length unit size

    gf_W    = gf_U;                 // standard width
    gf_L    = gf_U;                 // standard depth
    gf_H    = gf_u;                 // standard height

    gf_box  = [gf_W, gf_L, gf_H];   // 1u base bounds
    
 
    // base profile
    gf_3    = gf_u*43/140;          // 2.15
    gf_2    = gf_u*9/35;            // 1.8
    gf_1    = gf_u*8/70;            // 0.8
    gf_h    = gf_1 + gf_2 + gf_3;   // 4.75
    gf_w    = gf_U - gf_tol;        // bin width, depth
    gf_f    = gf_w-2*(gf_1+gf_3);   // floor width, depth     (35.6)
    
    //base corner rounding
    gfd_3   = 7.5;                  // corner top outer diameter
    gfd_2   = 3.2;                  // corner middle diameter
    gfd_1   = 1.6;                  // corner bottom diameter
    
    // magnet & screw holes
    gf_xy   = 4.8;                  // internal x,y offset from base inside corners
    gfsh_d  = 3.0;                  // M3 screw hole diameter
    gfmh_d  = 6.5;                  // magnet hole diameter

    // baseplate grid profile
    bp_3    = gf_3;                 // 2.15
    bp_2    = gf_2;                 // 1.8
    bp_1    = gf_u/10;              // 0.7  - all based on 'u'
    bp_w    = bp_1+bp_3;            // baseplate width
    bp_h    = bp_1+bp_2+bp_3;       // baseplate height
    bp_H    = 5.0;                  // specified total baseplate cell wall height 

    // stacking lip
    sl_3    = gf_u*19/70;           // 1.9
    sl_2    = bp_2;                 // 1.8
    sl_1    = bp_1;                 // 0.7
    

 /*^^^^^^^^^^^^^^^\
/ snap connections \-----------------------------------------------------------------------------------*/ 

// these numbers were reverse engineered from the original '.stl' file, using OrcaSlicer
    //!! > insert file URL here

    sc_w    = 4.3;
    sc_h    = 3.45;
    sc_l    = 4.0;
    sc_box  = [sc_w, sc_h, sc_l];

    // key slot
    ks_w    = 0.78;                 // key slot width
    ks_h    = 1.8;                  // key slot height
    ks_box  = [ks_w, ks_h];         // [width, height] of main key slot
    ks_diff = [.02,-1.3];           // differential to widen lower key slot section
    ks_circ = [0.65, [.65, 1,0 ]];  // [radius, [center point]] of bulge's circle
    ks_tan  = [224, .46];           // [angle, side] of tangent square 

    // edge connector
    ec_l    = 4.0;                  // edge connector length
    
  /*^^^^^^*\
 / profiles \===========================================================================================*/

    //!!> add style options, signaled via binary flags
    //!!> lid
    //!!> stackable lip
    
    //gridfinity profile
    function gf_p()         = [zero, [gf_1+gf_3,0], [gf_3,gf_1], [gf_3,gf_1+gf_2], [0,gf_h]];
    
    // baseplate profile
    function bp_p()         = [zero, [bp_w,0], [bp_3,bp_1], [bp_3,bp_1+bp_2], [0,bp_h]]; 

    // edge extrusion list
    function bp_edge()      = ["baseplate edge extrusion", gf_U, bp_p()];

    // sc_key default argument [list | stack]
    function kp_args()      = [ks_box, ks_diff, ks_circ, ks_tan];
   
    // edge connector: width, floor thickness, extrusion length, baseplate profile point list
    function ec_p()         = [bp_w, gf_t, ec_l, bp_p()]; 


  /*^^^^^^^^^^^^^^^^*\
 / profile generation \----------------------------------------------------------------------------------*/
 
// profiles are generated in X-Y plane, usually in Q1, for extrusion along +Z axis

// basic profile generator, a wrapper for 'poly'; defaults to gridfinity baseplate profile
module gf_p(point_list=bp_p()) { if(debug) echo("gf_p in");  poly(point_list); if(debug) echo("gf_p out");}

// snap connection profiles
module sc_hkp(arg=kp_args()) {       // "half key" profile, the foundation
    let (ks=arg[0], dk=arg[1], ksb=arg[2], kst=arg[3]){
        if (debug) echo("sc_hkp in",ks=ks,dk=dk,ksb=ksb,kst=kst);
        move([-eps,0]) {
            square(ks+eps*[0,4]);                                   // upper slot
            square(ks+dk+eps*[2,0]);                                // widened lower slot 
            move(ksb.y) circle(ksb[0]+eps);                         // add the bulge
            move(ks) rotate((kst[0])*$z) square(kst.y);             // add upper right tangent square
        };
    }
    if (debug) echo("sc_hkp out");
}

// baseplate edge snap connector key profile
module  sc_ekp(arg=ec_p()){
    let(w=arg[0], h=arg[1]) {
        if (debug) echo("sc_ekp in",w=w,h=h);
        move([0,h]) sc_hkp(); square([w,h]);
    }
    if (debug) echo("sc_ekp out");
}

// edge key 'die' that makes an edge key when removed from 'edge'
module  bp_ek(arg=ec_p())  {extrude(arg[2]) difference() {poly(arg[3]); sc_ekp(arg);}; }

module  sc_keyp(stack=kp_args()) { duplet() sc_hkp(stack); }               // full "snap key" profile
module  sc_hhp (stack=kp_args()) { invert([sc_w, bp_h]) sc_hkp(stack); }   // half "keyhole" profile
module  sc_khp (stack=kp_args()) { duplet() sc_hhp(stack); }               // full "keyhole" profile
       
module  gf_edge(arg=bp_edge(), newlen=gf_U) { // replaces arg's length with newlen, because 'arg' is immutable
    extrusion( swap( push( pop( swap(arg)), newlen) ) );
}


// creates a baseplate edge with a centered snap connection key
module sc_edge(length=gf_U) { difference() {gf_edge(newlen=length); move([0,0,(length-ec_l)/2]) bp_ek(); };}

// module sc_ecp() {difference() { bp_p(); move([0,0.2]) sc_hkp(); square([bp_w, 0.2]); };}


// √ ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

module sc_ek() {    // baseplate edge snap connector key profile   //!!> use a stack
    let ( basew=sc_w+bp_w-(sc_w-bp_h1), baseh=bp_h1)
    {
        //:! edge key depth = bp_w -(sc_w); floor height = h0 -(sc_h)   
        move([0,baseh-2*eps]) hk(); square([basew, baseh]); 
    }
}


 /*^^^^^*\
/ sandbox \================================================================================================*/

//sc_edge(length=16);

//poly(gf_p());
sc_ekp();
//echo(ec_p());

 /*^^^^^^^^^^^^^^^^\
/ construction zone \=======================================================================================

    (x/2)%2 tests bit 1
*/

