// gridfinity.scad

include <defs.scad>
include <gfbase.scad>


module gprof() { polygon(BPP);}


/*
module corner (is_male=true){ rotate_extrude(angle = 90, convexity=2) profile(is_grid); }

module edge(amt=U, is_male=true) { // creates edge along x axis in quanddrant 1 or 3
        delta = is_male? GFWW: GFWD;
        if (is_male) // extrude & position the base edge
            rotate(90*$e2) extrude(amt) move(delta*$fwd) rotate(-90*$e3) profileM(); 
        else // extrude & position the grid edge 
            move(delta*$down) rotate(90*$e2) extrude(amt) rotate (90*$e3) gprof(); 
}

//TODO: base on profile poly
//TODO: filleted corners, account for margins & fudge factor, add snaps points on outside walls
module grid_cell(size=U) {
    rotate(90*($e1+$e3)) extrude(size, $e3) profile(true);
    move($fwd*(size))  mirror($e2) rotate(90*($e1+$e3)) extrude(size, $e3) profile(true);
    rotate(90*$e3) mirror($e2) rotate(90*($e1+$e3)) extrude(size, $e3) profile(true);
    move($right*(size)) rotate(-90*$e3) mirror($e1) mirror($e2) rotate(90*($e1+$e3)) extrude(size, $e3) profile(true);
}



//TODO: filleted corners, account for margins & fudge factor
//DONE: bottom
module base_cell(size=U, depth=GFWD, wall=GFWW, bottom=GFBFT) {  

    move($fwd*wall + $right*(size-wall)) mirror($e3) rotate(90*($e3-$e1)) extrude(size-wall*2) profile();
    move($fwd*wall + $right*(size-wall)) rotate(90*$e1+180*$e3)  extrude(size-wall*2) profile();
    move($fwd*(size-wall) + $right*(size-wall)) rotate(90*($e1-$e3)) extrude(size-wall*2) profile();
    move($fwd*(size-wall) + $right*wall) rotate(90*($e1)) extrude(size-wall*2) profile();
    // add bottom
    move([wall, wall,-depth]) extrude(bottom) square(size-2*wall, false);
    move([wall, wall,-bottom]) extrude(bottom) square(size-2*wall, false);
}

module cell(size=U, depth=GFWD, wall=GFWW, bottom=GFBFT,is_male=true) {
    if(is_grid) grid_cell(size); else base_cell(size, depth, wall, bottom);
}
*/
    

