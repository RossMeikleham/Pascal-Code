UNIT TetrisGraph;
//Graphics for Tetris Game
//Ross Meikleham 2012


INTERFACE


USES CRT;

CONST Block='л'; //Block Ascii
      HorizLine='Э' ;
      VertLine='К';
      Up=#72;
      Down=#80;
      Left=#75;
      Right=#77;
      Space=#32;
      //Starting co-ordinates of the board
      Xstart=20;
      Ystart=2;
      //Background Color
      BckGrd=BLACK;

PROCEDURE UpdatePieceCount(PieceName:CHAR;Count:INTEGER);
PROCEDURE DrawBlock(PieceName:CHAR;XcoOrd,YCoOrd:INTEGER);
PROCEDURE DeleteBlock(XCoOrd,YCoOrd:INTEGER);
PROCEDURE UpdateScore(NextLevel,Level,Score,Lines:INTEGER);
PROCEDURE Initialise(Xmax,Ymax:INTEGER);
FUNCTION GetPieceColour(PieceName:CHAR):INTEGER;

IMPLEMENTATION


//Return Piece Colour based on Piece Type
FUNCTION GetPieceColour(PieceName:CHAR):INTEGER;
   BEGIN
      CASE PieceName OF
         'I':GetPieceColour:=RED;
         'J':GetPieceColour:=MAGENTA;
         'L':GetPieceColour:=YELLOW;
         'O':GetPieceColour:=CYAN;
         'S':GetPieceColour:=BLUE;
         'T':GetPieceColour:=LIGHTGRAY;
         'Z':GetPieceColour:=GREEN;
         //Remove Colour
         'R':GetPieceColour:=BckGrd;
      ELSE GetPieceColour:=0
      END;
   END;


PROCEDURE DrawBlock(PieceName:CHAR;XcoOrd,YCoOrd:INTEGER);
VAR PieceColour,X,Y:INTEGER;
   BEGIN

      PieceColour:=GetPieceColour(PieceName);
      TEXTCOLOR(PieceColour);

            X:=XcoOrd+XStart;
            Y:=YcoOrd+YStart;
            GOTOXY(X,Y);
            WRITE(Block);

   END;

PROCEDURE DeleteBlock(XCoOrd,YCoOrd:INTEGER);

   BEGIN
      DrawBlock('R',XCoOrd,YCoOrd);
   END;

//When Score changes, update on screen
PROCEDURE UpdateScore(NextLevel,Level,Score,Lines:INTEGER);
   BEGIN
      TEXTCOLOR(WHITE);
      GOTOXY(7,1);
      WRITE(Score);
      GOTOXY(7,3);
      WRITE(Lines);
      GOTOXY(7,5);
      WRITE(Level);
      GOTOXY(15,7);
      WRITE(NextLevel,' ');
   END;

PROCEDURE UpdatePieceCount(PieceName:CHAR;Count:INTEGER);
   BEGIN
      CASE PieceName OF
         'I':GOTOXY(40,4);
         'J':GOTOXY(39,7);
         'L':GOTOXY(39,10);
         'O':GOTOXY(39,13);
         'S':GOTOXY(39,15);
         'T':GOTOXY(39,19);
         'Z':GOTOXY(39,22);
      END;
      TEXTCOLOR(GetPieceColour(PieceName));
      WRITE(Count);
   END;


PROCEDURE Initialise(Xmax,Ymax:INTEGER);
VAR X,Y:INTEGER;
   BEGIN
      //Write Score Title
      TEXTCOLOR(WHITE);
      GOTOXY(1,1);
      WRITE('SCORE:0');
      GOTOXY(1,3);
      WRITE('LINES:0');
      GOTOXY(1,5);
      WRITE('LEVEL:0');
      GOTOXY(1,7);
      WRITE('LINES TO NEXT:10');
      GOTOXY(5,10);
      WRITE('H E L P');
      GOTOXY(1,12);
      WRITE(#27);
      WRITE(':Left');
      GOTOXY(1,13);
      WRITE(#26);
      WRITE(':Right');
      GOTOXY(1,14);
      WRITE(#24);
      WRITE(':Rotate Left');
      GOTOXY(1,15);
      WRITE(#25);
      WRITE(':Rotate Right');
      GOTOXY(1,16);
      WRITE('Space:Drop');
      GOTOXY(2,18);
      WRITE('NEXT:');

      GOTOXY(33,2);
      WRITE('S T A T I S T I C S');
      TEXTCOLOR(GetPieceColour('I'));
      GOTOXY(34,4);
      WRITE('лллл: 0');
      TEXTCOLOR(GetPieceColour('J'));
      GOTOXY(34,6);
      WRITE('л');
      GOTOXY(34,7);
      WRITE('ллл: 0');
      TEXTCOLOR(GetPieceColour('L'));
      GOTOXY(36,9);
      WRITE('л');
      GOTOXY(34,10);
      WRITE('ллл: 0');
      TEXTCOLOR(GetPieceColour('O'));
      GOTOXY(35,12);
      WRITE('лл');
      GOTOXY(35,13);
      WRITE('лл: 0');
      TEXTCOLOR(GetPieceColour('S'));
      GOTOXY(35,15);
      WRITE('лл: 0');
      GOTOXY(34,16);
      WRITE('лл');
      TEXTCOLOR(GetPieceColour('T'));
      GOTOXY(35,18);
      WRITE('л ');
      GOTOXY(34,19);
      WRITE('ллл: 0');
      TEXTCOLOR(GetPieceColour('Z'));
      GOTOXY(34,21);
      WRITE('лл');
      GOTOXY(35,22);
      WRITE('лл: 0');
      TEXTCOLOR(WHITE);
      //Draw Board

         FOR Y:=0 TO YMax DO
            BEGIN
               GOTOXY(XStart,YStart+Y);
               WRITE(VertLine);
            END;

         FOR Y:=0 TO YMax DO
            BEGIN
               GOTOXY(XStart+XMax+1,YStart+Y);
               WRITE(VertLine);
            END;

         GOTOXY(XStart,YStart+Ymax+1);
         WRITE(#200);
         FOR X:=1 TO XMax DO
            WRITE(HorizLine);
         WRITE(#188);

   END;


END.
