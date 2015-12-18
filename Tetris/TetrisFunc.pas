UNIT TetrisFunc;
{Contains all core data structures and routines
 for Tetris
 Created by Ross Meikleham 2012}

{$mode objfpc}{$H+}

INTERFACE

USES CRT;

CONST BoardMaxX=10;
      BoardMaxY=22;

TYPE


   TCoOrd=ARRAY['X'..'Y'] OF INTEGER;
   TcoOrds=ARRAY[1..4] OF TCoOrd; //Contains co-ordinates of pieces
   PTCoOrd=^TCoOrd;

   //Tetris Piece Class
   TPiece = CLASS

      PieceName:CHAR;
      CoOrdinates:TcoOrds; //Current CoOrdinates of Piece
      PrevCoOrds:TCoOrds; //Previous CoOrdinates of Piece
      Origin:PTCoOrd; //Location of Piece origin
      Form:INTEGER; //Rotation form 1-4 piece is currently in
      Placed:BOOLEAN; //Whether the piece has been locked into the board
      OriginX,OriginY:^INTEGER;
      PRIVATE
         PROCEDURE Rotate(Radians:REAL);

      PUBLIC
      PROCEDURE GetWidth;
      PROCEDURE GetHeight;
      PROCEDURE MoveLeft; //Move Piece to the left
      PROCEDURE MoveRight; //Move Piece to the right
      PROCEDURE RotateLeft; VIRTUAL;
      PROCEDURE RotateRight; VIRTUAL;

      //Put Methods
      PROCEDURE PutCoOrdinates(NewCoOrdinates:TCoOrds); //Change Piece Co-Ordinates
      PROCEDURE PutPrevCoOrds(NewCoOrdinates:TCoOrds); //Change old piece Co-Ordinates
      PROCEDURE PutForm(NewForm:INTEGER);
      PROCEDURE PutPieceName(NewName:CHAR);

      //Get Methods
      FUNCTION GetCoOrdinates:TcoOrds;
      FUNCTION GetPrevCoOrds:TCoOrds;
      FUNCTION GetOrigin:TCoOrd;
      FUNCTION GetForm:INTEGER;
      FUNCTION GetPieceName:CHAR;

      //Create Constructor
      CONSTRUCTOR Create(PName:CHAR);

   END;


   //Each Individual 7 Tetrominoes

   TIPiece=CLASS(TPiece) //I Piece
      PUBLIC
         CONSTRUCTOR Create;
   END;

   TJPiece=CLASS(TPiece) //J Piece
       PUBLIC
         CONSTRUCTOR Create;
   END;

   TLPiece=CLASS(Tpiece) //L Piece
       PUBLIC
         CONSTRUCTOR Create;
   END;

   TOPiece= CLASS(TPiece) //O Piece
      PUBLIC
         CONSTRUCTOR Create;
         PROCEDURE RotateLeft;  OVERRIDE;
         PROCEDURE RotateRight; OVERRIDE;
   END;

   TSPiece=CLASS(TPiece) //S Piece
      PUBLIC
         CONSTRUCTOR Create;
   END;

   TTPiece=CLASS(TPiece) //T Piece
      PUBLIC
         CONSTRUCTOR Create;
   END;


   TZPiece=CLASS(TPiece) //Z Piece
      PUBLIC
         CONSTRUCTOR Create;
   END;


   //State of a single block
   TBlockState=RECORD
      Occupied:BOOLEAN; //If block is occupied, or empty
      BlockName:CHAR; //Name of the block
   END;

   //State of the Entire Board
   TBoardState=ARRAY[1..BoardMaxX,1..BoardMaxY] OF TBlockState;

   //Tetris Board Class
   TBoard = CLASS
   Score:INTEGER;  //Current Score for board
   Lines:INTEGER; //No of lines completed
   Level:INTEGER; //Current level
   NextLevel:INTEGER; //Lines to next level
   Lose:BOOLEAN;
   PieceCount:ARRAY[1..7] OF INTEGER;
   BoardState:TBoardState; //State of the board


      PROCEDURE CheckComplete; //Check for any complete rows

   PUBLIC

      PROCEDURE PlacePiece(Piece:Tpiece); //Add a tetris piece to the board
      PROCEDURE ClearRow(RowNo:INTEGER); //Clear a tetris line

      //Put Methods:
      PROCEDURE PutBoardState(NewBoardState:TBoardState);
      //Get Methods:
      FUNCTION GetBoardState:TBoardState;
      //Constructor
      CONSTRUCTOR Create;
   END;

   PROCEDURE IncPiece(VAR Piece:TPiece);
   FUNCTION PieceNum(PieceName:CHAR):INTEGER;

