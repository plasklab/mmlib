#define PROCSIZE 2
#define VARSIZE 3
#define BUFFSIZE 5
#define flag(i) i
#define flag0 0
#define flag1 1
#define turn 2
#include "../../../library/sc.h"

proctype P1() {
  int i = 1;
  do
    ::true ->
      do
        ::true ->
          WRITE(flag(i-1), 1);
          do
            ::READ(turn) == i -> break;
            ::READ(turn) == 3-i ->
              if
                ::READ(flag(2-i)) == 0 -> WRITE(turn, i);
                ::(READ(flag(2-i)) == 1 || READ(flag(2-i)) == 2) -> skip;
              fi;
          od;
          WRITE(flag(i-1), 2);
          /* mfence needed */
          if
            ::READ(flag(2-i)) == 2 -> skip;
            ::(READ(flag(2-i)) == 1 || READ(flag(2-i)) == 0) -> break;
          fi;
      od;

      /* critical section */
crit: skip;
      WRITE(flag(i-1), 0);
  od;
}

proctype P2() {
  int i = 2;
  do
    ::true ->
      do
        ::true ->
          WRITE(flag(i-1), 1);
          do
            ::READ(turn) == i -> break;
            ::READ(turn) == 3-i ->
              if
                ::READ(flag(2-i)) == 0 -> WRITE(turn, i);
                ::(READ(flag(2-i)) == 1 || READ(flag(2-i)) == 2) -> skip;
              fi;
          od;
          WRITE(flag(i-1), 2);
          /* mfence needed */
          if
            ::READ(flag(2-i)) == 2 -> skip;
            ::(READ(flag(2-i)) == 1 || READ(flag(2-i)) == 0) -> break;
          fi;
      od;

      /* critical section */
crit: skip;
      WRITE(flag(i-1), 0);
  od;
}

init {
  INIT(turn, 1);
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
