// stacks.scad

use <lists.scad>

                                           /*^^^^^^^^^*\
===========================================/ DESCRIPTION \=================================================

functions that act on a list as a stack.

                                               /*^^*\
==============================================/ TODO \=====================================================

    !: use stacks to pass parameters to modules (& functions?)  
    !: push a list onto 'the' stack
    !: implement a  FORTH-like instruction sequence as a list
    !: push function "pointers" on the stack; need an "exec" function to execute the top item 

    ?: can we implement an interpreter using a recursive exec function? 
        > use it to interpret a function list.
    
    
                                         /*^^^^^^^^^^^^^^*\
========================================/ GENERAL CONCEPTS \===============================================

basically, try to mimic a FORTH interpreter or an RPN calculator



 /*^^^^^^^^*\
/ operations \===========================================================================================*/
function dup (stack)      = push(stack, stack[0]);
function swap(stack)      = push(push(drop(stack,2),stack[0]),stack[1]);

 /*^^*\
/ math \=================================================================================================*/

// binary operations
function add(stack) = push(drop(stack,2),stack[1]+stack[0]);
function sub(stack) = push(drop(stack,2),stack[1]-stack[0]);
function mul(stack) = push(drop(stack,2),stack[1]*stack[0]);
function div(stack) = push(drop(stack,2),stack[1]/stack[0]);

// mappings
function sum(stack) = (is_undef(stack))? undef : (len(stack)<2) ? stack[0] : sum(add(stack));
function avg(stack) = sum(stack)/len(stack);