IMPLEMENTATION



CONSTRUCTOR TPiece.Create(PName:CHAR);
   BEGIN
      PieceName:=PName;
      Placed:=FALSE;
   END;


PROCEDURE TPiece.GetWidth;
   BEGIN

   END;


PROCEDURE TPiece.GetHeight;
   BEGIN
   END;

PROCEDURE TPiece.MoveLeft;
VAR Pos:INTEGER;
   BEGIN
      FOR Pos:=1 TO 4 DO
         DEC(CoOrdinates[Pos,'X']); //Decrement X Co-Ordinate
   END;

PROCEDURE TPiece.MoveRight;
VAR Pos:INTEGER;
   BEGIN
      FOR Pos:=1 TO 4 DO
         INC(CoOrdinates[Pos,'X']); //Increment X Co-Ordinate
   END;

//Rotate Piece by an amount of radians
PROCEDURE TPiece.Rotate(Radians:REAL);
   VAR X,Y,oX,oY,Pos:INTEGER;
    CoOrds:TCoOrds;
   BEGIN
     //Obtain Origin Points
      oX:=OriginX^;
      oY:=OriginY^;
      GOTOXY(30,10);
      FOR Pos:=1 TO 4 DO
         BEGIN
              //Set every block in the piece relative to the origin piece as 0,0

            CoOrds[Pos,'X']:=CoOrdinates[Pos,'X']-oX;
            CoOrds[Pos,'Y']:=CoOrdinates[Pos,'Y']-oY;
            //Use rotation matrix with theta=radians

            X:=ROUND(CoOrds[Pos,'X']*COS(Radians)-CoOrds[Pos,'Y']*SIN(Radians));
            Y:=ROUND(CoOrds[Pos,'X']*SIN(Radians)+CoOrds[Pos,'Y']*COS(Radians));
            //Change co-ordinates to new ones
            CoOrdinates[Pos,'X']:=X+oX;
            CoOrdinates[Pos,'Y']:=Y+oY;
         END;
      END;

//Rotate Piece Left
PROCEDURE TPiece.RotateLeft;
   BEGIN
      Self.Rotate(-PI/2);
   END;

//Rotate Piece Right
PROCEDURE TPiece.RotateRight;
   BEGIN
      Self.Rotate(PI/2);
   END;


//Put Methods
PROCEDURE TPiece.PutCoOrdinates(NewCoOrdinates:TCoOrds);
   BEGIN
      CoOrdinates:=NewCoOrdinates;
   END;


PROCEDURE TPiece.PutPrevCoOrds(NewCoOrdinates:TCoOrds);
   BEGIN
      PrevCoOrds:=NewCoOrdinates;
   END;

PROCEDURE TPiece.PutForm(NewForm:INTEGER);
   BEGIN
      Form:=NewForm;
   END;


PROCEDURE TPiece.PutPieceName(NewName:CHAR);
   BEGIN
      PieceName:=NewName;
   END;


//Get Methods

FUNCTION TPiece.GetCoOrdinates:TcoOrds;
   BEGIN
      RESULT:=CoOrdinates;
   END;

FUNCTION TPiece.GetPrevCoOrds:TCoOrds;
   BEGIN
      RESULT:=PrevCoOrds;
   END;

FUNCTION TPiece.GetForm:INTEGER;
   BEGIN
      RESULT:=Form;
   END;

FUNCTION TPiece.GetOrigin:TCoOrd;
   BEGIN
      RESULT:=Origin^;
   END;

