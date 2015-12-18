PROGRAM TESTSCROLLYTHINGIE;
USES WINCRT,CRT,VPUTILS;

BEGIN
WRITELN('at first it looks like this ::D');
READLN;
SCROLLTO(13,40);
SETCURSORSIZE(100,100);
WRITELN('now it is here');
READLN;
WRITELN('now it should still be here ªª');
DONEWINCRT;
END.
