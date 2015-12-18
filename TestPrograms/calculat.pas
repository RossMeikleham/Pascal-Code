PROGRAM CIRCLETEST;
VAR A,B,C,R,X,Y,TempX,TempY:REAL;
    I:INTEGER;

BEGIN

   WRITE('Enter the radius');
   READLN(R);
   WRITE('Enter the X-Coordinate');
   READLN(X);
   WRITE('Enter the Y-Coordinate');
   READLN(Y);
   TempX:=X;
   TempY:=Y;

   FOR I:= 1 TO 360 DO

      BEGIN

         A:=(2*SQR(R)-2*SQR(R)*COS(I*0.0174532925));

         B:=(SIN(R*0.0174532925)/SIN(A*0.0174532925))*A;

         C:= SQRT(SQR(A)+SQR(B));

         X:=TempX+C;
         Y:=TempY+B;
         WRITELN(I,':  ',X:1:3,'   ',Y:1:3);
      END;
   READLN;

END.


