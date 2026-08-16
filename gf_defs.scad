// gf_defs.scad

include <oscad.scad> 

 /***********\
/ DESCRIPTION \____________________________________________________________________________________________

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
        

 /**********\
/ parameters \____________________________________________________________________________________________*/
    
    // 'u' and 'tol' are the only independent values; all others derive from them
    gftol = 2 * $dz;          // tolerance (0.5 mm), based on OSCAD 'dead zone'
    gfu   = 7;                // baseline reference unit
    gfU   = 6 * gfu;          // standard width & length unit size
    gft   = 1.0;              // default wall & floor thickness (not in the spec)

    // profile height parameters
    H0    =  gfu * 8/70;     // 0.8
    H1    =  gfu / 10;       // 0.7
    H2    =  gfu * 9/35;     // 1.8
    H3    =  gfu * 43/140;   // 2.15
    H4    =  gfu * 19/70;    // 1.9 ,  for lid, lip

    Hmax  =  gfu - 2;        // 5

    //corner rounding
    D0    =  8.0;             // baseplate corner
    D1    =  1.6;             // base bottom diameter
    D2    =  3.2;             // base middle diameter
    D3    =  7.5;             // base top outer diameter

    // base hole parameters
    HXY   =  4.8;             // hole center offset
    MHD   =  6.5;             // magnet hole diameter
    SHD   =  3.0;             // M3 screw hole diameter



  /*******************\
 / profile point lists \______________________________________________________________________________________*/

// use function calls instead of named values

// !!> add style options, signaled via binary flags
// !!> lid
// !!> stackable lip

function gf_box(sz=gfU-gftol) = [sz,sz,gfu];
function sc_box()             = [sc_w, sc_h, sc_l];

// base profile  (forms the bottom of a bin)
function gf_p(h1=H0, h2=H2, h3=H3, h=Hmax) =  let (x1=h1, y1= h1, x2= x1+h2, y2=y1+h2, y3=y2+h3)
    [ zero,[x1,y1], [x1,y2], [x2,y3], [0,y3] ] //, [x2, h], [0,h] ]
; //echo(gf_p()); projection(cut=false) rotex(90) poly(gf_p());

// stacking lip profile
function sl_p(h1=H1, h2=H2, h3=H4) =  let( x1=h1, x2=h3, y1=h1, y2=y1+h2, y3=y2+h3)
    [zero, [x1,y1], [x1,y2], [x2,y3], [0,y3]]
; //echo(sl_p()); poly(sl_p());

// baseplate profile
function bp_p(h1=H1, h2=H2, h3=H3) = 
    let( x1=h1+h3, x2=h3, y1=h1, y2=y1+h2, y3=y2+h3)
    [zero, [x1,0], [x2,y1],[x2,y2], [0,y3]]
; //echo(bp_p()); poly(bp_p());

// returns an extrusion list [length, style, profile] for extruding a gridfinity edge
function gf_edge(length=gfU, style=0, profile=gf_p()) = [length,style, profile];

 // edge extrusion list  //???
 function bp_edge()      = ["baseplate edge extrusion", gf_U, bp_p()];



 /****************\
/ snap connections \__________________________________________________________________________________________*/
   

// these parameters were reverse engineered from the original '.stl' file, using OrcaSlicer
// !! > insert file URL here
    
    // snap connector width, height, length: (x,y,z) extent
    sc_w    = 4.3;
    sc_h    = 3.45;
    sc_l    = 4.0;

    // key slot parameters
    ks_w    = 0.78;                 // key slot width
    ks_h    = 1.8;                  // key slot height
    ks_box  = [ks_w, ks_h];         // [width, height] of main key slot
    ks_diff = [.02,-1.3];           // differential to widen lower key slot section
    ks_circ = [0.65, [.65, 1,0 ]];  // [radius, [center point]] of bulge's circle
    ks_tan  = [224, .46];           // [angle, side] of tangent square 

    // edge connector
    ec_l    = sc_l+2*eps;           // edge connector length

  /*******************\
 / snap argument lists \______________________________________________________________________________________*/
    
// edge connector: width, floor thickness, extrusion length, baseplate profile point list
function ec_p()         = [bp_w, gf_t, ec_l, bp_p()]; 

// sc_key default argument [list | stack]
function kp_args()      = [ks_box, ks_diff, ks_circ, ks_tan];

/*____________________________________________________________________________________________________________*/
 
  

