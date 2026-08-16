include <gridfinity.scad>       //!! re-examine sc_ekp() floor stuff


 /*^^^^^^^^^^^^^^^^\
/ !!! WORK ZONE !!! \***************************************************************************************/


module  gf_edge(arg=bp_edge(), length=gf_U) { // replaces arg's length, because 'arg' is immutable
    extrusion( swap( push( pop( swap(arg)), length) ) );
}
// creates a baseplate edge with a centered snap connection key
module sc_edge(length=gf_U) { difference() {gf_edge(newlen=length); move([0,0,(length-ec_l)/2]) bp_ek(); };}

// module sc_ecp() {difference() { bp_p(); move([0,0.2]) sc_hkp(); square([bp_w, 0.2]); };}




//***********************************************************************************************************


//sc_edge(newlen=16);

//poly(gf_p());
//echo(ec_p());

echo($fn=$fn);
