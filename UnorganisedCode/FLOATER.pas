PROGRAM FLOATER;

{Converts a positive denary number into}
{the mantisa and exponent in binary}
{Created by Ross Meikleham ~2010}

USES CRT;

VAR
Exponent:INTEGER;
Mantisa:INTEGER;
OriginalNumber:REAL;
Divider:INTEGER;
TempMantisa:REAL;
MantisaBit:INTEGER;
ExponentBit:INTEGER;


   PROCEDURE Obtain;

      BEGIN

         WRITELN('Enter the number to convert to floating point');
         READLN(OriginalNumber);
         WRITELN('Enter bit value for Mantisa');
         READLN(MantisaBit);
         WRITELN('Enter bit value for Exponent');
         READLN(ExponentBit);
      END;


   PROCEDURE CalculateExponent;


       BEGIN

          Divider:=1;
          Exponent:=0;

          WHILE Divider < OriginalNumber DO

          BEGIN

             Divider:=Divider*2;
             Exponent:=Exponent+1

          END;

       END;



   PROCEDURE CalculateMantisa;

       BEGIN

          TempMantisa:=OriginalNumber/Divider; {Gives Decimal value of}
                                               {the mantisa}
       END;




   PROCEDURE DisplayFloater;
   VAR MantisaStr:STRING;
   I:INTEGER;
   P:INTEGER;

      BEGIN

         GOTOXY(30,10);
         WRITELN('Mantisa');
         GOTOXY(30,13);
         WRITELN('Exponent');
         GOTOXY(20,11);
         WRITE('0');  {defines the mantisa as positive}

         FOR I:= 1 TO MantisaBit-1 DO

         BEGIN

            TempMantisa:=TempMantisa*2;
            IF (TempMantisa >1) OR (TempMantisa =1)  THEN

            BEGIN

               WRITE('1');
               TempMantisa:=TempMantisa-1;

            END ELSE

            WRITE('0');

         END;



      BEGIN

         P:=25;
         FOR I:= 1 TO ExponentBit DO

         BEGIN

            GOTOXY(P,14);
            IF Exponent/2 <> TRUNC(Exponent/2) THEN
            WRITE('1') ELSE WRITE('0');

            P:=P-1;
            Exponent:=TRUNC(Exponent/2);

         END;

         READLN;

      END;

      END;



BEGIN
Obtain;
CalculateExponent;
CalculateMantisa;
DisplayFloater;
END.
