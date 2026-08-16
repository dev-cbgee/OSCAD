//oscad.scad
include <oscad_defs.scad>
include <math.scad>
include <point_ops.scad>
include <list_ops.scad>
include <stack_ops.scad>


module extrusion(arg, center=false){ let (h = arg[1], pts = center? centered(arg[2]) : arg[2]) 
    { if (debug) echo("extrusion:", arg=arg); extrude(h, center)  poly(pts); };
}

// arrange an MxN rectangular grid of children w/ vector spacing 'S'
module grid(M=1, N=1, S=$x+$y,center=false) {
    if(debug) echo("entering grid:", M=M, N=N, S=S, center=center);     
    let (ML = center? -(M-1)/2 : 0, MR = center?  (M-1)/2 : M-1,
         NB = center? -(N-1)/2 : 0, NT = center? (N-1)/2 : N-1) {
        echo(ML=ML,MR=MR,NB=NB, NT=NT); echo(S=S);
        for(i=[ML:MR], j=[NB:NT]) move(([i*S[0],j*S[1]])) children(); 
    }
    if(debug) echo("leaving grid:");     
}

//same as 'grid', but with parameters passed on a stack (a list)
module grid_s(stack) { //(M=1, N=1, S=U*[$x,$y],center=false) {
    let (M = stack[0][0], N=stack[0][1], spacing=stack[1],centering=stack[2],
         ML = centering? -(M-1)/2 : 0, MR = centering?  (M-1)/2 : M-1,
         NB = centering? -(N-1)/2 : 0, NT = centering? (N-1)/2 : N-1) {
        for(i=[ML:MR], j=[NB:NT]) move((i*spacing[0] +j*spacing[1])) children(); 
    }    
}

// like 'grid', but with R0 & dR in polar coordinates
module grid_p(R0,dR,M,N,center=true) {
    let( LR = center? ctr(0,M-1) : [0,M], BT = center? ctr(0,N-1) : [0,N] ) 
    {
        for (i=[LR[0]-LR[1]:(LR[0]+LR[1])], j=[BT[0]-BT[1]:BT[0]+BT[1]])
        let( r=[R0[0]+j*dr[0], R0[1]+i*dR[1]])  move_p(r) children();
    }
}
   

// move to polar coordinate z = '[r,w]'  !>: need to add 2D | 3D tests
module move_p(z, rot=true) { move(P2R(z)) rotate(rot ? z[1]:0) children();}

// place 'N' children along an arc, starting at R0 in increments of dR (all in polar form)
module arcn(R0,dR,N,rot=true){ for(i=[0:N-1]) move_p(R0+i*dR, rot)children();}

// place children along an arc, from R0  to RN, with spacing dR (all in polar form)
module arcl(R0,dR,RN,rot=true){ arcn(R0, dR, (RN[1]-R0[1])/dR[1],rot) children();}

// make a polar array of children
module fan(R0,dR,RN,center=true){ 
    let (M=1+(RN[1]-R0[1])/dR[1], N=1+((RN[0]-R0[0])/dR[0])) 
    grid_p(R0,dR,M,N,center) children();
}