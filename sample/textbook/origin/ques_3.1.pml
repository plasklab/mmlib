/*
  盤面
    NW-No-NE    B--W--B
    |  |  |     |  |  |
    We-CT-Ea -> W--B--W
    |  |  /     |  | /
    Sw-So       B--W
*/

mtype = {B1, Wh};
mtype mouse = B1;
mtype cat = Wh;
mtype cat_n, mouse_n;
bool csh, msh;

inline move_c(loc, dst) {
  if
    ::loc == B1 -> dst = Wh;
    ::loc == Wh -> dst = B1;
    ::loc == Wh -> dst = Wh;
  fi;
}

inline move_m(loc, dst) {
  if
    ::loc == B1 -> dst = Wh;
    ::loc == Wh -> dst = Wh;
    ::loc == Wh -> dst = B1;
  fi;
}

active proctype pg() {
  do
    ::true ->
CP:     atomic {
          move_m(mouse, mouse_n);
          if
            ::(mouse_n == Wh && mouse == Wh) -> msh = !msh;
            ::else -> skip;
          fi;
          mouse = mouse_n;
          move_c(cat, cat_n);
          if
            ::(cat_n == Wh && cat == Wh) -> csh = !csh;
            ::else -> skip;
          fi;
          cat = cat_n;
        }
  od;
}

#define p (pg@CP)
#define q (cat == mouse)
#define catch (p && q)
#define condm (msh == false)
#define condc (csh == true)

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
