PROGRAM QUEENS;

USES CRT,DRAW,VPUTILS;

TYPE BoardArray=ARRAY['A'..'H',1..8,1..1] OF CHAR;
     CursorArrayX=ARRAY['A'..'H'] OF INTEGER;
     CursorArrayY=ARRAY[1..8] OF INTEGER;



  VAR Board:BoardArray; {Each position on the chessboard is either set to}
                        {'E' (Empty)  'Q' (Contains a Queen) or 'T' (Can't}
                        {be used else 2 Queens are in 'range' of each other')}

      CursorX:CursorArrayX; {Location of each chess square}
      CursorY:CursorArrayY;



   PROCEDURE Create; {Draws the Chessboard}
   VAR X,Y:ARRAY[1..8] OF LONGINT;
       I,J:INTEGER;
       K:CHAR;

      BEGIN

         X[1]:=17;
         Y[1]:=40;
         I:=1;
         J:=1;

         FOR I:= 2 TO 8 DO

         BEGIN
         X[I]:=X[I-1]+6;
         Y[I]:=Y[I-1]-4;
         END;

            BEGIN

            FOR I:=1 TO 8 DO

               FOR J:=1 TO 8 DO

               BEGIN
               IF(((I+J)/2) <> ROUND((I+J)/2)) THEN
               TEXTBACKGROUND(WHITE)
               ELSE TEXTBACKGROUND(RED);

               FILLBOX(X[I],Y[J]-4,X[I]+6,Y[J]);
               //DELAY(20);
               END;

            END;
            TEXTBACKGROUND(BLACK);
            FILLBOX(X[8]+6,Y[8]-4,X[8]+6,Y[1]);




           I:=1;
           FOR K:='A' TO 'H' DO
           BEGIN
           CursorX[K]:=(X[I]+2);
           I:=I+1
           END;

        FOR I:=1 TO 8 DO
        CursorY[I]:=(Y[I]-2);

        FOR K:='A' TO 'H' DO
           FOR I:=1 TO 8 DO
              BEGIN
              GOTOXY(CursorX[K],CursorY[I]);
              WRITE(K,I);
              END;


      END;



   PROCEDURE GoToSquare(Z:STRING);     {sets cursor to square location}
   VAR Erval,Y:LONGINT;


       BEGIN
       VAL(Z[2],Y,Erval);
       GOTOXY(CursorX[Z[1]],CursorY[Y]);

       END;


   PROCEDURE SetBoard;  {Sets all 64 places on the chessboard to empty}
   VAR X:CHAR;
       Y:LONGINT;

      BEGIN

         FOR X:='A' TO 'H' DO

            FOR Y:=1 TO 8 DO

               BEGIN

                  Board[X,Y,1]:='E';

               END;


      END;







   PROCEDURE Start;


      BEGIN
         GoToSquare('D4');
         WRITE('Q');
         READLN;

      END;


BEGIN
SETVIDEOMODE(80,45);
CREATE;
START;
READLN;
END.
