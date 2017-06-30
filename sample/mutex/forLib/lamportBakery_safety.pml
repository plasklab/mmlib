#define PROCSIZE 2
#define VARSIZE 4
#define BUFFSIZE 5
#define c0 0
#define c1 1
#define n0 2
#define n1 3
#define TRUE 1
#define FALSE 0
#include "../../../library/sc.h"

proctype P0() {
  int r;
  do
    ::true ->
      WRITE(c0, TRUE);
      /* mfence needed */
      if
        ::READ(n1) == 0 -> WRITE(n0, 1); r = 1;
        ::READ(n1) == 1 -> WRITE(n0, 2); r = 2;
      fi;
      /* sfence needed */
      WRITE(c0, FALSE);
      /* mfence needed */
      if
        ::READ(c1) == FALSE -> skip;
      fi;
      if
        ::READ(n1) == 0 -> skip;
        ::(r == 0) -> skip;
        ::(r == 1 && (READ(n1) == 1 || READ(n1) == 2)) -> skip;
        ::(r == 2 && READ(n1) == 2) -> skip;
      fi;
crit: skip; /* critical section */
      WRITE(n0, 0);
  od;
}

proctype P1() {
  int r;
  do
    ::true ->
      WRITE(c1, TRUE);
      /* mfence needed */
      if
        ::READ(n0) == 0 -> WRITE(n1, 1); r = 1;
        ::READ(n0) == 1 -> WRITE(n1, 2); r = 2;
      fi;
      /* sfence needed */
      WRITE(c1, FALSE);
      /* mfence needed */
      if
        ::READ(c0) == FALSE -> skip;
      fi;
      if
        ::READ(n0) == 0 -> skip;
        ::(r == 0 && (READ(n0) == 1 || READ(n0) == 2)) -> skip;
        ::(r == 1 && READ(n0) == 2) -> skip;
      fi;
crit: skip; /* critical section */
      WRITE(n1, 0);
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
