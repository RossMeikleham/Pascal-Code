PROGRAM Racer;

USES CRT,VPUTILS;

   VAR Go:Array[1..7] OF INTEGER=(5,5,5,5,5,5,5);
       ColourArray:Array[1..7] OF INTEGER=(4,14,10,3,1,13,15);
       YArray:Array[1..7] OF INTEGER=(7,9,11,13,15,17,19);
       WinArray:ARRAY[1..7] OF STRING=('1st','2nd','3rd','4th','5th','6th',
                                       '7th');

       FinishArray:ARRAY[1..7] OF BOOLEAN=(FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE);
       NameArray:ARRAY[1..7] OF STRING[10]=('Bob','Bob2','Bob3','Bob4','Bob5','Bob6','Phillip');
       FinishCount:LONGINT;
       P:LONGINT=5;

   PROCEDURE draw;
   VAR Y:INTEGER;
   BEGIN
   Y:=5;
   TEXTCOLOR(WHITE);
   TEXTBACKGROUND(RED);
   REPEAT
   GOTOXY(60,Y);
   WRITE(#186);
   Y:=Y+1;
   UNTIL Y=21;
   TEXTBACKGROUND(BLACK);
   END;



   PROCEDURE Move;
   VAR x,Length:INTEGER;


   BEGIN
   FOR X:=1 TO 7 DO

   IF FinishArray[X]= FALSE THEN
   BEGIN

      Length:=5;
      TEXTCOLOR(ColourArray[x]);

      Go[X]:=Go[X]+RANDOM(3);

      IF GO[X] <57 THEN

      BEGIN

      WHILE Length<Go[x] DO

         BEGIN

         GOTOXY(Length,YArray[x]);
         WRITE(#219);
         Length:=Length+1;

         END;

      GOTOXY(Go[x],Yarray[x]);
      WRITE('/--\');
      DELAY(60);

      END ELSE BEGIN

      FinishArray[X]:=TRUE;
      FinishCount:=FinishCount+1;
      TEXTCOLOR(ColourArray[X]);
      GOTOXY(65,P);
      WRITE(WinArray[FinishCount]);
      P:=P+2;
   END;

   END;
   END;


   //PROCEDURE StartScreen;



BEGIN
RANDOMIZE;
HIDECURSOR;
draw;
FinishCount:=0;
READLN;
REPEAT
move;
UNTIL FinishCount=8;
READLN;
END.
