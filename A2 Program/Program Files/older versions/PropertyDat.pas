UNIT PROPERTYDAT;

INTERFACE

TYPE

     PropertyInfo=RECORD

        PropertyId:STRING[6];
        TotalKeys:INTEGER;
        KeysTaken:INTEGER;
        PropertyAvailable:BOOLEAN;
        LandLordId:STRING[6];
        TenantId:STRING;
     END;


    PropA=ARRAY[1..50] OF PropertyInfo;



   VAR PropArray:PropA;
       TempPropArray:PropA;
       TempPropRec:PropertyInfo;
       Prop:PropertyInfo;
       PropFile:FILE OF PropertyInfo;
       GlobalDriveLetter:CHAR;
       ArrayValue:INTEGER;

       BackupProp:FILE OF PropertyInfo;



PROCEDURE ResetProp;

PROCEDURE LoadProp(VAR Found:BOOLEAN; DriveLetter:CHAR);

PROCEDURE LoadBackupProp(VAR Found:BOOLEAN);

PROCEDURE FindProp(PropertyID:STRING; VAR Found:BOOLEAN);

PROCEDURE AddProp;

PROCEDURE AmendProp;

PROCEDURE DisplayAllProp;

PROCEDURE DisplaySearchProp;

PROCEDURE DeleteProp;

PROCEDURE SavePropFile(Backup:BOOLEAN);

IMPLEMENTATION

