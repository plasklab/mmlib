#define TRUE 1
#define FALSE 0
int b[2] = {0, 0};
int x = 0;
int y = 0;

proctype P1() {
  bool flag;
  int i = 1;
  do
  ::true ->
    flag = false;
    b[i-1] = TRUE;
    x = i;
    /* mfence needed */
    if
      ::(y == 1 || y == 2) ->
        b[i-1] = FALSE;
        if
          ::y == 0 -> skip;
        fi;
        flag = true;
      ::(y == 0) ->
        y = i;
        /* mfence needed */
        if
          ::(x == 3-i) ->
            b[i-1] = FALSE;
            if
              ::(b[2-i] == FALSE) -> skip;
            fi;
            if
              ::(y == 3-i) ->
                if
                  ::(y == 0) -> skip;
                fi;
                flag = true;
              ::(y == i) -> skip;
              ::(y == 0) -> flag = true;
            fi;
          ::(x == i) -> skip;
        fi;
    fi;
    if
      ::flag -> skip;
      ::!flag ->
        /* critical section */
crit: skip;
        y = 0;
        /* sfence needed */
        b[i-1] = FALSE;
    fi;
  od;
}

proctype P2() {
  bool flag;
  int i = 2;
  do
  ::true ->
    flag = false;
    b[i-1] = TRUE;
    x = i;
    /* mfence needed */
    if
      ::(y == 1 || y == 2) ->
        b[i-1] = FALSE;
        if
          ::y == 0 -> skip;
        fi;
        flag = true;
      ::(y == 0) ->
        y = i;
        /* mfence needed */
        if
          ::(x == 3-i) ->
            b[i-1] = FALSE;
            if
              ::(b[2-i] == FALSE) -> skip;
            fi;
            if
              ::(y == 3-i) ->
                if
                  ::(y == 0) -> skip;
                fi;
                flag = true;
              ::(y == i) -> skip;
              ::(y == 0) -> flag = true;
            fi;
          ::(x == i) -> skip;
        fi;
    fi;
    if
      ::flag -> skip;
      ::!flag ->
        /* critical section */
crit: skip;
        y = 0;
        /* sfence needed */
        b[i-1] = FALSE;
    fi;
  od;
}

init {
  atomic {
    run P1();
    run P2();
  }
}

never  {    /* ! []((b[0] == TRUE) -> <> (P1@crit)) */
T0_init:
	do
	:: (! ((P1@crit)) && (b[0] == TRUE)) -> goto accept_S4
	:: (1) -> goto T0_init
	od;
accept_S4:
	do
	:: (! ((P1@crit))) -> goto accept_S4
	od;
}
