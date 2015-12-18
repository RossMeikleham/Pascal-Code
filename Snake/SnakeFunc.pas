UNIT SNAKEFUNC;

INTERFACE
USES CRT;
CONST LowerBound:ARRAY['X'..'Y'] OF INTEGER=(10,5); //Bounds of the snake board
      UpperBound:ARRAY['X'..'Y'] OF INTEGER=(70,24);

TYPE
   SnakePtr=^TSnakePiece;
   TSnakePiece=RECORD
      Prev:SnakePtr;
      X:INTEGER;
      Y:INTEGER;
      Dir:CHAR;
      Next:SnakePtr;

   END;

   SnakeT=RECORD //Stores First and Last Record pointers
      First:SnakePtr;
      Last:SnakePtr;
   END;

   FoodT=RECORD //Stores Location of Food
      X:INTEGER;
      Y:INTEGER;
   END;

PROCEDURE AddPiece(VAR Snake:SnakeT;X,Y:INTEGER;Dir:CHAR); //Add a piece onto the snake
FUNCTION GetPiece(Snake:SnakeT;N:INTEGER):SnakePtr; //Gets piece at position N
PROCEDURE MoveSnake(VAR Snake:SnakeT;Dir:CHAR);//Moves snake 1 unit in a specified direction
FUNCTION Collision(Snake:SnakeT):BOOLEAN; //Checks if a collision has occured
PROCEDURE CreateSnake(VAR Snake:SnakeT); //Initialised a 'blank' snake
FUNCTION ValidDirection(CurDir,NewDir:CHAR):BOOLEAN; //Checks if new Direction is Valid
FUNCTION FoodCollected(Snake:SnakeT;Food:FoodT):BOOLEAN;
FUNCTION PlaceFood(X1,Y1,X2,Y2:INTEGER):FoodT;

IMPLEMENTATION


PROCEDURE CreateSnake(VAR Snake:SnakeT);

   BEGIN
      Snake.First:=NIL;
      Snake.Last:=NIL;
   END;


PROCEDURE AddPiece(VAR Snake:SnakeT;X,Y:INTEGER;Dir:CHAR); //Add a piece onto the snake
VAR  Piece:SnakePtr;

   BEGIN

         NEW(Piece);
         Piece.X:=X;
         Piece.Y:=Y;
         Piece.Dir:=Dir;

      IF Snake.First=NIL THEN //If no Pieces
         BEGIN
            Snake.First:=Piece; //Piece is the first Piece
            Snake.First.Prev:=NIL; //No pieces before it
            Snake.First.Next:=NIL; //No pieces after
            Snake.Last:=Snake.First;
         END
      ELSE

         Snake.Last.Next:=Piece; //Previous Last piece now points to new piece


      Snake.Last.Next:=Piece;
      Piece.Prev:=Snake.Last;
      Snake.Last:=Piece; //Last Piece becomes Piece Added
      Snake.Last.Next:=NIL; //New last piece doesn't have a next piece


   END;

FUNCTION GetPiece(Snake:SnakeT;N:INTEGER):SnakePtr; //Gets piece at position N
VAR PieceNo:INTEGER;                   //Returns Null pointer if doesn't exist
    Finish:BOOLEAN;
    CurrentPiece:SnakePtr;

   BEGIN
      Finish:=False;
      PieceNo:=0; //Position Starts at 0
      CurrentPiece:=Snake.First;

      WHILE (PieceNo<N) AND (NOT Finish) DO
         BEGIN

            IF CurrentPiece.Next <> NIL THEN  //If next piece exists
               BEGIN

                  CurrentPiece:=CurrentPiece.Next; //Set current to next piece
                  PieceNo:=PieceNo+1           //Increment piece location

               END
             ELSE
               Finish:=TRUE; //If next piece doesn't exist, end has been reached

         END;

      IF Finish THEN //If end was reached without Piece being found
         RESULT:=NIL       //It doesn't exist
      ELSE
         RESULT:=CurrentPiece;
   END;


PROCEDURE MoveSnake(VAR Snake:SnakeT;Dir:CHAR);//Moves snake 1 unit in a specified direction

