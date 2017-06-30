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
      /* mfence needed */
      do
        ::READ(want2) == 1 ->
          if
            ::READ(turn) == 1 ->
              WRITE(want1, 0);
              if
                ::READ(turn) == 0 -> skip;
              fi;
              WRITE(want1, 1);
              /* mfence needed */
            ::READ(turn) == 0 -> skip;
          fi;
        ::READ(want2) == 0 -> break;
      od;
      /* critical section */
crit: skip;
      WRITE(turn, 1);
      WRITE(want1, 0);
  od;
}

proctype P2() {
  do
    ::true ->
      WRITE(want2, 1);
      /* mfence needed */
      do
        ::READ(want1) == 1 ->
          if
            ::READ(turn) == 0 ->
              WRITE(want2, 0);
              if
                ::READ(turn) == 1 -> skip;
              fi;
              WRITE(want2, 1);
              /* mfence needed */
            ::READ(turn) == 1 -> skip;
          fi;
        ::READ(want1) == 0 -> break;
      od;
      /* critical section */
crit: skip;
      WRITE(turn, 0);
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
