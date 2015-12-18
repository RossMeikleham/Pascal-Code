UNIT Validate;

INTERFACE


PROCEDURE ValStrLetter(Str:STRING; VAR Valid:BOOLEAN);  {Validates Strings where only letters can be used}

PROCEDURE ValStrLetNum(Str:STRING; VAR Valid:BOOLEAN);  {Validates strings which should only contain numbers and letters}

PROCEDURE ValidateYN(VAR Key:CHAR);                {Validates Characters that should only be Yes or No}

PROCEDURE ValStrInt(Str:STRING; VAR Valid:BOOLEAN); {Validates strings which should only contain numbers}

PROCEDURE Val2Char(Ch1,Ch2:CHAR; VAR Key:CHAR);  {Validates 2 characters and returns the character selected if it's valid}

PROCEDURE ValPostCode(VAR PostCode:STRING); {Validates postcodes}



IMPLEMENTATION

USES DRAW,SYSUTILS,CRT;



   PROCEDURE  ValStrInt(Str:STRING; VAR Valid:BOOLEAN);
   VAR I:INTEGER;

      BEGIN
         I:=0;
         Str:=UPPERCASE(Str);

       REPEAT

           I:=I+1;
           IF (Str[I]<#48) OR (Str[I]>#57) THEN  {If not between 0-9}

               Valid:=FALSE

             ELSE

               Valid:=TRUE;

     UNTIL (Valid=FALSE) OR (I=LENGTH(Str));

           IF Valid= FALSE THEN
           ErrorMessage('You entered: '+Str[I]+' Only enter 0-9');

           END;






   PROCEDURE  ValStrLetter(Str:STRING; VAR Valid:BOOLEAN);
   VAR I:INTEGER;

      BEGIN
         I:=0;
         Str:=UPPERCASE(Str);

       REPEAT

           I:=I+1;
           IF ((Str[I]<#65) OR (Str[I]>#122))
           AND (Str[I]<>#32) THEN

               Valid:=FALSE

             ELSE

               Valid:=TRUE;

     UNTIL (Valid=FALSE) OR (I=LENGTH(Str));

           IF Valid= FALSE THEN
           ErrorMessage('You entered: '+Str[I]+' Only enter A-Z');

           END;



   PROCEDURE ValStrLetNum(Str:STRING; VAR Valid:BOOLEAN);
   VAR I:INTEGER;

      BEGIN
         I:=0;
         Str:=UPPERCASE(Str);

       REPEAT

           I:=I+1;
           IF ((Str[I]<#65) OR (Str[I]>#122)) AND
              ((Str[I]<#48) OR (Str[I]>#57)) AND
              ((Str[I]<>#32)) THEN

               Valid:=FALSE

             ELSE

               Valid:=TRUE;

     UNTIL (Valid=FALSE) OR (I=LENGTH(Str));

           IF Valid= FALSE THEN
           ErrorMessage('You entered: '+Str[I]+' Only enter A-Z or 0-9');

           END;



   PROCEDURE ValidateYN(VAR Key:CHAR);

      BEGIN

         REPEAT

         WRITELN('Enter either Y/N');
         Key:=UPCASE(READKEY);

         IF (Key<>'N') AND (Key<>'Y') THEN

         BEGIN

            ErrorMessage('Error, you entered: '+Key+' Enter either Y/N');

         END;

         UNTIL (Key='Y') OR (Key='N');

      END;





   PROCEDURE Val2Char(Ch1,Ch2:CHAR; VAR Key:CHAR);

      BEGIN

         REPEAT

         WRITELN('Enter either ',Ch1,'/',Ch2);
         Key:=UPCASE(READKEY);

         IF (Key<>Ch1) AND (Key<>Ch2) THEN

         BEGIN

            ErrorMessage('Error, you entered: '+Key+' Enter either '+Ch1+'/'+Ch2);

         END;

         UNTIL (Key=Ch1) OR (Key=Ch2);

      END;



   PROCEDURE ValPostCode(VAR PostCode:STRING);
   VAR ValidType:BOOLEAN;
       Part1,Part2:STRING;
        I:LONGINT;

               BEGIN

                 REPEAT

                  WRITELN('Enter first part of the Postcode:');
                  READLN(Part1);


          BEGIN
         I:=0;
         part1:=UPPERCASE(part1);

       REPEAT

           I:=I+1;
           IF ((part1[I]<#65) OR (part1[I]>#122)) AND
              ((part1[I]<#48) OR (part1[I]>#57))
               THEN

               validtype:=FALSE

             ELSE

               validtype:=TRUE;

     UNTIL (validtype=FALSE) OR (I=LENGTH(part1));

           IF validtype= FALSE THEN
           ErrorMessage('You entered: '+part1[I]+' Only enter A-Z or 0-9');

           END;

                  IF (validtype=TRUE) AND ((LENGTH(Part1) >4) OR (LENGTH(Part1) <2)) THEN
                  ErrorMessage('Please enter  between 2 Or 4 Characters');


                 UNTIL (validtype=TRUE) AND ((LENGTH(Part1) <5) OR (LENGTH(Part1) >2));

               BEGIN

                 REPEAT

                  WRITELN('Enter second part of the Postcode:');
                  READLN(Part2);


      BEGIN
         I:=0;
         Part2:=UPPERCASE(part2);

       REPEAT

           I:=I+1;
           IF ((part2[I]<#65) OR (part2[I]>#122)) AND
              ((part2[I]<#48) OR (part2[I]>#57))
              THEN

               validtype:=FALSE

             ELSE

               validtype:=TRUE;

     UNTIL (validtype=FALSE) OR (I=LENGTH(part2));

           IF validtype= FALSE THEN
           ErrorMessage('You entered: '+part2[I]+' Only enter A-Z or 0-9');

           END;

                  IF (validtype=TRUE) AND (LENGTH(Part2) <>3)  THEN
                  ErrorMessage('Please enter only 3 Characters');


                 UNTIL (validtype=TRUE) AND (LENGTH(Part2) =3) ;


               END;

            PostCode:=Part1+' '+Part2;
            PostCode:=UPPERCASE(PostCode);
         END;

END.
