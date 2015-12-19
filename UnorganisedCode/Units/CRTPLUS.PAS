UNIT CRTPLUS;

//ττττττττττττττττττττττττττττττττττττττττττ
//τ     Extra Screen Display Functions     τ
//τ     For Use With Virtual Pascal        τ
//τ        Copyright Ross Meikleham        τ
//τ                2011                    τ
//ττττττττττττττττττττττττττττττττττττττττττ

INTERFACE

USES CRT;

PROCEDURE DrawBox(x1,y1,x2,y2:INTEGER; No:BOOLEAN);
{Draws box between points on screen x1,y1 and x2,y2}
{'No' is either 'TRUE' for single lined box or 'FALSE' for Double Lined}


PROCEDURE FillBox(x1,y1,x2,y2:INTEGER); {Fills an area x1,y1,x2,y2}

PROCEDURE PutStr(Text:STRING; X,Y:LONGINT); //Places text on screen
                                            //and moves cursor back
                                            //to original position



PROCEDURE StoreScr;

PROCEDURE ReturnScr;

IMPLEMENTATION


 TYPE

    Chtype = RECORD
      Value:CHAR;     //record stores the actual character
      Attribute:BYTE; //and it's attirbute i.e. bckground colour/font colour
 END;

    ChrNo=ARRAY[1..80,1..25] OF Chtype;  //80*25 locations on screen
    CurrentChr=^ChrNo;  //Pointer to address location of current screen


 VAR ChTest:CurrentChr;


   PROCEDURE StoreScr;
   {Temporarily Stores all characters on screen as well as txtcolor and
   txtbackground attributes}

      BEGIN
           Chtest:=PTR($B800);  // Sets the address location of the screen to
                                //the actual memory location of the screen $B800
      END;                      //So all characters with attributes are stored within
                                //each of the array positions defined in 'ChrNo'





   PROCEDURE ReturnScr;  //Displays the 'saved screen'
                         // Stored in 'StoreScr' Scren
   VAR X,Y:BYTE;
       CurrentScr:CurrentChr;

      BEGIN
         CurrentScr:=PTR($B800);  //Read in current screen
         FOR Y:= 1 TO 25 DO
            FOR X:=1 TO 80 DO
            BEGIN
            CurrentScr^[X,Y].Value:=Chtest^[X,Y].Value;    //Overwrite current screen
            CurrentScr^[X,Y].Attribute:=ChTest^[X,Y].Attribute                                   //with screen stored in ChTest^
      END;  END;


   PROCEDURE PutStr(Text:STRING;X,Y:LONGINT);
    VAR CurrentX,CurrentY:LONGINT;
      BEGIN
         CurrentX:=WHEREX;
         CurrentY:=WHEREY;
         GOTOXY(X,Y);
         WRITE(Text);
         GOTOXY(CurrentX,CurrentY);

      END;

   PROCEDURE DrawVLine(x1,y1,y2:INTEGER); {Writes the vertical lines}

      BEGIN


         WHILE y1 <= y2 DO

         BEGIN
            GOTOXY(x1,y1);       {goes to same x location}
             WRITE(#186);

            y1:=y1+1;            {goes down a line}

         END;

     END;

     PROCEDURE DrawHLine(x1,y1,x2:INTEGER;HChar:CHAR); {Writes the horizontal lines}

      BEGIN

         GOTOXY(X1,Y1);

         X1:=X1+1;

         WHILE x1 <= x2 DO

         BEGIN
            GOTOXY(x1,y1);

          //  IF AlternateBox= TRUE THEN
            WRITE(#205)
          //  ELSE WRITE(#196);

            ;x1:=x1+1;

         END;
       END;





   PROCEDURE DrawBox(x1,y1,x2,y2:INTEGER; No:BOOLEAN);

   VAR Vchar,HChar:CHAR;

      BEGIN

         IF No=TRUE THEN

            BEGIN

               VChar:='Δ';
               HChar:='³';

            END ELSE

            BEGIN

               VChar:='Ί';
               HChar:='Ν';

            END;
         DrawHLine(x1,y1,x2,HChar);  {obtain top horizontal line}

         DrawHLine(x1,y2,x2,HChar);  {obtain bottom horizontal line}

       //  DrawVLine(x1,y1+1,y2-1,VChar);  {obtain left vertical line}

       //  DrawVLine(x2,y1+1,y2-1,VChar);  {obtain right vertical line}

      END;








     PROCEDURE FillBox(x1,y1,x2,y2:INTEGER);
     VAR I:LONGINT;

        BEGIN
         REPEAT

          GOTOXY(x1,y1+1);
          I:=X1;
          WHILE X1<X2+1 DO

           BEGIN
            WRITE(' ');
            X1:=x1+1;

           END;
          X1:=I; {goes back to start "x" location of the next line}
          y1:=y1+1 {goes down a line}
         UNTIL y1=y2;

        END;




      PROCEDURE ChoiceSelected(Choice:BOOLEAN);
                                                 {Highlights the currently}
                                                  {Selected option with a background}
      BEGIN                                       {colour and text colour}

         IF Choice=TRUE THEN

         BEGIN

            TEXTBACKGROUND(RED);   {If option selected give}
            TEXTCOLOR(YELLOW);     {yellow text and red background}

         END ELSE

         BEGIN

            TEXTBACKGROUND(BLUE);  {If option not selected give}
            TEXTCOLOR(LIGHTCYAN);  {Lightcyan text and Blue background}

         END;

      END;

END.
