bool w0 = false, w1 = false;
byte last = 0;

active proctype p0()
{
    do
      ::true ->
                /* ( Non-critical Section ) */
                w0 = true;
                last = 0;
                do
                  ::(w1 != false) && (last == 0) -> skip;
                  ::else -> break;
                od;
CS1: /* (Critical Section) */
      w0 = false;
    od;
}

active proctype p1()
{
    do
      ::true ->
                /* ( Non-critical Section ) */
                w1 = true;
                last = 1;
                do
                  ::(w0 != false) && (last == 1) -> skip;
                  ::else -> break;
                od;
CS2: /* (Critical Section) */
      w1 = false;
    od;
}

never  {    /* ! (! <> (p0@CS1 && p1@CS2)) */
T0_init:
	do
	:: atomic { ((p0@CS1 && p1@CS2)) -> assert(!((p0@CS1 && p1@CS2))) }
	:: (1) -> goto T0_init
	od;
accept_all:
	skip
}
