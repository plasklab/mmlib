int flag0 = 0;
int flag1 = 0;

proctype P0() {
  do
    ::true ->
      flag0 = 1;
      /* mfence needed */
      if
        ::(flag1 == 0 || flag1 == 1 || flag1 == 2) -> skip;
      fi;
      flag0 = 3;
      /* mfence needed */
      if
        ::flag1 == 1 ->
          flag0 = 2;
          if
            ::(flag1 == 4) -> skip;
          fi;
        ::(flag1 == 0 || flag1 == 2 || flag1 == 3 || flag1 == 4) -> skip;
      fi;
      flag0 = 4;
crit: skip;  /* critical section */
      if
        ::(flag1 == 0 || flag1 == 1 || flag1 == 4) -> skip;
      fi;
      flag0 = 0;
  od;
}


proctype P1() {
  do
    ::true ->
      flag1 = 1;
      if
        ::(flag0 == 0 || flag0 == 1 || flag0 == 2) -> skip;
      fi;
      flag1 = 3;
      /* mfence needed */
      if
        ::flag0 == 1 ->
          flag1 == 2;
          if
            ::flag0 == 4 -> skip;
          fi;
        ::(flag0 == 0 || flag0 == 2 || flag0 == 3 || flag0 == 4) -> skip;
      fi;
      flag1 = 4;
      if
        ::(flag0 == 0 || flag0 == 1) -> skip;
      fi;
crit: skip;  /* critical section */
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
