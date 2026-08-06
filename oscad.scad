  // oscad.scad 
 
                                            /*^^^^^^^^^*\
===========================================/ DESCRIPTION \=================================================
Minimal, general Open SCAD (OSCAD) support parameters,functions and operators


                                         /*^^^^^^^^^^^^^^*\
========================================/ GENERAL CONCEPTS \===============================================

 !: OSCAD values are considered immutable; there is no concept of 'variable' in the usual sense
    - what may appear to be a variable is merely a name that maps to a value
        !: a name may be reused (mapped to a new value) within a subordinate scope; it doesn't persist
    - they mostly serve to parameterize modules
    - except for 'eps' most general value names will begin with '$'

 !: some trivial (re)naming and apparently trivial operations here can simplify later code
 
    
 /*^^^^^^^^*\
/ parameters \===========================================================================================*/

$fn  = 60;      // # of segments comprising the circumference of a "circle"
$sf  = 1;       // 1:$sf scale factor, i.e., 1 OSCAD unit = $sf physical units.
$max = 10000;   // 10^4 (10 meters, when $fs==1 (defaul)
eps = 10/$max;  // ε, OSCAD offset to effect a trivial overlap connecting adjacent objects

 /*^^^^^^^^^^^^^^^*\
/ special constants \====================================================================================*/

// unit coordinate vector 'i' in N-space
function $e(i, N=3) = [for (j=[1:N]) j==i? 1:0];

// the x,y,z axis vectors
$x = $e(1);    $y = $e(2);     $z =$e(3);

function $ones(N=3)  = [for (i=[1:N]) 1];

function $zeros(N=3) = 0 * $ones(N); 

function $eps(N=3)   = eps * $ones(N);

use <misc_ops.scad>
use <lists.scad>
use <stacks.scad>
use <vectors.scad>
use <matrices.scad>
use <geo_algebra.scad>
/*
*/

                                               /*^^*\
==============================================/ TODO \=====================================================
    !>:structure and economize assertion testing 
    !>:use stacks to pass parameters to modules (& functions?)  
    >: add internal validity checks of parameters, etc.,  to list & point operations
    >: rethink stack operations -- add & subtract should return modified stack as result


=========================================================================================================*/
