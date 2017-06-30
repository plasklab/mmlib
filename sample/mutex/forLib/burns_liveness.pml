#define PROCSIZE 2
#define VARSIZE 2
#define BUFFSIZE 5
#define flag0 0
#define flag1 1
#include "../../../library/sc.h"

proctype P0() {
  do
    ::true ->
      WRITE(flag0, 1);
      /* mfence needed */
      if
        ::READ(flag1) == 0 -> skip;
      fi;
crit: skip;      /* critical section */
      WRITE(flag0, 0);
  od;
}

proctype P1() {
  do
    ::true ->
      do
        ::true ->
          WRITE(flag1, 0);
          if
            ::READ(flag0) == 1 -> skip;
            ::READ(flag0) == 0 ->
              WRITE(flag1, 1);
              /* mfence needed */
              if
                ::READ(flag0) == 1 -> skip;
                ::READ(flag0) == 0 -> break;
              fi;
          fi;
      od;
crit: skip;      /* critical section */
      WRITE(flag1, 0);
  od;
}

init {
  atomic {
    run P0();
    run P1();
  }
}

never  {    /* ! []((SVAR(P0, flag0) == 1) -> <> (P0@crit)) */
T0_init:
	do
	:: (! ((P0@crit)) && (SVAR(P0, flag0) == 1)) -> goto accept_S4
	:: (1) -> goto T0_init
	od;
accept_S4:
	do
	:: (! ((P0@crit))) -> goto accept_S4
	od;
}
