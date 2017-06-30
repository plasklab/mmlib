#define TRUE 1
#define FALSE 0
int c0 = 0;
int c1 = 0;
int n0 = 0;
int n1 = 0;

proctype P0() {
  int r;
  do
    ::true ->
      c0 = TRUE;
      /* mfence needed */
      if
        ::n1 == 0 -> n0 = 1; r = 1;
        ::n1 == 1 -> n0 = 2; r = 2;
      fi;
      /* sfence needed */
      c0 = FALSE;
      /* mfence needed */
      if
        ::c1 == FALSE -> skip;
      fi;
      if
        ::n1 == 0 -> skip;
        ::(r == 0) -> skip;
        ::(r == 1 && (n1 == 1 || n1 == 2)) -> skip;
        ::(r == 2 && n1 == 2) -> skip;
      fi;
crit: skip; /* critical section */
      n0 = 0;
  od;
}

proctype P1() {
  int r;
  do
    ::true ->
      c1 = TRUE;
      /* mfence needed */
      if
        ::n0 == 0 -> n1 = 1; r = 1;
        ::n0 == 1 -> n1 = 2; r = 2;
      fi;
      /* sfence needed */
      c1 = FALSE;
      /* mfence needed */
      if
        ::c0 == FALSE -> skip;
      fi;
      if
        ::n0 == 0 -> skip;
        ::(r == 0 && (n0 == 1 || n0 == 2)) -> skip;
        ::(r == 1 && n0 == 2) -> skip;
      fi;
crit: skip; /* critical section */
      n1 = 0;
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
