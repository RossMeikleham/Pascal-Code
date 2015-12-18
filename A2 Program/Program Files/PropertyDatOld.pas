UNIT PROPERTYDAT;

INTERFACE

TYPE

   KeyRec=RECORD

          KeyNo:INTEGER;     {Key field for house keys}
          KeyTaken:BOOLEAN; {if the key has been taken or not}
          LastDate:STRING;  {last date the key was taken}

          END;

     PropertyInfo=RECORD

        PropertyId:STRING[6];
        NoOfKeys:INTEGER;
        NoOfKeysAvailable:INTEGER;
        KeyArray:ARRAY[1..9] OF KeyRec;
        PropertyAvailable:BOOLEAN;
     END;


    PropA=ARRAY[1..50] OF PropertyInfo;



   VAR PropArray:PropA;
       TempPropArray:PropA;
       TempPropRec:PropertyInfo;
       Prop:PropertyInfo;
       PropFile:FILE OF PropertyInfo;
       GlobalDriveLetter:CHAR;
       ArrayValue:INTEGER;


PROCEDURE ResetProp;

PROCEDURE LoadProp(VAR Found:BOOLEAN;DriveLetter:CHAR);

PROCEDURE FindProp(PropertyID:STRING; VAR Found:BOOLEAN);

PROCEDURE AddProp;

PROCEDURE AmendProp;

PROCEDURE DisplayAllProp;

PROCEDURE DisplaySearchProp;

PROCEDURE DeleteProp;


IMPLEMENTATION

