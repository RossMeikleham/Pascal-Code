UNIT LANDLORDDAT;

INTERFACE

PROCEDURE ResetlandLord;

PROCEDURE LoadLandLordFile(VAR FOUND:BOOLEAN; DriveLetter:CHAR);

PROCEDURE LoadBackupLord(VAR Found:BOOLEAN);

PROCEDURE DeleteLandLord;

PROCEDURE AddLandLord;

PROCEDURE AmendLandLord;

PROCEDURE DisplayAllLandLord;

PROCEDURE DisplaySearchLandLord;

PROCEDURE SaveLandLordFile(Backup:BOOLEAN);

TYPE

           PropertyIDArray=ARRAY[1..10] OF STRING;


           LandLordInfo=Record
                           LandLordId      :STRING;
                           Surname     :STRING;
                           Forename    :STRING;
                           Gender      :CHAR;
                           DayOfBirth  :INTEGER;
                           MonthOfBirth:INTEGER;
                           YearOfBirth :INTEGER;
                           HouseNum    :STRING;
                           Street      :STRING;
                           City        :STRING;
                           PhoneNum    :STRING;
                           Postcode    :STRING;
                           Properties   :PropertyIdArray;


                     END;

           LandLord=ARRAY[1..50] OF LandLordInfo;


VAR
   LandLordArray:LandLord;
   TempLordArray:LandLord;
   LandLordFile :FILE OF LandLordInfo;
   BackupLord: FILE OF LandLordInfo;
   Lan:LandLordInfo;
   ArrayValue:INTEGER;
   GlobalDriveLetter:CHAR;

