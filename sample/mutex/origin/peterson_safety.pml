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

never  {    /* ! ! <> (P1@crit && P2@crit) */
T0_init:
	do
	:: atomic { ((P1@crit && P2@crit)) -> assert(!((P1@crit && P2@crit))) }
	:: (1) -> goto T0_init
	od;
accept_all:
	skip
}
