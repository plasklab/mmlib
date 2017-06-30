int want1 = 0;
int want2 = 0;
int turn = 0;

proctype P1() {
  do
    ::true ->
      want1 = 1;
      turn = 1;
      /* mfence needed */
      if
        ::turn == 0 -> skip;
        ::want2 == 0 -> skip;
      fi;
crit: skip;
      want1 = 0;
  od;
}

proctype P2() {
  do
    ::true ->
      want2 = 1;
      turn = 0;
      /* mfence needed */
      if
        ::turn == 1 -> skip;
        ::want1 == 0 -> skip;
      fi;
crit: skip;
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
