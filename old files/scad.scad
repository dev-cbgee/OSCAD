  // scad.scad 
debug = true;         // flag to trigger tests within modules during review/render false; // 
  
include <scad_defs.scad>
use <math.scad>
use <scad_ops.scad>
use <point_ops.scad>
use <list_ops.scad>
/*
use <stack_ops.scad>


use <vectors.scad>
use <matrices.scad>
use <geo_algebra.scad>
*/

// ! > include appropriate asserts and debug actions


/* some simple but very useful 'helper' routines *\=========================================================*

 /*^^^^^^^^^^^^^^*\
/ aliases & extras \======================================================================================*/





/*
*/


                                            /*^^^^^^^^^*\
===========================================/ DESCRIPTION \=================================================


                                         /*^^^^^^^^^^^^^^*\
========================================/ GENERAL CONCEPTS \===============================================

    
 /*^^^^^^^^*\
/ parameters \===========================================================================================*/



 /*^^^^^^^^^^^^^^^*\
/ special constants \====================================================================================*/

                                               /*^^*\
==============================================/ TODO \=====================================================
    !>  function invert(points) = 'photo' negative of 'points' when fed to 'poly'
    
    > structure and economize assertion testing 
    > use stack to pass args to modules (& functions?)  
        => just do: fcn([arg1,arg2, ...]); => can use stack ops inside fcn!
    > add 'assert' internal validity checks of parameters, etc.,  to list & point operations
----------
    √ rethink stack operations -- add & subtract should return modified stack as result


=========================================================================================================*/