FUNCTION TPiece.GetPieceName:CHAR;
   BEGIN
      RESULT:=PieceName;
   END;


CONSTRUCTOR TIPiece.Create;
VAR X,Y:INTEGER;
   BEGIN
      X:=BoardMaxX DIV 2;
      Y:=2;
      GETMEM(OriginX,SIZEOF(INTEGER));
      GETMEM(OriginY,SIZEOF(INTEGER));
      CoOrdinates[1,'X']:=X;
      CoOrdinates[1,'Y']:=Y-1;
      CoOrdinates[2,'X']:=X;
      CoOrdinates[2,'Y']:=Y;
      CoOrdinates[3,'X']:=X;
      CoOrdinates[3,'Y']:=Y+1;
      CoOrdinates[4,'X']:=X;
      CoOrdinates[4,'Y']:=Y+2;

      OriginX:=@(CoOrdinates[2,'X']);
      OriginY:=@(CoOrdinates[2,'Y']);

      INHERITED Create('I');
   END;


CONSTRUCTOR TJPiece.Create;
VAR X,Y:INTEGER;
   BEGIN

      X:=BoardMaxX DIV 2;
      Y:=2;

      CoOrdinates[1,'X']:=X+1;
      CoOrdinates[1,'Y']:=Y-1;
      CoOrdinates[2,'X']:=X+1;
      CoOrdinates[2,'Y']:=Y;
      CoOrdinates[3,'X']:=X+1;
      CoOrdinates[3,'Y']:=Y+1;
      CoOrdinates[4,'X']:=X;
      CoOrdinates[4,'Y']:=Y+1;

      GETMEM(OriginX,SIZEOF(INTEGER));
      GETMEM(OriginY,SIZEOF(INTEGER));
      OriginX:=@CoOrdinates[2,'X'];
      OriginY:=@CoOrdinates[2,'Y'];
      INHERITED Create('J');

   END;


CONSTRUCTOR TLPiece.Create;
VAR X,Y:INTEGER;
   BEGIN
      X:=BoardMaxX DIV 2;
      Y:=2;

      CoOrdinates[1,'X']:=X-1;
      CoOrdinates[1,'Y']:=Y-1;
      CoOrdinates[2,'X']:=X-1;
      CoOrdinates[2,'Y']:=Y;
      CoOrdinates[3,'X']:=X-1;
      CoOrdinates[3,'Y']:=Y+1;
      CoOrdinates[4,'X']:=X;
      CoOrdinates[4,'Y']:=Y+1;

       GETMEM(OriginX,SIZEOF(INTEGER));
      GETMEM(OriginY,SIZEOF(INTEGER));
      OriginX:=@CoOrdinates[2,'X'];
      OriginY:=@CoOrdinates[2,'Y'];
      INHERITED Create('L');
   END;

CONSTRUCTOR TOPiece.Create;
VAR X,Y:INTEGER;
   BEGIN
      X:=BoardMaxX DIV 2;
      Y:=2;

      CoOrdinates[1,'X']:=X-1;
      CoOrdinates[1,'Y']:=Y;
      CoOrdinates[2,'X']:=X;
      CoOrdinates[2,'Y']:=Y;
      CoOrdinates[3,'X']:=X-1;
      CoOrdinates[3,'Y']:=Y+1;
      CoOrdinates[4,'X']:=X;
      CoOrdinates[4,'Y']:=Y+1;

       GETMEM(OriginX,SIZEOF(INTEGER));
      GETMEM(OriginY,SIZEOF(INTEGER));
      OriginX:=@CoOrdinates[2,'X'];
      OriginY:=@CoOrdinates[2,'Y'];
      INHERITED Create('O');

   END;

//O Piece rotation leaves in exact same location
//Place dummy routines to override parent routine
PROCEDURE TOPiece.RotateLeft;
   BEGIN
   END;

PROCEDURE TOPiece.RotateRight;
   BEGIN
   END;


