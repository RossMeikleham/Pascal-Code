PROGRAM NewThreadTest;

USES VPUTILS, CRT;

VAR X,ThreadId:LONGINT;

FUNCTION Thread(P:Pointer):LONGINT;

BEGIN
WRITELN('test1');
X:=X+1;
READLN;
END;



PROCEDURE Test;

BEGIN
X:=0;
WRITELN('testttt');
ThreadId:=VPBEGINTHREAD(Thread, 16384, nil);

WHILE X<2 DO
WRITELN(ThreadId);

END;


BEGIN
Test;
END.



