// gridfinity.scad

include <gf_defs.scad>     // includes scad_defs.scad
 
 /**********\
/ PUNCH LIST \********************************************************************************************

    √ using hull in 'gf_p()' doesn't seem to get distances right; need to investigate & resolve
        -- it does; projecting yields correct measurements;
        !?> shape is wrong, though: 'hull' misshapes gf_p()'s profile.
        ==> need to subtract a gf_p() - shaped edge ring from a  create an edge ring from 1gf_bo
    
    
    
    
    ?> could snap connections secure bins in baseplate?
    !> bins: lid, bottom, stacking lip
    !> use bitwise 'style' flags where useful
    !> expand 'grid' fcn to 3-D
    
    
 
// create a profile extrusion
//module polex(points=gf_p(), length=gfU, dir=$z, center=true) {  extrude(length,center) poly(points); }

//polex(length=16);

extrusion([16, gf_p()], center=true);


//cube(size=gf_box(),center=true);

/*
// create base from profile; saves render time by rotex only 90 deg
// !! problem: hull misshapes the profile; must make corners separately
module gf_profile(profile=gf_p(), size=gfU-(gftol+2*(H0+H3))) {    //36.3  default size=41.5
    hull() { quad() move([1,1]*size/2) rotex(90) poly(profile); }; 
} gf_profile();  
*/








                                 


  /*^^^^^^^^^^^^^^^^*\
 / profile generation \----------------------------------------------------------------------------------*/
 
// profiles are generated in X-Y plane, usually in Q1, for extrusion along +Z axis

// basic profile generator, a wrapper for 'poly'; defaults to gridfinity baseplate profile
//module gf_p(point_list=bp_p()) { if(debug) echo("gf_p in");  poly(point_list); if(debug) echo("gf_p out");}

// snap connection profiles
module sc_hkp(arg=kp_args()) {       // "half key" profile, the foundation
    let (ks=arg[0], dk=arg[1], ksb=arg[2], kst=arg[3]){
    if (debug) echo("entering sc_hkp",ks=ks,dk=dk,ksb=ksb,kst=kst);
        move([-eps,0]) {
            square(ks+eps*[0,4]);                                   // upper slot
            square(ks+dk+eps*[2,0]);                                // widened lower slot 
            move(ksb.y) circle(ksb[0]+eps);                         // add the bulge
            move(ks) rotate((kst[0])*$z) square(kst.y);             // add upper right tangent square
        };
    }
    if (debug) echo("leaving sc_hkp");
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
       

// √ ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

//!!> use a stack; reexamine 'floor' sizing
module sc_ek() {    // baseplate edge snap connector key profile
    let ( basew=sc_w+bp_w-(sc_w-bp_1), baseh=bp_1)
        { move([0,baseh-2*eps]) sc_hkp(); square([basew, baseh]); }
}





 /*"""""""*\
/ WORK ZONE \"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""*/

L=[1,2,3,4,5];

/*

    >idea now is to make a 1u bin / bottom using 'hull' approach, using subtractive combinations for final shaping;
    >then use a grid of bin bottoms subtracted from an MxN slab to create baseplate
    > finally, punch snap connection grid onto the baseplate
*/








//poly( additem(gf_p(),[0,.125]));

//poly(conj_x(gf_p()));
//poly(gf_p());


//hull() { grid(2,2, S=(gf_W-gfd_3-gf_tol)*[$x,$y], center=true)   cylinder(d2=gfd_3, d1=gfd_3-.7, h=.7);} //tapered lid part
//points=gf_p();


//echo(corners(gf_p()));
//echo(centrum(gf_p()));
//rotate_extrude() 


//mirror($z) 

//hull() { grid(2,2, S=(gf_W-gfd_3-gf_tol)*[$x,$y], center=true)   cylinder(d=gfd_3, h=gfu);}  // basic box
/*

xmax =(corners(gf_p())[1][1]);
poly( additem(-gf_p(), [xmax,0]));
*/