CONST UP=#72; DOWN=#80; LEFT=#75; RIGHT=#77;

VAR X,Y:INTEGER;
    Piece:SnakePtr;

   BEGIN

      NEW(Piece);
      Piece.X:=Snake.First.X;
      Piece.Y:=Snake.First.Y;
      Piece.Dir:=Dir;
      Piece.Prev:=NIL;

      CASE Dir OF
        UP:Piece.Y:=Piece.Y-1;
        DOWN:Piece.Y:=Piece.Y+1;
        LEFT:Piece.X:=Piece.X-1;
        RIGHT:Piece.X:=Piece.X+1;
      END;

      Snake.First.Prev:=Piece;
      Piece.Next:=Snake.First; //Piece points to the 'first'
      Snake.First:=Piece;   //Piece becomes the new first

      IF GetPiece(Snake,2)<>NIL THEN
      BEGIN
      Snake.Last:=Snake.Last.Prev; //Last becomes the one before the Last
      Snake.Last.Next:=NIL;     //New Last points to nothing as it is last
      END ELSE
      BEGIN
       Snake.Last:=Snake.First;
       Snake.First.Next:=NIL;
      END;
   END;


FUNCTION Collision(Snake:SnakeT):BOOLEAN;
VAR Piece,First:SnakePtr;
    Col:BOOLEAN;

   BEGIN
   Col:=FALSE;
   First:=Snake.First;
   Piece:=First;

   IF (First.X>=UpperBound['X']) OR (First.X<=LowerBound['X'])
      OR (First.Y>=UpperBound['Y']) OR (First.Y<=LowerBound['Y']) THEN BEGIN
         Col:=TRUE;
         END
   ELSE IF Piece.Next<> NIL THEN //Check if more than 1 piece
      BEGIN
         Piece:=Piece.Next;
         WHILE (Col=False) AND (Piece<>NIL) DO
            BEGIN

               IF (First.X = Piece.X) AND (First.Y=Piece.Y) THEN  //If position of 1st piece is equal
                  Col:=True                     //to the position of any other piece, then collision must have happened
               ELSE
                  Piece:=Piece.Next;
            END;
      END;
      RESULT:=Col;
   END;

FUNCTION ValidDirection(CurDir,NewDir:CHAR):BOOLEAN; //Checks whether new direction is valid

   FUNCTION Opposite(CurDir,NewDir:CHAR):BOOLEAN; //Checks whether new direction
   CONST UP=#72; DOWN=#80; LEFT=#75; RIGHT=#77;
      BEGIN                                       //is the opposite of old direction
        NewDir:=UPCASE(NewDir);
        CurDir:=UPCASE(CurDir);
        CASE NewDir OF
           UP:RESULT:=(CurDir=DOWN);
           DOWN:RESULT:=(CurDir=UP);
           LEFT:RESULT:=(CurDir=RIGHT);
           RIGHT:RESULT:=(CurDir=LEFT);
        END;
      END;

      BEGIN
      IF (Opposite(CurDir,NewDir)) OR (CurDir=NewDir) THEN
         RESULT:=FALSE
      ELSE
         RESULT:=TRUE;
      END;


FUNCTION PlaceFood(X1,Y1,X2,Y2:INTEGER):FoodT;  //Returns random
VAR X,Y:INTEGER;                                //Spot to place food on screen
    Food:FoodT;
   BEGIN
      RANDOMIZE;
      X:=RANDOM(X2-X1)+X1;
      IF X=X1 THEN
      INC(X);

      Y:=RANDOM(Y2-Y1)+Y1;
      IF Y=Y1 THEN
      INC(Y);

      Food.X:=X;
      Food.Y:=Y;
      RESULT:=Food;
   END;


FUNCTION FoodCollected(Snake:SnakeT;Food:FoodT):BOOLEAN; //Checks if the food has been collected
VAR Finish:BOOLEAN;

   BEGIN
      //Only need to check the head of the snake, as it would be the
      //only piece to ever touch food
      IF (Snake.First.X=Food.X) AND (Snake.First.Y=Food.Y) THEN
         RESULT:=TRUE
      ELSE
         RESULT:=FALSE;

   END;
END.