USES CRT, SYSUTILS, Draw, Validate, DateCalc, TenantDat;

   PROCEDURE ResetProp;
   VAR I,J:INTEGER;

      BEGIN

         FOR I:= 1 TO 50 DO

            BEGIN
            PropArray[I].PropertyId:='0';
            TempPropArray[I].PropertyId:='0';

            END;

      END;


    PROCEDURE LoadData(I:LONGINT);

       BEGIN
        WITH Prop DO BEGIN
                      PropArray[I].PropertyId:=PropertyId;
                      PropArray[I].PropertyAvailable:=PropertyAvailable;
                      PropArray[I].TotalKeys:=TotalKeys;
                      PropArray[I].LandLordId:=LandLordId;
                      PropArray[I].TenantId:=TenantId
                      END;
       END;


    PROCEDURE LoadProp(VAR Found:BOOLEAN;DriveLetter:CHAR);
    VAR I,J:INTEGER;
        Path:STRING;


      BEGIN
         GlobalDriveLetter:=DriveLetter;

           BEGIN
           Path:=':\MainProgram\Files\PropData.DTA';

           END;
           ASSIGN(PropFile,GlobalDriveLetter+Path);
           {Finds the file to be read from}


         IF NOT FILEEXISTS(GlobalDriveLetter+Path) THEN  {if file not found}
         Found:=FALSE

         ELSE

         BEGIN
         Found:=TRUE;

         RESET(PropFile);
         ResetProp;

            BEGIN
              I:=1;

               WITH Prop DO
               WHILE (NOT EOF(PropFile)) AND (PropertyID<>'0')  DO

                  BEGIN
                      READ(PropFile,Prop);
                      LoadData(I);
                      I:=I+1;
                  END;

         END

        END;
      END;


   PROCEDURE LoadBackupProp(VAR Found:BOOLEAN); {Puts data from file into the array}
   VAR
      I:INTEGER;
      FilePath:STRING;
      DriveLetter:CHAR;

      BEGIN
         FOUND:=FALSE;
         DriveLetter:='A';

         REPEAT
         FilePath:=DriveLetter+':\MainProgram\Backup\PropData.BCK'; {Finds the file to be read from}


         IF FILEEXISTS(FilePath) THEN Found:=TRUE  ELSE

                               {if file not found}
         DriveLetter:=CHR(ORD(DriveLetter)+1); //increment the drive, e.g. driveletter of 'A' becomes 'B'

        UNTIL (Found) OR (DriveLetter=CHR(ORD('Z')+1)); //Letter of drive passes 'Z'

        IF Found THEN

        BEGIN

         ASSIGN(BackupProp,FilePath);
         RESET(BackupProp);

         IF FILESIZE(BackupProp)=0 THEN WRITELN ('No Data in Backup Property File')
         ELSE BEGIN




         ASSIGN(PropFile,DriveLetter+':\MainProgram\Files\PropData.DTA');
     //    IF FILEEXISTS(DriveLetter+':\MainProgram\Files\PropData.DTA') THEN
    //     BEGIN
   //      RESET(PropFile);

   //      ResetProp;  //Sets all records in the array with a rogue value
                       //Marking them for deletion

   //      SavePropFile(FALSE);   //All current property records (if any) are wiped
                       //since they are all marked for deletion
   //      END;
              I:=1;


                WRITELN('test2');
                WITH Prop DO
               BEGIN
               REWRITE(PropFile);
               RESET(PropFile);

               WHILE (NOT EOF(BackupProp)) AND (PropertyID<>'0')  DO

                  BEGIN
                      READ(BackupProp,Prop);
                      LoadData(I);
                      WRITE(PropFile,Prop);
                      I:=I+1;
                  END;
                  CLOSE(BackupProp);

        END;
    END;
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
             TempPropArray[I].PropertyId:=PropArray[J].PropertyID;   {so any Properties deleted are just not saved into the file}
             TempPropArray[I].PropertyAvailable:=PropArray[J].PropertyAvailable;
             TempPropArray[I].TotalKeys:=PropArray[J].TotalKeys;
             TempPropArray[I].KeysTaken:=PropArray[J].KeysTaken;
             TempPropArray[I].LandLordId:=PropArray[J].LandLordId;
             TempPropArray[I].TenantId:=PropArray[J].TenantId; {when it is rewritten}
             I:=I+1;                                           {'I' will count as the total amount of}
           END;                                                {subscripts that are 'valid' within the array}
           J:=J+1;
       END;
       I:=I-1;
       IF Backup=TRUE THEN
       BEGIN
       ASSIGN(BackupProp,GlobalDriveletter+':\MainProgram\Backup\PropData.BCK');
       REWRITE(BackupProp);
       RESET(BackupProp);
       END ELSE
       BEGIN
       REWRITE(PropFile);  {Rewrites the valid records}
       RESET(PropFile);
       END;
       FOR K:=1 TO I DO  {For total amount of valid subscripts}
       WITH Prop DO
       BEGIN
       PropertyId:=TempPropArray[K].PropertyId;
       PropertyAvailable:=TempPropArray[K].PropertyAvailable;
       TotalKeys:=TempPropArray[K].TotalKeys;
       KeysTaken:=TempPropArray[K].KeysTaken;
       LandLordId:=TempPropArray[K].LandLordId;
       TenantId:=TempPropArray[K].TenantId;
       IF Backup=TRUE THEN
       WRITE(BackupProp,Prop) ELSE
       WRITE(PropFile,Prop);
       END;
       IF Backup=FALSE THEN
       BEGIN
       Close(PropFile);
       FOUND:=TRUE;
       LoadProp(FOUND,GlobalDriveLetter); {loads the file back into the PropArray}
       END ELSE
       Close(BackupProp);
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
         CLRSCR;
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
         WRITE(' HouseId:                       '); WRITELN(PropArray[Pos].PropertyId);
         WRITELN(' LandlordId:                  ',PropArray[Pos].LandLordId);

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
         REPEAT
         READLN(TempProp);
         ValStrLetNum(TempProp,Valid);
         UNTIL Valid=TRUE;
         IF LENGTH(TempProp) <>6 THEN
            BEGIN
            ErrorMessage('Must be 6 characters in Length');
            Valid:=FALSE;
            END;
         UNTIL Valid=TRUE;
         TempProp:=UPPERCASE(TempProp);
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
         REPEAT
         READLN(TempProp);
         ValStrLetNum(TempProp,Valid);

         UNTIL Valid=TRUE;
            IF LENGTH(TempProp)<>6 THEN
               BEGIN
               ErrorMessage('Must be 6 characters in length');
               Valid:=FALSE;
               END;
         UNTIL Valid=TRUE;
         TempProp:=UPPERCASE(TempProp);
         FindProp(TempProp,FOUND);


         IF Found=TRUE THEN

         BEGIN

            WRITELN('Prop found, would you like to delete? Y/N');
            ValidateYN(ConfirmDelete);

            IF ConfirmDelete='Y' THEN

            BEGIN

               PropArray[arrayvalue].PropertyId:='0'; {sets the CustId of the record to an invalid record}



            SavePropFile(FALSE);
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
         SavePropFile(FALSE);

      END;



   PROCEDURE AmendTotalNumberOfKeys(New:BOOLEAN);
   VAR TempNoOfKeys,Error:LONGINT;
       Valid:BOOLEAN;
       keyStr:STRING;
      BEGIN
      Valid:=FALSE;
      CLRSCR;
      WRITELN('Enter New Total Number Of Keys (1-10)');
      IF New=FALSE THEN
      WRITELN('(',PropArray[ArrayValue].KeysTaken,' keys have not been returned, you cannot enter a value lower than that)');
      REPEAT
      REPEAT
      REPEAT
      READLN(KeyStr);
      ValidateInt(KeyStr,Valid,TempNoOfKeys);
      UNTIL Valid=TRUE;
      IF (TempNoOfKeys<1) OR (TempNoOfKeys>10) THEN
      BEGIN
      Errormessage('Only Enter a number between 1 and 10');
      Valid:=FALSE;
      END;
      UNTIL Valid=TRUE;
      IF (TempNoOfKeys<PropArray[ArrayValue].KeysTaken) THEN
      BEGIN
      Errormessage('You cannot have a total value of keys less than the number taken');
      Valid:=FALSE;
      END;
      UNTIL Valid=TRUE;

      PropArray[ArrayValue].TotalKeys:=TempNoOfKeys;
      WRITELN;
      WRITELN('The total number of keys has been changed to: ',TempNoOfKeys);
      WRITELN('Press Enter to return to the previous menu');
      SavePropFile(FALSE);
      READLN;

      END;

   PROCEDURE AmendKeysTaken;
   VAR TempkeysTaken:LONGINT;
       StrKeysTaken:STRING;
       Valid:BOOLEAN;
      BEGIN

      WRITELN('The Amount of keys taken is currently: ',PropArray[ArrayValue].KeysTaken);
      WRITELN('The Total Amount of Keys for the Property is: ',PropArray[ArrayValue].TotalKeys);
      WRITELN('Enter an amount between 0 and ',PropArray[ArrayValue].TotalKeys);
      WRITELN('For the new total amount of keys that have been taken');

      REPEAT
      REPEAT
      READLN(StrKeysTaken);
      ValidateInt(StrKeysTaken,Valid,TempkeysTaken);
      UNTIL Valid=TRUE;
      IF (TempKeysTaken <0) OR (TempKeysTaken>PropArray[ArrayValue].TotalKeys)
      THEN BEGIN
      ErrorMessage('Not in the range');
      Valid:=FALSE;
      END;
      UNTIL Valid=TRUE;
      PropArray[ArrayValue].KeysTaken:=TempKeysTaken;
      WRITELN;
      WRITELN('The total number of keys taken has been changed to: ',TempKeysTaken);
      WRITELN('Press Enter to return to the previous menu');
      SavePropFile(FALSE);
      READLN;
      END;



   PROCEDURE AmendPropertyId(New:BOOLEAN);
   VAR Valid:BOOLEAN;
       NewPropId:STRING;
      BEGIN

         IF New=FALSE THEN
         WRITELN('Current PropertyId is: ',PropArray[ArrayValue].PropertyId);
         WRITELN('Enter PropId for new Prop ');
         WRITELN('(6 characters long)');
         REPEAT
         REPEAT
         REPEAT
         READLN(NewPropid);
         ValStrLetNum(NewPropid,Valid);
         UNTIL Valid=TRUE;

         IF LENGTH(NewPropid) <> 6 THEN
           BEGIN
           ErrorMessage('Must be 6 characters long');
           Valid:=FALSE;
           END;
         UNTIL Valid=TRUE;

         UNTIL Valid=TRUE;
         PropArray[ArrayValue].PropertyId:=NewPropId;
         WRITELN('PropertyId is now ',NewPropId);
         END;


   PROCEDURE AddTenant(New:BOOLEAN);
     VAR I,J,Pos,MaxPos:LONGINT;
       SearchArray:ARRAY[1..50] OF STRING;
       TempId:STRING;
       Found:BOOLEAN;

   BEGIN

      I:=1;
      Pos:=1;

        WHILE (TenantArray[Pos].TenantId<>'0') AND (Pos<51) DO

         BEGIN

               SearchArray[Pos]:=TenantArray[Pos].TenantId;
               Pos:=Pos+1;      {add 1 to the total number of available Tenants}

            END;


         IF Pos=1 THEN  {If no available Tenants}
         ErrorMessage('No available Tenant') ELSE

         BEGIN

            MaxPos:=Pos-1;
            FOR Pos:=1 TO MaxPos DO
            WRITELN(SearchArray[Pos]);
            WRITELN;
            WRITELN('Enter 1 of the above TenantId`s to add to the Tenant');
            READLN(TempId);
            TempId:=UPPERCASE(TempId);

            Pos:=1;

               WHILE (TempId<>SearchArray[Pos]) AND (Pos<>MaxPos) DO
                  Pos:=Pos+1;

            IF TempId=SearchArray[Pos] THEN Found:=TRUE ELSE
            Found:=FALSE;

            IF Found=TRUE THEN

               BEGIN

               PropArray[ArrayValue].TenantId:=SearchArray[Pos];

               J:=1;
               WHILE SearchArray[Pos] <> TenantArray[J].TenantId DO {Already know the property exists}
               J:=J+1;                                         {so find position}

               TenantArray[J].PropertyId:=PropertyArray[ArrayValue].PropertyId;

               SaveTenantFile(FALSE);
               SavePropFile(FALSE);

               END;

   PROCEDURE AddLandlord(New:BOOLEAN);
    Valid:BOOLEAN;
    TempId;
      BEGIN

         IF New=FALSE THEN
         WRITELN('Current LandlordId is: ',PropArray[ArrayValue].LandlordId);
         WRITELN('Enter new LandlordId');
         WRITELN('(6 characters long)');
         REPEAT
         REPEAT

         READLN(Tempid);
         ValStrLetNum(Tempid,Valid);
         UNTIL Valid=TRUE;

         IF LENGTH(Tempid) <> 6 THEN
           BEGIN
           ErrorMessage('Must be 6 characters long');
           Valid:=FALSE;
           END;
         UNTIL Valid=TRUE;

         UNTIL Valid=TRUE;
         PropArray[I].LandlordId:=TempId;
         WRITELN('LandlordId is now ',TempId);
         END;



   PROCEDURE AmendProp;
   VAR
       TempProp:STRING;
       Found,Valid:BOOLEAN;
       FieldChoice:CHAR;
       Existing:BOOLEAN;

     BEGIN

         Existing:=FALSE;
         CLRSCR;
         arrayvalue:=1;
         WRITELN('Enter Prop Id To Amend');
         REPEAT
         READLN(TempProp);
         ValStrLetNum(TempProp,Valid);

         UNTIL Valid=TRUE;

         FindProp(TempProp,FOUND);
         IF Found=TRUE THEN

         BEGIN

        REPEAT
        CLRSCR;
        WRITELN('Select Field To Amend');
        WRITELN('1: PropTaken');
        WRITELN('2: PropertyId');
        WRITELN('3: KeysTaken');
        WRITELN('4: TotalKeysAvailable');
        WRITELN('5: TenantId');
        WRITELN('6: LandlordId');



        FieldChoice:=UPCASE(READKEY);
        CASE FieldChoice OF
        '1':AmendPropTaken(Existing);
        '2':;
        '3':AmendKeysTaken(Existing);
        '4':AmendTotalNumberOfKeys(Existing);

        'X':;
        ELSE
        ErrorMessage('Only enter digits 1-4 OR X');
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
         ArrayValue:=I-1
         New:=TRUE;
         AmendPropertyId(New);
         AmendTotalNoOfKeys(New);
         AmendPropTaken(New);

         SavePropFile(FALSE);
         READLN;

         END;

      END;
   END.


END.
