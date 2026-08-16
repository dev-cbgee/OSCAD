// list_ops.scad
// include<scad_defs.scad>

 /********\
/ list ops \______________________________________________________________________________________________________*/

//!>: add assertion test(s) for valid conditions

// helpers
//---------------------
// consider list as an RPN calculator stack, where x & y are the top two items:
function uniop(list, op) = [for (N=len(list)-1, i=[0:N]) (i==0)? op(list[0]) : list[i]];   			//     x <-- op(x)
function binop(list, op) = [for (N=len(list)-1, i=[1:N]) (i==1)? op(list[0],list[1]) : list[i]];	// (x,y) <-- op(x,y)

function item(list,n) = assert(!(is_undef(list)||is_undef(len(list))||(len(list)<=n))) list[n];	// <-- item 'n' ε [0:N-1]
function putitem(list,item,n) = [for (N=len(list),i=[0:N-1]) (i==n)? item : list[i]];           // list[n] <-- item
        
function additem(list, item) = [for (N=len(list),i=[0:N-1]) list[i]+item]; // add 'item' to each element of list, if '+' is defined
// !:  adding -(list[0] translates point list to the origin, moving its implied polygon
    
// list transformations   // !!> clean up asserts
//------------------------

function push(list,item) = 	 // <-- [item, list[0], ... list[N-1]]
    assert(!is_undef(list) && len(list)>= 0, "bad list!")
    [for(N=len(list), i=[0:N]) (i==0)? item : list[i-1]]
;
function pull(list, n=1) = let(N=len(list)) 	// <-- list[0:n-1]
    assert(N>0, "empty list!") assert(0<=n && n<N, "index out of range!")
    assert(!(n<=0||is_undef(list)||is_undef(len(list))))
    [for (i=[n:N-1]) list[i]]
;
function last(list, n=1) = pull(list,(len(list)-n));

function first(list, n=1) = // <-- list[0:n-1]
    assert(!(n<=0||is_undef(list)||is_undef(len(list))||(len(list)<=n))) [ for(i=[0:n-1]) list[i] ];
;
function chop(list, n=1) = first(list,len(list)-n); // <-- list[0:n-1]

function split(list,n) = [first(list,n), last(list,n-1)];							// list <-- [ list[0:n-1], list[n:N-1] ]
function append(list1, list2) = concat(list1, list2);								// simple rename for clarity
function prepend(list1,list2) = append(list2,list1);								// prepend 'list2' to 'list'

// extend L1 by L2, treating last(L1) as L2's new origin => can extend a polygon list
function extend(L1, L2) = append(L1, additem(L2, last(L1)[0] ));   

// √√√√√√√√√√√√√√√√√√√√√√√√√√√√√√√√√√

// circular shift all list elements
function roll(list, n, i=0, R=[]) = 
    let(N=len(list), modsum=(i+n)%N, nxti= (modsum>=0)? modsum : (N+modsum))    //!! <<<< rework!
    (is_undef(N)||(N==0))? undef : n==0? list : i>=N? R : roll(list,n,i+1,concat(R,list[nxti%N]))
;

// item 'n' jumps over preceding items to the front of the 'list'
function over(list,n=1) = let (N=len(list)-1) (n<0)? undef : (n>=N)? undef:
    [for(i=[0:N]) (i==0)? list[n]:(i<=n)? list[i-1] : list[i]];  
    
 //-----------------------------------------------------------------
    

// self explanatory; useful for lists where 'item + item' makes sense
function sum(list) = (is_undef(list))? undef : (len(list)<2) ? list[0] : sum(add(list));

function avg(list) = sum(list)/len(list);

// transform row vector to column vector  <<---- use for loops!
function row2col(v, i=0, R=[]) = (i>=(len(v))) ? R : row2col(v, i+1, concat(R, [[v[i]]])) ;

// transform column vector to row vector  <<---- use for loops!
function col2row(v, i=0, R=[]) = (i>=(len(v))) ? R : col2row(v, i+1, concat(R, v[i])) ;

// make a 1-D list from a column in an N-Dim list; NB: a points list is a Nx2 matrix  
function getcol(list,col) =  [for(N=len(list)-1, i=[0:N]) [list[i][col]]];  // returns column vector

// make the  1-D 'newcol' a new column of the matrix 'list'
function addcol(list,newcol) = [for (row=[0:len(list[0])-1]) additem(list[row],newcol[row])]; 
    
// dimensions of matrix (only tested for 2D matrices)
function dim(list, d=[]) = is_undef(list) ? undef : is_undef(list[0]) ? d : dim(list[0], concat(d, [len(list)])) ; 

 /*"""""""*\
/ WORK ZONE \"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""*/
