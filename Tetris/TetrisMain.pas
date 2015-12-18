PROGRAM TetrisMain;
//Tetris Game
//By Ross Meikleham 2012


USES TetrisFunc,TetrisGraph,CRT;

VAR Debug:BOOLEAN=TRUE;

PROCEDURE RedrawBoard(Board:TBoard);
VAR X,Y:INTEGER;
   BEGIN
      WINDOW(XStart+1,YStart,XStart+BoardMaxX,YStart+BoardMaxY);
      CLRSCR;
      WINDOW(1,1,80,25);

      FOR Y:=1 TO BoardMaxY DO
         FOR X:=1 TO BoardMaxX DO

            DrawBlock(Board.BoardState[X,Y].BlockName,X,Y);

      IF Debug THEN
        // DrawBoardState(60,3,Board);
   END;

PROCEDURE PlacePiece(Board:TBoard;Piece:TPiece);

   BEGIN
      Board.PlacePiece(Piece);

      Board.CheckComplete;
      RedrawBoard(Board);
      Piece.Placed:=TRUE;
      UpdateScore(Board.NextLevel,Board.Level,Board.Score,Board.Lines);

   END;



PROCEDURE DrawPiece(PieceName:CHAR;CoOrds:TCoOrds);
VAR Pos,X,Y:INTEGER;
   BEGIN
      FOR Pos:=1 TO 4 DO
         BEGIN
            X:=CoOrds[Pos,'X'];
            Y:=CoOrds[Pos,'Y'];
            DrawBlock(PieceName,X,Y);
         END;
   END;

PROCEDURE DrawRemovePiece(CoOrds:TCoOrds);
VAR Pos,X,Y:INTEGER;
   BEGIN
      FOR Pos:=1 TO 4 DO
         BEGIN
            X:=CoOrds[Pos,'X'];
            Y:=CoOrds[Pos,'Y'];
            DeleteBlock(X,Y);
         END;
   END;


//Draws the new position of the current falling piece
PROCEDURE DrawMovePiece(Piece:TPiece);
VAR PieceName:CHAR;

   BEGIN
      PieceName:=Piece.GetPieceName; //Obtain Piece Name
      DrawRemovePiece(Piece.GetPrevCoOrds); //Remove Previous Drawn Piece
      DrawPiece(PieceName,Piece.GetCoOrdinates); //Draw Current Positions of Piece
   END;


//Checks if a move will cause the piece to collide with a wall or
//An already placed block

FUNCTION PieceCollision(Board:TBoard;CoOrds:TCoOrds):BOOLEAN;
VAR BoardState:TBoardState;
    Collision:BOOLEAN;
    Pos,X,Y:INTEGER;

   BEGIN
      BoardState:=Board.GetBoardState;
      Collision:=FALSE;
      Pos:=1;
      //Check all co-ordinates of every block with
      //co-ordinates of the board to see if a block
      //already exists there

      WHILE (NOT Collision) AND (Pos<5) DO
         BEGIN
            X:=CoOrds[Pos,'X'];
            Y:=CoOrds[Pos,'Y'];
            IF (BoardState[X,Y].Occupied=TRUE) OR ( X<1 ) OR (X>BoardMaxX) OR
            (Y>BoardMaxY)
             THEN
               Collision:=TRUE
            ELSE INC(Pos);

         END;
     PieceCollision:=Collision;

   END;

//Generates One of the 7 Tetrominoes
FUNCTION RandomPiece(Board:TBoard):TPiece;
VAR Num:INTEGER;
    Piece:TPiece;

   BEGIN
      RANDOMIZE;
      Num:=RANDOM(7);//Generate Random Number from 0-7

      CASE Num OF
      0:Piece:=TIPiece.Create;
      1:Piece:=TJPiece.Create;
      2:Piece:=TLPiece.Create;
      3:Piece:=TOPiece.Create;
      4:Piece:=TSPiece.Create;
      5:Piece:=TTPiece.Create;
      6:Piece:=TZPiece.Create;
      END;

   RandomPiece:=Piece;
   END;

PROCEDURE MoveToBottom(Board:TBoard;Piece:TPiece);
   BEGIN
      REPEAT
        Piece.PutPrevCoOrds(Piece.GetCoOrdinates);
        IncPiece(Piece);
      UNTIL PieceCollision(Board,Piece.GetCoOrdinates);
   END;