IMPLEMENTATION

 USES CRT,SYSUTILS,Draw,Validate,Datecalc,TenantDat,PropertyDat;



   PROCEDURE ResetLandLord;
   VAR
      I,J:INTEGER;
      BEGIN
         I:=0;
         FOR I:=1 TO 50 DO
         BEGIN                    {Sets all the LandLord ID's to 0,}
         LandLordArray[I].LandLordId:='0';{so all the 'marked for deletion' or empty arrays have a LandLord Id of 0}
         TempLordArray[I].LandLordId:='0';{after the file has been read in}
         FOR J:=1 TO 10 DO
         LandLordArray[I].Properties[J]:='0';
         TempLordArray[I].Properties[J]:='0';
         END;

      END;



   PROCEDURE LoadData(I:LONGINT);
     VAR J:LONGINT;
      BEGIN
                  WITH Lan DO
                  BEGIN
                      LandlordId:=UPPERCASE(LandlordId);
                      LandLordArray[I].LandLordID:=LandLordId;
                      LandLordArray[I].Surname:=Surname;
                      LandLordArray[I].Forename:=Forename;
                      LandLordArray[I].Gender:=Gender;
                      LandLordArray[I].DayOfBirth:=DayOfBirth;
                      LandLordArray[I].MonthOfBirth:=MonthOfBirth;
                      LandLordArray[I].YearOfBirth:=YearOfBirth;
                      LandLordArray[I].HouseNum:=HouseNum;
                      LandLordArray[I].Street:=Street;
                      LandLordArray[I].City:=City;
                      LandLordArray[I].PhoneNum:=PhoneNum;
                      LandLordArray[I].Postcode:=Postcode;
                      J:=1;
                      WHILE (J<11) AND (Properties[J]<>'') DO
                      BEGIN
                      LandLordArray[I].Properties[J]:=Properties[J];
                      J:=J+1
                      END;
                      END;
      END;


   PROCEDURE LoadLandLordFile(VAR Found:BOOLEAN; DriveLetter:CHAR); {Puts data from file into the array}
   VAR
      I,J:INTEGER;
      FilePath:STRING;
      BEGIN

         GlobalDriveLetter:=DriveLetter;



           FilePath:=':\MainProgram\Files\LandLordDet.DTA';







           {Finds the file to be read from}
         ASSIGN(LandLordFile,GlobalDriveLetter+FilePath);
         IF NOT FILEEXISTS(GlobalDriveLetter+FilePath)   {if file not found}
         THEN

         Found:=FALSE

         ELSE

         BEGIN

         RESET(LandLordFile);

         Found:= TRUE;


         ResetLandLord;

         BEGIN
              I:=1;

               WITH Lan DO
               WHILE (NOT EOF(LandLordFile)) AND (LandLordID<>'0')  DO

                  BEGIN
                      READ(LandLordFile,Lan);
                      LoadData(I);
                      I:=I+1;
                  END;


         END

        END;
      END;



   PROCEDURE LoadBackupLord(VAR Found:BOOLEAN); {Puts data from file into the array}
   VAR
      I:INTEGER;
      FilePath:STRING;
      DriveLetter:CHAR;

      BEGIN
         FOUND:=FALSE;
         DriveLetter:='A';

         REPEAT
         FilePath:=DriveLetter+':\MainProgram\Backup\LandlordDet.BCK'; {Finds the file to be read from}


         IF FILEEXISTS(FilePath) THEN Found:=TRUE  ELSE

                               {if file not found}
         DriveLetter:=CHR(ORD(DriveLetter)+1); //increment the drive, e.g. driveletter of 'A' becomes 'B'

        UNTIL (Found) OR (DriveLetter=CHR(ORD('Z')+1)); //Letter of drive passes 'Z'

        IF Found THEN

        BEGIN

         ASSIGN(BackupLord,FilePath);
         RESET(BackupLord);

         IF FILESIZE(BackupLord)=0 THEN WRITELN ('No Data in Backup Lord File')
         ELSE BEGIN



         ASSIGN(LandLordFile,DriveLetter+':\MainProgram\Files\LandlordDet.DTA');

         ResetLandLord;


              I:=1;

               WITH Lan DO

               BEGIN
               REWRITE(LandLordFile);
               RESET(LandLordFile);

               WHILE (NOT EOF(BackupLord)) AND (LandlordID<>'0')  DO

                  BEGIN
                      READ(BackupLord,Lan);
                      LoadData(I);
                      WRITE(LandLordFile,Lan);
                      I:=I+1;
                  END;
                  CLOSE(BackupLord);

        END;
    END;
      END;
   END;





   PROCEDURE SaveLandLordFile;
   VAR I,J,K,L:INTEGER;
       FOUND:BOOLEAN;
       FileName:STRING;
      BEGIN

         I:=1;
         J:=1;
         L:=1;
         WHILE J<51 DO
         BEGIN
            IF LandLordArray[J].LandLordID <> '0' THEN
            WITH Lan DO                                {If LandLordId is rogue value of 0}
            BEGIN                                        {then it is not added to the temp array}
             TempLordArray[I].LandLordId:=LandLordArray[J].LandLordID;   {so any LandLords deleted are just not saved into the file}
             TempLordArray[I].Surname:=LandLordArray[J].Surname; {when it is rewritten}
             TempLordArray[I].Forename:=LandLordArray[J].Forename;  {'I' will count as the total amount of}
             TempLordArray[I].Gender:=LandLordArray[J].Gender;      {subscripts that are 'valid' within the array}
             TempLordArray[I].DayOfBirth:=LandLordArray[J].DayOfBirth;
             TempLordArray[I].MonthOfBirth:=LandLordArray[J].MonthOfBirth;
             TempLordArray[I].YearOfBirth:=LandLordArray[J].YearOfBirth;
             TempLordArray[I].HouseNum:=LandLordArray[J].HouseNum;
             TempLordArray[I].Street:=LandLordArray[J].Street;
             TempLordArray[I].City:=LandLordArray[J].City;
             TempLordArray[I].PhoneNum:=LandLordArray[J].Phonenum;
             TempLordArray[I].Postcode:=LandLordArray[J].Postcode;
             WHILE (LandLordArray[J].Properties[L]<> '0') AND (L<11) DO
             BEGIN
             TempLordArray[I].Properties[L]:=LandLordArray[J].Properties[L];
             L:=L+1;
             END;
             I:=I+1;
           END;
           J:=J+1;
           L:=1;
       END;
       I:=I-1;

       IF Backup=TRUE THEN
       BEGIN
       ASSIGN(BackupLord,GlobalDriveLetter+':\MainProgram\Backup\LandLordDet.BCK');
       REWRITE(BackupLord);
       RESET(BackupLord);
       END ELSE

       BEGIN
       REWRITE(LandLordFile);  {Rewrites the valid records}
       RESET(LandLordFile);
       END;

       FOR K:=1 TO I DO  {For total amount of valid subscripts}
       WITH Lan DO
       BEGIN
       LandLordId:=TempLordArray[K].LandLordID;
       Surname:=TempLordArray[K].Surname;
       Forename:=TempLordArray[K].Forename;
       Gender:=TempLordArray[K].Gender;
       DayOfBirth:=TempLordArray[K].DayOfBirth;
       MonthOfBirth:=TempLordArray[K].MonthOfBirth;
       YearOfBirth:=TempLordArray[K].YearOfBirth;
       HouseNum:=TempLordArray[K].HouseNum;
       Street:=TempLordArray[K].Street;
       City:=TempLordArray[K].City;
       PhoneNum:=TempLordArray[K].Phonenum;
       Postcode:=TempLordArray[K].Postcode;
       J:=1;
       WHILE (TempLordArray[K].Properties[J] <>'0') AND (J<11) DO
       BEGIN
       Properties[J]:=TempLordArray[K].Properties[J];
       J:=J+1;
       END;
       IF Backup= TRUE THEN
       WRITE(BackupLord,Lan) ELSE
       WRITE(LandLordFile,Lan);
       L:=1;
       END;
       IF Backup=FALSE THEN
       BEGIN
       Close(LandLordFile);
       FOUND:=TRUE;
       LoadLandLordFile(FOUND,GlobalDriveLetter); {loads the file back into the LandLordArray}
       END ELSE
       Close(BackupLord);
     END;




   PROCEDURE SortLandLords; {Bubble sort's LandLords by LandLord id}

   VAR Pos,Finish:INTEGER;  {sorts from largest to smallest as invalid or empty records contain an ID of "0"}
       Swapped:BOOLEAN;     {and if done smallest to largest will send all the valid data to the back}
       TempRec:LandLordInfo;

      BEGIN

         Finish:=49;

         REPEAT

            Swapped:=FALSE;
            FOR Pos:=1 TO Finish DO

               BEGIN

                  IF LandLordArray[Pos].LandLordId < LandLordArray[Pos+1].LandLordId THEN

                     BEGIN //Swap

                        TempRec:=LandLordArray[Pos]; {Assigns temporary record}
                        LandLordArray[Pos]:=LandLordArray[Pos+1];
                        LandLordArray[Pos+1]:=TempRec;
                        Swapped:=TRUE;

                     END;

               END;

            Finish:=Finish-1;

         UNTIL (NOT Swapped) OR (Finish=0);

      END;



   PROCEDURE FindLandLord(LandLordID:STRING; VAR Found:BOOLEAN);
   VAR I,Start,Finish:INTEGER;
       TempStart,TempFinish:INTEGER;
       NoChange:BOOLEAN;
       Value:INTEGER;
      BEGIN

         RESET(LandLordFile);
         Start:=0;
         Finish:=50;
         IF FILESIZE(LandLordFile) <>0 THEN

         BEGIN
            NoChange:=FALSE;
            SortLandLords;  {landlords sorted into sequential order}
            Found:=FALSE;
            arrayvalue:=0;
            WHILE (NoChange=FALSE) AND (Found=FALSE) DO {Binary Search}
            BEGIN

            arrayvalue:=ROUND((Start+Finish)/2);

            TempStart:=Start;
            TempFinish:= Finish;

            IF LandLordArray[arrayvalue].LandLordId < LandLordId  THEN
            Finish:=arrayvalue;

            IF LandLordArray[arrayvalue].LandLordId > LandLordId  THEN
            Start:=arrayvalue;

            IF LandLordID=LandLordArray[arrayvalue].LandLordID THEN
            Found:=TRUE;

            IF (TempStart=Start) AND (TempFinish=Finish) THEN
            NoChange:=TRUE;
            END;

         END;
        END;



   PROCEDURE FindLandLordDetails(VAR Found:BOOLEAN);
   VAR TempLordId:STRING;
       Valid:BOOLEAN;

      BEGIN
         CLRSCR;
         WRITELN('Enter the LandLordID to search for (6 characters in length): ');
         REPEAT
         REPEAT
         READLN(TempLordId);
         ValStrLetNum(TempLordId,Valid);
         UNTIL Valid=TRUE;
         TempLordId:=UPPERCASE(TempLordId);
         IF LEngth(TempLordId) <>6 THEN
         BEGIN
         ErrorMessage('Not 6 characters in length');
         Valid:=FALSE;
         END;

         UNTIL Valid=TRUE;


         FINDLandLord(TempLordId,Found);

         IF Found=FALSE THEN
         ErrorMessage('Not Found');

      END;


   PROCEDURE DisplayLandLordDetails(Pos:LONGINT);
   VAR I:INTEGER;
         BEGIN
         DRAWBOX(18,1,42,3);
         GOTOXY(20,2);
         WRITE('LandLordId: '); WRITELN(LandLordArray[Pos].LandLordID);
         GOTOXY(1,5);
         WRITE(' Name:                    '); WRITE(LandLordArray[Pos].Forename,' '); WRITELN(LandLordArray[Pos].Surname);
         WRITELN;
         WRITE(' Gender:                  '); WRITELN(LandLordArray[Pos].Gender);
         WRITELN;
         WRITE(' Date Of Birth:           '); WRITE(LandLordArray[Pos].DayOfBirth,'/');
         WRITE(LandLordArray[Pos].MonthOfBirth,'/'); WRITELN(LandLordArray[Pos].YearOfBirth);
         WRITELN;
         WRITE(' Address:                 '); WRITE(LandLordArray[Pos].HouseNum,' ');   WRITELN(LandLordArray[Pos].Street);
         WRITELN;
         WRITE('                          ',LandLordArray[Pos].City,' '); WRITELN(LandLordArray[Pos].PostCode);
         WRITELN;
         WRITE(' PhoneNo:                 '); WRITELN(LandLordArray[Pos].PhoneNum);
         WRITELN;
         WRITE(' Properties: ');
         I:=1;
         WHILE (LandLordArray[Pos].Properties[I]<>'0') AND(I<11) DO
         BEGIN WRITE(LandLordArray[Pos].Properties[I],' ');
         I:=I+1;
         END;

         FOR I :=6 TO 20 DO
         BEGIN
         DRAWBOX(1,4,60,I);
         I:=I+1;
         END;

         END;



   PROCEDURE DisplaySearchLandLord;
   VAR Found:BOOLEAN;
       Pos:LONGINT;

      BEGIN

      FindLandLordDetails(Found);
      Pos:=ArrayValue;
      CLRSCR;
      IF Found=TRUE THEN
      DisplayLandLordDetails(Pos);
      READLN;

      END;


   PROCEDURE DisplayAllLandLord;
   VAR TempLandLordId:INTEGER;
       Total,Pos,I:INTEGER;
       Key:CHAR;

      BEGIN

         Total:=1;
         Pos:=1;
         WHILE (LandLordArray[Total].LandLordId <> '0') DO
         Total:=Total+1;

         Total:=Total-1;
         IF Total<>0 THEN
         REPEAT
         TEXTBACKGROUND(BLUE);
         GOTOXY(1,25);
         FOR I:=1 TO 79 DO WRITE(' ');
         GOTOXY(1,25);
         WRITE('Record ',Pos,' Of ',Total,'     ',#24,#25,' to select Record      `X` to exit');
         TEXTBACKGROUND(BLACK);

         DisplayLandLordDetails(Pos);
         REPEAT
         Key:=UPCASE(READKEY);
         IF (Key=#80) AND (Pos<>Total) THEN Pos:=Pos+1; //Down
         IF (Key=#72) AND (Pos<>1) THEN Pos:=Pos+-1; //up
         UNTIL (Key=#80) OR (Key=#72) OR (Key='X');
         CLRSCR;
         UNTIL Key='X'
         ELSE
         Errormessage('No records in the file');


      END;



   PROCEDURE DeleteLandLord;
    VAR Found,Valid:BOOLEAN;
        Value:INTEGER;
        ConfirmDelete:CHAR;
        TempLordID:STRING;

      BEGIN

         CLRSCR;
         arrayvalue:=1;
         WRITELN('Enter LandLordID to Delete');

         REPEAT
         REPEAT
         READLN(TempLordId);
         ValStrLetNum(TempLordId,Valid);
         UNTIL Valid=TRUE;
               IF LENGTH(TempLordId)<>6 THEN
                  BEGIN
                  ErrorMessage('Must be 6 characters in Length');
                  Valid:=FALSE;
                  END;
         UNTIL Valid=TRUE;
         TempLordId:=UPPERCASE(TempLordId);
         FindLandLord(TempLordId,FOUND);


         IF Found=TRUE THEN

         BEGIN

            WRITELN('LandLord found, would you like to delete? Y/N');
            ValidateYN(ConfirmDelete);

            IF ConfirmDelete='Y' THEN

            BEGIN

               LandLordArray[arrayvalue].LandLordId:='0'; {sets the LandLordId of the record to an invalid record}



            SaveLandLordFile(FALSE);
            WRITELN('Deleted');
            READLN;

         END ELSE

         BEGIN

            WRITELN('Not Deleted');
            READLN;

         END;

        END ELSE

        ErrorMessage('LandLord Not Found');


    END;


   PROCEDURE AmendLandlordId(New:BOOLEAN);
     VAR Valid:BOOLEAN;
         NewLordId:STRING;
      BEGIN
           CLRSCR;
         IF New=FALSE THEN
         WRITELN('Current LandlordId is: ',LandlordArray[ArrayValue].LandlordId);
         WRITELN('Enter new LandlordId');
         WRITELN('(6 characters long)');
         REPEAT
         REPEAT
         REPEAT
         READLN(NewLordID);
         ValStrLetNum(NewLordID,Valid);
         UNTIL Valid=TRUE;

         IF LENGTH(NewLordID) <> 6 THEN
           BEGIN
           ErrorMessage('Must be 6 characters long');
           Valid:=FALSE;
           END;
         UNTIL Valid=TRUE;

         UNTIL Valid=TRUE;
         NewLordId:=UPPERCASE(NewLordID);
         LandLordArray[ArrayValue].LandlordId:=NewLordID;
         WRITELN('LandlordId is now ',NewLordID);
         WRITELN('Press Enter to Continue..');
         READLN;
           CLRSCR;
         END;


   PROCEDURE AmendName(FieldName:STRING;New:BOOLEAN);
   VAR TempName:STRING;
       YesNoChoice:CHAR;
       Skip,Valid:BOOLEAN;

      BEGIN
           CLRSCR;
         IF FieldName='surname' THEN

         TempName:=LandLordArray[arrayvalue].Surname

         ELSE TempName:=LandLordArray[arrayvalue].Forename;

         YesNoChoice:='N';

         WRITELN('Enter a new ',FieldName);
         REPEAT

            READLN(Tempname);
            ValStrLetter(TempName,Valid);

        UNTIL Valid=TRUE;
               TempName:=LOWERCASE(TempName);
               TempName[1]:=UPCASE(TempName[1]);
               WRITELN('Is the new ',FieldName,' ',TempName,' correct? Y/N');
               ValidateYN(YesNoChoice);


         IF YesNoChoice='Y' THEN

            BEGIN

               IF FieldName='surname' THEN

               LandLordArray[arrayvalue].Surname:=TempName

               ELSE LandLordArray[arrayvalue].Forename:=TempName;
               WRITELN('Name has been changed');
               WRITELN('Press Enter to Continue..');
               READLN;
               SaveLandLordFile(FALSE);
                CLRSCR;
            END;

      END;



   PROCEDURE AmendGender(New:BOOLEAN);
   VAR TempGen:CHAR;
       Gen:STRING;
       Valid:BOOLEAN;

      BEGIN
          CLRSCR;
         IF LandLordArray[arrayvalue].Gender ='M' THEN
            Gen:='Male' ELSE
            Gen:='Female';

         IF New=FALSE THEN
         WRITELN('The Current Gender is: ',Gen);
         WRITELN;
         WRITELN('Enter New Gender');

         Val2Char('M','F',TempGen);

         IF TempGen='M' THEN
            Gen:='Male' ELSE
            Gen:='Female';

         WRITELN;
         WRITELN('The Gender has been changed to: ',Gen);
         WRITELN('Press Enter to Continue..');

         LandLordArray[arrayvalue].Gender:=TempGen;
         SaveLandLordFile(FALSE);
          CLRSCR;
      END;




   PROCEDURE AmendDOB(New:BOOLEAN);
   VAR Year,Month,Day:INTEGER;
       DOB:STRING;
       YearStr,MonthStr,DayStr:STRING;
       ErrNum:LONGINT;
       Valid:BOOLEAN;

      BEGIN
        CLRSCR;
      IF New=FALSE THEN
      BEGIN
      WRITE('The current DOB is: ');
      WRITE(LandLordArray[arrayvalue].DayOfBirth,'/');
      WRITE(LandLordArray[arrayvalue].MonthOfBirth,'/');
      WRITELN(LandLordArray[arrayvalue].YearOfBirth);
      END;
      WRITELN('Enter DOB (DD/MM/YYYY)');
         REPEAT
            REPEAT
               REPEAT
               REPEAT
               REPEAT

               READLN(DOB);
               IF (DOB[3]<>'/') OR (DOB[6]<>'/') OR (LENGTH(DOB)<>10) THEN
               ErrorMessage('Please enter in format DD/MM/YYYY');

            UNTIL (DOB[3]='/') AND (DOB[6]='/') AND (LENGTH(DOB)=10);

            YearStr:=DOB[7]+DOB[8]+DOB[9]+DOB[10];
            MonthStr:=DOB[4]+DOB[5];
            DayStr:=DOB[1]+DOB[2];

            ValStrInt(YearStr,Valid);

            IF Valid=TRUE THEN

            BEGIN

               ValidateYear(YearStr,Valid,Year);
               IF Valid=FALSE THEN
               ErrorMessage('Not a valid year');

           END;

           UNTIL Valid=TRUE;

           BEGIN

              ValidateAgeRestriction(Year,Month,Day,Valid);

           END;

           UNTIL Valid=TRUE;

           Valid:=FALSE;
           ValStrInt(MonthStr,Valid);

           IF Valid= TRUE THEN

           BEGIN


              ValidateMonth(MonthStr,Valid,Month);
              IF Valid=FALSE THEN
              ErrorMessage('Not a valid month');
           END;

           UNTIL Valid= TRUE;

           Valid:=FALSE;
           ValStrInt(DayStr,Valid);

           IF Valid = TRUE THEN

           BEGIN


              ValidateDay(DayStr,MonthStr,YearStr,Valid,Day);
              IF Valid=FALSE THEN
              ErrorMessage('Not a valid day');

          END;

          UNTIL Valid=TRUE;

          WRITELN('The Date has been changed to:');
          WRITELN(DOB);
          WRITELN('Press Enter to Continue..');
          READLN;

          LandLordArray[ArrayValue].DayOfBirth:=Day;
          LandLordArray[ArrayValue].MonthOfBirth:=Month;
          LandLordArray[ArrayValue].YearOfBirth:=Year;

          SaveLandLordFile(FALSE);
            CLRSCR;
      END;



   PROCEDURE AmendPhone(New:BOOLEAN);
   VAR Valid:BOOLEAN;
       TempPhone:STRING;
       I:LONGINT;
   BEGIN
        CLRSCR;
      IF New=FALSE THEN
      WRITELN('The Phone Number is currently: ',LandLordArray[ArrayValue].PhoneNum);
      WRITELN('Enter Phone Number (No Spaces)');
      REPEAT
      REPEAT
      READLN(TempPhone);
      ValStrInt(TempPhone,Valid);
      UNTIL Valid=TRUE;
      IF (TempPhone[1]<>'0')  OR (LENGTH(TempPhone)<>11) THEN
      BEGIN
      ErrorMessage('Phone Number must begin with 0 and contain 11 digits');
      Valid:=FALSE;
      END ELSE
      BEGIN
      TempPhone:=TempPhone+#32;
      //FOR I:=11 TO 6 DO
      //TempPhone[I+1]:=TempPhone[I]; //Puts in phone format 0XXXX XXXXXX
      TempPhone[12]:=TempPhone[11];
      TempPhone[11]:=TempPhone[10];
      TempPhone[10]:=TempPhone[9];
      TempPhone[9]:=TempPhone[8];
      TempPhone[8]:=TempPhone[7];
      TempPhone[7]:=TempPhone[6];

      TempPhone[6]:=#32;

      WRITELN('The Phone Number has changed to: ',TempPhone);
      WRITELN('Press Enter to Continue..');
      READLN;
      LandLordArray[ArrayValue].PhoneNum:=TempPhone;
      SaveLandLordFile(FALSE);
      END;
      UNTIL Valid=TRUE;
        CLRSCR;
   END;



   PROCEDURE AmendHouseNum(New:BOOLEAN);
   VAR Valid:BOOLEAN;
       TempHouse:STRING;

      BEGIN
           CLRSCR;
         IF New=FALSE THEN
         WRITELN('The House Name/Number is currently: ',LandLordArray[ArrayValue].HouseNum);
         WRITELN('Enter House Num');
         REPEAT
         READLN(TempHouse);
         ValStrLetNum(TempHouse,Valid);
         UNTIL Valid=TRUE;

         WRITELN('The House Name/Number has changed to: ',TempHouse);
         WRITELN('Press Enter to Continue..');
         READLN;
         LandLordArray[ArrayValue].HouseNum:=TempHouse;
         SaveLandLordFile(FALSE);
           CLRSCR;
     END;


   PROCEDURE AmendStreet(New:BOOLEAN);
   VAR Valid:BOOLEAN;
       TempStreet:STRING;

      BEGIN
           CLRSCR;
         IF New=FALSE THEN
         WRITELN('The Current Street is: ',LandLordArray[ArrayValue].Street);
         WRITELN('Enter New Street');
         REPEAT
         READLN(TempStreet);
         ValStrLetter(TempStreet,Valid);
         UNTIL Valid=TRUE;
         TempStreet:=LOWERCASE(TempStreet);
         TempStreet[1]:=UPCASE(TempStreet[1]);
         WRITELN('The Street has changed to: ',TempStreet);
         WRITELN('Press Enter to Continue..');
         READLN;
         LandLordArray[ArrayValue].Street:=TempStreet;
         SaveLandLordFile(FALSE);
           CLRSCR;
      END;


     PROCEDURE AmendCity(New:BOOLEAN);
   VAR Valid:BOOLEAN;
       TempCity:STRING;

      BEGIN
           CLRSCR;
         IF New=FALSE THEN
         WRITELN('The Current City is: ',LandLordArray[ArrayValue].City);
         WRITELN('Enter New City');
         REPEAT
         READLN(TempCity);
         ValStrLetter(TempCity,Valid);
         UNTIL Valid=TRUE;
         TempCity:=LOWERCASE(TempCity);
         TempCity[1]:=UPCASE(TempCity[1]);
         WRITELN('The City has changed to: ',TempCity);
         WRITELN('Press Enter to Continue..');
         READLN;
         LandLordArray[ArrayValue].City:=TempCity;
         SaveLandLordFile(FALSE);
           CLRSCR;
      END;


   PROCEDURE AmendPostCode(New:BOOLEAN);
   VAR Valid:BOOLEAN;
       TempPost:STRING;

      BEGIN
           CLRSCR;
         IF New=FALSE THEN
         WRITELN('The Current PostCode is: ',LandLordArray[ArrayValue].PostCode);
         WRITELN('Enter New PostCode:');
         ValPostCode(TempPost);
         TempPost:=UPPERCASE(TempPost);
         WRITELN('The Postcode has changed to: ',TempPost);
         WRITELN('Press Enter to Continue..');
         READLN;
         LandLordArray[ArrayValue].PostCode:=TempPost;
         SaveLandLordFile(FALSE);
          CLRSCR;
     END;



   PROCEDURE AddProperty;
   VAR I,J,Pos,MaxPos:LONGINT;
       TotalProperties:ARRAY[1..50] OF STRING;
       TempId:STRING;
       Found,Valid:BOOLEAN;

   BEGIN
        CLRSCR;
      I:=1;
      Pos:=1;
      WHILE (I<11) AND (LandLordArray[ArrayValue].Properties[I]<>'0')
      DO
        I:=I+1;


      IF I>10 THEN

      ErrorMessage('No spaces for Properties') ELSE
      BEGIN

        WHILE (PropArray[Pos].PropertyId<>'0') AND (Pos<51) DO

         BEGIN

               TotalProperties[Pos]:=PropArray[Pos].PropertyId;
               Pos:=Pos+1;      {add 1 to the total number of available Properties}

            END;


         END;

         IF Pos=1 THEN  {If no available houses}
         ErrorMessage('No available Properties') ELSE

         BEGIN
            WRITELN('Properties:');
            WRITELN('~~~~~~~~~~~');
            WRITELN;
            MaxPos:=Pos-1;
            FOR Pos:=1 TO MaxPos DO
            WRITELN(TotalProperties[Pos]);
            WRITELN;
            WRITELN('Enter 1 of the above propertyId`s to add to the Landlord');
             REPEAT
             REPEAT
               READLN(TempId);
            TempId:=UPPERCASE(TempId);
         ValStrLetNum(TempId,Valid);
         TempId:=UPPERCASE(TempId);
         UNTIL Valid=TRUE;
         IF LENGTH(TempId)<>6 THEN
            BEGIN
            ErrorMessage('Must be 6 characters in length');
            Valid:=FALSE;
            END;
         UNTIL Valid=TRUE;
            Pos:=1;

               WHILE (TempId<>TotalProperties[Pos]) AND (Pos<>MaxPos) DO
                  Pos:=Pos+1;

            IF TempId=TotalProperties[Pos] THEN Found:=TRUE ELSE
            Found:=FALSE;

            IF Found=TRUE THEN

               BEGIN

               LandLordArray[ArrayValue].Properties[I]:=TotalProperties[Pos];

               J:=1;
               WHILE TotalProperties[Pos] <> PropArray[J].PropertyId DO {Already know the property exists}
               J:=J+1;                                         {so find position}
               PropArray[J].LandLordId:=LandLordArray[ArrayValue].LandLordId;
               WRITELN('PropertyId has changed to: ',TotalProperties[Pos]);
               WRITELN('Press Enter to Continue..');
               READLN;
               SaveLandLordFile(FALSE);
               SavePropFile(FALSE);
                 CLRSCR;
               END ELSE Errormessage('Doesn`t exist');



         END;



      END;





   PROCEDURE DrawAmendLordMenu(CurrentChoice:INTEGER;Main:BOOLEAN);
      VAR I:INTEGER;

      BEGIN

          BEGIN

         TEXTCOLOR(LIGHTCYAN);
         TEXTBACKGROUND(BLUE);
         FILLBOX(20,1,60,5);   {Fills specified background with colour}
         DRAWBOX(20,1,60,4);   {Draws a box (startingX,StartingY,EndingX,EndingY)}
         DRAWBOX(20,5,60,21);


                              {Setting x co-ordinates as the same}
         DRAWBOX(20,7,60,7);  {creates a horizontal line}
         DRAWBOX(20,9,60,9);  {used to create sections for options}
         DRAWBOX(20,11,60,11);
         DRAWBOX(20,13,60,13);
         DRAWBOX(20,15,60,15);
         DRAWBOX(20,17,60,17);
         DRAWBOX(20,19,60,19);


         FOR I:=1 TO 7 DO
         BEGIN

            GOTOXY(20,5+(2*I));  {replaces points of lines joining}
            WRITE(#195);         {#195 for + left points}
            GOTOXY(60,5+(2*I));
            WRITE(#180);         {#180 for Ý right points}

         END;


         TEXTCOLOR(WHITE);
         GOTOXY(28,2);
         WRITE('Amend Landlord '); TEXTCOLOR(GREEN);
         WRITELN(LandlordArray[ArrayValue].landlordId);
         TEXTCOLOR(WHITE);
         GOTOXY(28,3);
         WRITELN('   Select Option To Amend');

         GOTOXY(21,6);
         IF CurrentChoice=1 THEN                        {Test if the option is selected}
         ChoiceSelected(TRUE)                        {Write location of menu names}
         ELSE ChoiceSelected(FALSE);
         IF Main=TRUE THEN
         WRITELN('                LandlordId             ')ELSE
         WRITELN('                House Number           ');



         GOTOXY(21,8);
         IF CurrentChoice=2 THEN
         ChoiceSelected(TRUE)
          ELSE ChoiceSelected(FALSE);
             IF Main=TRUE THEN
         WRITELN('                Surname                ')ELSE
         WRITELN('                Street                 ');


         GOTOXY(21,10);
         IF CurrentChoice=3 THEN
         ChoiceSelected(TRUE)
          ELSE ChoiceSelected(FALSE);
             IF Main=TRUE THEN
         WRITELN('                Forename               ')ELSE
          WRITELN('                City                   ');
         GOTOXY(21,12);
         IF CurrentChoice=4 THEN
          ChoiceSelected(TRUE)
          ELSE ChoiceSelected(FALSE);
             IF Main=TRUE THEN
         WRITELN('                Gender                 ')ELSE
         WRITELN('                PostCode               ');

         GOTOXY(21,14);
           IF CurrentChoice=5 THEN
           ChoiceSelected(TRUE)
           ELSE ChoiceSelected(FALSE);
              IF Main=TRUE THEN
         WRITELN('                Date Of Birth          ')
          ELSE WRITELN('                                       ');
         GOTOXY(21,16);
           IF CurrentChoice=6 THEN
           ChoiceSelected(TRUE)
           ELSE ChoiceSelected(FALSE);
              IF Main=TRUE THEN
         WRITELN('                Address                ')
            ELSE WRITELN('                                       ');
         GOTOXY(21,18);
           IF CurrentChoice=7 THEN
           ChoiceSelected(TRUE)
           ELSE ChoiceSelected(FALSE);
              IF Main=TRUE THEN
         WRITELN('                Phone Number           ')
            ELSE WRITELN('                                       ');

         GOTOXY(21,20);
           IF CurrentChoice=8 THEN
           ChoiceSelected(TRUE)
           ELSE ChoiceSelected(FALSE);
              IF Main=TRUE THEN
         WRITELN('                Properties            ')
            ELSE WRITELN('                                       ');









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


   PROCEDURE AmendLandLord;
      VAR ChoiceCount:INTEGER;
       Press,Menu:CHAR;
       New,Valid,Found,Main:BOOLEAN;
       TempId:STRING;
      BEGIN
         New:=FALSE;
         CLRSCR;
         arrayvalue:=1;
         WRITELN('Enter Landlord Id To Amend');
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

         FindLandLord(TempId,FOUND);
         IF Found=TRUE THEN

         BEGIN
         CLRSCR;

         ChoiceCount:=1;
         Menu:='M';
         Main:=TRUE;

         REPEAT
            DrawAmendLordMenu(ChoiceCount,Main);
            Press:=UPCASE(READKEY); {same key pressed is assigned to 'Press'}
            CASE Press OF

            #80:BEGIN           {Down Arrow}
                  IF Menu='M' THEN
                  BEGIN

                   IF ChoiceCount <8 THEN
                    ChoiceCount:=ChoiceCount+1 ELSE ChoiceCount:=1;
                    END
                   ELSE BEGIN
                   IF ChoiceCount<4 THEN
                   ChoiceCount:=ChoiceCount+1 ELSE ChoiceCount:=1;
                   END;
                                {If option highlighted is the last and down is pressed}
                      {return to the first option}



                END;

         #72:BEGIN                   {Up Arrow}


                IF ChoiceCount >1 THEN
                ChoiceCount:=ChoiceCount-1
                ELSE
                IF Menu='M' THEN              {If option highlighted is the first and up is pressed}
                ChoiceCount:=8 ELSE
                ChoiceCount:=4;   {return to the last option}



             END;

         #13:;  {enter key, will select a function or new menu}

         'X':;  {to exit the current menu or program}

         END;





        IF (Press=#13) AND (Menu='M') THEN      {If On MainMenu}
         CASE ChoiceCount OF                     {and enter has been pressed}
         1:AmendLandlordId(New);
         2:AmendName('surname',New);
         3:AmendName('forename',New);
         4:AmendGender(New);
         5:AmendDOB(New);
         6: BEGIN Menu:='A';Main:=FALSE; END;
         7:AmendPhone(New);
         8:AddProperty;

         END;

          IF (Press=#13) AND (Menu<>'M') THEN      {If on a Submenu}
        BEGIN                                     {and enter has been pressed}
         CASE ChoiceCount OF                      {select a function from suboption}
          1:AmendHouseNum(New);
          2:AmendStreet(New);
          3:AmendCity(New);
          4:AmendPostCode(New);
         END;

         ChoiceCount:=1;
        END;

         IF (Press='X') AND (Menu<>'M') THEN     {If on a Submenu and x is pressed}
         BEGIN                                   {return to the main menu}
         Menu:='M';
         Main:=TRUE;
         Press:='a'; {set to rogue value so program doesn't exit}
         END;



         UNTIL (Press='X') AND (Menu='M');      {If on Main Menu when X is pressed exits program}


      END ELSE    ErrorMessage('Lord Record Not Found');
    END;

   PROCEDURE AddLandLord;
   VAR I,J:INTEGER;
       Full,Valid:BOOLEAN;
       NewLandLordNo:STRING;
       New:BOOLEAN;

         BEGIN
         SortLandlords;
         I:=1;
         Full:=TRUE;
         WHILE (I<51) AND (Full=TRUE) DO   {check if all arrays are filled}
         IF LandLordArray[I].LandLordId ='0' THEN Full:=FALSE
         ELSE I:=I+1;


          IF Full=TRUE THEN

         BEGIN

            WRITE('All Records have been filled, no remaning space is');
            WRITELN(' available. Please delete a record to add a new one.');
            READLN;


         END ELSE

         BEGIN
         WRITELN(I);
         READLN;
         New:=TRUE;
         CLRSCR;
         ArrayValue:=I;
         FOR J:=1 TO 10 DO
         LandLordArray[ArrayValue].Properties[J]:='0';
         AmendLandLordid(New);
         AmendName('surname',New);
         AmendName('forename',New);
         AmendGender(New);
         AmendDoB(New);
         AmendPhone(New);
         AmendHouseNum(New);
         AmendStreet(New);
         AmendCity(New);
         AmendPostCode(New);
         AddProperty;


         END;

      END;

END.





