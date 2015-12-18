UNIT SNAKEGRAPH; //GRAPHICS FUNCTIONS

INTERFACE

USES CRT;

CONST SQUARE=#219;
      FOOD=#207;

PROCEDURE CreateBorder(X1,Y1,X2,Y2:INTEGER);
PROCEDURE DrawPiece(X,Y:INTEGER);
PROCEDURE DrawRemove(X,Y:INTEGER);
PROCEDURE DrawFood(X,Y:INTEGER);

IMPLEMENTATION

PROCEDURE CreateBorder(X1,Y1,X2,Y2:INTEGER);
VAR X,Y:INTEGER;

   PROCEDURE CreateVLine(X,Y1,Y2:INTEGER);
      VAR Y:INTEGER;

         BEGIN
         Y:=Y1;
         WHILE Y<=Y2 DO
            BEGIN
            GOTOXY(X,Y);
            WRITE(Square);
            Y:=Y+1
            END;
         END;

   PROCEDURE CreateHLine(Y,X1,X2:INTEGER);
      VAR X:INTEGER;

         BEGIN
         X:=X1;
         WHILE X<=X2 DO
            BEGIN
            GOTOXY(X,Y);
            WRITE(Square);
            X:=X+1
            END;
         END;

   BEGIN
      CreateVLine(X1,Y1,Y2);
      CreateVLine(X2,Y1,Y2);
      CreateHLine(Y1,X1,X2);
      CreateHLine(Y2,X1,X2);
   END;


PROCEDURE DrawPiece(X,Y:INTEGER);
   BEGIN
      GOTOXY(X,Y);
      WRITE(Square);
   END;


PROCEDURE DrawRemove(X,Y:INTEGER);
   BEGIN
   TEXTCOLOR(BLACK);
   DrawPiece(X,Y);
   TEXTCOLOR(WHITE);
   END;


PROCEDURE DrawFood(X,Y:INTEGER);
   BEGIN
       GOTOXY(X,Y);
       WRITE(FOOD);
   END;


END.
