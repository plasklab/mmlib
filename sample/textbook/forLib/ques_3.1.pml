#define PROCSIZE 1
#define VARSIZE 6
#define BUFFSIZE 5
#define mouse 0
#define cat 1
#define mouse_n 2
#define cat_n 3
#define csh 4
#define msh 5
#define B1 0
#define Wh 1
#include "../../../library/sc.h"

inline move_c(loc, dst) {
  if
    ::(READ(loc) == B1) -> WRITE(dst, Wh);
    ::(READ(loc) == Wh) -> WRITE(dst, B1);
    ::(READ(loc) == Wh) -> WRITE(dst, Wh);
  fi;
}

inline move_m(loc, dst) {
  if
    ::(READ(loc) == B1) -> WRITE(dst, Wh);
    ::(READ(loc) == Wh) -> WRITE(dst, Wh);
    ::(READ(loc) == Wh) -> WRITE(dst, B1);
  fi;
}

proctype pg() {
  do
    ::true ->
CP:     atomic {
          move_m(mouse, mouse_n);
          if
            ::((READ(mouse_n) == Wh) && (READ(mouse) == Wh)) -> WRITE(msh, (1 - READ(msh)));
            ::else -> skip;
          fi;
          WRITE(mouse, READ(mouse_n));
          move_c(cat, cat_n);
          if
            ::((READ(cat_n) == Wh) && (READ(cat) == Wh)) -> WRITE(csh, (1 - READ(csh)));
            ::else -> skip;
          fi;
          WRITE(cat, READ(cat_n));
        }
  od;
}

init {
  INIT(mouse, B1);
  INIT(cat, Wh);
  atomic {
    run pg();
  }
}

#define p (pg@CP)
#define q ((SVAR(pg, cat)) == (SVAR(pg, mouse)))
#define catch (p && q)
#define condm (SVAR(pg, msh) == 0)
#define condc (SVAR(pg, csh) == 1)

never  {    /* ! [] ( ([]condm && (<>[]condc)) -> <>catch ) */
T0_init:
	do
	:: (! ((catch)) && (condc) && (condm)) -> goto accept_S19
	:: (! ((catch)) && (condm)) -> goto T0_S23
	:: (1) -> goto T0_init
	od;
accept_S19:
	do
	:: (! ((catch)) && (condc) && (condm)) -> goto accept_S19
	od;
T0_S23:
	do
	:: (! ((catch)) && (condc) && (condm)) -> goto accept_S19
	:: (! ((catch)) && (condm)) -> goto T0_S23
	od;
}
