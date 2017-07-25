#define PROCSIZE 2
#define VARSIZE 2
#define BUFFSIZE 5
#define s0 0
#define t0 1
#define x0 0
#define x1 1
#define y0 0
#define y1 1
#define y2 2
#include "../../../library/sc.h"

proctype c1() {
  do
    ::true ->
      atomic {
        if
          ::READ(s0) == x0 -> WRITE(s0, x1);
          ::READ(s0) == x1 -> WRITE(s0, x0);
        fi;
      }
  od;
}

proctype c2() {
  do
    ::true ->
      atomic {
        if
          ::READ(t0) == y0 -> WRITE(t0, y1);
          ::READ(t0) == y1 -> WRITE(t0, y2);
          ::READ(t0) == y2 -> WRITE(t0, y0);
        fi;
      }
  od;
}

init {
  atomic {
    run c1();
    run c2();
  }
}

#define p (GSVAR(s0) == x1)
#define q (GSVAR(t0) == y2)
never  {    /* !(<> (p && q)) */
accept_init:
T0_init:
	do
	:: (! ((p && q))) -> goto T0_init
	od;
}
