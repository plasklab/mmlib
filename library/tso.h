//20170625
/* shared memory */
int shared_memory[VARSIZE];

/* buffer */
int buffer[(PROCSIZE + 2) * VARSIZE];
byte counter[(PROCSIZE + 2) * VARSIZE];
byte gcounter;

/* store_buffer: queue */
chan queue[PROCSIZE + 2] = [BUFFSIZE] of {int, int};

/* commit operation */
#define COMMIT_WRITE(i)\
{\
    queue[i]?s,v -> shared_memory[s] = v; counter[(i) * VARSIZE + s]--;\
    gcounter--;\
    s = 0;v = 0;\
}

/* memory process */
int s, v;
active proctype mem()
{
  int i, r;
endmem:
  do
    ::atomic {
            (gcounter != 0) ->
            r = gcounter;
            do
              ::(len(queue[i + 2]) > 0) -> COMMIT_WRITE(i + 2); break;
              ::(i < PROCSIZE - 1 && r > len(queue[i + 2])) ->
                 r = r - len(queue[i + 2]);
                 i++;
            od;
            i = 0; r = 0;
      }
  od;
}

#define READ(s) (counter[(_pid) * VARSIZE + (s)] == 0 -> shared_memory[s] : buffer[(_pid) * VARSIZE + (s)])

#define WRITE(s, v)\
{\
  atomic{\
    (len(queue[_pid]) < BUFFSIZE);\
    int temp = v;\
    queue[_pid]!s,temp;\
    buffer[(_pid) * VARSIZE + (s)] = temp;\
    counter[(_pid) * VARSIZE + (s)]++;\
    gcounter++;\
    temp = 0;\
  }\
}

#define FENCE()\
{\
  atomic{\
    do\
      ::(len(queue[_pid]) > 0) -> COMMIT_WRITE(_pid);\
      ::else -> break;\
    od;\
  }\
}

#define INIT(s, v) shared_memory[s] = v;

#define SVAR(p, s) (counter[((p:_pid) * VARSIZE) + (s)] == 0 -> shared_memory[s] : buffer[((p:_pid) * VARSIZE) + (s)])

#define GSVAR(s) shared_memory[s]
