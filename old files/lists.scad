// lists.scad

use <misc_ops.scad>

 /*^^^^^^^^^^^^^*\
/ list operations \======================================================================================*/
//!>: add assertion test(s) for valid conditions


// insert 'item' at the front of 'list'
function push(list,item) = 
    assert(!is_undef(list) && len(list)>= 0, "bad list!") 
    [for(N=len(list), i=[0:N]) (i==0)? item : list[i-1]];

// insert 'list2' to front of  of the 'list'
function pushl(list,list2) = concat(list2,list);

// return first 'n' items of the list as a sub list.
function head(list,n=1)  = (is_undef(list) || is_undef(len(list)))? undef : 
    n==len(list)? list : n<=0? [] : [for(m=mod(n,len(list)), i=[0:m-1]) list[i]]; 
        
// remove first 'n' items from list, just one by default
function pop(list, n=1) = let(N=len(list))
    assert(N>0, "empty stack!") 
    assert(0<=n && n<N, "'n' out of range!")
    (n<0 || n>=N)? undef : [for (i=[n:N-1]) list[i]];

// item 'n' jumps over preceding items to the front of the 'list'
function over(list,n=1) = let (N=len(list)-1) (n<0)? undef : (n>=N)? undef:
    [for(i=[0:N]) (i==0)? list[n]:(i<=n)? list[i-1] : list[i]];  


// ------------------------------


// returns last 'n' items of the list as a sub list : list[m .. N-1]
function tail(list,n=1) = (is_undef(list) || is_undef(len(list)))? undef : 
    n==len(list)? list : n<=0? [] : [for(N=len(list), m=mod(N-n,N), i=[m:N-1]) list[i]];

function chop(list, n=1) = // remove last 'n' items from list: list[0. . N-n
    (n<0 || n>len(list))? undef : n==len(list)? [] : [for (N=len(list)-1, i=[0:N-n]) list[i]];
        
// returns original, split into a pair of sub-lists: [ list[0..n-1], list[n..N-1] }
function split(list,n) = [head(list,n), pop(list,n)];

// add 'item' to each element of list, when '+' is defined
// !:  adding -(list[0] esseentially translates point list to the origin, moving its implied polygon
function additem(list,item) = [for (N=len(list),i=[0:N-1]) list[i]+item]; 

//replace list[n] with item
function putitem(list,item,n) = [for (N=len(list),i=[0:N-1]) (i==n)? item : list[i]]; 

// make a 1-D list from a column in an N-D list; NB: a points list is a Nx2 matrix  
function getcol(list,col) =  [for(N=len(list)-1, i=[0:N]) list[i][col]];


// make the  1-D 'newcol' a new column of the matrix 'list'
function addcol(list,newcol) = [for (row=[0:len(list[0])-1]) additem(list[row],newcol[row])]; 

// append L2 to L1, treating last(L1) as L2's new origin => can turn two segments into a new polygon
function append(L1, L2) = concat(L1,  list_add(L2, last(L1) ));   

