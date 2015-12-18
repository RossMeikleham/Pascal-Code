PROGRAM TESTFILL;
USES WINCRT, WINDOWS,DRAWTEST,CRT;

VAR hWindow : hWnd;
DC : hDC;

BEGIN
InitWinCRT;
GotoXY(3,2);
hWindow := GetFocus;
DC := GetDC(hWindow);
MoveTo(DC,10,10); LineTo(DC,128,10);
MoveTo(DC,10,10); LineTo(DC,10,36);
MoveTo(DC,10,36); LineTo(DC,128,36);
MoveTo(DC,128,10); LineTo(DC,128,36);



{TEXTCOLOR(7);
TEXTBACKGROUND(BLUE);}
WRITE(' ');
DRAW(1,5,60,20);  {X1,Y1,X2,Y2}
WriteLn('PASCAL IN A WINDOW`S WINDOW FUCK YEAH 8)');
ReleaseDC(hWindow,DC);

DONEWINCRT;
READLN;
END.

