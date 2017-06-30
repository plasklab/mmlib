#define PROCSIZE 2
#define VARSIZE 2
#define BUFFSIZE 5
#define x 0
#define y 1
#include "../../../library/sc.h"

proctype p1() {
  do
    ::true ->
      /* (Non-Critical section) */
      WRITE(x, READ(y) + 1);
      (READ(y) == 0 || READ(x) <= READ(y));
CS1:  skip; /* (Critical section) */
      WRITE(x, 0);
  od;
}

proctype p2() {
  do
    ::true ->
      /* (Non-Critical section) */
      WRITE(y,  READ(x) + 1);
      (READ(x) == 0 || READ(y) <= READ(x));
CS1:  skip; /* (Critical section) */
      WRITE(y, 0);
  od;
}

init {
  atomic {
    run p1();
    run p2();
  }
}

never  {    /* ! [](GSVAR(x) < 10) */
T0_init:
	do
	:: atomic { (! ((GSVAR(x) < 10))) -> assert(!(! ((GSVAR(x) < 10)))) }
	:: (1) -> goto T0_init
	od;
accept_all:
	skip
}
