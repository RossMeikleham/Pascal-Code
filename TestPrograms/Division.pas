PROGRAM DIVISION;

USES CRT,DRAW, VPUTILS;


   {PROCEDURE Obtain;}


   PROCEDURE FlashColour(Text:STRING);

   VAR Count,I:INTEGER;

      BEGIN

         HIDECURSOR;
         Count:=1;
         REPEAT


            FOR I:= 1 TO LENGTH(Text) DO {overwrites with blank text}
            WRITE(' ');


            CASE Count OF
            1:TEXTCOLOR(RED);
            2:TEXTCOLOR(CYAN);
            3:TEXTCOLOR(GREEN);
            4:TEXTCOLOR(YELLOW);

            END;

                  GOTOXY(WHEREX-LENGTH(Text),WHEREY);    {sets cursor back to before the text}
                  IF Count <4 THEN Count:=Count+1
                  ELSE Count:=1;

                  WRITE(Text);

                  IF KEYPRESSED=FALSE THEN
                  DELAY(300);
                  GOTOXY(WHEREX-LENGTH(Text),WHEREY);


         UNTIL KEYPRESSED=TRUE;  {Repeats until a key is pressed}
        SHOWCURSOR;
      END;


   PROCEDURE something;
   VAR ColourNo:INTEGER;
       SoundNo:INTEGER;

      BEGIN

         HIDECURSOR;
         ColourNo:=1;
         SoundNo:=300;
         REPEAT

            CLRSCR;
            TEXTBACKGROUND(ColourNo);
            PLAYSOUND(SoundNo,500);
            Delay(200);
            ColourNo:=ColourNo+1;
            SoundNo:=SoundNo+5;

         UNTIL ColourNo=300;
         SHOWCURSOR;
      END;

   PROCEDURE DRAWCALC;

      BEGIN

       //  DrawBox(

      END;

BEGIN
something;
READLN;
END.



