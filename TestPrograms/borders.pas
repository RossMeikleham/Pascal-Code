
Program Borders;



Uses WinCRT, Windows;


Var hWindow : hWnd;
DC : hDC;

Begin
InitWinCRT;
GotoXY(3,2);
WriteLn('Demonstration');
hWindow := GetFocus;
DC := GetDC(hWindow);
MoveTo(DC,10,10); LineTo(DC,128,10);
MoveTo(DC,10,10); LineTo(DC,10,36);
MoveTo(DC,10,36); LineTo(DC,128,36);
MoveTo(DC,128,10); LineTo(DC,128,36);
ReleaseDC(hWindow,DC);
ReadLn;
DoneWinCRT;
End.
