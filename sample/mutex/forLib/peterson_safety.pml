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

never  {    /* ! ! <> (P1@crit && P2@crit) */
T0_init:
	do
	:: atomic { ((P1@crit && P2@crit)) -> assert(!((P1@crit && P2@crit))) }
	:: (1) -> goto T0_init
	od;
accept_all:
	skip
}
