//20170625
/* shared memory */
int shared_memory[VARSIZE];

/* buffer */
int buffer[(PROCSIZE + 2) * VARSIZE];
byte gcounter;

/* store_buffer */
chan queue[(PROCSIZE + 2) * VARSIZE] = [BUFFSIZE] of {int};

/* commit operation */
#define COMMIT_WRITE(i, j)\
{\
    queue[(i) * VARSIZE + (j)]?v -> shared_memory[j] = v;\
    gcounter--;\
    v = 0;\
}

/* memory process */
int v;
active proctype mem()
{
  int i, j, r;
endmem:
  do
    ::atomic
      {
        (gcounter != 0) ->
        r = gcounter;
        do
          ::(len(queue[(i + 2) * VARSIZE + j]) > 0 && j < VARSIZE) ->
            COMMIT_WRITE(i + 2, j);
            break;
          ::(i < PROCSIZE - 1 && j >= VARSIZE) ->
            i++;
            j = 0;
          ::(j < VARSIZE && r > len(queue[(i + 2) * VARSIZE + j])) ->
            r = r - len(queue[(i + 2) * VARSIZE + j]);
            j++;
        od;
        i = 0;
	      j = 0;
        r = 0;
      }
  od;
}

#define READ(s) ( (len(queue[(_pid) * VARSIZE + (s)]) == 0) -> shared_memory[s] : buffer[(_pid) * VARSIZE + (s)] )

#define WRITE(s, v)\
{\
  atomic{\
    (len(queue[(_pid) * VARSIZE + (s)]) < BUFFSIZE);\
    int temp = v;\
    queue[(_pid) * VARSIZE + (s)]!temp;\
    buffer[(_pid) * VARSIZE + (s)] = temp;\
    gcounter++;\
    temp = 0;\
  }\
}

#define FENCE()\
{\
  atomic{\
    int iterator = 0;\
    do\
      ::(len(queue[(_pid) * VARSIZE + iterator]) > 0) -> COMMIT_WRITE(_pid, iterator);\
      ::(len(queue[(_pid) * VARSIZE + iterator]) == 0) ->\
        iterator++;\
        if\
          ::(iterator >= VARSIZE) -> break;\
          ::else -> skip;\
        fi;\
    od;\
    iterator = 0;\
  }\
}

#define INIT(s, v) shared_memory[s] = v;

#define SVAR(p, s) ( len(queue[(p:_pid) * VARSIZE + (s)]) == 0 -> shared_memory[s] : buffer[(p:_pid) * VARSIZE + (s)] )

#define GSVAR(s) shared_memory[s]
