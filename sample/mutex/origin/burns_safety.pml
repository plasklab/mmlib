int flag0 = 0;
int flag1 = 0;

proctype P0() {
  do
    ::true ->
      flag0 = 1;
      /* mfence needed */
      if
        ::flag1 == 0 -> skip;
      fi;
crit: skip;      /* critical section */
      flag0 = 0;
  od;
}

proctype P1() {
  do
    ::true ->
      do
        ::true ->
          flag1 = 0;
          if
            ::flag0 == 1 -> skip;
            ::flag0 == 0 ->
              flag1 = 1;
              /* mfence needed */
              if
                ::flag0 == 1 -> skip;
                ::flag0 == 0 -> break;
              fi;
          fi;
      od;
crit: skip;      /* critical section */
      flag1 = 0;
  od;
}

init {
  atomic {
    run P0();
    run P1();
  }
}

never  {    /* ! ! <> (P0@crit && P1@crit) */
T0_init:
	do
	:: atomic { ((P0@crit && P1@crit)) -> assert(!((P0@crit && P1@crit))) }
	:: (1) -> goto T0_init
	od;
accept_all:
	skip
}
