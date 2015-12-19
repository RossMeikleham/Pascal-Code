PROGRAM BUBBLESORT;
USES CRT;

TYPE

 Num=Array[1..8] OF INTEGER;
 Phonetic=Array[1..8] OF STRING;

VAR


  NumList:Num=(32,12,19,6,48,17,16,1);
  PhoList:Phonetic=('Zulu','Delta','Whisky','Xray',
                     'Foxtrot','tango','Alpha','Lima');
  Placement:INTEGER;



   PROCEDURE DisplayNumList;
   VAR Pos:INTEGER;

      BEGIN
         Placement:=Placement+2;
         Pos:=1;
         GOTOXY(27,Placement);
         FOR Pos:=1 TO 8 DO
         WRITE(NumList[Pos],'  ');

         WRITELN;
      END;


   PROCEDURE SortNumList;
   VAR Pos,Finish,Temp:INTEGER;
       Swapped:BOOLEAN;

      BEGIN

         Finish:=7;

         REPEAT

            Swapped:=FALSE;
            FOR Pos:=1 TO Finish DO

               BEGIN

                  IF NumList[Pos] > NumList[Pos+1] THEN

                     BEGIN //Swap

                        Temp:=NumList[Pos];
                        NumList[Pos]:=NumList[Pos+1];
                        NumList[Pos+1]:=Temp;
                        Swapped:=TRUE;

                     END;

               END;

            Finish:=Finish-1;

         UNTIL (NOT Swapped) OR (Finish=0);

      END;


   PROCEDURE DisplayStrList;
   VAR Pos:INTEGER;

      BEGIN
         Placement:=Placement+2;
         GOTOXY(14,Placement);
         FOR Pos:=1 TO 8 DO
         WRITE(PhoList[Pos],'  ');

         WRITELN;

      END;


   PROCEDURE SortStrList;
   VAR Pos,Finish:INTEGER;
       Swapped:BOOLEAN;
       Temp:STRING;

      BEGIN

         Finish:=7;

         REPEAT

            Swapped:=FALSE;
            FOR Pos:=1 TO Finish DO

               BEGIN

                  IF PhoList[Pos] > PhoList[Pos+1] THEN

                     BEGIN //Swap

                        Temp:=PhoList[Pos];
                        PhoList[Pos]:=PhoList[Pos+1];
                        PhoList[Pos+1]:=Temp;
                        Swapped:=TRUE;

                     END;

               END;

            Finish:=Finish-1;

         UNTIL (NOT Swapped) OR (Finish=0);

      END;


BEGIN

Placement:=1;
GOTOXY(30,1);
WRITELN('0 O o Bubble Sort o O 0');

DisplayNumList;
SortNumList;
READLN;
DisplayNumList;
READLN;

DisplayStrList;
SortStrList;
READLN;
DisplayStrList;
READLN;

END.
