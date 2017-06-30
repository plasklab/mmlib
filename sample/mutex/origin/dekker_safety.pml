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

never  {    /* ! ! <> (P1@crit && P2@crit) */
T0_init:
	do
	:: atomic { ((P1@crit && P2@crit)) -> assert(!((P1@crit && P2@crit))) }
	:: (1) -> goto T0_init
	od;
accept_all:
	skip
}
