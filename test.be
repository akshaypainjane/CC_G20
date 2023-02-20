#def DEBUG 10
let x = 5;
#undef DEBUG

#ifdef DEBUG11
dbg x;

#elif DEBUG22
dbg x*4;

#elif DEBUG
dbg 940;

#else
dbg x*100;

#endif
