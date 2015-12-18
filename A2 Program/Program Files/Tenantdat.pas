UNIT TENANTDAT;

INTERFACE

PROCEDURE ResetTenant;

PROCEDURE LoadTenantFile(VAR Found:BOOLEAN; DriveLetter:CHAR);

PROCEDURE LoadBackupTenant(VAR Found:BOOLEAN);

PROCEDURE DeleteTenant;

PROCEDURE AddTenant;

PROCEDURE AmendTenant;

PROCEDURE DisplayAllTenant;

PROCEDURE DisplaySearchTenant;

PROCEDURE SaveTenantFile(Backup:BOOLEAN);

TYPE
           TenantInfo=Record
                           TenantId      :STRING;
                           Surname     :STRING;
                           Forename    :STRING;
                           Gender      :CHAR;
                           DayOfBirth  :LONGINT;
                           MonthOfBirth:LONGINT;
                           YearOfBirth :LONGINT;
                           HouseNum    :STRING;
                           Street      :STRING;
                           City        :STRING;
                           PhoneNum    :STRING[12];
                           Postcode    :STRING;
                           PropertyId  :STRING;
                           PaymentId   :STRING;


                     END;

           Tenants=ARRAY[1..50] OF TenantInfo;


VAR
   TenantArray:Tenants;
   TempArray:Tenants;
   TenantFile :FILE OF TenantInfo;
   Tenant:TenantInfo;
   ArrayValue:INTEGER;
   GlobalDriveLetter:CHAR;

   BackupTenant:FILE OF TenantInfo;

