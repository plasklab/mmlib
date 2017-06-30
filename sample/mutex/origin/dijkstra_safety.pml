int flag[2] = {0, 0};
int turn = 1;

proctype P1() {
  int i = 1;
  do
    ::true ->
      do
        ::true ->
          flag[i-1] = 1;
          do
            ::turn == i -> break;
            ::turn == 3-i ->
              if
                ::flag[2-i] == 0 -> turn = i;
                ::(flag[2-i] == 1 || flag[2-i] == 2) -> skip;
              fi;
          od;
          flag[i-1] = 2;
          /* mfence needed */
          if
            ::flag[2-i] == 2 -> skip;
            ::(flag[2-i] == 1 || flag[2-i] == 0) -> break;
          fi;
      od;

      /* critical section */
crit: skip;
      flag[i-1] = 0;
  od;
}

proctype P2() {
  int i = 2;
  do
    ::true ->
      do
        ::true ->
          flag[i-1] = 1;
          do
            ::turn == i -> break;
            ::turn == 3-i ->
              if
                ::flag[2-i] == 0 -> turn = i;
                ::(flag[2-i] == 1 || flag[2-i] == 2) -> skip;
              fi;
          od;
          flag[i-1] = 2;
          /* mfence needed */
          if
            ::flag[2-i] == 2 -> skip;
            ::(flag[2-i] == 1 || flag[2-i] == 0) -> break;
          fi;
      od;

      /* critical section */
crit: skip;
      flag[i-1] = 0;
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
