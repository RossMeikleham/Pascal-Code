PROGRAM X;

USES CRT,DRAW,MULTIWINDOW;

BEGIN
Snapshot:=ptr($B800);
WindowNumber:=0;
OpenWindow(30,5,50,18);
OpenWindow(10,10,65,15);
OpenWindow(15,12,35,22);
READLN;
CLOSEWINDOW;
READLN;
CLOSEWINDOW;
READLN;
CLOSEWINDOW;
END.