CONSTRUCTOR TSPiece.Create;
VAR X,Y:INTEGER;
   BEGIN

      X:=BoardMaxX DIV 2;
      Y:=2;

      CoOrdinates[1,'X']:=X-1;
      CoOrdinates[1,'Y']:=Y+1;
      CoOrdinates[2,'X']:=X;
      CoOrdinates[2,'Y']:=Y+1;
      CoOrdinates[3,'X']:=X;
      CoOrdinates[3,'Y']:=Y;
      CoOrdinates[4,'X']:=X+1;
      CoOrdinates[4,'Y']:=Y;

       GETMEM(OriginX,SIZEOF(INTEGER));
      GETMEM(OriginY,SIZEOF(INTEGER));
      OriginX:=@CoOrdinates[2,'X'];
      OriginY:=@CoOrdinates[2,'Y'];
      INHERITED Create('S');


   END;

CONSTRUCTOR TTPiece.Create;
VAR X,Y:INTEGER;
   BEGIN
      X:=BoardMaxX DIV 2;
      Y:=2;

      CoOrdinates[1,'X']:=X-1;
      CoOrdinates[1,'Y']:=Y+1;
      CoOrdinates[2,'X']:=X;
      CoOrdinates[2,'Y']:=Y;
      CoOrdinates[3,'X']:=X;
      CoOrdinates[3,'Y']:=Y+1;
      CoOrdinates[4,'X']:=X+1;
      CoOrdinates[4,'Y']:=Y+1;

       GETMEM(OriginX,SIZEOF(INTEGER));
      GETMEM(OriginY,SIZEOF(INTEGER));
      OriginX:=@CoOrdinates[3,'X'];
      OriginY:=@CoOrdinates[3,'Y'];
      INHERITED Create('T');

   END;

CONSTRUCTOR TZPiece.Create;
VAR X,Y:INTEGER;
   BEGIN
      X:=BoardMaxX DIV 2; //Get 'Centre' X of Piece
      Y:=2; //Get Centre Y Of Piece

      CoOrdinates[1,'X']:=X-1;
      CoOrdinates[1,'Y']:=Y;
      CoOrdinates[2,'X']:=X;
      CoOrdinates[2,'Y']:=Y;
      CoOrdinates[3,'X']:=X;
      CoOrdinates[3,'Y']:=Y+1;
      CoOrdinates[4,'X']:=X+1;
      CoOrdinates[4,'Y']:=Y+1;

       GETMEM(OriginX,SIZEOF(INTEGER));
      GETMEM(OriginY,SIZEOF(INTEGER));
      OriginX:=@CoOrdinates[3,'X'];
      OriginY:=@CoOrdinates[3,'Y'];
      INHERITED Create('Z');

   END;

//Places a piece on the board
PROCEDURE Tboard.PlacePiece(Piece:TPiece);
VAR X,Y,Pos:INTEGER;
    CoOrdinates:TCoOrds;

      BEGIN

         CoOrdinates:=Piece.GetCoOrdinates; //Obtain Co-ordinates of Piece

         FOR Pos:=1 TO 4 DO //For each block in the piece

            BEGIN
               X:=CoOrdinates[Pos,'X']; //Obtain X Co-Ordinate
               Y:=CoOrdinates[Pos,'Y']; //Obtain Y Co-Ordinate
               BoardState[X,Y].Occupied:=TRUE;  //Add it to the board
               BoardState[X,Y].BlockName:=Piece.GetPieceName;
            END;

      END;


PROCEDURE Tboard.ClearRow(RowNo:INTEGER);
VAR X,Y:INTEGER;
   BEGIN
      FOR X:=1 TO BoardMaxX DO
         BEGIN
            BoardState[X,RowNo].Occupied:=FALSE; //Set all points on line to unoccupied
            BoardState[X,RowNo].BlockName:='R';
         END;
      //Move all blocks above the line 1 space down

      IF (RowNo > 1) THEN //If the row is not the top row
      FOR Y:=(RowNo-1) DOWNTO 1 DO //For every row above the row cleared
         FOR X:= 1 TO BoardMaxX DO //For every space on the row
         IF BoardState[X,Y].Occupied = TRUE THEN //If a block occupies it
            BEGIN
               BoardState[X,Y+1].Occupied:=TRUE; //Assign the space below to a block
               BoardState[X,Y+1].BlockName:=BoardState[X,Y].BlockName;
               BoardState[X,Y].Occupied:=FALSE;    //Remove the initial block
               BoardState[X,Y].BlockName:='R';
            END;
   END;

