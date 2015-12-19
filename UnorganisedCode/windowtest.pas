PROGRAM MessageboxTest;

USES CRT,WINDOWS;



BEGIN
Messagebox(0,'Cannot use value of this type','ERROR',MB_ICONEXCLAMATION);
Messagebox(0,'Never gunna give you upppp','ERROR',MB_ICONHAND);
TEXTBACKGROUND(1);
TEXTCOLOR(3);
CLRSCR;
WRITELN('TESTTTTTT');
READLN;
WRITELN('test2');
READLN;
END.
