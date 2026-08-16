  // oscad_defs.scad

                                            /*^^^^^^^^^*\
===========================================/ DESCRIPTION \=================================================
Minimal, general Open SCAD (OSCAD) support parameters,functions and operators


                                         /*^^^^^^^^^^^^^^*\
========================================/ GENERAL CONCEPTS \===============================================

    Open SCAD is a functional programming language, so names map to values or other objects. 
        - values are immutable; there is no concept of 'variable' in the usual sense
        - what may appear like a variable is more like the usual idea of a constant
            -- within a given scope, the last value mapped to a name persists; i = i+1; has no effect, e.g.
            -- a name reused in a subordinate scope doesn't affect a same-named value in an ancestral scope
        - they mostly serve to parameterize modules
        - except for 'eps' most general value names will begin with '$'

    in general, all basic values will be defined in an .scad file that is 'included' where needed.
        - all functions and modules will be defined in files to be 'used' where needed.
            -- though it's possible to add definitions within functions, it's better to build more 
            complex structures that consistently use named values from (included!) definition files.
            This consistency makes for easier debugging. You can always put defining functions in
            a definition file.
            
        - some trivial (re)naming and operation definitions here can simplify and clarify later code

     useful characters:  √ ε ρ φ θ

 /******************\
/ general parameters \__________________________________________________________________________________________*/

debug       = false;            // 'true' enables selected diagnostics

nozzle_d    = 0.4;              // 3D printer nozzle diameter
$thk        = 2 * nozzle_d;     // default wall and floor thickness
$dz         = 0.25;             // "tolerance; dead zone between mating parts
$fn         = 60;               // # of pie slices (6 deg, ea )
$sf         = 1;                // 1:$sf scale factor, i.e., 1 OSCAD unit = $sf physical units.
$max        = 10000;            // 10^4 (10 meters, when $fs==1 (defaul)
eps         = 10/$max;          // ε, an offset to trivially overlap connecting adjacent objects


 /*****************\
/ special constants \__________________________________________________________________________________________*/

zero        = [0,0];      $origin  = zero;     // 2-D
ZERO        = [0,0,0];    $ORIGIN  = ZERO;     // 3-D

// created by  function call, per functional programming approach

function $ones(N=3)  = [for (i=[1:N]) 1];           // outer corner of a unit 'cube'
function $zeros(N=3) = 0 * $ones(N);                // general N-space origin
function $e(i, N=3)  = [for (j=[1:N]) j==i? 1:0];   // unit coordinate vector 'i' in N-space
function $I(N=3)     = [for(i=[1:N]) $e(i,N)];      // identity matrix    

$x = $e(1);    $y = $e(2);     $z =$e(3);           // the x,y,z axis vectors
$left=$x; $right= -$left; $fwd=$y; $bkwd = -$fwd;  $up = $z; $down = -$up;

function $eps(N=3)   = eps * $ones(N);


 /****************************\
/ essential operations aliases \________________________________________________________________________________*/
   
// !!>: add the additional argument defaults below

module poly(points) { polygon(points); } 

module move(r) {translate(r) children();}   // r is element of RN, N= 2|3

module extrude(height=1, center=true)  //TODO: lotsa stuff...
   { linear_extrude(height=height, center=center) children(); }

module extrusion(arg, center=false){ let (h = arg[1], pts = center? centered(arg[2]) : arg[2]) 
    { if (debug) echo("extrusion:", arg=arg); extrude(h, center)  poly(pts); };
}

module rot(a=180, v=$z) { rotate(a=a, v=v) children(); }

module rotex(angle=360, convexity=2)   // start= requires development build of OSCAD
   { rotate_extrude(angle=angle, convexity=convexity) children(); } 




















