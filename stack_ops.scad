// stack_ops.scad

                                            /*^^^^^^^^^*\
===========================================/ DESCRIPTION \=================================================

functions that interpret a list as a stack.

                                               /*^^*\
==============================================/ TODO \=====================================================


    !: implement a  FORTH-like instruction sequence as a list
        > implement an interpreter using a recursive exec function? 
        > use it to interpret an instruction sequence


    √: use stacks to pass parameters to modules (& functions?)  
    √: push a list onto 'the' stack
    √: push function "pointers" on the stack; need an "exec" function to execute the top item 
        -- not really a pointer, though; it's the function definition that gets pushed
   
    
                                         /*^^^^^^^^^^^^^^*\
========================================/ GENERAL CONCEPTS \===============================================

basically, try to mimic a FORTH interpreter or an RPN calculator


 /*^^^^^^^*\
/ stack ops \--------------------------------------------------------------------------------------*/

// synonymous nod to HP RPN & FORTH
function dup(stack)         = assert(len(stack)>0,"empty stack!") push(stack, stack[0]);
function pop (stack, n=1)   = pull(stack,n); // returns modified stack, rather than the value
function drop(stack, n=1)   = pull(stack,n);   
function swap(stack)        = push(push(pull(stack,2),stack[0]),stack[1]);					// x <--> y
function top(stack, n=1)    = head(stack,n); // synonym for 'first', viewing list from a stack perspective

exec = function(stack) stack[0](pop(stack)); // TOS holds a function to be executed on the rest of the stack

flr  = function(stack) uniop(stack, function(a) floor(a));
add  = function(stack) binop(stack, function(a,b) b+a);   // binop(stack, add) equivalent
sub  = function(stack) binop(stack, function(a,b) b-a); 
mul  = function(stack) binop(stack, function(a,b) b*a);
div  = function(stack) binop(stack, function(a,b) assert(a!=0, "dividing by 0") b/a);
int  = function(stack) binop(stack, function(a,b) assert(a!=0, "dividing by 0") floor(b/a));
quo  = function(stack) flr(div(stack)); 
rem  = function(stack) div(stack)-int(stack);

