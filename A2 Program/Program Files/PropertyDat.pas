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


    Properties=ARRAY[1..50] OF PropertyInfo;



   VAR PropArray:Properties;
       TempPropArray:Properties;
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

USES CRT, SYSUTILS, Draw, Validate, DateCalc;

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
         END;
              I:=1;



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






   PROCEDURE SavePropFile;
   VAR I,J,K:INTEGER;
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
            SortProps;  {Properties sorted into sequential order}
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

         WRITELN(' LandlordId:                    ',PropArray[Pos].LandLordId);
         WRITELN(' TenantId:                      ',PropArray[Pos].TenantId);
         WRITELN(' TotalKeys:                     ',PropArray[Pos].TotalKeys);
         WRITELN(' KeysTaken:                     ',PropArray[Pos].KeysTaken);
         DRAWBOX(1,3,50,13);
         DRAWBOX(30,3,50,13);

         END;



   PROCEDURE FindPropDetails(VAR Found:BOOLEAN);
   VAR TempProp:STRING;
       Valid:BOOLEAN;

      BEGIN
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
         CLRSCR;
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

         GOTOXY(1,25);
         TEXTBACKGROUND(BLUE);
         WRITE('Record ',Pos,' Of ',Total,'     ',#24,#25,' to select Record      `X` to exit');
         TEXTBACKGROUND(BLACK);

         DisplayPropDetails(Pos);
         Prop:=UPCASE(READKey);
         IF (Prop=#80) AND (Pos<>Total) THEN Pos:=Pos+1; //Down
         IF (Prop=#72) AND (Pos<>1) THEN Pos:=Pos+-1; //up

         CLRSCR;
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
         WRITELN('Enter PropID to Delete');

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
         CLRSCR;
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
         READLN;
         PropArray[arrayvalue].PropertyAvailable:=Available;
         SavePropFile(FALSE);
         CLRSCR;
      END;



   PROCEDURE AmendTotalNumberOfKeys(New:BOOLEAN);
   VAR TempNoOfKeys,Error:LONGINT;
       keyStr:STRING;
       Valid:BOOLEAN;
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
      Valid:=TRUE;
      Val(KeyStr,TempNoOfKeys,Error);
      IF Error<>0 THEN BEGIN
      Valid:=FALSE;
      ErrorMessage('Not a valid integer, only enter 0-9');
      END;
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
      WRITELN('Press Enter to Continue...');
      SavePropFile(FALSE);
      READLN;
      CLRSCR;

      END;


   PROCEDURE AmendKeysTaken(New:BOOLEAN);
   VAR TempkeysTaken,Error:LONGINT;
       StrKeysTaken:STRING;
       Valid:BOOLEAN;
      BEGIN
        CLRSCR;
      IF New=FALSE THEN
      WRITELN('The Amount of keys taken is currently: ',PropArray[ArrayValue].KeysTaken);
      WRITELN('The Total Amount of Keys for the Property is: ',PropArray[ArrayValue].TotalKeys);
      WRITELN('Enter an amount between 0 and ',PropArray[ArrayValue].TotalKeys);
      WRITELN('For the new total amount of keys that have been taken');

      REPEAT
      REPEAT
      Valid:=TRUE;
      READLN(StrKeysTaken);
      Val(StrKeysTaken,TempkeysTaken,Error);
      IF Error<>0 THEN
      BEGIN
      Valid:=FALSE;
      ErrorMessage('Not a valid integer, only enter 0-9');
      END;
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
      WRITELN('Press Enter to continue...');
      SavePropFile(FALSE);
      READLN;
        CLRSCR;
      END;



   PROCEDURE AmendPropertyId(New:BOOLEAN);
   VAR Valid:BOOLEAN;
       NewPropId:STRING;
       I:LONGINT;

      BEGIN
         CLRSCR;
         IF New=FALSE THEN
         WRITELN('Current PropertyId is: ',PropArray[ArrayValue].PropertyId);
         WRITELN('Enter PropId for new Prop ');
         WRITELN('(6 characters long)');
         PropArray[ArrayValue].PropertyId:='x';
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
         NewPropId:=UPPERCASE(NewPropId);
         FOR I:=1 TO 50 DO
         IF NewPropId=PropArray[I].PropertyId THEN
            BEGIN
            ErrorMessage('Current Property Id already exists');
            Valid:=FALSE;
            END;
         UNTIL Valid=TRUE;

         PropArray[ArrayValue].PropertyId:=NewPropId;
         WRITELN('PropertyId is now ',NewPropId);
         WRITELN('Press Enter to continue...');
         READLN;
           CLRSCR;
         END;


   PROCEDURE AmendTenantId(New:BOOLEAN);
   VAR Valid:BOOLEAN;
       TempId:STRING;
       I:LONGINT;
      BEGIN
           CLRSCR;
         IF New=FALSE THEN
         WRITELN('Current TenantId is: ',PropArray[ArrayValue].TenantId);
         WRITELN('Enter new TenantId');
         WRITELN('(6 characters long)');
         PropArray[ArrayValue].TenantId:='x';
         REPEAT
         REPEAT
         REPEAT
         READLN(Tempid);
         TempId:=UPPERCASE(Tempid);
         ValStrLetNum(Tempid,Valid);
         UNTIL Valid=TRUE;

         IF LENGTH(Tempid) <> 6 THEN
           BEGIN
           ErrorMessage('Must be 6 characters long');
           Valid:=FALSE;
           END;
         UNTIL Valid=TRUE;
            FOR I:=1 TO 50 DO
         IF TempId=PropArray[I].TenantId THEN
            BEGIN
            ErrorMessage('Current Tenant Id already exists on a property');
            Valid:=FALSE;
            END;
         UNTIL Valid=TRUE;
         PropArray[ArrayValue].TenantId:=TempId;
         WRITELN('TenantId is now ',TempId);
         WRITELN('Press Enter to continue...');
         READLN;
         CLRSCR;
         END;

   PROCEDURE AmendLandlordId(New:BOOLEAN);
    VAR Valid:BOOLEAN;
        TempId:STRING;
      BEGIN
           CLRSCR;
         IF New=FALSE THEN
         WRITELN('Current LandlordId is: ',PropArray[ArrayValue].LandlordId);
         WRITELN('Enter new LandlordId');
         WRITELN('(6 characters long)');
         REPEAT
         REPEAT
         REPEAT
         READLN(Tempid);
         Tempid:=UPPERCASE(Tempid);
         ValStrLetNum(Tempid,Valid);
         UNTIL Valid=TRUE;

         IF LENGTH(Tempid) <> 6 THEN
           BEGIN
           ErrorMessage('Must be 6 characters long');
           Valid:=FALSE;
           END;
         UNTIL Valid=TRUE;

         UNTIL Valid=TRUE;
         PropArray[ArrayValue].LandlordId:=TempId;
         WRITELN('LandlordId is now ',TempId);
         WRITELN('Press Enter to continue...');
         READLN;
           CLRSCR;
         END;




   PROCEDURE DrawAmendPropMenu(CurrentChoice:INTEGER);
      VAR I:INTEGER;

      BEGIN

          BEGIN

         TEXTCOLOR(LIGHTCYAN);
         TEXTBACKGROUND(BLUE);
         FILLBOX(20,1,60,5);   {Fills specified background with colour}

         DRAWBOX(20,1,60,4);   {Draws a box (startingX,StartingY,EndingX,EndingY)}
         DRAWBOX(20,7,60,19);


                              {Setting x co-ordinates as the same}
                              {creates a horizontal line}
         DRAWBOX(20,9,60,9);  {used to create sections for options}
         DRAWBOX(20,11,60,11);
         DRAWBOX(20,13,60,13);
         DRAWBOX(20,15,60,15);
         DRAWBOX(20,17,60,17);



         FOR I:=1 TO 5 DO
         BEGIN

            GOTOXY(20,7+(2*I));  {replaces points of lines joining}
            WRITE(#195);         {#195 for + left points}
            GOTOXY(60,7+(2*I));
            WRITE(#180);         {#180 for Ý right points}

         END;


         TEXTCOLOR(WHITE);
         GOTOXY(28,2);
         WRITE('Amend Property '); TEXTCOLOR(GREEN);
         WRITELN(PropArray[ArrayValue].PropertyId);
         TEXTCOLOR(WHITE);
         GOTOXY(28,3);
         WRITELN('   Select Option To Amend');

         GOTOXY(21,8);
         IF CurrentChoice=1 THEN                        {Test if the option is selected}
         ChoiceSelected(TRUE)                        {Write location of menu names}
         ELSE ChoiceSelected(FALSE);
         WRITELN('                Property Id            ');



         GOTOXY(21,10);
         IF CurrentChoice=2 THEN
         ChoiceSelected(TRUE)
          ELSE ChoiceSelected(FALSE);

         WRITELN('               Property Available      ');



         GOTOXY(21,12);
         IF CurrentChoice=3 THEN
         ChoiceSelected(TRUE)
          ELSE ChoiceSelected(FALSE);

         WRITELN('                Total Keys             ');

         GOTOXY(21,14);
         IF CurrentChoice=4 THEN
          ChoiceSelected(TRUE)
          ELSE ChoiceSelected(FALSE);

         WRITELN('                Keys Taken             ');


         GOTOXY(21,16);
           IF CurrentChoice=5 THEN
           ChoiceSelected(TRUE)
           ELSE ChoiceSelected(FALSE);

         WRITELN('                Tenant Id              ');

         GOTOXY(21,18);
           IF CurrentChoice=6 THEN
           ChoiceSelected(TRUE)
           ELSE ChoiceSelected(FALSE);

         WRITELN('                Landlord Id            ');









         TEXTBACKGROUND(BLUE);
         GOTOXY(1,25);
         TEXTCOLOR(WHITE);
         GOTOXY(2,25);
         WRITE(' '#24''#25' To select option');
         WRITE('         Press "X" Key To Exit    ');
         WRITE('                        ');
         TEXTBACKGROUND(BLACK);



          END;
      END;


   PROCEDURE AmendProp;
      VAR ChoiceCount:INTEGER;
       Press:CHAR;
       Valid,Found:BOOLEAN;
       TempId:STRING;
       New:BOOLEAN;
      BEGIN
         New:=FALSE;
         CLRSCR;
         arrayvalue:=1;
         WRITELN('Enter Property Id To Amend');
         REPEAT
         REPEAT
         READLN(TempId);
         ValStrLetNum(TempId,Valid);

         UNTIL Valid=TRUE;
         IF LENGTH(TempId)<>6 THEN BEGIN
         ErrorMessage('Must be 6 characters long');
         Valid:=FALSE;
         END;
         UNTIL Valid=TRUE;
         TempId:=UPPERCASE(TempId);

         FindProp(TempId,FOUND);
         IF Found=TRUE THEN

         BEGIN
         CLRSCR;

         ChoiceCount:=1;


         REPEAT
            DrawAmendPropMenu(ChoiceCount);
            Press:=UPCASE(READKEY); {same key pressed is assigned to 'Press'}
            CASE Press OF

            #80:BEGIN           {Down Arrow}


                   IF ChoiceCount <6 THEN
                    ChoiceCount:=ChoiceCount+1 ELSE ChoiceCount:=1;


                                {If option highlighted is the last and down is pressed}
                      {return to the first option}



                END;

         #72:BEGIN                   {Up Arrow}


                IF ChoiceCount >1 THEN
                ChoiceCount:=ChoiceCount-1
                ELSE
                             {If option highlighted is the first and up is pressed}
                ChoiceCount:=6
                   {return to the last option}



             END;

         #13:;  {enter key, will select a function or new menu}

         'X':;  {to exit the current menu or program}

         END;





        IF (Press=#13)  THEN      {If On MainMenu}
         CASE ChoiceCount OF                     {and enter has been pressed}
        1:AmendPropertyId(New);
        2:AmendPropTaken(New);
        3:AmendTotalNumberOfKeys(New);
        4:AmendKeysTaken(New);
        5:AmendTenantId(New);
        6:AmendLandLordId(New);

         END;









         UNTIL (Press='X')      {If on Main Menu when X is pressed exits program}


      END ELSE    ErrorMessage('Property Record Not Found');
    END;







   PROCEDURE AddProp;
   VAR I:INTEGER;
       Full,Valid:BOOLEAN;
       NewPropId:STRING;
       New:BOOLEAN;

         BEGIN
         I:=1;
         Full:=TRUE;
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
         ArrayValue:=I;
         New:=TRUE;
         AmendPropertyId(New);
         AmendTotalNumberOfKeys(New);
         AmendPropTaken(New);
         AmendTenantId(New);
         AmendLandlordId(New);

         SavePropFile(FALSE);
         READLN;

         END;

      END;
   END.


END.
