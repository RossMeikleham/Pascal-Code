PROGRAM Checkers;

USES CRT,DRAW,VPUTILS,debug;

CONST Up='H';
      Down='P';
      Left='K';
      Right='M';

TYPE BoardArray=ARRAY['A'..'H',1..8,1..1] OF CHAR;
     CursorArrayX=ARRAY['A'..'H'] OF INTEGER;
     CursorArrayY=ARRAY[1..8] OF INTEGER;
     Pieces=ARRAY[1..12] OF STRING;


  VAR Board:BoardArray; {Each position on the chessboard is either set to}
                        {'E' (Empty)  'Q' (Contains a Queen) or 'T' (Can't}
                        {be used else 2 Queens are in 'range' of each other')}

      CursorX:CursorArrayX; {Location of each chess square}
      CursorY:CursorArrayY;
      NoOfBlaCkCheckers:LONGINT=12;
      NoOfWhiteCheckers:LONGINT=12;
      BlackPieces:Pieces=('B8','D8','F8','H8','A7','C7','E7','G7',
                          'B6','D6','F6','H6');

      WhitePieces:Pieces=('A1','C1','E1','G1','B2','D2','F2','H2',
                          'A3','C3','E3','G3');

      KEY:CHAR;

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
              //GOTOXY(CursorX[K],CursorY[I]);
              //WRITE(K,I);
              END;


      END;



   PROCEDURE GoToSquare(Z:STRING);     {sets cursor to square location}
   VAR Erval,Y:LONGINT;


       BEGIN
       VAL(Z[2],Y,Erval);
       GOTOXY(CursorX[Z[1]],CursorY[Y]);

       END;


   PROCEDURE SetBoard;  {Sets all 64 places on the board to empty}
   VAR X:CHAR;
       Y:LONGINT;

      BEGIN

         FOR X:='A' TO 'H' DO

            FOR Y:=1 TO 8 DO

               BEGIN

                  Board[X,Y,1]:='E';

               END;


      END;



   PROCEDURE SetCursor(Key:CHAR);

   BEGIN

   IF (Key=LEFT) AND (WHEREX>CursorX['A']) THEN GOTOXY(WHEREX-6,WHEREY);
   IF (Key=RIGHT) AND (WHEREX<CursorX['H']) THEN GOTOXY(WhereX+6,WHEREY);

   IF (Key=UP) AND (WHEREY<CursorY[8]) THEN GOTOXY(WHEREX,WHEREY+4);
   IF (Key=DOWN) AND (WHEREY>CursorY[1]) THEN GOTOXY(WHEREX,WHEREY-4);

   END;




   PROCEDURE Start;
   VAR I:LONGINT;

      BEGIN
      FOR I:=1 TO 12 DO
      BEGIN
         GoToSquare(BlackPieces[I]);
         TEXTCOLOR(BLACK);
         WRITE('[]');
         GoToSquare(WhitePieces[I]);
         TEXTBACKGROUND(WHITE);
         TEXTCOLOR(White);
         WRITE('[]');
         TEXTBACKGROUND(BLACK);
      END;


      END;


BEGIN
SETVIDEOMODE(80,45);
CREATE;
START;
GOTOXY(19,38);
REPEAT
Key:=UPCASE(READKEY);
IF (KEY=UP) OR (Key=DOWN) OR (Key=LEFT) OR (Key=RIGHT) THEN
SETCURSOR(KEY);
UNTIL KEY=#27;
END.
