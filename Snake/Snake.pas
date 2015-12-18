PROGRAM SnakeGame;

USES SNAKEFUNC,SNAKEGRAPH,CRT,VPUTILS,WINDOWS;

CONST SNAKECOLOUR=GREEN;
      BORDERCOLOUR=RED;
      UP=#72; DOWN=#80; LEFT=#75; RIGHT=#77;


VAR Snake:SnakeT;
    Food:FoodT;
    I,Score:INTEGER;
    Lose,Quit:BOOLEAN;
    Keys:ARRAY[0..3] OF CHAR =(UP,DOWN,LEFT,RIGHT);
    CurrentDir:CHAR; //Current Direction Of Snake


FUNCTION FoodCollision(VAR Snake:SnakeT;Food:FoodT):BOOLEAN; //Check if placement of food
   VAR Collision:BOOLEAN;                                    //is same place as a piece
       Piece:SnakePtr;                                       //of the snake

      BEGIN
         Piece:=Snake.First;
         Collision:=FALSE;

         WHILE (Piece<>NIL) AND (NOT Collision) DO
            BEGIN
              IF (Food.X=Piece.X) AND (Food.Y=Piece.Y) THEN
                 Collision:=TRUE
              ELSE
                 Piece:=Piece.Next;
            END;
         RESULT:=Collision;
      END;


PROCEDURE CreateFood(VAR Snake:SnakeT;VAR Food:FoodT); //Creates food for snake
VAR Collision:BOOLEAN;

   BEGIN
      Collision:=TRUE;
      WHILE Collision DO
         BEGIN
            // repeat Until random place found which doesn't spawn food ontop of snake
            Food:=PlaceFood(LowerBound['X'],LowerBound['Y'],UpperBound['X'],Upperbound['Y']);
            IF NOT FoodCollision(Snake,Food) THEN
               Collision:=FALSE;
         END;

      DrawFood(Food.X,Food.Y);
   END;


PROCEDURE UpdateSnake(VAR Snake:SnakeT;Dir:CHAR;VAR Food:FoodT);
VAR LastPiece:SnakePtr;
    I:INTEGER;
   BEGIN
   NEW(LastPiece);
   LastPiece.X:=Snake.Last.X;
   LastPiece.Y:=Snake.Last.Y;
   LastPiece.Dir:=Snake.Last.Dir;

   MoveSnake(Snake,Dir);
   IF Collision(Snake) THEN
   BEGIN
      Lose:=TRUE;
      END
   ELSE IF
      FoodCollected(Snake,Food) THEN
         BEGIN
            INC(Score); //Increment the score count
            DrawRemove(Food.X,Food.Y); //Remove Food
            CreateFood(Snake,Food); //Place New Food
            GOTOXY(1,1);
            WRITE('Food Location X:',Food.X,' Y:',Food.Y);
            GOTOXY(1,25);
            WRITE('Score:',Score);
            AddPiece(Snake,LastPiece.X,LastPiece.Y,LastPiece.Dir);//Add the last piece back on
         END

   ELSE
      DrawRemove(LastPiece.X,LastPiece.Y);

   TEXTCOLOR(GREEN);
   TEXTBACKGROUND(SNAKECOLOUR);
   DrawPiece(Snake.First.X,Snake.First.Y);
   GOTOXY(40,1);
   TEXTCOLOR(WHITE);
   TEXTBACKGROUND(BLACK);
   WRITE('Snake Head Location X:',Snake.First.X,' Y:',Snake.First.Y);
   DISPOSE(LastPiece);

   {WINDOW(5,2,70,3);
   FOR I:=0 TO 2 DO
   BEGIN
      IF GetPiece(Snake,I)=NIL THEN
      WRITELN('NULL')
      ELSE
      WRITELN('X:',GetPiece(Snake,I).X,' Y:',GetPiece(Snake,I).Y,' D:',GetPiece(Snake,I).Dir);
      READLN;
      CLRSCR;
   END;
   WINDOW(1,1,80,25);}
   END;

PROCEDURE Initialise(VAR Snake:SnakeT;VAR Food:FoodT);
VAR X,Y:INTEGER;
   BEGIN
      X:=ROUND((LowerBound['X']+UpperBound['X'])/2);
      Y:=ROUND((LowerBound['Y']+UpperBound['Y'])/2);
      Quit:=FALSE;
      CurrentDir:=RIGHT;
      Lose:=FALSE;
      CreateSnake(Snake);
      Snake.First:=NIL;
      Snake.Last:=NIL;
      TEXTCOLOR(BORDERCOLOUR);
      TEXTBACKGROUND(BORDERCOLOUR);
      CreateBorder(LowerBound['X'],LowerBound['Y'],UpperBound['X'],UpperBound['Y']);
      TEXTCOLOR(SNAKECOLOUR);
      AddPiece(Snake,X,Y,RIGHT);
      Snake.Last:=Snake.First;
      DrawPiece(X,Y);
      TEXTCOLOR(WHITE);
      TEXTBACKGROUND(BLACK);
      CreateFood(Snake,Food);
      GOTOXY(1,1);
      WRITE('Food Location X:',Food.X,' Y:',Food.Y);
      GOTOXY(1,25);
      WRITE('Score:0');

   END;


PROCEDURE ProcessKey(VAR Snake:SnakeT;VAR Food:FoodT);
VAR Key:CHAR;
    KeyNo:INTEGER;
    ValidKey:BOOLEAN;

   BEGIN
      Key:=UPCASE(READKEY);
      KeyNo:=0;

      WHILE (KeyNo<4) AND (NOT ValidKey) DO
         BEGIN
            IF Key=Keys[KeyNo] THEN
               ValidKey:=TRUE
            ELSE
               INC(KeyNo);
         END;

      IF ValidKey THEN
         IF ValidDirection(Keys[KeyNo],Snake.First.Dir) THEN
            CurrentDir:=Keys[KeyNo];

   END;



PROCEDURE EndGame;
VAR KEY:CHAR;
    Valid:BOOLEAN;
BEGIN
CLRSCR;
Valid:=FALSE;
WRITELN('YOU LOSE');
WRITELN('SCORE: ',Score);
WRITELN;
WRITELN('Press `R` to replay, `X` to exit to windows..`');
REPEAT
KEY:=READKEY;
IF (UPCASE(KEY)='R') OR (UPCASE(KEY)='X') THEN
   BEGIN
   Valid:=TRUE;
   Lose:=FALSE;
   IF UPCASE(KEY)='R' THEN
      BEGIN
      CLRSCR;
      Initialise(Snake,Food);
      Score:=0;
      END ELSE
      QUIT:=TRUE;
      END;
UNTIL Valid=TRUE;
END;



PROCEDURE Run(VAR Snake:SnakeT;VAR Food:FoodT);
VAR KeyLoops:INTEGER;

   BEGIN
   KeyLoops:=0;
   Quit:=FALSE;
      WHILE NOT QUIT DO

         BEGIN
            IF (KeyPressed) AND (NOT LOSE) THEN
               ProcessKey(Snake,Food);

            INC(KeyLoops);
            IF (KeyLoops=5000) AND (NOT LOSE) THEN
               BEGIN
               KeyLoops:=0; //Reset Loop
               UpdateSnake(Snake,CurrentDir,Food);
               END;
            IF LOSE THEN
               EndGame;
               Lose:=FALSE;
         END;
   END;




BEGIN
HIDECURSOR;
Initialise(Snake,Food);
RUN(Snake,Food);
END.

