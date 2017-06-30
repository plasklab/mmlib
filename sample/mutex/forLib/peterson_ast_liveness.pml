#define PROCSIZE 2
#define VARSIZE 3
#define BUFFSIZE 5
#define want1 0
#define want2 1
#define turn 2
#include "../../../library/sc.h"

proctype P1() {
  do
    ::true ->
      WRITE(want1, 1);
      /* sfence needed */
      WRITE(turn, 1);
      /* mfence needed */
      if
        ::READ(turn) == 0 -> skip;
        ::READ(want2) == 0 -> skip;
      fi;
crit: skip;
      WRITE(want1, 0);
  od;
}

proctype P2() {
  do
    ::true ->
      WRITE(want2, 1);
      /* sfence needed */
      WRITE(turn, 0);
      /* mfence needed */
      if
        ::READ(turn) == 1 -> skip;
        ::READ(want1) == 0 -> skip;
      fi;
crit: skip;
      WRITE(want2, 0);
  od;
}

init {
  atomic {
    run P1();
    run P2();
  }
}

never  {    /* ! []((SVAR(P1, want1) == 1) -> <> (P1@crit)) */
T0_init:
	do
	:: (! ((P1@crit)) && (SVAR(P1, want1) == 1)) -> goto accept_S4
	:: (1) -> goto T0_init
	od;
accept_S4:
	do
	:: (! ((P1@crit))) -> goto accept_S4
	od;
}