//Check every row to see if there are any complete rows
//Clear all complete rows

PROCEDURE Tboard.CheckComplete;
VAR X,Y,Count,Points:INTEGER;
    Gap:BOOLEAN;

   BEGIN
      Count:=0; //No Of Rows complete per check
      Y:=BoardMaxY; //Initial Y set at bottom row

      WHILE ( Y>0 ) AND ( Count<4 ) DO //For every row, and while 4 lines haven't been cleared

         BEGIN
            Gap:=FALSE;
            X:=1;
            WHILE (Gap=FALSE) AND (X <= BoardMaxX) DO   //While not gap, and not end of row
               IF BoardState[X,Y].Occupied=FALSE THEN
                  Gap:=TRUE
               ELSE X:=X+1;

            IF Gap = FALSE THEN //If there isn't a gap in the row, clear it
               BEGIN

                  Count:=Count+1;
                  ClearRow(Y);
                  Y:=Y+1; //Increment Y as row above falls down
               END;

            Y:=Y-1; //Go to next row

         END;
   //Obtain amount of points scored
   CASE Count OF
    0:Points:=0;
    1:Points:=40*(Level+1);
    2:Points:=100*(Level+1);
    3:Points:=300*(level+1);
    4:Points:=1200*(level+1);
   END;

   Score:=Score+Points;
   Lines:=Lines+Count;
   NextLevel:=NextLevel-Count;

   IF NextLevel<=0 THEN //If lines to next level reached
      BEGIN
         NextLevel:=10; //Reset no of lines to get to next level
         INC(Level); //Increment to the next level
      END;
   END;

//TBoard Put Methods
PROCEDURE TBoard.PutBoardState(NewBoardState:TBoardState);
   BEGIN
      BoardState:=NewBoardState;
   END;

//TBoard Get Methods
FUNCTION TBoard.GetBoardState:TBoardState;
   BEGIN
      RESULT:=BoardState;
   END;



//Initialise all places in board as unoccupied
CONSTRUCTOR TBoard.Create;
VAR X,Y:INTEGER;
   BEGIN
      Score:=0;
      Lines:=0;
      Level:=0;
      Lose:=FALSE;
      FOR X:=1 TO BoardMaxX DO
         FOR Y:=1 TO BoardMaxY DO
            BEGIN
               BoardState[X,Y].Occupied:=FALSE;
               BoardState[X,Y].BlockName:='R'; //Set block to the removed piece
            END;
     FOR X:=1 TO 7 DO
        PieceCount[X]:=0;
   END;

//Returns Number of piece from it's name
FUNCTION PieceNum(PieceName:CHAR):INTEGER;
   BEGIN
     CASE PieceName OF
      'I':RESULT:=1;
      'J':RESULT:=2;
      'L':RESULT:=3;
      'O':RESULT:=4;
      'S':RESULT:=5;
      'T':RESULT:=6;
      'Z':RESULT:=7;
     END;
   END;

//Increment the piece downward
PROCEDURE IncPiece(VAR Piece:TPiece);
VAR CoOrdinates:TCoOrds;
    X,Y,Pos:INTEGER;

   BEGIN
      CoOrdinates:=Piece.GetCoOrdinates; //Obtain Co-Ordinates of Piece
      FOR Pos:=1 TO 4 DO
         BEGIN            //Set Y Pos of every block in Piece to the row below
            Y:=CoOrdinates[Pos,'Y'];
            CoOrdinates[Pos,'Y']:=Y+1;
         END;
      Piece.PutCoOrdinates(CoOrdinates); //Change Co-ordinates of the piece object

   END;

BEGIN
END.
