#define PROCSIZE 1
#define VARSIZE 2
#define BUFFSIZE 5
#define x 0
#define y 1
#include "../../../library/sc.h"

bool flag = false;

init {
  INIT(x, 11);
  /* 実引数の設定 */
  if
    ::true -> INIT(x, 0);
    ::true -> INIT(x, 1);
    ::true -> INIT(x, 2);
    ::true -> INIT(x, 3);
    ::true -> INIT(x, 4);
    ::true -> INIT(x, 5);
    ::true -> INIT(x, 6);
    ::true -> INIT(x, 7);
    ::true -> INIT(x, 8);
    ::true -> INIT(x, 9);
    ::true -> INIT(x, 10);
  fi;
  if
    ::true -> INIT(y, -5);
    ::true -> INIT(y, -4);
    ::true -> INIT(y, -3);
    ::true -> INIT(y, -2);
    ::true -> INIT(y, -1);
    ::true -> INIT(y, 0);
    ::true -> INIT(y, 1);
    ::true -> INIT(y, 2);
    ::true -> INIT(y, 3);
    ::true -> INIT(y, 4);
    ::true -> INIT(y, 5);
    ::true -> INIT(y, 6);
    ::true -> INIT(y, 7);
    ::true -> INIT(y, 8);
    ::true -> INIT(y, 9);
    ::true -> INIT(y, 10);
    ::true -> INIT(y, 11);
    ::true -> INIT(y, 12);
    ::true -> INIT(y, 13);
    ::true -> INIT(y, 14);
    ::true -> INIT(y, 15);
  fi;
  flag = true;
  flag = false;
  /* サブルーチン呼び出し */
  atomic {
    run countAndAlerm();
  }
}

proctype countAndAlerm() {
  L1: WRITE(x, READ(x) + 1);
  L5: if
        ::READ(y) < 10 ->
  L6:     WRITE(y, READ(y) + 1);
        ::else ->
  L7:     WRITE(x, READ(x) - 1);
      fi;
  L8: if
        ::READ(x) != 0 ->
  L9:     goto L5;
        ::else ->
  L10:    skip;
      fi;
}

never  {    /* ! []((flag) -> <> (SVAR(countAndAlerm, x) == 0)) */
T0_init:
	do
	:: (! ((SVAR(countAndAlerm, x) == 0)) && (flag)) -> goto accept_S4
	:: (1) -> goto T0_init
	od;
accept_S4:
	do
	:: (! ((SVAR(countAndAlerm, x) == 0))) -> goto accept_S4
	od;
}
