PROGRAM CREATECIRCLE;
USES CRT;
VAR R,X,Y,TempX,TempY,Z:REAL;

PROCEDURE OBTAIN;
BEGIN
WRITELN('Enter Radius of circle');
READLN(R);
WRITELN('Enter X Co-ordinate of centre of circle');
READLN(X);
WRITELN('Enter Y Co-ordinate of centre of circle');
READLN(Y);
END;

PROCEDURE DRAW;
VAR I:INTEGER;

   BEGIN
      TempX:=X;
      TempY:=Y;
      FOR I:= 1 TO 360 DO

      BEGIN;
      Z:=I;
      X:=(COS(Z*0.0174532925)*R)+TempX;
      Y:=(SIN(Z*0.0174532925)*R)+TempY;
      WRITELN(I,':  ',X:1:3,'    ',Y:1:3);
      END;
END;

BEGIN
OBTAIN;
DRAW;
READLN;
END.