USES CRT, SYSUTILS, Draw, Validate, DateCalc;

   PROCEDURE ResetProp;
   VAR I,J:INTEGER;

      BEGIN

         FOR I:= 1 TO 50 DO

            BEGIN
            PropArray[I].PropertyId:='0';
            TempPropArray[I].PropertyId:='0';
            FOR J:=1 TO 9 DO
            PropArray[I].KeyArray[J].KeyNo:=0;
            END;

      END;




    PROCEDURE LoadProp(VAR Found:BOOLEAN;DriveLetter:CHAR);
    VAR I:INTEGER;


      BEGIN
         GlobalDriveLetter:=DriveLetter;
         ASSIGN(PropFile,GlobalDriveLetter+':\Computing\A2\Main Program\PropData.DTA');  {Finds the file to be read from}


         IF NOT FILEEXISTS(GlobalDriveLetter+':\Computing\A2\Main Program\PropData.DTA') THEN  {if file not found}
         Found:=FALSE

         ELSE

         BEGIN
         Found:=TRUE;
         RESET(PropFile);
         ResetProp;
         IF FILESIZE(PropFile) <>0 THEN  {Check if there is data in the file}
         BEGIN
              I:=1;
               WITH Prop DO
               WHILE (NOT EOF(PropFile)) AND (PropertyID<>'0')  DO

                  BEGIN
                      READ(PropFile,Prop);
                      PropArray[I].PropertyId:=PropertyId;
                      PropArray[I].PropertyAvailable:=propertyAvailable;
                      PropArray[I].KeyArray[I].KeyNo:=KeyNo;
                      PropArray[I].KeyArray[I].KeyTaken:=KeyTaken;
                      PropArray[I].KeyArray[I].LastDate:=LastDate;
                      I:=I+1;
                      I:=I+1;
                  END;

         END

        END;
      END;


   PROCEDURE SavePropFile;
   VAR I:INTEGER;
       J:INTEGER;
       K:INTEGER;
       FOUND:BOOLEAN;
       FileName:STRING;
      BEGIN
         I:=1;
         J:=1;
         WHILE J<51 DO
         BEGIN
            IF PropArray[J].PropertyID <> '0' THEN
            WITH Prop DO                                {If PropertyId is rogue value of 0}
            BEGIN                                        {then it is not added to the temp array}
             TempPropArray[I].PropertyId:=PropArray[J].PropertyID;   {so any Propertys deleted are just not saved into the file}
             TempPropArray[I].PropertyAvailable:=PropArray[J].PropertyAvailable; {when it is rewritten}
             I:=I+1;                                    {'I' will count as the total amount of}
           END;                                         {subscripts that are 'valid' within the array}
           J:=J+1;
       END;
       I:=I-1;

       REWRITE(PropFile);  {Rewrites the valid records}
       RESET(PropFile);
       FOR K:=1 TO I DO  {For total amount of valid subscripts}
       WITH Prop DO
       BEGIN
       PropertyId:=TempPropArray[K].PropertyId;
       PropertyAvailable:=TempPropArray[K].PropertyAvailable;
       WRITE(PropFile,Prop);
       END;
       Close(PropFile);
       FOUND:=TRUE;
       LoadProp(FOUND,GlobalDriveLetter); {loads the file back into the PropArray}
    END;




    PROCEDURE SortProps; {Bubble sort's Props by Propid}

   VAR Pos,Finish:LONGINT;  {sorts from largest to smallest as invalid or empty records contain an ID of "0"}
       Swapped:BOOLEAN;     {and if done smallest to largest will send all the valid data to the back}

      BEGIN

         Finish:=49;

         REPEAT

            Swapped:=FALSE;
            FOR Pos:=1 TO Finish DO

               BEGIN

                  IF PropArray[Pos].PropertyId < PropArray[Pos+1].PropertyId THEN

                     BEGIN //Swap

                        TempPropRec:=PropArray[Pos]; {Assigns temporary record}
                        PropArray[Pos]:=PropArray[Pos+1];
                        PropArray[Pos+1]:=TempPropRec;
                        Swapped:=TRUE;

                     END;

               END;

            Finish:=Finish-1;

         UNTIL (NOT Swapped) OR (Finish=0);

      END;


   PROCEDURE FindProp(PropertyID:STRING; VAR Found:BOOLEAN);
   VAR I,Start,Finish:INTEGER;
       TempStart,TempFinish:INTEGER;
       NoChange:BOOLEAN;
       Value:INTEGER;
      BEGIN

         RESET(PropFile);
         Start:=0;
         Finish:=50;
         IF FILESIZE(PropFile) <>0 THEN

         BEGIN
            NoChange:=FALSE;
            SortProps;  {Tennants sorted into sequential order}
            Found:=FALSE;
            arrayvalue:=0;
            WHILE (NoChange=FALSE) AND (Found=FALSE) DO {Binary Search}
            BEGIN

            arrayvalue:=ROUND((Start+Finish)/2);

            TempStart:=Start;
            TempFinish:= Finish;

            IF PropArray[arrayvalue].PropertyId < PropertyId  THEN
            Finish:=arrayvalue;

            IF PropArray[arrayvalue].PropertyId > PropertyId  THEN
            Start:=arrayvalue;

            IF PropertyID=PropArray[arrayvalue].PropertyID THEN
            Found:=TRUE;

            IF (TempStart=Start) AND (TempFinish=Finish) THEN
            NoChange:=TRUE;
            END;

         END;
     END;

   PROCEDURE DisplayPropDetails(Pos:LONGINT);

         BEGIN
         DRAWBOX(18,1,42,3);
         GOTOXY(20,2);
         WRITE('PropId: '); WRITELN(PropArray[Pos].PropertyID);
         GOTOXY(1,4);
         WRITE(' Prop     :                    ');
         IF PropArray[Pos].PropertyAvailable=TRUE THEN

            BEGIN

               TEXTCOLOR(GREEN);
               WRITELN('[ Available   ]');
               TEXTCOLOR(WHITE);

            END ELSE

            BEGIN

               TEXTCOLOR(RED);
               WRITELN('[ Rented ]');
               TEXTCOLOR(WHITE);

            END;
         WRITE(' HouseId:                     '); WRITELN(PropArray[Pos].PropertyId);


         DRAWBOX(1,3,50,13);
         DRAWBOX(30,3,50,13);

         END;



   PROCEDURE FindPropDetails(VAR Found:BOOLEAN);
   VAR TempProp:STRING;
       Valid:BOOLEAN;

      BEGIN
         CLRSCR;
         WRITELN('Enter the Prop ID: ');
         REPEAT
         READLN(TempProp);
         ValStrInt(TempProp,Valid);
         UNTIL Valid=TRUE;

         FindProp(TempProp,Found);

         IF Found=FALSE THEN
         ErrorMessage('Not Found');

      END;


   PROCEDURE DisplaySearchProp;
   VAR Found:BOOLEAN;
       Pos:LONGINT;

      BEGIN

      FindPropDetails(Found);
      Pos:=ArrayValue;
      IF Found=TRUE THEN
      DisplayPropDetails(Pos);
      READLN;

      END;


   PROCEDURE DisplayAllProp;
   VAR TempPropId:INTEGER;
       Total,Pos:INTEGER;
       Prop:CHAR;

      BEGIN

         Total:=1;
         Pos:=1;
         WHILE (PropArray[Total].PropertyId <> '0') DO
         Total:=Total+1;

         Total:=Total-1;
         IF Total<>0 THEN
         REPEAT

         GOTOXY(1,14);
         TEXTBACKGROUND(BLUE);
         WRITE('Record ',Pos,' Of ',Total,'     ',#24,#25,' to select Record      `X` to exit');
         TEXTBACKGROUND(BLACK);

         DisplayPropDetails(Pos);
         Prop:=UPCASE(READKey);
         IF (Prop=#80) AND (Pos<>Total) THEN Pos:=Pos+1; //Down
         IF (Prop=#72) AND (Pos<>1) THEN Pos:=Pos+-1; //up


         UNTIL Prop='X'
         ELSE
         Errormessage('No records in the file');


      END;



   PROCEDURE DeleteProp;
    VAR Found,Valid:BOOLEAN;
        Value:INTEGER;
        ConfirmDelete:CHAR;
        TempProp:STRING;

      BEGIN

         CLRSCR;
         arrayvalue:=1;
         WRITE('Enter PropID to Delete');

         REPEAT

         READLN(TempProp);
         ValStrInt(TempProp,Valid);

         UNTIL Valid=TRUE;

         FindProp(TempProp,FOUND);


         IF Found=TRUE THEN

         BEGIN

            WRITELN('Prop found, would you like to delete? Y/N');
            ValidateYN(ConfirmDelete);

            IF ConfirmDelete='Y' THEN

            BEGIN

               PropArray[arrayvalue].PropertyId:='0'; {sets the CustId of the record to an invalid record}



            SavePropFile;
            WRITELN('Deleted');
            READLN;

         END ELSE

         BEGIN

            WRITELN('Not Deleted');
            READLN;

         END;

        END ELSE

        ErrorMessage('Prop Not Found');


    END;



   PROCEDURE AmendPropTaken(New:BOOLEAN);
   VAR PropStroke:CHAR;
       Available:BOOLEAN;
       Prop:STRING;
       Valid:BOOLEAN;

      BEGIN

         IF PropArray[arrayvalue].PropertyAvailable =TRUE THEN
            Prop:='Available' ELSE
            Prop:='Rented';

         IF New=FALSE THEN
         WRITELN('The Prop for the property is currently: ',Prop);
         WRITELN;
         WRITELN('Enter New Status of Property (`A` for Available `R` for Rented');

         Val2Char('A','R',PropStroke);

         IF PropStroke='A' THEN
            BEGIN
            Available:=TRUE;
            Prop:='Available';

            END ELSE
            BEGIN
            Available:=FALSE;
            Prop:='Rented'
            END;

         WRITELN;
         WRITELN('The status of the Prop has been changed to: ',Prop);
         WRITELN('Press Enter to Continue..');

         PropArray[arrayvalue].PropertyAvailable:=Available;
         SavePropFile;

      END;





   PROCEDURE AmendKeys;
   VAR I:INTEGER;

      BEGIN
        CLRSCR;
        REPEAT
        WRITELN('Select Keys Option');
        WRITELN('1: Display All Keys');
        WRITELN('3: Amend Key');
        WRITELN('2: Add New Key');
        WRITELN('3: Delete Key');

         FOR I:=1 TO 9 DO
         PropArray[ArrayValue].KeyArray[I].KeyNo
         END;

        FieldChoice:=UPCASE(READKEY);
        CASE FieldChoice OF
        '1':AmendPropTaken(New);
        '2'://AmendPropertyID;
        ;
        'X':;
        ELSE
        ErrorMessage('Only enter digits 1-2 OR X');
        END;
        UNTIL FieldChoice='X';
      END




   PROCEDURE AmendProp;
   VAR
       TempProp:STRING;
       Found,Valid:BOOLEAN;
       FieldChoice:CHAR;
       New:BOOLEAN;

     BEGIN

         New:=FALSE;
         CLRSCR;
         arrayvalue:=1;
         WRITELN('Enter Prop Id To Amend');
         REPEAT
         READLN(TempProp);
         ValStrInt(TempProp,Valid);

         UNTIL Valid=TRUE;

         FindProp(TempProp,FOUND);
         IF Found=TRUE THEN

         BEGIN

        CLRSCR;
        REPEAT
        WRITELN('Select Field To Amend');
        WRITELN('1: PropTaken');
        WRITELN('2: PropertyId');
        WRITELN('3: Keys');



        FieldChoice:=UPCASE(READKEY);
        CASE FieldChoice OF
        '1':AmendPropTaken(New);
        '2'://AmendPropertyID;
        ;
        'X':;
        ELSE
        ErrorMessage('Only enter digits 1-2 OR X');
        END;
        UNTIL FieldChoice='X';
        END
        ELSE ErrorMessage('Prop Record Not Found');



     END;

   PROCEDURE AddProp;
   VAR I:INTEGER;
       Full,Valid:BOOLEAN;
       NewPropId:STRING;
       New:BOOLEAN;

         BEGIN
         I:=1;
         WHILE (I<51) AND (Full=TRUE) DO
         IF PropArray[I].PropertyId = '0' THEN Full:=FALSE
         ELSE I:=I+1;

         IF Full=TRUE THEN

         BEGIN

            WRITE('All Records have been filled, no remaning space is');
            WRITELN(' available. Please delete a record to add a new one.');
            READLN;


         END ELSE

         BEGIN

         New:=TRUE;
         CLRSCR;
         WRITELN('Enter PropId for new Prop ');
         WRITELN('(6 digits long)');
         REPEAT

         READLN(NewPropid);
         ValStrInt(NewPropid,Valid);
         IF LENGTH(NewPropid) <> 6 THEN Valid:=FALSE;

         UNTIL Valid=TRUE;
         PropArray[I].PropertyId:=NewPropId;
         WRITELN('New Prop with Prop Id ',PropArray[I].PropertyID,' has been created');
         WRITELN;
         WRITELN('Would you like to add keys to the property?');

         SavePropFile;
         READLN;
         AmendProp;

         //AmendPropertyId;
         READLN;

         END;

      END;
   END.


END.
