#define PROCSIZE 2
#define VARSIZE 4
#define BUFFSIZE 5
#define b(i) i
#define b0 0
#define b1 1
#define x 2
#define y 3
#define TRUE 1
#define FALSE 0
#include "../../../library/sc.h"

proctype P1() {
  bool flag;
  int i = 1;
  do
  ::true ->
    flag = false;
    WRITE(b(i-1), TRUE);
    WRITE(x, i);
    /* mfence needed */
    if
      ::(READ(y) == 1 || READ(y) == 2) ->
        WRITE(b(i-1), FALSE);
        if
          ::READ(y) == 0 -> skip;
        fi;
        flag = true;
      ::(READ(y) == 0) ->
        WRITE(y, i);
        /* mfence needed */
        if
          ::(READ(x) == 3-i) ->
            WRITE(b(i-1), FALSE);
            if
              ::(READ(b(2-i)) == FALSE) -> skip;
            fi;
            if
              ::(READ(y) == 3-i) ->
                if
                  ::(READ(y) == 0) -> skip;
                fi;
                flag = true;
              ::(READ(y) == i) -> skip;
              ::(READ(y) == 0) -> flag = true;
            fi;
          ::(READ(x) == i) -> skip;
        fi;
    fi;
    if
      ::flag -> skip;
      ::!flag ->
        /* critical section */
crit: skip;
        WRITE(y, 0);
        /* sfence needed */
        WRITE(b(i-1), FALSE)
    fi;
  od;
}

proctype P2() {
  bool flag;
  int i = 2;
  do
  ::true ->
    flag = false;
    WRITE(b(i-1), TRUE);
    WRITE(x, i);
    /* mfence needed */
    if
      ::(READ(y) == 1 || READ(y) == 2) ->
        WRITE(b(i-1), FALSE);
        if
          ::READ(y) == 0 -> skip;
        fi;
        flag = true;
      ::(READ(y) == 0) ->
        WRITE(y, i);
        /* mfence needed */
        if
          ::(READ(x) == 3-i) ->
            WRITE(b(i-1), FALSE);
            if
              ::(READ(b(2-i)) == FALSE) -> skip;
            fi;
            if
              ::(READ(y) == 3-i) ->
                if
                  ::(READ(y) == 0) -> skip;
                fi;
                flag = true;
              ::(READ(y) == i) -> skip;
              ::(READ(y) == 0) -> flag = true;
            fi;
          ::(READ(x) == i) -> skip;
        fi;
    fi;
    if
      ::flag -> skip;
      ::!flag ->
        /* critical section */
crit: skip;
        WRITE(y, 0);
        /* sfence needed */
        WRITE(b(i-1), FALSE)
    fi;
  od;
}

init {
  atomic {
    run P1();
    run P2();
  }
}

never  {    /* ! []((SVAR(P1, b0) == TRUE) -> <> (P1@crit)) */
T0_init:
	do
	:: (! ((P1@crit)) && (SVAR(P1, b0) == TRUE)) -> goto accept_S4
	:: (1) -> goto T0_init
	od;
accept_S4:
	do
	:: (! ((P1@crit))) -> goto accept_S4
	od;
}
