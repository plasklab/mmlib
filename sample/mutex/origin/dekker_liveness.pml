int want1 = 0;
int want2 = 0;
int turn = 0;

proctype P1() {
  do
    ::true ->
      want1 = 1;
      /* mfence needed */
      do
        ::want2 == 1 ->
          if
            ::turn == 1 ->
              want1 = 0;
              if
                ::turn == 0 -> skip;
              fi;
              want1 = 1;
              /* mfence needed */
            ::turn == 0 -> skip;
          fi;
        ::want2 == 0 -> break;
      od;
      /* critical section */
crit: skip;
      turn = 1;
      want1 = 0;
  od;
}

proctype P2() {
  do
    ::true ->
      want2 = 1;
      /* mfence needed */
      do
        ::want1 == 1 ->
          if
            ::turn == 0 ->
              want2 = 0;
              if
                ::turn == 1 -> skip;
              fi;
              want2 = 1;
              /* mfence needed */
            ::turn == 1 -> skip;
          fi;
        ::want1 == 0 -> break;
      od;
      /* critical section */
crit: skip;
      turn = 0;
      want2 = 0;
  od;
}

init {
  atomic {
    run P1();
    run P2();
  }
}

never  {    /* ! []((want1 == 1) -> <> (P1@crit)) */
T0_init:
	do
	:: (! ((P1@crit)) && (want1 == 1)) -> goto accept_S4
	:: (1) -> goto T0_init
	od;
accept_S4:
	do
	:: (! ((P1@crit))) -> goto accept_S4
	od;
}
