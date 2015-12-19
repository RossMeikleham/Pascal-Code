program samp;

type

    TempArray=Array[1..50] OF INTEGER;

    rec=record

        i:longint;

        f:real;

        c:char;

    end;

var

    p:^rec;
    CustArray:TempArray;
    Top:INTEGER;



PROCEDURE Test;

VAR NewArray:Array[1..Top];
BEGIN


END;
begin
    Top:=1;
    Test;
    new(p);

    p^.i:=10;

    p^.f:=3.14;

    p^.c:='a';

    writeln(p^.i);
    Writeln(p^.f);
    writeln(p^.c);
    readln;
    dispose(p);
    WRITELN;

    writeln(p^.i);
    Writeln(p^.f);
    writeln(p^.c);
    readln;

end.

