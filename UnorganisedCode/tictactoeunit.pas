UNIT TICTACTOE;
{Created by Ross Meikleham 2010}

INTERFACE
USES CRT,VPUTILS,Draw;


TYPE CoordinateArray=ARRAY[1..3] OF INTEGER;

VAR FillArray:ARRAY[1..3,1..3] OF CHAR;
    Xbox:CoordinateArray;
    Ybox:CoordinateArray;
    Player1:BOOLEAN;
    NoFilled:INTEGER;
    OutCome:STRING;
    WinArray:ARRAY[1..8] OF INTEGER=(7,56,73,84,146,273,292,448);
    GameOver:BOOLEAN;


CONST Up='H';
      Down='P';
      Left='K';
      Right='M';

PROCEDURE PlayGame;

IMPLEMENTATION
PROCEDURE start;
VAR Y,I:INTEGER;

  BEGIN
  Y:=8;

  GOTOXY(20,3);
  WRITELN('Player 1: X');
  GOTOXY(60,3);
  WRITELN('Player 2: O');
  GOTOXY(1,25);
  TEXTBACKGROUND(BLUE);
  FOR I:=1 TO 80 DO WRITE(' ');
  TEXTCOLOR(WHITE);
  GOTOXY(5,25);
  WRITE('Arrow keys to moves to a square, `C` to select the square');
  FOR I:=1 TO 3 DO

  BEGIN
     {Draw the playing field :D}
     TEXTBACKGROUND(RED);
     TEXTCOLOR(BLACK);
     FillBox(25,Y,35,Y+4);
     DrawBox(25,Y+1,35,Y+4);
     TEXTBACKGROUND(WHITE);
     TEXTCOLOR(BLACK);
     Fillbox(36,Y,45,Y+4);
     Drawbox(36,Y+1,45,Y+4);
     TEXTBACKGROUND(RED);
     Fillbox(46,Y,55,Y+4);
     Drawbox(46,Y+1,55,Y+4);
     Y:=Y+4;

  END;

  {Positions where the cursor is to move to in X,Y co-ordinates}
  Xbox[1]:=30;
  Xbox[2]:=40;
  Xbox[3]:=51;

  Ybox[1]:=11;
  Ybox[2]:=15;
  Ybox[3]:=19;

  END;


   PROCEDURE WinConditions;
   VAR TotalX,TotalO,I:INTEGER;
      BEGIN

         TotalX:=0;
         TotalO:=0;

         {Each square is assigned a value to the power of 2}
         {From left to right, specific combinations can tell which}
         {squares each player has selected, there are 8 ways to win}
         {in which 8 seperate totals can be used}
         {1, 2,  4}
         {8, 16, 32}
         {64,128,256}

         {1+16+256=273 (Diagonal top left to bottom right)}

         IF FillArray[1,1]='X' THEN TotalX:=TotalX+1;
         IF FillArray[1,2]='X' THEN TotalX:=TotalX+2;
         IF FillArray[1,3]='X' THEN TotalX:=TotalX+4;
         IF FillArray[2,1]='X' THEN TotalX:=TotalX+8;
         IF FillArray[2,2]='X' THEN TotalX:=TotalX+16;
         IF FillArray[2,3]='X' THEN TotalX:=TotalX+32;
         IF FillArray[3,1]='X' THEN TotalX:=TotalX+64;
         IF FillArray[3,2]='X' THEN TotalX:=TotalX+128;
         IF FillArray[3,3]='X' THEN TotalX:=TotalX+256;

         IF FillArray[1,1]='O' THEN TotalO:=TotalO+1;
         IF FillArray[1,2]='O' THEN TotalO:=TotalO+2;
         IF FillArray[1,3]='O' THEN TotalO:=TotalO+4;
         IF FillArray[2,1]='O' THEN TotalO:=TotalO+8;
         IF FillArray[2,2]='O' THEN TotalO:=TotalO+16;
         IF FillArray[2,3]='O' THEN TotalO:=TotalO+32;
         IF FillArray[3,1]='O' THEN TotalO:=TotalO+64;
         IF FillArray[3,2]='O' THEN TotalO:=TotalO+128;
         IF FillArray[3,3]='O' THEN TotalO:=TotalO+256;

         {Checks the total value of the squares each player has selected}
         {after each move and does a search to see if the total equals that}
         {of 1 of the 8 'winning' totals}

         FOR I:=1 TO 8 DO
         BEGIN
         IF TotalX=WinArray[I] THEN Outcome:='Player 1 Wins';
         IF TotalO=WinArray[I] THEN Outcome:='Player 2 Wins';
         END;

         {If all 9 squares have been filled and no player has a 'winning total' then}
         {no player has won and it must be a draw}
         IF (NoFilled=9) AND (Outcome<>'Player 1 Wins') AND (OutCome<>'Player 2 Wins') THEN

         OutCome:='Draw';

         IF (NoFilled=9) OR (Outcome='Player 1 Wins') OR (OutCome='Player 2 Wins')
         THEN BEGIN
         GOTOXY(34,23);
         TEXTCOLOR(WHITE);
         TEXTBACKGROUND(BLACK);
         WRITELN(OutCome);
         GameOver:=TRUE;
         END;

      END;


   PROCEDURE Fill(X,Y:INTEGER; Player:INTEGER);

      BEGIN
      {Checks the square hasn't already been filled}
      IF (FillArray[X,Y] <>'X') AND (Fillarray[X,Y] <> 'O') THEN

         BEGIN
         IF X=2 THEN TEXTBACKGROUND(WHITE) ELSE
         TEXTBACKGROUND(RED);
         IF Player1=TRUE THEN

         BEGIN
         FillArray[X,Y]:='X';
         WRITE('X');
         END;

         IF Player1=FALSE THEN

         BEGIN
         FillArray[X,Y]:='O';
         WRITE('O');
         END;
         {Sets the go to the opposite player}
         IF Player=1 THEN Player1:=FALSE;
         IF Player=2 THEN Player1:=TRUE;
         {sets number of moves player to +1}
         NoFilled:=NoFilled+1;
         WinConditions;

        END;
      END;



   PROCEDURE Go;
   VAR Z:CHAR;
       X,Y:INTEGER;

      BEGIN
      X:=1;
      Y:=1;
         REPEAT
         REPEAT
         GOTOXY(Xbox[X],Ybox[Y]);
         IF KeyPressed= TRUE THEN
         BEGIN
         Z:=UPCASE(READKEY);
         IF (Z=Up) AND (Y<>1) THEN Y:=Y-1; {If up and not at top, move up}
         IF (Z=Down) AND (Y<>3) THEN Y:=Y+1; {If down and not at bottom move down}
         IF (Z=Left) AND (X<>1) THEN X:=X-1; {If left and not at beginning move left}
         IF (Z=Right) AND (X<>3) THEN X:=X+1;{if right and not at end move right}
         END;
         UNTIL Z='C';
         IF Player1=TRUE THEN {If player1's go, take his go}
         Fill(X,Y,1) ELSE     {Else take player2's go}
         Fill(X,Y,2);
         Z:='V';              {set Z to something else so it doesn't loop infinite}
         UNTIL GameOver=TRUE; {Repeat until the game ends}
      END;



PROCEDURE PlayGame;
BEGIN
SETVIDEOMODE(80,25);
Player1:=TRUE;
NoFilled:=0;
Start;
GO;
READLN;
END;
END.