IMPLEMENTATION

 USES CRT,SYSUTILS,Draw,Validate,Datecalc,PropertyDat;



   PROCEDURE ResetTenant;
   VAR
      I:INTEGER;
      BEGIN
         I:=0;
         FOR I:=1 TO 50 DO
         BEGIN                    {Sets all the Tenant ID's to 0,}
         TenantArray[I].TenantId:='0';{so all the 'marked for deletion' or empty arrays have a Tenant Id of 0}
         TempArray[I].TenantId:='0';{after the file has been read in}
         END;

      END;



   PROCEDURE LoadData(I:LONGINT);

      BEGIN
             WITH Tenant DO
             BEGIN
                      TenantArray[I].TenantID:=TenantId;
                      TenantArray[I].Surname:=Surname;
                      TenantArray[I].Forename:=Forename;
                      TenantArray[I].Gender:=Gender;
                      TenantArray[I].DayOfBirth:=DayOfBirth;
                      TenantArray[I].MonthOfBirth:=MonthOfBirth;
                      TenantArray[I].YearOfBirth:=YearOfBirth;
                      TenantArray[I].HouseNum:=HouseNum;
                      TenantArray[I].Street:=Street;
                      TenantArray[I].City:=City;
                      TenantArray[I].PhoneNum:=PhoneNum;
                      TenantArray[I].Postcode:=Postcode;
                      TenantArray[I].PropertyId:=PropertyId;
                      TenantArray[I].PaymentId:=PaymentId;
                      END;
      END;





   PROCEDURE LoadTenantFile(VAR Found:BOOLEAN; DriveLetter:CHAR); {Puts data from file into the array}
   VAR
      I:INTEGER;
      FilePath:STRING;

      BEGIN

         GlobalDriveLetter:=DriveLetter;


         FilePath:=GlobalDriveLetter+':\MainProgram\Files\TenantDet.DTA';
          {Finds the file to be read from}


          IF NOT FILEEXISTS(FilePath)   {if file not found}
         THEN

         Found:=FALSE

         ELSE

         BEGIN

         ASSIGN(TenantFile,FilePath);  //Assign the Main File

         RESET(TenantFile);
         ResetTenant;

         Found:= TRUE;



              I:=1;

               WITH Tenant DO

               BEGIN


               WHILE (NOT EOF(TenantFile)) AND (TenantID<>'0')  DO

                  BEGIN
                      READ(TenantFile,Tenant);
                      LoadData(I);
                      I:=I+1;
                  END;

        END;

        END;
      END;


   PROCEDURE LoadBackupTenant(VAR Found:BOOLEAN); {Puts data from file into the array}
   VAR
      I:INTEGER;
      FilePath:STRING;
      DriveLetter:CHAR;

      BEGIN
         FOUND:=FALSE;
         DriveLetter:='A';

         REPEAT
         FilePath:=DriveLetter+':\MainProgram\Backup\TenantDet.BCK'; {Finds the file to be read from}


         IF FILEEXISTS(FilePath) THEN Found:=TRUE  ELSE

                               {if file not found}
         DriveLetter:=CHR(ORD(DriveLetter)+1); //increment the drive, e.g. driveletter of 'A' becomes 'B'

        UNTIL (Found) OR (DriveLetter=CHR(ORD('Z')+1)); //Letter of drive passes 'Z'

        IF Found THEN

        BEGIN
         ASSIGN(BackupTenant,FilePath);
         RESET(BackupTenant);
         IF FILESIZE(BackupTenant)=0 THEN WRITELN ('No Data in Backup Tenant File')
         ELSE BEGIN
         ASSIGN(TenantFile,DriveLetter+':\MainProgram\Files\TenantDet.DTA');
               WITH Tenant DO

               BEGIN
               REWRITE(TenantFile);
               WHILE (NOT EOF(BackupTenant)) AND (TenantID<>'0') AND(I<51)  DO
                  BEGIN
                      READ(BackupTenant,Tenant);
                      LoadData(I);
                      WRITE(TenantFile,Tenant);
                      I:=I+1;
                  END;
                  CLOSE(BackupTenant);

        END;
    END;
      END;
   END;


   PROCEDURE SaveTenantFile(Backup:BOOLEAN);
   VAR I:INTEGER;
       J:INTEGER;
       K:INTEGER;
       FOUND:BOOLEAN;

      BEGIN
         I:=1;
         J:=1;
         WHILE J<51 DO
         BEGIN
            IF TenantArray[J].TenantID <> '0' THEN
            WITH Tenant DO                                {If TenantId is rogue value of 0}
            BEGIN                                        {then it is not added to the temp array}
             TempArray[I].TenantId:=TenantArray[J].TenantID;   {so any Tenants deleted are just not saved into the file}
             TempArray[I].Surname:=TenantArray[J].Surname; {when it is rewritten}
             TempArray[I].Forename:=TenantArray[J].Forename;
             TempArray[I].Gender:=TenantArray[J].Gender;
             TempArray[I].DayOfBirth:=TenantArray[J].DayOfBirth;
             TempArray[I].MonthOfBirth:=TenantArray[J].MonthOfBirth;
             TempArray[I].YearOfBirth:=TenantArray[J].YearOfBirth;
             TempArray[I].HouseNum:=TenantArray[J].HouseNum;
             TempArray[I].Street:=TenantArray[J].Street;
             TempArray[I].City:=TenantArray[J].City;
             TempArray[I].PhoneNum:=TenantArray[J].PhoneNum;
             TempArray[I].Postcode:=TenantArray[J].Postcode;
             TempArray[I].PropertyId:=TenantArray[J].PropertyId;
             TempArray[I].PaymentId:=TenantArray[J].PaymentId;
             I:=I+1;                                    {'I' will count as the total amount of}
           END;                                         {subscripts that are 'valid' within the array}
           J:=J+1;
       END;
       I:=I-1;


       IF Backup=TRUE THEN
        BEGIN
        ASSIGN(BackupTenant,GlobalDriveLetter+':\MainProgram\Backup\TenantDet.BCK');
        REWRITE(BackupTenant);
        RESET(BackupTenant);
        END ELSE

        BEGIN
       REWRITE(TenantFile);  {Rewrites the valid records}
       RESET(TenantFile);

       END;

       FOR K:=1 TO I DO  {For total amount of valid subscripts}
       WITH Tenant DO
       BEGIN
       TenantId:=TempArray[K].TenantID;
       Surname:=TempArray[K].Surname;
       Forename:=TempArray[K].Forename;
       Gender:=TempArray[K].Gender;
       DayOfBirth:=TempArray[K].DayOfBirth;
       MonthOfBirth:=TempArray[K].MonthOfBirth;
       YearOfBirth:=TempArray[K].YearOfBirth;
       HouseNum:=TempArray[K].HouseNum;
       Street:=TempArray[K].Street;
       City:=TempArray[K].City;
       PhoneNum:=TempArray[K].PhoneNum;
       Postcode:=TempArray[K].Postcode;
       PropertyId:=TempArray[K].PropertyId;
       PaymentId:=TempArray[K].PaymentId;
       IF Backup=TRUE THEN
       WRITE(BackupTenant,Tenant) ELSE
       WRITE(TenantFile,Tenant);
       END;
       FOUND:=TRUE;
       IF Backup=FALSE THEN
       BEGIN
       Close(TenantFile);
       LoadTenantFile(FOUND,GlobalDriveLetter); {loads the file back into the TenantArray}
       END ELSE
       Close(BackupTenant);
     END;



   PROCEDURE SortTenants; {Bubble sort's Tenants by Tenant id}

   VAR Pos,Last:INTEGER;  {sorts from largest to smallest as invalid or empty records contain an ID of "0"}
       Swapped:BOOLEAN;
       TempRec:TenantInfo;

      BEGIN

         Last:=49; //maximum 50 records, so 49 'passes' can be performed

         REPEAT

            Swapped:=FALSE;
            FOR Pos:=1 TO Last DO

               BEGIN

                  IF TenantArray[Pos].TenantId < TenantArray[Pos+1].TenantId THEN

                     BEGIN //Swap

                        TempRec:=TenantArray[Pos]; {Assigns temporary record}
                        TenantArray[Pos]:=TenantArray[Pos+1];
                        TenantArray[Pos+1]:=TempRec;
                        Swapped:=TRUE;

                     END;

               END;

            Last:=Last-1;

         UNTIL (NOT Swapped) OR (Last=0); //If no swapps performed during the pass then the data is sorted
                                          //Or if maximum number of passes
      END;



   PROCEDURE FindTenant(TenantID:STRING; VAR Found:BOOLEAN);
   VAR I,Start,Finish:INTEGER;
       TempStart,TempFinish:INTEGER;
       NoChange:BOOLEAN;

      BEGIN

         RESET(TenantFile);
         Start:=0;
         Finish:=50;
         IF FILESIZE(TenantFile) <>0 THEN

         BEGIN
            NoChange:=FALSE;
            SortTenants;  {Tenants sorted into sequential order}
            Found:=FALSE;
            arrayvalue:=0;
            WHILE (NoChange=FALSE) AND (Found=FALSE) DO {Binary Search}
            BEGIN

            ArrayValue:=ROUND((Start+Finish)/2);

            TempStart:=Start;
            TempFinish:= Finish;

            IF TenantArray[arrayvalue].TenantId < TenantId  THEN
            Finish:=arrayvalue;

            IF TenantArray[arrayvalue].TenantId > TenantId  THEN
            Start:=arrayvalue;

            IF TenantID=TenantArray[arrayvalue].TenantID THEN
            Found:=TRUE;

            IF (TempStart=Start) AND (TempFinish=Finish) THEN
            NoChange:=TRUE;
            END;

         END;
        END;



   PROCEDURE FindTenantDetails(VAR Found:BOOLEAN);
   VAR TempId:STRING;
       Valid:BOOLEAN;

      BEGIN
         CLRSCR;
         WRITELN('Enter the Tenant ID: ');
         REPEAT
         REPEAT
         READLN(TempId);
         ValStrLetNum(TempId,Valid);
         UNTIL Valid=TRUE;
         IF LENGTH(TempID)<>6 THEN
         BEGIN
         ErrorMessage('Must be 6 characters');
         Valid:=FALSE;
         END;
         UNTIL Valid=TRUE;

         TempId:=UPPERCASE(TempId);
         FindTenant(TempId,Found);

         IF Found=FALSE THEN
         ErrorMessage('Not Found');

      END;


   PROCEDURE DisplayTenantDetails(Pos:LONGINT);
   VAR I:INTEGER;
         BEGIN
         DRAWBOX(18,1,42,3);
         GOTOXY(20,2);

         WRITE('TenantId: '); WRITELN(TenantArray[Pos].TenantID);
         GOTOXY(1,5);
         WRITE(' Name:                    '); WRITE(TenantArray[Pos].Forename,' '); WRITELN(TenantArray[Pos].Surname);
         WRITELN;
         WRITE(' Gender:                  '); WRITELN(TenantArray[Pos].Gender);
         WRITELN;
         WRITE(' Date Of Birth:           '); WRITE(TenantArray[Pos].DayOfBirth,'/');
         WRITE(TenantArray[Pos].MonthOfBirth,'/'); WRITELN(TenantArray[Pos].YearOfBirth);
         WRITELN;
         WRITE(' Address:                 '); WRITE(TenantArray[Pos].HouseNum,' ');   WRITELN(TenantArray[Pos].Street);
         WRITELN;
         WRITE('                          ',TenantArray[Pos].City,' '); WRITELN(TenantArray[Pos].PostCode);
         WRITELN;
         WRITE(' PhoneNo:                 '); WRITELN(TenantArray[Pos].PhoneNum);
         WRITELN;
         WRITE(' PropertyId:              '); WRITELN(TenantArray[Pos].PropertyId);
         WRITELN;
         WRITE(' PaymentId:               '); WRITELN(TenantArray[Pos].PaymentId);
         FOR I :=6 TO 20 DO
         BEGIN
         DRAWBOX(1,4,60,I);
         I:=I+1;
         END;

         END;



   PROCEDURE DisplaySearchTenant;
   VAR Found:BOOLEAN;
       Pos:LONGINT;

      BEGIN

      FindTenantDetails(Found);
      Pos:=ArrayValue;
      CLRSCR;
      IF Found=TRUE THEN
      DisplayTenantDetails(Pos);
      READLN;

      END;


   PROCEDURE DisplayAllTenant;
   VAR TempTenantId:INTEGER;
       Total,Pos,I:INTEGER;
       Key:CHAR;

      BEGIN
         READLN;
         Total:=1;
         Pos:=1;
         WHILE (TenantArray[Total].TenantId <> '0') DO
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

         DisplayTenantDetails(Pos);
         REPEAT
         Key:=UPCASE(READKEY);
         IF (Key=#80) AND (Pos<>Total) THEN Pos:=Pos+1; //Down
         IF (Key=#72) AND (Pos<>1) THEN Pos:=Pos-1; //up
         UNTIL (Key=#80) OR (Key=#72) OR (Key='X');
         CLRSCR;
         UNTIL Key='X'
         ELSE
         Errormessage('No records in the file');


      END;



   PROCEDURE DeleteTenant;
    VAR Found,Valid:BOOLEAN;

        ConfirmDelete:CHAR;
        TempID:STRING;

      BEGIN

         CLRSCR;
         arrayvalue:=1;
         WRITELN('Enter TenantID to Delete');

         REPEAT
         REPEAT
         READLN(TempId);
         TempId:=UPPERCASE(TempId);
         ValStrLetNum(TempId,Valid);

         UNTIL Valid=TRUE;
          IF LENGTH(TempID)<>6 THEN
         BEGIN
         ErrorMessage('Must be 6 characters');
         Valid:=FALSE;
         END;
         UNTIL Valid=TRUE;
         FindTenant(TempId,FOUND);


         IF Found=TRUE THEN

         BEGIN

            WRITELN('Tenant found, would you like to delete? Y/N');
            ValidateYN(ConfirmDelete);

            IF ConfirmDelete='Y' THEN

            BEGIN

               TenantArray[arrayvalue].TenantId:='0'; {sets the TenantId of the record to an invalid record}



            SaveTenantFile(FALSE);
            WRITELN('Deleted');
            READLN;

         END ELSE

         BEGIN

            WRITELN('Not Deleted');
            READLN;

         END;

        END ELSE

        ErrorMessage('Tenant Not Found');


    END;



   PROCEDURE AmendSurname(New:BOOLEAN);
   VAR TempName:STRING;
       YesNoChoice:CHAR;
       Valid:BOOLEAN;

      BEGIN
         CLRSCR;
         IF New=FALSE THEN
         WRITELN('Current Surname is: ',TenantArray[ArrayValue].Surname);

         YesNoChoice:='N';

         WRITELN('Enter a new Surname');
         REPEAT

            READLN(Tempname);
            ValStrLetter(Tempname,Valid);

        UNTIL Valid=TRUE;
               TempName:=LOWERCASE(TempName);
               TempName[1]:=UPCASE(TempName[1]);
               WRITELN('Is the new Surname ',TempName,' correct? Y/N');
               ValidateYN(YesNoChoice);


         IF YesNoChoice='Y' THEN

            BEGIN

               TenantArray[arrayvalue].Surname:=TempName;

               WRITELN('Surname has been changed to ',Tempname);
               SaveTenantFile(FALSE);
               WRITELN('Press Enter to Continue..');
               READLN;
                 CLRSCR;
            END;

      END;



   PROCEDURE AmendForename(New:BOOLEAN);
   VAR TempName:STRING;
       YesNoChoice:CHAR;
       Valid:BOOLEAN;

      BEGIN
         CLRSCR;

         IF New=FALSE THEN
         WRITELN('Current Forename is: ',TenantArray[ArrayValue].Forename);

         YesNoChoice:='N';

         WRITELN('Enter a new Forename');
         REPEAT

            READLN(Tempname);
            ValStrLetter(Tempname,Valid);

        UNTIL Valid=TRUE;
               TempName:=LOWERCASE(TempName);
               TempName[1]:=UPCASE(TempName[1]);
               WRITELN('Is the new Forename ',TempName,' correct? Y/N');
               ValidateYN(YesNoChoice);


         IF YesNoChoice='Y' THEN

            BEGIN

               TenantArray[arrayvalue].Forename:=TempName;

               WRITELN('Forename has been changed to ',Tempname);
               SaveTenantFile(FALSE);
               WRITELN('Press Enter to Continue..');
               READLN;
                 CLRSCR;
            END;

      END;



   PROCEDURE AmendGender(New:BOOLEAN);
   VAR TempGen:CHAR;
       Gen:STRING;
       Valid:BOOLEAN;

      BEGIN
          CLRSCR;
         IF TenantArray[arrayvalue].Gender ='M' THEN
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
         READLN;
         TenantArray[arrayvalue].Gender:=TempGen;
         SaveTenantFile(FALSE);
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
      WRITE(TenantArray[arrayvalue].DayOfBirth,'/');
      WRITE(TenantArray[arrayvalue].MonthOfBirth,'/');
      WRITELN(TenantArray[arrayvalue].YearOfBirth);
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

              Val(DayStr,Day,ErrNum);
              ValidateDay(DayStr,Monthstr,Yearstr,Valid,Day);
              IF Valid=FALSE THEN
              ErrorMessage('Not a valid day');

          END;

          UNTIL Valid=TRUE;

          WRITELN('The Date has been changed to:');
          WRITELN(DOB);
          WRITELN('Press `Enter` to continue...');
          READLN;

          TenantArray[ArrayValue].DayOfBirth:=Day;
          TenantArray[ArrayValue].MonthOfBirth:=Month;
          TenantArray[ArrayValue].YearOfBirth:=Year;

          SaveTenantFile(FALSE);
            CLRSCR;
      END;



   PROCEDURE AmendPhone(New:BOOLEAN);
   VAR Valid:BOOLEAN;
       TempPhone:STRING[12];
       I:LONGINT;

   BEGIN
       CLRSCR;
      IF New=FALSE THEN
      WRITELN('The Phone Number is currently: ',TenantArray[ArrayValue].PhoneNum);
      WRITELN('Enter Phone Number(No Spaces)');
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
      TempPhone:=TempPhone+#13;
      //FOR I:=12 TO 7 DO
      //TempPhone[I]:=TempPhone[I-1];
      TempPhone[12]:=TempPhone[11];
      TempPhone[11]:=TempPhone[10];
      TempPhone[10]:=TempPhone[9];
      TempPhone[9]:=TempPhone[8];
      TempPhone[8]:=TempPhone[7];
      TempPhone[7]:=TempPhone[6];

      TempPhone[6]:=#32;
      WRITELN('The Phone Number has changed to: ',TempPhone);
      TenantArray[ArrayValue].PhoneNum:=TempPhone;
      WRITELN('Press `Enter` to continue...');
      READLN;
      SaveTenantFile(FALSE);
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
         WRITELN('The House Name/Number is currently: ',TenantArray[ArrayValue].HouseNum);
         WRITELN('Enter House Num');
         REPEAT
         READLN(TempHouse);
         ValStrLetNum(TempHouse,Valid);
         UNTIL Valid=TRUE;

         WRITELN('The House Name/Number has changed to: ',TempHouse);
         WRITELN('Press `Enter` to continue...');
         READLN;


         TenantArray[ArrayValue].HouseNum:=TempHouse;
         SaveTenantFile(FALSE);
           CLRSCR;
     END;


   PROCEDURE AmendStreet(New:BOOLEAN);
   VAR Valid:BOOLEAN;
       TempStreet:STRING;

      BEGIN
          CLRSCR;
         IF New=FALSE THEN
         WRITELN('The Current Street is: ',TenantArray[ArrayValue].Street);
         WRITELN('Enter New Street');
         REPEAT
         READLN(TempStreet);
         TempStreet:=LOWERCASE(TempStreet);
         TempStreet[1]:=UPCASE(TempStreet[1]);
         ValStrLetter(TempStreet,Valid);
         UNTIL Valid=TRUE;

         WRITELN('The Street has changed to: ',TempStreet);
         WRITELN('Press `Enter` to continue...');
         READLN;
         TenantArray[ArrayValue].Street:=TempStreet;
         SaveTenantFile(FALSE);
           CLRSCR;
      END;


     PROCEDURE AmendCity(New:BOOLEAN);
   VAR Valid:BOOLEAN;
       TempCity:STRING;

      BEGIN
          CLRSCR;
         IF New=FALSE THEN
         WRITELN('The Current City is: ',TenantArray[ArrayValue].City);
         WRITELN('Enter New City');
         REPEAT
         READLN(TempCity);
         ValStrLetter(TempCity,Valid);
         UNTIL Valid=TRUE;
         TempCity:=LOWERCASE(TempCity);
         TempCity[1]:=UPCASE(TempCity[1]);
         WRITELN('The City has changed to: ',TempCity);
         WRITELN('Press `Enter` to continue...');
         READLN;
         TenantArray[ArrayValue].City:=TempCity;
         SaveTenantFile(FALSE);
           CLRSCR;
      END;


   PROCEDURE AmendPostCode(New:BOOLEAN);
   VAR Valid:BOOLEAN;
       TempPost:STRING;

      BEGIN
          CLRSCR;
         IF New=FALSE THEN
         WRITELN('The Current PostCode is: ',TenantArray[ArrayValue].PostCode);
         WRITELN('Enter New PostCode:');
         ValPostCode(TempPost);
         TempPost:=UPPERCASE(TempPost);
         WRITELN('The Postcode has changed to: ',TempPost);
         WRITELN('Press `Enter` to continue...');
         READLN;
         TenantArray[ArrayValue].PostCode:=TempPost;
         SaveTenantFile(FALSE);
         CLRSCR;
     END;

   PROCEDURE AmendPropertyId(New:BOOLEAN);
   VAR I,J,Pos,MaxPos:LONGINT;
       PropertyIds:ARRAY[1..50] OF STRING;
       TempId:STRING;
       Valid,Found:BOOLEAN;

   BEGIN
      CLRSCR;
      I:=1;
      Pos:=1;

        WHILE (PropArray[Pos].PropertyId<>'0') AND (Pos<51) DO

         BEGIN

               PropertyIds[Pos]:=PropArray[Pos].PropertyId;
               Pos:=Pos+1;      {add 1 to the total number of available Properties}

            END;


         IF Pos=1 THEN  {If no available houses}
         ErrorMessage('No available Properties') ELSE

         BEGIN
                      IF New=FALSE THEN
            WRITELN('PropertyId for current Tenant is ',TenantArray[ArrayValue].PropertyId);
            MaxPos:=Pos-1;
            WRITELN;
            WRITELN('Properties:');
            WRITELN;
            FOR Pos:=1 TO MaxPos DO
            WRITELN(PropertyIds[Pos]);
            WRITELN;
            WRITELN('Enter 1 of the above propertyId`s to add to the Tenant');
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

               WHILE (TempId<>PropertyIds[Pos]) AND (Pos<>MaxPos) DO
                  Pos:=Pos+1;

            IF TempId=PropertyIds[Pos] THEN Found:=TRUE ELSE
            Found:=FALSE;

            IF Found=TRUE THEN

               BEGIN

               TenantArray[ArrayValue].PropertyId:=PropertyIds[Pos];

               J:=1;
               WHILE PropertyIds[Pos] <> PropArray[J].PropertyId DO {Already know the property exists}
               J:=J+1;                                         {so find position}

               PropArray[J].TenantId:=TenantArray[ArrayValue].TenantId;

               SaveTenantFile(FALSE);
               SavePropFile(FALSE);
               CLRSCR;
               END ELSE WRITELN('Property Not Found');
               READLN;
           END;
           END;


   PROCEDURE AmendPaymentId(New:BOOLEAN);
   VAR  TempId:STRING;
         Valid:BOOLEAN;
         I:LONGINT;

      BEGIN
         CLRSCR;
         IF New=FALSE THEN
         WRITELN('Current Payment Id is: ',TenantArray[ArrayValue].PaymentId);
         WRITELN('Enter New PaymentId');
         WRITELN('(6 characters long)');
         TenantArray[ArrayValue].PaymentId:='x';
         REPEAT
         REPEAT
         READLN(TempId);
         ValStrLetNum(TempId,Valid);
         TempId:=UPPERCASE(TempId);
         UNTIL Valid=TRUE;
         IF LENGTH(TempId)<>6 THEN
            BEGIN
            ErrorMessage('Must be 6 characters in length');
            Valid:=FALSE;
            END;
         UNTIL Valid=TRUE;
            FOR I:=1 TO 50 DO
         IF TempId=TenantArray[I].PaymentId THEN
            BEGIN
            ErrorMessage('Current Payment Id already assigned to a Tenant');
            Valid:=FALSE;
            END;
         TenantArray[ArrayValue].PaymentID:=TempId;
         WRITELN('New PaymentId has been amended to ',TenantArray[ArrayValue].PaymentID);
         WRITELN('Press `Enter` to continue...');
         READLN;
         SaveTenantFile(FALSE);
         CLRSCR;
      END;


   PROCEDURE AmendTenantId(New:BOOLEAN);
   VAR TempId:STRING;
       Valid:BOOLEAN;
       I:LONGINT;

      BEGIN
         CLRSCR;
         IF New=FALSE THEN
         WRITELN('Current Tenant Id is: ',TenantArray[ArrayValue].TenantId);
         WRITELN('Enter New TenantId');
         WRITELN('(6 characters long)');
         TenantArray[ArrayValue].TenantId:='x';
         REPEAT
         REPEAT
         REPEAT
         READLN(TempId);
         ValStrLetNum(TempId,Valid);
         TempId:=UPPERCASE(TempId);
         UNTIL Valid=TRUE;
         IF LENGTH(TempId)<>6 THEN
            BEGIN
            ErrorMessage('Must be 6 characters in length');
            Valid:=FALSE;
            END;
         UNTIL Valid=TRUE;
            FOR I:=1 TO 50 DO
         IF TempId=TenantArray[I].TenantId THEN
            BEGIN
            ErrorMessage('Current Tenant Id already exists');
            Valid:=FALSE;
            END;
         UNTIL Valid=TRUE;
         TenantArray[ArrayValue].TenantID:=TempId;
         WRITELN('New TenantId has been amended to ',TenantArray[ArrayValue].TenantID);
         WRITELN('Press `Enter` to continue...');
         READLN;
         SaveTenantFile(FALSE);
         CLRSCR;
     END;



   PROCEDURE DrawAmendTenantMenu(CurrentChoice:INTEGER;Main:BOOLEAN);
      VAR I:INTEGER;

      BEGIN

         TEXTCOLOR(LIGHTCYAN);
         TEXTBACKGROUND(BLUE);
         FILLBOX(20,1,60,5);   {Fills specified background with colour}
         DRAWBOX(20,1,60,4);   {Draws a box (startingX,StartingY,EndingX,EndingY)}
         DRAWBOX(20,5,60,23);


                              {Setting x co-ordinates as the same}
         DRAWBOX(20,7,60,7);  {creates a horizontal line}
         DRAWBOX(20,9,60,9);  {used to create sections for options}
         DRAWBOX(20,11,60,11);
         DRAWBOX(20,13,60,13);
         DRAWBOX(20,15,60,15);
         DRAWBOX(20,17,60,17);
         DRAWBOX(20,19,60,19);
         DRAWBOX(20,21,60,21);


         FOR I:=1 TO 8 DO
         BEGIN

            GOTOXY(20,5+(2*I));  {replaces points of lines joining}
            WRITE(#195);         {#195 for + left points}
            GOTOXY(60,5+(2*I));
            WRITE(#180);         {#180 for Ý right points}

         END;


         TEXTCOLOR(WHITE);
         GOTOXY(28,2);
         WRITE('Amend Tenant '); TEXTCOLOR(GREEN);
         WRITELN(TenantArray[ArrayValue].TenantId);
         TEXTCOLOR(WHITE);
         GOTOXY(28,3);
         WRITELN('   Select Option To Amend');

         GOTOXY(21,6);
         IF CurrentChoice=1 THEN                        {Test if the option is selected}
         ChoiceSelected(TRUE)                        {Write location of menu names}
         ELSE ChoiceSelected(FALSE);
         IF Main=TRUE THEN
         WRITELN('                TenantId               ')ELSE
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
         WRITELN('                Property Id            ')
            ELSE WRITELN('                                       ');

         GOTOXY(21,22);
           IF CurrentChoice=9 THEN
           ChoiceSelected(TRUE)
           ELSE ChoiceSelected(FALSE);
              IF Main=TRUE THEN
         WRITELN('                Payment Id             ')
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







   PROCEDURE AmendTenant;
   VAR ChoiceCount:INTEGER;
       Press,Menu:CHAR;
       New,Valid,Found,Main:BOOLEAN;
       TenantId:STRING;
      BEGIN
         New:=FALSE;
         CLRSCR;
         arrayvalue:=1;
         WRITELN('Enter Tenant Id To Amend');
         REPEAT
         REPEAT
         READLN(TenantId);
         ValStrLetNum(TenantId,Valid);

         UNTIL Valid=TRUE;
          IF LENGTH(TenantId)<>6 THEN
         BEGIN
         ErrorMessage('Must be 6 characters');
         Valid:=FALSE;
         END;
         UNTIL Valid=TRUE;

         FindTenant(TenantId,FOUND);
         IF Found=TRUE THEN

         BEGIN
         CLRSCR;

         ChoiceCount:=1;
         Menu:='M';
         Main:=TRUE;

         REPEAT
            DrawAmendTenantMenu(ChoiceCount,Main);
            Press:=UPCASE(READKEY); {same key pressed is assigned to 'Press'}
            CASE Press OF

            #80:BEGIN           {Down Arrow}
                  IF Menu='M' THEN
                  BEGIN

                   IF ChoiceCount <9 THEN
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
                ChoiceCount:=9 ELSE
                ChoiceCount:=4;   {return to the last option}



             END;

         #13:;  {enter key, will select a function or new menu}

         'X':;  {to exit the current menu or program}

         END;





        IF (Press=#13) AND (Menu='M') THEN      {If On MainMenu}
         CASE ChoiceCount OF                     {and enter has been pressed}
         1:AmendTenantId(New);
         2:AmendSurname(New);
         3:AmendForename(New);
         4:AmendGender(New);
         5:AmendDOB(New);
         6: BEGIN Menu:='A';Main:=FALSE; END;
         7:AmendPhone(New);
         8:AmendPropertyId(New);
         9:AmendPaymentId(New);

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


      END


        ELSE ErrorMessage('Tenant Record Not Found');


     END;



   PROCEDURE AddTenant;
   VAR I:INTEGER;
       Full,Valid:BOOLEAN;
       New:BOOLEAN;

         BEGIN
         I:=1;
         Full:=TRUE;
         WHILE (I<51) AND (Full=TRUE) DO   {check if all arrays are filled}
         IF TenantArray[I].TenantId = '0' THEN Full:=FALSE
         ELSE I:=I+1;


          IF Full=TRUE THEN

         BEGIN

            WRITE('All Records have been filled, no remaning space is');
            WRITELN(' available. Please delete a record to add a new one.');
            READLN;


         END ELSE

         BEGIN
         ArrayValue:=I;
         AmendTenantId(New);
         AmendSurname(New);
         AmendForeName(New);
         AmendGender(New);
         AmendDoB(New);
         AmendPhone(New);
         AmendHouseNum(New);
         AmendStreet(New);
         AmendCity(New);
         AmendPostCode(New);
         AmendPropertyId(New);
         AmendPaymentId(New);

         END;

      END;

END.





