UNIT KEYDAT;

INTERFACE

TYPE
   KeyRec=RECORD

          KeyId:STRING;     {Key field for house keys}
          KeyTaken:BOOLEAN; {if the key has been taken or not}
          PropertyId:STRING;   {id of the house the key is for}
          LastDate:STRING;  {last date the key was taken}

          END;

   Keys=ARRAY[1..50] OF KeyRec;


   VAR Key:KeyRec;
       KeyFile: FILE OF KeyRec;
       KeyArray:Keys;
       TempKey:Keys;
       TempArray:KeyRec;
       GlobalDriveLetter:CHAR;
       ArrayValue:LONGINT;

PROCEDURE ResetKey;

PROCEDURE LoadKey(VAR Found:BOOLEAN;DriveLetter:CHAR);

PROCEDURE FindKey(KeyID:STRING; VAR Found:BOOLEAN);

PROCEDURE AddKey;

PROCEDURE AmendKey;

PROCEDURE DisplayAllKey;

PROCEDURE DisplaySearchKey;

PROCEDURE DeleteKey;

IMPLEMENTATION


USES CRT,SYSUTILS,Draw,Validate,DateCalc,PropertyDat;

    PROCEDURE ResetKey;
    VAR I:INTEGER;

    BEGIN

       FOR I:= 1 TO 50 DO

          BEGIN

             KeyArray[I].KeyId:='0';
             TempKey[I].KeyId:='0';

          END;

    END;


    PROCEDURE LoadKey(VAR Found:BOOLEAN;DriveLetter:CHAR);
    VAR I:INTEGER;


      BEGIN
         GlobalDriveLetter:=DriveLetter;
         ASSIGN(KeyFile,GlobalDriveLetter+':\Computing\A2\Main Program\KeyData.DTA');  {Finds the file to be read from}


         IF NOT FILEEXISTS(GlobalDriveLetter+':\Computing\A2\Main Program\KeyData.DTA') THEN  {if file not found}
         Found:=FALSE

         ELSE

         BEGIN
         Found:=TRUE;
         RESET(KeyFile);
         ResetKey;
         IF FILESIZE(KeyFile) <>0 THEN  {Check if there is data in the file}
         BEGIN
              I:=1;
               WITH Key DO
               WHILE (NOT EOF(KeyFile)) AND (KeyID<>'0')  DO

                  BEGIN
                      READ(KeyFile,Key);
                      KeyArray[I].KeyId:=KeyId;
                      KeyArray[I].KeyTaken:=KeyTaken;
                      KeyArray[I].PropertyId:=PropertyId;
                      KeyArray[I].LastDate:=LastDate;
                      I:=I+1;
                  END;

         END

        END;
      END;


   PROCEDURE SaveKeyFile;
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
            IF KeyArray[J].KeyID <> '0' THEN
            WITH Key DO                                {If CustId is rogue value of 0}
            BEGIN                                        {then it is not added to the temp array}
             TempKey[I].KeyId:=KeyArray[J].KeyID;   {so any customers deleted are just not saved into the file}
             TempKey[I].KeyTaken:=KeyArray[J].KeyTaken; {when it is rewritten}
             TempKey[I].PropertyId:=KeyArray[J].PropertyId;
             TempKey[I].LastDate:=KeyArray[J].LastDate;
             I:=I+1;                                    {'I' will count as the total amount of}
           END;                                         {subscripts that are 'valid' within the array}
           J:=J+1;
       END;
       I:=I-1;

       REWRITE(KeyFile);  {Rewrites the valid records}
       RESET(KeyFile);
       FOR K:=1 TO I DO  {For total amount of valid subscripts}
       WITH Key DO
       BEGIN
       KeyId:=TempKey[K].KeyId;
       KeyTaken:=TempKey[K].KeyTaken;
       PropertyId:=TempKey[K].PropertyId;
       LastDate:=TempKey[K].LastDate;
       WRITE(KeyFile,Key);
       END;
       Close(KeyFile);
       FOUND:=TRUE;
       LoadKey(FOUND,GlobalDriveLetter); {loads the file back into the KeyArray}
    END;




    PROCEDURE SortKeys; {Bubble sort's Keys by Keyid}

   VAR Pos,Finish:LONGINT;  {sorts from largest to smallest as invalid or empty records contain an ID of "0"}
       Swapped:BOOLEAN;     {and if done smallest to largest will send all the valid data to the back}

      BEGIN

         Finish:=49;

         REPEAT

            Swapped:=FALSE;
            FOR Pos:=1 TO Finish DO

               BEGIN

                  IF KeyArray[Pos].KeyId < KeyArray[Pos+1].KeyId THEN

                     BEGIN //Swap

                        TempArray:=KeyArray[Pos]; {Assigns temporary record}
                        KeyArray[Pos]:=KeyArray[Pos+1];
                        KeyArray[Pos+1]:=TempArray;
                        Swapped:=TRUE;

                     END;

               END;

            Finish:=Finish-1;

         UNTIL (NOT Swapped) OR (Finish=0);

      END;


   PROCEDURE FindKey(KeyID:STRING; VAR Found:BOOLEAN);
   VAR I,Start,Finish:INTEGER;
       TempStart,TempFinish:INTEGER;
       NoChange:BOOLEAN;
       Value:INTEGER;
      BEGIN

         RESET(KeyFile);
         Start:=0;
         Finish:=50;
         IF FILESIZE(KeyFile) <>0 THEN

         BEGIN
            NoChange:=FALSE;
            SortKeys;  {Tennants sorted into sequential order}
            Found:=FALSE;
            arrayvalue:=0;
            WHILE (NoChange=FALSE) AND (Found=FALSE) DO {Binary Search}
            BEGIN

            arrayvalue:=ROUND((Start+Finish)/2);

            TempStart:=Start;
            TempFinish:= Finish;

            IF KeyArray[arrayvalue].KeyId < KeyId  THEN
            Finish:=arrayvalue;

            IF KeyArray[arrayvalue].KeyId > KeyId  THEN
            Start:=arrayvalue;

            IF KeyID=KeyArray[arrayvalue].KeyID THEN
            Found:=TRUE;

            IF (TempStart=Start) AND (TempFinish=Finish) THEN
            NoChange:=TRUE;
            END;

         END;
     END;

   PROCEDURE DisplayKeyDetails(Pos:LONGINT);

         BEGIN
         DRAWBOX(18,1,42,3);
         GOTOXY(20,2);
         WRITE('KeyId: '); WRITELN(KeyArray[Pos].KeyID);
         GOTOXY(1,4);
         WRITE(' Key     :                    ');
         IF KeyArray[Pos].KeyTaken=TRUE THEN

            BEGIN

               TEXTCOLOR(RED);
               WRITELN('[ Taken   ]');
               TEXTCOLOR(WHITE);

            END ELSE

            BEGIN

               TEXTCOLOR(GREEN);
               WRITELN('[ Present ]');
               TEXTCOLOR(WHITE);

            END;
         WRITE(' HouseId:                     '); WRITELN(KeyArray[Pos].PropertyId);
         WRITE(' Last Date Key was checked:   '); WRITELN(KeyArray[Pos].LastDate);

         DRAWBOX(1,3,50,13);
         DRAWBOX(30,3,50,13);

         END;



   PROCEDURE FindKeyDetails(VAR Found:BOOLEAN);
   VAR TempKey:STRING;
       Valid:BOOLEAN;

      BEGIN
         CLRSCR;
         WRITELN('Enter the Key ID: ');
         REPEAT
         READLN(TempKey);
         ValStrInt(TempKey,Valid);
         UNTIL Valid=TRUE;

         FindKey(TempKey,Found);

         IF Found=FALSE THEN
         ErrorMessage('Not Found');

      END;


   PROCEDURE DisplaySearchKey;
   VAR Found:BOOLEAN;
       Pos:LONGINT;

      BEGIN

      FindKeyDetails(Found);
      Pos:=ArrayValue;
      IF Found=TRUE THEN
      DisplayKeyDetails(Pos);
      READLN;

      END;


   PROCEDURE DisplayAllKey;
   VAR TempKeyId:INTEGER;
       Total,Pos:INTEGER;
       Key:CHAR;

      BEGIN

         Total:=1;
         Pos:=1;
         WHILE (KeyArray[Total].KeyId <> '0') DO
         Total:=Total+1;

         Total:=Total-1;
         IF Total<>0 THEN
         REPEAT

         GOTOXY(1,14);
         TEXTBACKGROUND(BLUE);
         WRITE('Record ',Pos,' Of ',Total,'     ',#24,#25,' to select Record      `X` to exit');
         TEXTBACKGROUND(BLACK);

         DisplayKeyDetails(Pos);
         Key:=UPCASE(READKEY);
         IF (Key=#80) AND (Pos<>Total) THEN Pos:=Pos+1; //Down
         IF (Key=#72) AND (Pos<>1) THEN Pos:=Pos+-1; //up


         UNTIL Key='X'
         ELSE
         Errormessage('No records in the file');


      END;



   PROCEDURE DeleteKey;
    VAR Found,Valid:BOOLEAN;
        Value:INTEGER;
        ConfirmDelete:CHAR;
        TempKey:STRING;

      BEGIN

         CLRSCR;
         arrayvalue:=1;
         WRITE('Enter KeyID to Delete');

         REPEAT

         READLN(TempKey);
         ValStrInt(TempKey,Valid);

         UNTIL Valid=TRUE;

         FindKey(TempKey,FOUND);


         IF Found=TRUE THEN

         BEGIN

            WRITELN('Key found, would you like to delete? Y/N');
            ValidateYN(ConfirmDelete);

            IF ConfirmDelete='Y' THEN

            BEGIN

               KeyArray[arrayvalue].KeyId:='0'; {sets the CustId of the record to an invalid record}



            SaveKeyFile;
            WRITELN('Deleted');
            READLN;

         END ELSE

         BEGIN

            WRITELN('Not Deleted');
            READLN;

         END;

        END ELSE

        ErrorMessage('Key Not Found');


    END;

   PROCEDURE DateTaken;
   VAR Year,Month,Day:LONGINT;
       DateStr:STRING;

   BEGIN
      ObtainDate(Year,Month,Day,DateStr);
      KeyArray[ArrayValue].LastDate:=DateStr;
   END;


   PROCEDURE AmendKeyTaken(New:BOOLEAN);
   VAR KeyStroke:CHAR;
       Taken:BOOLEAN;
       Key:STRING;
       Valid:BOOLEAN;

      BEGIN

         IF KeyArray[arrayvalue].KeyTaken =TRUE THEN
            Key:='Taken' ELSE
            Key:='Present';

         IF New=FALSE THEN
         WRITELN('The Key for the property is currently: ',Key);
         WRITELN;
         WRITELN('Enter New Status of Key (`T` for taken `P` for present');

         Val2Char('T','P',KeyStroke);

         IF KeyStroke='T' THEN
            BEGIN
            Taken:=TRUE;
            Key:='Taken';
            DateTaken;
            END ELSE
            BEGIN
            Taken:=FALSE;
            Key:='Present'
            END;

         WRITELN;
         WRITELN('The status of the Key has been changed to: ',Key);
         WRITELN('Press Enter to Continue..');

         KeyArray[arrayvalue].KeyTaken:=Taken;
         SaveKeyFile;

      END;





   PROCEDURE AmendPropertyId;
   VAR I,Pos,MaxPos:LONGINT;
       SearchArray:ARRAY[1..50] OF STRING;
       TempId:STRING;
       Found:BOOLEAN;

      BEGIN

         I:=1;
         Pos:=1;

         WHILE (PropArray[I].PropertyId<>'0') AND (I<51) DO

         BEGIN

            IF PropArray[I].Available = TRUE THEN {If property is available}
                                                  {for Rent, (as a property already}
            BEGIN                                 {being rented wouldn't need keys}
                                                  {assigned to it or vice-versa) then}
                                                  {add that property to the list to be chosen}

               SearchArray[Pos]:=PropArray[I].PropertyId;
               Pos:=Pos+1;      {add 1 to the total number of available propertys}

            END;

            I:=I+1;

         END;

         IF Pos=1 THEN  {If no available houses}
         ErrorMessage('No available propertys for rent') ELSE

         BEGIN

            MaxPos:=Pos;
            FOR Pos:=1 TO MaxPos DO
            WRITELN(SearchArray[Pos]);
            WRITELN;
            WRITELN('Enter 1 of the above property numbers that the key is assigned to or press `P` to add a new property for the key');
            READLN(TempId);
            Pos:=1;

               WHILE (TempId<>SearchArray[Pos]) AND (Pos<>MaxPos) DO
                  Pos:=Pos+1;

            IF TempId=SearchArray[Pos] THEN Found:=TRUE ELSE
            Found:=FALSE;

            IF Found=TRUE THEN

               BEGIN

               KeyArray[ArrayValue].PropertyId:=SearchArray[Pos];

               I:=1;
               WHILE SearchArray[Pos] <> PropArray[I].PropertyId DO {Already know the property exists}
               I:=I+1;                                         {so find position}

               PropArray[I].KeyId:=KeyArray[ArrayValue].KeyId

               END;



         END;



      END;




   PROCEDURE AmendKey;
   VAR
       TempKey:STRING;
       Found,Valid:BOOLEAN;
       FieldChoice:CHAR;
       New:BOOLEAN;

     BEGIN

         New:=FALSE;
         CLRSCR;
         arrayvalue:=1;
         WRITELN('Enter Key Id To Amend');
         REPEAT
         READLN(TempKey);
         ValStrInt(TempKey,Valid);

         UNTIL Valid=TRUE;

         FindKey(TempKey,FOUND);
         IF Found=TRUE THEN

         BEGIN

        CLRSCR;
        REPEAT
        WRITELN('Select Field To Amend');
        WRITELN('1: KeyTaken');
        WRITELN('2: PropertyId');



        FieldChoice:=UPCASE(READKEY);
        CASE FieldChoice OF
        '1':AmendKeyTaken(New);
        '2':AmendPropertyID;

        'X':;
        ELSE
        ErrorMessage('Only enter digits 1-2 OR X');
        END;
        UNTIL FieldChoice='X';
        END
        ELSE ErrorMessage('Key Record Not Found');



     END;




   PROCEDURE AddKey;
   VAR I:INTEGER;
       Full,Valid:BOOLEAN;
       NewKeyId:STRING;
       New:BOOLEAN;

         BEGIN
         I:=1;
         WHILE (I<51) AND (Full=TRUE) DO
         IF KeyArray[I].KeyId = '0' THEN Full:=FALSE
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
         WRITELN('Enter KeyId for new Key ');
         WRITELN('(6 digits long)');
         REPEAT

         READLN(NewKeyid);
         ValStrInt(Newkeyid,Valid);
         IF LENGTH(Newkeyid) <> 6 THEN Valid:=FALSE;

         UNTIL Valid=TRUE;
         KeyArray[I].KeyId:=NewKeyId;
         WRITELN('New Key with Key Id ',KeyArray[I].KeyID,' has been created');
         SaveKeyFile;
         READLN;
         AmendKeyTaken(New);
         AmendPropertyId;
         READLN;

         END;

      END;
   END.

