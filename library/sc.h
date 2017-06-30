//20170508
/* shared memory */
int shared_memory[VARSIZE];

#define READ(s) shared_memory[s]

#define WRITE(s, v) shared_memory[s] = v;

#define FENCE() skip;

#define INIT(s, v) shared_memory[s] = v;

#define SVAR(p, s) shared_memory[s]

#define GSVAR(s) shared_memory[s]
