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
        ::(READ(flag1) == 0 || READ(flag1) == 1 || READ(flag1) == 2) -> skip;
      fi;
      WRITE(flag0, 3);
      /* mfence needed */
      if
        ::READ(flag1) == 1 ->
          WRITE(flag0, 2);
          if
            ::(READ(flag1) == 4) -> skip;
          fi;
        ::(READ(flag1) == 0 || READ(flag1) == 2 || READ(flag1) == 3 || READ(flag1) == 4) -> skip;
      fi;
      WRITE(flag0, 4);
crit: skip;  /* critical section */
      if
        ::(READ(flag1) == 0 || READ(flag1) == 1 || READ(flag1) == 4) -> skip;
      fi;
      WRITE(flag0, 0);
  od;
}


proctype P1() {
  do
    ::true ->
      WRITE(flag1, 1);
      if
        ::(READ(flag0) == 0 || READ(flag0) == 1 || READ(flag0) == 2) -> skip;
      fi;
      WRITE(flag1, 3);
      /* mfence needed */
      if
        ::READ(flag0) == 1 ->
          WRITE(flag1, 2);
          if
            ::READ(flag0) == 4 -> skip;
          fi;
        ::(READ(flag0) == 0 || READ(flag0) == 2 || READ(flag0) == 3 || READ(flag0) == 4) -> skip;
      fi;
      WRITE(flag1, 4);
      if
        ::(READ(flag0) == 0 || READ(flag0) == 1) -> skip;
      fi;
crit: skip;  /* critical section */
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
