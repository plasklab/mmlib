int x = 11, y;
/* 引数xは負でないと仮定する */

init {
  /* 実引数の設定 */
  if
    ::true -> x = 0;
    ::true -> x = 1;
    ::true -> x = 2;
    ::true -> x = 3;
    ::true -> x = 4;
    ::true -> x = 5;
    ::true -> x = 6;
    ::true -> x = 7;
    ::true -> x = 8;
    ::true -> x = 9;
    ::true -> x = 10;
  fi;
  if
    ::true -> y = -5;
    ::true -> y = -4;
    ::true -> y = -3;
    ::true -> y = -2;
    ::true -> y = -1;
    ::true -> y = 0;
    ::true -> y = 1;
    ::true -> y = 2;
    ::true -> y = 3;
    ::true -> y = 4;
    ::true -> y = 5;
    ::true -> y = 6;
    ::true -> y = 7;
    ::true -> y = 8;
    ::true -> y = 9;
    ::true -> y = 10;
    ::true -> y = 11;
    ::true -> y = 12;
    ::true -> y = 13;
    ::true -> y = 14;
    ::true -> y = 15;
  fi;
  /* サブルーチン呼び出し */
  run countAndAlerm();
}

proctype countAndAlerm() {
  L1: x = x + 1;
  L5: if
        ::y < 10 ->
  L6:     y = y + 1;
        ::else ->
  L7:     x = x - 1;
      fi;
  L8: if
        ::x != 0 ->
  L9:     goto L5;
        ::else ->
  L10:    skip;
      fi;
}

never  {    /* ! <> (x == 0) */
accept_init:
T0_init:
	do
	:: (! ((x == 0))) -> goto T0_init
	od;
}