PROCEDURE MovePiece(Board:TBoard;Piece:TPiece;Dir:CHAR);
   BEGIN
      Piece.PutPrevCoOrds(Piece.GetCoOrdinates); //Set previous co-ordinates to current
      CASE Dir OF
       'R':Piece.MoveRight;
       'L':Piece.MoveLeft;
       'D':MoveToBottom(Board,Piece);
       'I':IncPiece(Piece);
       'Z':Piece.RotateLeft;
       'X':Piece.RotateRight;
      END;
       IF PieceCollision(Board,Piece.GetCoOrdinates) THEN //If the move causes a collision
          BEGIN
             Piece.PutCoOrdinates(Piece.PrevCoOrds); //Set the co-ordinates back
             IF (Dir='I') OR (Dir='D')THEN
                PlacePiece(Board,Piece);
          END
       ELSE
       DrawMovePiece(Piece);
   END;



//Move one of the pieces
PROCEDURE PieceAction(Board:TBoard;Piece:TPiece);
VAR Timer:INTEGER;
    Key:CHAR;
   BEGIN
      Timer:=0;
      REPEAT

         IF KeyPressed THEN
            BEGIN
               Key:=READKEY;
               CASE UPCASE(Key) OF
                  LEFT:MovePiece(Board,Piece,'L');
                  RIGHT:MovePiece(Board,Piece,'R');
                  SPACE:MovePiece(Board,Piece,'D');
                  UP:MovePiece(Board,Piece,'Z');
                  DOWN:MovePiece(Board,Piece,'X');

               END;
            END;
         INC(Timer);
      UNTIL Timer>=(60000-(Board.Level*1000)); //when Time to make an action runs out
      IF Piece.Placed=FALSE THEN //Don't move piece if already placed
         MovePiece(Board,Piece,'I'); //Piece moves downwards by 1 block
   END;




//Displays the next piece that will fall
PROCEDURE ShowNext(Piece:TPiece);
VAR TempCoOrd:TCoOrds;
    Pos:INTEGER;
   BEGIN
      WINDOW(1,20,19,25);
      CLRSCR;
      WINDOW(1,1,80,25);
      TempCoOrd:=Piece.CoOrdinates;
      FOR Pos:=1 TO 4 DO
         BEGIN
         TempCoOrd[Pos,'X']:=TempCoOrd[Pos,'X']+1;
         TempCoOrd[Pos,'Y']:=TempCoOrd[Pos,'Y']+19;
         GOTOXY(TempCoOrd[Pos,'X'],TempCoOrd[Pos,'Y']);
         TEXTCOLOR(GetPieceColour(Piece.PieceName));
         WRITE(Block);
         END;

   END;

PROCEDURE Main;
VAR Piece,NextPiece:TPiece;
    Board:TBoard;
    Timer,x,y,Count:INTEGER;
    Lose:BOOLEAN;
   BEGIN

      Board:=TBoard.Create; //Create the tetris board
      //  IF Debug THEN
     // DrawBoardState(60,3,Board);
      Initialise(BoardMaxX,BoardMaxY); //Initialise the screen
      NextPiece:=RandomPiece(Board);

         REPEAT

            Piece:=NextPiece;
            NextPiece:=RandomPiece(Board);
            ShowNext(NextPiece);

            //If there's a collision as soon as a piece is placed
            //then the player has lost
            IF NOT PieceCollision(Board,Piece.CoOrdinates) THEN
               BEGIN
                  REPEAT

                  PieceAction(Board,Piece);

                  UNTIL Piece.Placed; //Repeat until piece has been placed on board

                  INC(Board.PieceCount[PieceNum(Piece.PieceName)]);
                  UpdatePieceCount(Piece.PieceName,Board.PieceCount[PieceNum(Piece.PieceName)]);
               END
            ELSE Board.Lose:=TRUE;
         UNTIL Board.Lose; //Repeat game until lost

      GOTOXY(30,24);
      WRITELN('You Lose,Press Enter to exit');
      READLN;
   END;

BEGIN
//HideCursor;
Main;
END.
