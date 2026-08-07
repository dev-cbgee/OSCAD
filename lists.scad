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

// remove first 'n' items from list
function pop(list, n=1) = let(N=len(list))
    assert(N>0, "empty stack!") 
    assert(0<=n && n<N, "'n' out of range!")
    (n<0 || n>=N)? undef : [for (i=[n:N-1]) list[i]];

// item 'n' jumps over preceding items to the front of the 'list'
function over(list,n=1) = let (N=len(list)-1) (n<0)? undef : (n>=N)? undef:
    [for(i=[0:N]) (i==0)? list[n]:(i<=n)? list[i-1] : list[i]];  


 /*^^^^^^^^^^^^^^^^^^^^^^^^*\
/ from a 'stack' perspective \===========================================================================*/

function dup(stack) = assert(len(stack)>0,"empty stack!") push(stack, stack[0]);

function swap(stack)= push(push(drop(stack,2),stack[0]),stack[1]);

// a synonymous nod to HP RPN & FORTH
function drop(stack, n=1) = pop(stack,n);   

// ------------------------------

// return first 'n' items of the list as a sub list.
function head(list,n=1)  = (is_undef(list) || is_undef(len(list)))? undef : 
    n==len(list)? list : n<=0? [] : [for(m=mod(n,len(list)), i=[0:m-1]) list[i]]; 
        
function top(stack, n=1) = head(stack,n); // synonym for 'first', viewing list from a stack perspective

// returns last 'n' items of the list as a sub list : list[m .. N-1]
function tail(list,n=1) = (is_undef(list) || is_undef(len(list)))? undef : 
    n==len(list)? list : n<=0? [] : [for(N=len(list), m=mod(N-n,N), i=[m:N-1]) list[i]];

function chop(list, n=1) = // remove last 'n' items from list: list[0. . N-n
    (n<0 || n>len(list))? undef : n==len(list)? [] : [for (N=len(list)-1, i=[0:N-n]) list[i]];
        
// returns original, split into a pair of sub-lists: [ list[0..n-1], list[n..N] }
function split(list,n) = [head(list,n), pop(list,n)];

// add 'item' to each element of list, when '+' is defined
// !:  adding -(list[0] esseentially translates point list to the origin, moving its implied polygon
function additem(list,item) = [for (N=len(list),i=[0:N]) (i<N)? list[i]:item]; 

// make a 1-D list from a column in an N-D list  
function getcol(list,col) =  [for(i=[0:len(list)-1]) list[i][col]]; // return 1-D list from list col

// make the  1-D list 'newcol' a new column of list
function addcol(list,newcol) = [for (row=[0:len(list[0])-1]) additem(list[row],newcol[row])]; 

// append L2 to L1, treating last(L1) as L2's new origin => can turn two segments into a new polygon
function append(L1, L2) = concat(L1,  list_add(L2, last(L1) ));   

