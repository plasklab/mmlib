mtype = {z_z, p_z, z_p, l_p, p_l, pEq};
/*
  z_z: x = 0 /\ y = 0
  p_z: x >= 1 /\ y = 0
  z_p: x = 0 /\ y >= 1
  l_p: x >= 1 /\ y > x
  p_l: y >= 1 /\ y < x
  pEq: x >= 1 /\ x = y
*/

mtype np = z_z;

active proctype p1() {
  do
    ::true ->
      /* (Non-Critical section) */
      atomic {
        if
          ::np == z_z -> np = p_z;
          ::np == z_p -> np = p_l;
          ::np == l_p -> np = p_l;
          ::np == pEq -> np = p_l;
        fi;
      }
      (np != p_l);
CS1:  skip;
      atomic {
        if
          ::np == p_z -> np = z_z;
          ::np == p_l -> np = z_p;
          ::np == l_p -> np = z_p;
          ::np == pEq -> np = z_p;
        fi;
      }
  od;
}

active proctype p2() {
  do
    ::true ->
      /* (Non-Critical section) */
      atomic {
        if
          ::np == z_z -> np = z_p;
          ::np == p_z -> np = l_p;
          ::np == p_l -> np = l_p;
          ::np == pEq -> np = l_p;
        fi;
      }
      (np != l_p);
CS2:  skip;
      atomic {
        if
          ::np == z_p -> np = z_z;
          ::np == p_l -> np = p_z;
          ::np == l_p -> np = p_z;
          ::np == pEq -> np = p_z;
        fi;
      }
  od;
}

#define p (np == p_z)
#define q (np == p_l)
#define r (p1@CS1)

never  {    /* ! []((p || q) -> <> r) */
T0_init:
	do
	:: (! ((r)) && (p || q)) -> goto accept_S4
	:: (1) -> goto T0_init
	od;
accept_S4:
	do
	:: (! ((r))) -> goto accept_S4
	od;
}
