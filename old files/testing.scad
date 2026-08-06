//Gridfinity testing
include <gridfinity.scad>

/*
//array(6,5) base_cell(); //grid_cell();
//base_cell();
//profile(true);
//cell(is_grid=true); move([0,0, 2*u]) cell();
// edge(is_grid=true);

delta = is_grid? GRID_WALL_DEPTH: GRID_WALL_WIDTH;
    if (is_grid) // extrude & position the grid edge
       move(delta*$down) rotate(90*$e2) extrude(amt) rotate (90*$e3) profile(is_grid); 
    else // extrude & position the base edge 
       rotate(90*$e2) extrude(amt) move(delta*$fwd) rotate(-90*$e3) profile(); 
edge(is_grid=false);

*/
move((0.65)*$right+$fwd) circle(.65);
move(.78*$right++1.8*$fwd) rotate((180+43.85)*$e3) square(.492,false);
move(1.5*$fwd) square([.78,.3], false);
square([.9,1.5+eps], false); 
