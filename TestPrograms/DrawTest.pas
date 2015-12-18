UNIT DrawTest;

INTERFACE

USES CRT;

PROCEDURE Draw(x1,y1,x2,y2:INTEGER);

PROCEDURE Fill(x1,y1,x2,y2:INTEGER);

PROCEDURE DrawVLine(x1,y1,x2,y2:INTEGER);

PROCEDURE DrawHLine(x1,y1,x2,y2:INTEGER);


IMPLEMENTATION

     PROCEDURE DrawVLine(x1,y1,x2,y2:INTEGER); {Writes the horizontal lines}

      BEGIN


         WHILE y1 <= y2 DO

         BEGIN
            GOTOXY(x1,y1);
            WRITE(#179);
            y1:=y1+1;

         END;

     END;

     PROCEDURE DrawHLine(x1,y1,x2,y2:INTEGER); {Writes the horizontal lines}

      BEGIN


         WHILE x1 <= x2 DO

         BEGIN
            GOTOXY(x1,y1);
            WRITE(#196);
            x1:=x1+1;

         END;

     END;


   PROCEDURE Draw(x1,y1,x2,y2:INTEGER);


   BEGIN

      DrawHLine(x1,y1,x2,x2);  {obtain top horizontal line}

      DrawHLine(x1,y2,x2,x2);  {obtain bottom horizontal line}

      DrawVLine(x1,y1+1,y1,y2-1);  {obtain left vertical line}

      DrawVLine(x2,y1+1,y1,y2-1);  {obtain right vertical line}

      GOTOXY(x1,y1);
      WRITE(#218);  {obtains top left corner }

      GOTOXY(x2,y1);
      WRITE(#191);  {obtains top right corner}

      GOTOXY(x2,y2);
      WRITE(#217);  {obtains bottom right corner}

      GOTOXY(x1,y2);
      WRITE(#192);  {obtains bottom left corner}

   END;

     PROCEDURE Fill(x1,y1,x2,y2:INTEGER);
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
          X1:=I;
          y1:=y1+1
         UNTIL y1=y2;

        END;


   END.
