
include <oscad.scad>



                                               /*^^^^^*\                                      
==============================================/ SANDBOX \================================================*/
/**/ 

/*
function pl_arrowshaft(w=4,h=1) = [[0,h],[w,h], [w,-h], [0,-h]]; 
function pl_arrowhead(w=4,h=1)  = [[0,h],[w,0], [0,-h,]];
//poly(pl_arrowshaft());
//poly(pl_arrowhead(), [2,1]);
*/

L1 = [1,2,3,4,5]; L2=[function(stack) add(stack),3,2,1];
List = [[0,10],[99,20],[0,30]]; item=[1,0];
M9 = [ [1,2,3], [4,5,6], [7,8,9] ];
r0=[1, 45]; rN=[2,135]; dr = [.2,10]; N=(rN[1]-r0[1])/dr[1]; S = .5*[$x,$y]; U=2;


/// √ echo(push([],"test"));

/*
fcn = function(stack) add(stack);
echo( top(L1)(pop(push(L1,fcn))));
echo(add(L1));
echo(push(L1,fcn)[0](L1));  // ==> ECHO: [3, 3, 4, 5]
echo(top(L2)[0]);           // ==>ECHO: function(stack) add(stack)
echo(L2[0](pop(L2)));       // ==>ECHO: [5, 1]
echo(top(L2)(pop(L2)));     // ==>ECHO: undef WARNING: Can't call function on vector ...
echo(top(L2)[0](pop(L2)));  // ==>ECHO: [5, 1]
*/
//function exec(stack) = stack[0](pop(stack));
//echo(over(L1,3));
//fan([2,45], [.5,5 ], [4,90]) square([.15,.1],center=true);

//arcn (r0, dr, N) square([.2,.1],center=true);
//arcl(r0,dr,rN) square([.2,.1],center=true);
//grid(5, 4, S, center=true ) square([.2,.1],center=true);
//grid_s( [[5,4],.5*[$x,$y],[false]] ) square([.2,.1],center=false);
//fan(r0,dr,5,4) square([.1,.1],center=true);

