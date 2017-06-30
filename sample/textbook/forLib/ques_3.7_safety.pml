#define PROCSIZE 2
#define VARSIZE 1
#define BUFFSIZE 5
#define np 0
#define z_z 0
#define p_z 1
#define z_p 2
#define l_p 3
#define p_l 4
#define pEq 5
#include "../../../library/sc.h"

proctype p1() {
  do
    ::true ->
      /* (Non-Critical section) */
      atomic {
        if
          ::READ(np) == z_z -> WRITE(np, p_z);
          ::READ(np) == z_p -> WRITE(np, p_l);
          ::READ(np) == l_p -> WRITE(np, p_l);
          ::READ(np) == pEq -> WRITE(np, p_l);
        fi;
      }
      (READ(np) != p_l);
CS1:  skip;
      atomic {
        if
          ::READ(np) == p_z -> WRITE(np, z_z);
          ::READ(np) == p_l -> WRITE(np, z_p);
          ::READ(np) == l_p -> WRITE(np, z_p);
          ::READ(np) == pEq -> WRITE(np, z_p);
        fi;
      }
  od;
}

proctype p2() {
  do
    ::true ->
      /* (Non-Critical section) */
      atomic {
        if
          ::READ(np) == z_z -> WRITE(np, z_p);
          ::READ(np) == p_z -> WRITE(np, l_p);
          ::READ(np) == p_l -> WRITE(np, l_p);
          ::READ(np) == pEq -> WRITE(np, l_p);
        fi;
      }
      (READ(np) != l_p);
CS2:  skip;
      atomic {
        if
          ::READ(np) == z_p -> WRITE(np, z_z);
          ::READ(np) == p_l -> WRITE(np, p_z);
          ::READ(np) == l_p -> WRITE(np, p_z);
          ::READ(np) == pEq -> WRITE(np, p_z);
        fi;
      }
  od;
}

init {
  INIT(np, z_z);
  atomic {
    run p1();
    run p2();
  }
}

/*
  z_z: x = 0 /\ y = 0
  p_z: x >= 1 /\ y = 0
  z_p: x = 0 /\ y >= 1
  l_p: x >= 1 /\ y > x
  p_l: y >= 1 /\ y < x
  pEq: x >= 1 /\ x = y
*/

never  {    /* ! []!(p1@CS1 && p2@CS2) */
T0_init:
	do
	:: atomic { ((p1@CS1 && p2@CS2)) -> assert(!((p1@CS1 && p2@CS2))) }
	:: (1) -> goto T0_init
	od;
accept_all:
	skip
}
