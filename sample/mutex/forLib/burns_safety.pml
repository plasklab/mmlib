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

never  {    /* ! ! <> (P0@crit && P1@crit) */
T0_init:
	do
	:: atomic { ((P0@crit && P1@crit)) -> assert(!((P0@crit && P1@crit))) }
	:: (1) -> goto T0_init
	od;
accept_all:
	skip
}
