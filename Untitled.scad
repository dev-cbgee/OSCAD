// gridfinity.scad


include <math.scad>   // which includes oscad.scad
 
                                           /*^^^^^^^^^*\
==========================================/ DESCRIPTION \=================================================
 based on https://gridfinity.xyz/specification/

    > defines constants and various useful primitives
    
    constant / function / module name abbreviations, e.g., 'gfbp_h' denotes gridfinity baseplate height
        gf..    <==> 'gridfinity'
        ..bp..  <==> 'baseplate'; 'gfbp' is implied
        ..w     <==> 'width' ('x' size); also ..W
        ..l     <==> 'length'('y' size); also ..L
        ..h     <==> 'height'('z' size); also ..H
        ..p     <==> ''profile'
        ..r     <==> 'radius'
        ..d     <==> 'diameter'or 'depth', depending on context
        ..box   <==> 'containing box', as a 3- vector: [w, d, h]
        -- u    <==> 'unit'; also 'U'
        .. t    <==> 'thickness'


                                               /*^^*\
==============================================/ TODO \====================================================

    >: bins: lid, bottom, stacking lip


 /*^^^^^^^^^^^^^^^^^^^^*\
/ constants & parameters \==============================================================================*/

    gf_u    = 7;
    gf_U    = 6 * gf_u;         // standard width & length unit size
    gf_H    = gf_u;             // standard height unit size
    gf_W    = gf_U;             // standard width unit size
    gf_L    = gf_U;             // standard lenth unit size
    gf_box  = [gf_W, gf_L, gf_H];

 /*^^^^^^^^^^^^^^^^^^*\
/ baseplate parameters \--------------------------------------------------------------------------------*/
    bp_h1 = u/10;               // 0.7  - all based on 'u'
    bp_h2 = u*9/35;             // 1.8
    bp_h3 = u*43/140;           // 2.15
    bp_h4 = u*19/70;            // 1.9
    bp_w  = bp_h1+bp_h3;        // baseplate width
    bp_h  = bp_h1+bp_h2+bp_h3;  // baseplate height
    bp_H  = 5.0;                // specified total baseplate cell wall height 

// paseplate profile point list
    bp_p = [zero, [bp_w,0], [h3,h1], [h3,h1+h2], [0,bp_h]]; 
