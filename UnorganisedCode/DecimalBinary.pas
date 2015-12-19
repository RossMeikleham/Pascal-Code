PROGRAM DecimalBinary;

   USES DRAWTEST,CRT;

   VAR BinaryArray:ARRAY[1..10] OF INTEGER=(0,0,0,0,0,0,0,0,0,0);
       NumberArray:ARRAY[1..10] OF INTEGER=(1,2,4,8,16,32,64,128,256,512);
       ReadNumber:REAL;
       IntNumber:INTEGER;





   PROCEDURE CalculateBinary;
      VAR IntNumber,I:LONGINT;

      BEGIN

         I:=1;
         REPEAT

            IntNumber:=TRUNC(ReadNumber);
            IF ODD(IntNumber) THEN
               BinaryArray[I] := 1
            ELSE BinaryArray[I] :=0;
            ReadNumber:=TRUNC(ReadNumber/2);
            I:=I+1;

         UNTIL ReadNumber=0;

      END;






   PROCEDURE Display;
   VAR X,I:INTEGER;
   BEGIN

      X:=12;

      TEXTCOLOR(LIGHTCYAN);
      DRAW(6,1,60,5);
      DRAW(6,8,66,11);
      DRAW(6,8,66,14);

      FOR I:=1 TO 9 DO
      BEGIN
      DRAWVLINE(X,8,X,14);
      GOTOXY(X,8);
      WRITE(#194);
      GOTOXY(X,14);
      WRITE(#193);
      X:=X+6;
      END;

      X:=8;
      I:=10;

      REPEAT

      TEXTCOLOR(WHITE);
      GOTOXY(X,9);
      WRITE(NumberArray[I]);
      GOTOXY(X+1,12);
      TEXTCOLOR(LIGHTGREEN);
      WRITE(BinaryArray[I]);
      X:=X+6;
      I:=I-1
      UNTIL I=0;



READLN;



END;

BEGIN
TEXTCOLOR(LIGHTGREEN);
GOTOXY(20,3);
WRITELN('Enter Number(Between 1 And 1023): ');
GOTOXY(55,3);
READLN(ReadNumber);
CalculateBinary;
Display;
END.

