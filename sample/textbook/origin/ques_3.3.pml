int x = 0;
int y = 0;

active proctype p1() {
  do
    ::true ->
      /* (Non-Critical section) */
      x = y + 1;
      (y == 0 || x <= y);
CS1:  skip; /* (Critical section) */
      x = 0;
  od;
}

active proctype p2() {
  do
    ::true ->
      /* (Non-Critical section) */
      y = x + 1;
      (x == 0 || y <= x);
CS1:  skip; /* (Critical section) */
      y = 0;
  od;
}

never  {    /* ! [](x < 10) */
T0_init:
	do
	:: atomic { (! ((x < 10))) -> assert(!(! ((x < 10)))) }
	:: (1) -> goto T0_init
	od;
accept_all:
	skip
}
