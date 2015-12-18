PROGRAM FindKey;

USES CRT;

VAR key:CHAR;


BEGIN
TEXTCOLOR(WHITE);
WRITELN('Enter Key to find');
READLN;
Key:=UPCASE(READKEY);
WRITE(key);
WRITELN('< key');
READLN;
END.
