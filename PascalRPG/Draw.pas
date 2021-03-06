UNIT Draw;

INTERFACE

USES CRT;

PROCEDURE DrawBox(x1,y1,x2,y2:INTEGER); {Draws a Box x1,y1,x2,y2}

PROCEDURE FillBox(x1,y1,x2,y2:INTEGER); {Fills an area x1,y1,x2,y2}

PROCEDURE DrawDoubleBox(x1,y1,x2,y2:INTEGER); {same as drawbox but draws a different ascii code}

PROCEDURE ErrorMessage(Mes:STRING);

PROCEDURE ChoiceSelected(Choice:BOOLEAN);

IMPLEMENTATION

VAR AlternateBox:BOOLEAN;






   PROCEDURE DrawVLine(x1,y1,y2:INTEGER); {Writes the vertical lines}

      BEGIN


         WHILE y1 <= y2 DO

         BEGIN
            GOTOXY(x1,y1);       {goes to same x location}
            IF AlternateBox= TRUE THEN
            WRITE(#186)
            ELSE WRITE(#179);
            y1:=y1+1;            {goes down a line}

         END;

     END;

     PROCEDURE DrawHLine(x1,y1,x2:INTEGER); {Writes the horizontal lines}

      BEGIN


         WHILE x1 <= x2 DO

         BEGIN
            GOTOXY(x1,y1);

            IF AlternateBox= TRUE THEN
            WRITE(#205)
            ELSE WRITE(#196);

            x1:=x1+1;

         END;
       END;


   PROCEDURE DrawAllLines(X1,Y1,X2,Y2:INTEGER);

      BEGIN

         DrawHLine(x1,y1,x2);  {obtain top horizontal line}

         DrawHLine(x1,y2,x2);  {obtain bottom horizontal line}

         DrawVLine(x1,y1+1,y2-1);  {obtain left vertical line}

         DrawVLine(x2,y1+1,y2-1);  {obtain right vertical line}

            GOTOXY(x1,y1);
           IF AlternateBox= TRUE THEN
            WRITE(#201)
            ELSE WRITE(#218);  {obtains top left corner }

         GOTOXY(x2,y1);
           IF AlternateBox= TRUE THEN
            WRITE(#187)
            ELSE WRITE(#191);  {obtains top right corner}

         GOTOXY(x2,y2);
           IF AlternateBox= TRUE THEN
            WRITE(#188)
            ELSE WRITE(#217);  {obtains bottom right corner}

         GOTOXY(x1,y2);
           IF AlternateBox= TRUE THEN
            WRITE(#200)
            ELSE WRITE(#192);  {obtains bottom left corner}

      END;


   PROCEDURE DrawBox(x1,y1,x2,y2:INTEGER);

      BEGIN
        AlternateBox:=FALSE;
        DrawAllLines(x1,y1,x2,y2);
      END;




     PROCEDURE DrawDoubleBox(x1,y1,x2,y2:INTEGER);

        BEGIN
        AlternateBox:=TRUE;
        DrawAllLines(x1,y1,x2,y2);
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



    PROCEDURE ErrorMessage(Mes:STRING);
    VAR Y,I:INTEGER;

       BEGIN

       Y:=WHEREY;
       TEXTBACKGROUND(RED);
       TEXTCOLOR(YELLOW);
       WINDOW(1,25,80,25);
       GOTOXY(1,1);
       FOR I:=1 TO 80 DO
       WRITE(' ');
       GOTOXY(1,1);
       WRITE(Mes);

       REPEAT
       UNTIL KEYPRESSED;

       TEXTBACKGROUND(BLACK);
       TEXTCOLOR(WHITE);
       CLRSCR;
       WINDOW(1,Y-1,80,Y-1);
       CLRSCR;
       WINDOW(1,1,80,25);   {Return window to original size};
       GOTOXY(1,Y-1);


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
