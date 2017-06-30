mtype = {x0, x1};
mtype = {y0, y1, y2};
mtype s = x0;
mtype t = y0;

active proctype c1() {
  do
    ::true ->
      atomic {
        if
          ::s == x0 -> s = x1;
          ::s == x1 -> s = x0;
        fi;
      }
  od;
}

active proctype c2() {
  do
    ::true ->
      atomic {
        if
          ::t == y0 -> t = y1;
          ::t == y1 -> t = y2;
          ::t == y2 -> t = y0;
        fi;
      }
  od;
}

#define p (s == x1)
#define q (t == y2)

never  {    /* ! <> (p && q) */
accept_init:
T0_init:
	do
	:: (! ((p && q))) -> goto T0_init
	od;
}
