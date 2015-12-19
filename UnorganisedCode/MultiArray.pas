PROGRAM MULTIARRAYTEST;

USES CRT;

TYPE

   TypeA= ARRAY[1..10,1..10] OF INTEGER; {10*10 = total of 50 positions in}
                                       {2 dimensional array [1,1] to [10,10]}

VAR
   A:TypeA;


   PROCEDURE Calculate;
   VAR X,Y,I:INTEGER;

      BEGIN

         X:=1; {X= 1st part of the 2d array}
         Y:=0  {Y= 2nd part of the 2d array}
         I:=0; {I= Value of the array}

         REPEAT

           X:=1;       {Sets the 2nd part of the array}
           I:=I+1;     {as it starts [1,1] then [2,1]..}
           Y:=Y+1;     {then when it gets to [10,1] the next value is [1,2]}
           A[X,Y] :=I;
           GOTOXY(X,Y);     {Goes to the X and Y values to show the array in a}
           WRITELN(A[X,Y]); {graphical form}

          REPEAT
           I:=I+1;        {Sets the 1st part of the array}
           A[X,Y] := I;   {this part repeats until the X value is 10}
           GOTOXY(X*4,Y); {as it goes from [1,Y] to [10,Y]}
           WRITELN(A[X,Y]);
           X:=X+1;
          UNTIL X=10;

         UNTIL Y=10;

      END;


BEGIN
Calculate;
READLN;
END.
