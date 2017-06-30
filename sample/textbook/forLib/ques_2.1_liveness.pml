#define PROCSIZE 2
#define VARSIZE 3
#define BUFFSIZE 5
#define w0 0
#define w1 1
#define last 2
#include "../../../library/sc.h"

proctype p0()
{
    do
      ::true ->
                /* ( Non-critical Section ) */
                WRITE(w0, 1);
                WRITE(last, 0);
                do
                  ::(READ(w1) != 0) && (READ(last) == 0) -> skip;
                  ::else -> break;
                od;
CS1: skip;/* (Critical Section) */
      WRITE(w0, 0);
    od;
}

proctype p1()
{
    do
      ::true ->
                /* ( Non-critical Section ) */
                WRITE(w1, 1);
                WRITE(last, 1);
                do
                  ::(READ(w0) != 0) && (READ(last) == 1) -> skip;
                  ::else -> break;
                od;
CS2: /* (Critical Section) */
      WRITE(w1, 0);
    od;
}

init {
  atomic {
    run p0();
    run p1();
  }
}

never  {    /* ! [](((SVAR(p0, w1) != 0) && (SVAR(p0, last) == 0) ) -> <> (p0@CS1) ) */
T0_init:
	do
	:: (! ((p0@CS1)) && ((SVAR(p0, w1) != 0) && (SVAR(p0, last) == 0) )) -> goto accept_S4
	:: (1) -> goto T0_init
	od;
accept_S4:
	do
	:: (! ((p0@CS1))) -> goto accept_S4
	od;
}
