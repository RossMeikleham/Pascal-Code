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
                           PhoneNum    :STRING;
                           Postcode    :STRING;
                           PropertyId  :STRING;
                           PaymentId   :STRING;


                     END;

           Tenants=ARRAY[1..50] OF TenantInfo;


VAR
   TenantArray:Tenants;
   TempArray:Tenants;
   TempRec:TenantInfo;
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
         WRITELN('stage3');
         WRITELN(DriveLetter);
         READLN;

         ASSIGN(BackupTenant,FilePath);
         RESET(BackupTenant);

         IF FILESIZE(BackupTenant)=0 THEN WRITELN ('No Data in Backup Tenant File')
         ELSE BEGIN

         writeln('stage5');
         READLN;
         ASSIGN(TenantFile,DriveLetter+':\MainProgram\Files\TenantDet.DTA');
        // IF FILEEXISTS(DriveLetter+':\MainProgram\Files\TenantDet.DTA') THEN
       //  BEGIN
      //   RESET(TenantFile);
     //    writeln('stage6');
     //    READLN;
     //    ResetTenant;  //Sets all records in the array with a rogue value
                       //Marking them for deletion



     //    SaveTenantFile(FALSE);   //All current Tenant records (if any) are wiped
     //                  //since they are all marked for deletion
     //   END;
              I:=1;
              WRITELN('stage7');
               WITH Tenant DO

               BEGIN
               REWRITE(TenantFile);

               WHILE (NOT EOF(BackupTenant)) AND (TenantID<>'0')  DO

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
       FileName:STRING;
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


   //PROCEDURE SaveBackupTenant;

      //BEGIN


      //END;

   PROCEDURE SortTenants; {Bubble sort's Tenants by Tenant id}

   VAR Pos,Finish:INTEGER;  {sorts from largest to smallest as invalid or empty records contain an ID of "0"}
       Swapped:BOOLEAN;     {and if done smallest to largest will send all the valid data to the back}

      BEGIN

         Finish:=49;

         REPEAT

            Swapped:=FALSE;
            FOR Pos:=1 TO Finish DO

               BEGIN

                  IF TenantArray[Pos].TenantId < TenantArray[Pos+1].TenantId THEN

                     BEGIN //Swap

                        TempRec:=TenantArray[Pos]; {Assigns temporary record}
                        TenantArray[Pos]:=TenantArray[Pos+1];
                        TenantArray[Pos+1]:=TempRec;
                        Swapped:=TRUE;

                     END;

               END;

            Finish:=Finish-1;

         UNTIL (NOT Swapped) OR (Finish=0);

      END;



   PROCEDURE FindTenant(TenantID:STRING; VAR Found:BOOLEAN);
   VAR I,Start,Finish:INTEGER;
       TempStart,TempFinish:INTEGER;
       NoChange:BOOLEAN;
       Value:INTEGER;
      BEGIN

         RESET(TenantFile);
         Start:=0;
         Finish:=50;
         IF FILESIZE(TenantFile) <>0 THEN

         BEGIN
            NoChange:=FALSE;
            SortTenants;  {Tennants sorted into sequential order}
            Found:=FALSE;
            arrayvalue:=0;
            WHILE (NoChange=FALSE) AND (Found=FALSE) DO {Binary Search}
            BEGIN

            arrayvalue:=ROUND((Start+Finish)/2);

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
         READLN(TempId);
         ValStrLetNum(TempId,Valid);
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
         WRITE(' Name:                    '); WRITE(TenantArray[Pos].Surname,' '); WRITELN(TenantArray[Pos].Forename);
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
      IF Found=TRUE THEN
      DisplayTenantDetails(Pos);

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
         IF (Key=#72) AND (Pos<>1) THEN Pos:=Pos+-1; //up
         UNTIL (Key=#80) OR (Key=#72) OR (Key='X');

         UNTIL Key='X'
         ELSE
         Errormessage('No records in the file');


      END;



   PROCEDURE DeleteTenant;
    VAR Found,Valid:BOOLEAN;
        Value:INTEGER;
        ConfirmDelete:CHAR;
        TempID:STRING;

      BEGIN

         CLRSCR;
         arrayvalue:=1;
         WRITE('Enter TenantID to Delete');

         REPEAT

         READLN(TempId);
         TempId:=UPPERCASE(TempId);
         ValStrLetNum(TempId,Valid);

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



   PROCEDURE AmendName(FieldName:STRING;New:BOOLEAN);
   VAR TempName:STRING;
       YesNoChoice:CHAR;
       Skip,Valid:BOOLEAN;

      BEGIN
         CLRSCR;
         IF FieldName='surname' THEN

         TempName:=TenantArray[arrayvalue].Surname

         ELSE TempName:=TenantArray[arrayvalue].Forename;

         YesNoChoice:='N';

         WRITELN('Enter a new ',FieldName);
         REPEAT

            READLN(Tempname);
            ValStrLetter(Tempname,Valid);

        UNTIL Valid=TRUE;
               TempName:=LOWERCASE(TempName);
               TempName[1]:=UPCASE(TempName[1]);
               WRITELN('Is the new ',FieldName,' ',TempName,' correct? Y/N');
               ValidateYN(YesNoChoice);


         IF YesNoChoice='Y' THEN

            BEGIN

               IF FieldName='surname' THEN

               TenantArray[arrayvalue].Surname:=TempName

               ELSE TenantArray[arrayvalue].Forename:=TempName;
               WRITELN('Name has been changed');
               SaveTenantFile(FALSE);

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

         TenantArray[arrayvalue].Gender:=TempGen;
         SaveTenantFile(FALSE);

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
      WRITE('The current DOB is: ');
      WRITE(TenantArray[arrayvalue].DayOfBirth,'/');
      WRITE(TenantArray[arrayvalue].MonthOfBirth,'/');
      WRITELN(TenantArray[arrayvalue].YearOfBirth);
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
          READLN;

          TenantArray[ArrayValue].DayOfBirth:=Day;
          TenantArray[ArrayValue].MonthOfBirth:=Month;
          TenantArray[ArrayValue].YearOfBirth:=Year;

          SaveTenantFile(FALSE);
      END;



   PROCEDURE AmendPhone(New:BOOLEAN);
   VAR Valid:BOOLEAN;
       TempPhone:STRING;

   BEGIN
       CLRSCR;
      IF New=FALSE THEN
      WRITELN('The Phone Number is currently: ',TenantArray[ArrayValue].PhoneNum);
      WRITELN('Enter Phone Number');
      REPEAT
      REPEAT
      READLN(TempPhone);
      ValStrLetNum(TempPhone,Valid);
      UNTIL Valid=TRUE;
      IF (TempPhone[1]<>'0')  OR (LENGTH(TempPhone)<>11) THEN
      BEGIN
      ErrorMessage('Phone Number must begin with 0 and contain 11 digits');
      Valid:=FALSE;
      END ELSE
      BEGIN
      WRITELN('The Phone Number has changed to: ',TempPhone);
      READLN;
      TenantArray[ArrayValue].PhoneNum:=TempPhone;
      SaveTenantFile(FALSE);
      END;
      UNTIL Valid=TRUE;
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
         READLN;
         TenantArray[ArrayValue].PhoneNum:=TempHouse;
         SaveTenantFile(FALSE);

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
         READLN;
         TenantArray[ArrayValue].Street:=TempStreet;
         SaveTenantFile(FALSE);

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
         TempCity[1]:=UPCASE(TempCity[1);
         WRITELN('The City has changed to: ',TempCity);
         READLN;
         TenantArray[ArrayValue].City:=TempCity;
         SaveTenantFile(FALSE);

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
         READLN;
         TenantArray[ArrayValue].PostCode:=TempPost;
         SaveTenantFile(FALSE);

     END;

   PROCEDURE AmendPropertyId(New:BOOLEAN);
   VAR I,J,Pos,MaxPos:LONGINT;
       SearchArray:ARRAY[1..50] OF STRING;
       TempId:STRING;
       Found:BOOLEAN;

   BEGIN

      I:=1;
      Pos:=1;

        WHILE (PropArray[Pos].PropertyId<>'0') AND (Pos<51) DO

         BEGIN

               SearchArray[Pos]:=PropArray[Pos].PropertyId;
               Pos:=Pos+1;      {add 1 to the total number of available Properties}

            END;


         IF Pos=1 THEN  {If no available houses}
         ErrorMessage('No available Properties') ELSE

         BEGIN
                      IF New=FALSE THEN
            WRITELN('PropertyId for current Tenant is ',TenantArray[ArrayValue].PropertyId);
            MaxPos:=Pos-1;
            WRITELN;
            FOR Pos:=1 TO MaxPos DO
            WRITELN(SearchArray[Pos]);
            WRITELN;
            WRITELN('Enter 1 of the above propertyId`s to add to the Tenant');
            READLN(TempId);
            TempId:=UPPERCASE(TempId);

            Pos:=1;

               WHILE (TempId<>SearchArray[Pos]) AND (Pos<>MaxPos) DO
                  Pos:=Pos+1;

            IF TempId=SearchArray[Pos] THEN Found:=TRUE ELSE
            Found:=FALSE;

            IF Found=TRUE THEN

               BEGIN

               TenantArray[ArrayValue].PropertyId:=SearchArray[Pos];

               J:=1;
               WHILE SearchArray[Pos] <> PropArray[J].PropertyId DO {Already know the property exists}
               J:=J+1;                                         {so find position}

               PropArray[J].TenantId:=TenantArray[ArrayValue].TenantId;

               SaveTenantFile(FALSE);
               SavePropFile(FALSE);

               END;




   PROCEDURE AmendPaymentId(New);
   VAR I,J,Pos,MaxPos:LONGINT;
       SearchArray:ARRAY[1..50] OF STRING;
       TempId:STRING;
       Found:BOOLEAN;

   BEGIN

      I:=1;
      Pos:=1;

        WHILE (PayArray[Pos].PaymentId<>'0') AND (Pos<51) DO

         BEGIN

               SearchArray[Pos]:=PayArray[Pos].PaymentId;
               Pos:=Pos+1;      {add 1 to the total number of available Payerties}

            END;


         IF Pos=1 THEN  {If no available houses}
         ErrorMessage('No available Payments') ELSE

         BEGIN
            IF New=FALSE THEN
            WRITELN('PaymentId for current Tenant is ',TenantArray[ArrayValue].PaymentId);
            MaxPos:=Pos-1;
            FOR Pos:=1 TO MaxPos DO
            WRITELN(SearchArray[Pos]);
            WRITELN;
            WRITELN('Enter 1 of the above PayId`s to add to the Tenant');
            READLN(TempId);
            TempId:=UPPERCASE(TempId);

            Pos:=1;

               WHILE (TempId<>SearchArray[Pos]) AND (Pos<>MaxPos) DO
                  Pos:=Pos+1;

            IF TempId=SearchArray[Pos] THEN Found:=TRUE ELSE
            Found:=FALSE;

            IF Found=TRUE THEN

               BEGIN

               TenantArray[ArrayValue].PaymentId:=SearchArray[Pos];

               J:=1;
               WHILE SearchArray[Pos] <> PayArray[J].PaymentId DO {Already know the Pay exists}
               J:=J+1;                                         {so find position}

               PayArray[J].TenantId:=TenantArray[ArrayValue].TenantId;

               SaveTenantFile(FALSE);
               SavePayFile(FALSE);

               END;


   PROCEDURE AmendTenantId(New:BOOLEAN);
   TempId:STRING;
   Valid:BOOLEAN;

      BEGIN

         IF New=FALSE THEN
         WRITELN('Current Tenant Id is: ',TenantArray[I].TenantId);
         WRITELN('Enter New TenantId');
         WRITELN('(6 characters long)');
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
         TenantArray[I].TenantID:=NewTenantNo;
         WRITELN('New TenantId has been amended to ',TenantArray[I].TenantID,);
         SaveTenantFile(FALSE);

   PROCEDURE AmendAddress;
   VAR FieldChoice:CHAR;
       New:BOOLEAN;

      BEGIN
       CLRSCR;
         New:=FALSE;
         CLRSCR;
         WRITELN('Enter part of Address to amend');
         WRITELN('1: House Number');
         WRITELN('2: Street');
         WRITELN('3: City');
         WRITELN('4: Postcode');

         REPEAT
         FieldChoice:=UPCASE(READKEY);

         CASE FieldChoice OF
         '1':AmendHouseNum(New);
         '2':AmendStreet(New);
         '3':AmendCity(New);
         '4':AmendPostCode(New);
         'X':;
         ELSE
         ErrorMessage('Only enter keys 1-4 or X');
         END;
         UNTIL FieldChoice='X';
         CLRSCR;
      END;


   PROCEDURE DrawAmendTenantMenu(CurrentChoice:INTEGER);
      VAR I:INTEGER;

      BEGIN

       IF Redisplay= TRUE THEN

          BEGIN

         TEXTCOLOR(LIGHTCYAN);
         TEXTBACKGROUND(BLUE);
         FILLBOX(20,1,60,5);   {Fills specified background with colour}
         FILLBOX(20,7,60,22);
         DRAWBOX(20,1,60,5);   {Draws a box (startingX,StartingY,EndingX,EndingY)}
         DRAWBOX(20,7,60,22);


         DRAWBOX(20,10,60,10);  {Setting x co-ordinates as the same}
         DRAWBOX(20,12,60,10);  {creates a horizontal line}
         DRAWBOX(20,14,60,10);  {used to create sections for options}
         DRAWBOX(20,16,60,10);
         DRAWBOX(20,18,60,10);
         DRAWBOX(20,20,60,10);
         DRAWBOX(20,22,60,10);

         FOR I:=1 TO 7 DO
         BEGIN

            GOTOXY(20,8+(2*I));  {replaces points of lines joining}
            WRITE(#195);         {#195 for + left points}
            GOTOXY(60,8+(2*I));
            WRITE(#180);         {#180 for Ý right points}

         END;


         TEXTCOLOR(WHITE);
         GOTOXY(28,3);
         WRITELN('      Select Option To Amend');

         GOTOXY(21,8);
         IF CurrentChoice=1 THEN                        {Test if the option is selected}
         CurrentChoiceTest(TRUE)                        {Write location of menu names}
         ELSE CurrentChoiceTest(FALSE);
         WRITELN('                TenantId                ');
         GOTOXY(21,9);
         WRITELN('                                       ');

         GOTOXY(21,11);
         IF CurrentChoice=2 THEN
         CurrentChoiceTest(TRUE)
          ELSE CurrentChoiceTest(FALSE);
         WRITELN('                Delete                 ');
         GOTOXY(21,12);
         WRITELN('                                       ');

         GOTOXY(21,14);
         IF CurrentChoice=3 THEN
         CurrentChoiceTest(TRUE)
          ELSE CurrentChoiceTest(FALSE);
         WRITELN('                Add                    ');
          GOTOXY(21,15);
         WRITELN('                                       ');

         GOTOXY(21,17);
         IF CurrentChoice=4 THEN
         CurrentChoiceTest(TRUE)
          ELSE CurrentChoiceTest(FALSE);
         WRITELN('                Amend                  ');
          GOTOXY(21,18);
         WRITELN('                                       ');

         GOTOXY(21,20);
         IF CurrentChoice=5 THEN
         CurrentChoiceTest(TRUE)
          ELSE CurrentChoiceTest(FALSE);
         WRITELN('                Option 5               ');
          GOTOXY(21,21);
         WRITELN('                                       ');

         TEXTBACKGROUND(BLUE);
         GOTOXY(1,25);
         TEXTCOLOR(WHITE);
         GOTOXY(2,25);
         WRITE(' '#24''#25' To select option');
         WRITE('         Press "X" Key To Exit    ');
         WRITE('                        ');
         TEXTBACKGROUND(BLACK);

         TimeWindow;

          END;
      END;



   PROCEDURE AmendTenant;
   VAR
       TenantId:STRING;
       Found,Valid:BOOLEAN;
       FieldChoice:CHAR;
       New:BOOLEAN;

     BEGIN
         DrawAmendTenantMenu;
         New:=FALSE;
         CLRSCR;
         arrayvalue:=1;
         WRITELN('Enter Tenant Id To Amend');
         REPEAT
         READLN(TenantId);
         ValStrLetNum(TenantId,Valid);

         UNTIL Valid=TRUE;

         FindTenant(TenantId,FOUND);
         IF Found=TRUE THEN

         BEGIN

        CLRSCR;
        REPEAT
        WRITELN('Select Field To Amend');
        WRITELN('1: Surname');
        WRITELN('2: Forename');
        WRITELN('3: Gender');
        WRITELN('4: DoB   ');
        WRITELN('5: Phone');
        WRITELN('6: Address');
        WRITELN('7: Property Id');
        WRITELN('8: Payment Id');


        FieldChoice:=UPCASE(READKEY);
        CASE FieldChoice OF
        '1':AmendTenantId(New);
        '2':AmendName('Surname',New);
        '3':AmendName('Forename',New);
        '4':AmendGender(New);
        '5':AmendDOB(New);
        '6':AmendPhone(New);
        '7':AmendAddress;
        '8':AmendPropertyId;
        '9':AmendPaymentId;
        'X':;
        ELSE
        ErrorMessage('Only enter digits 1-8 OR X');
        END;
        CLRSCR;
        UNTIL FieldChoice='X';
        END
        ELSE ErrorMessage('Tenant Record Not Found');



     END;

   PROCEDURE AddTenant;
   VAR I:INTEGER;
       Full,Valid:BOOLEAN;
       NewTenantNo:STRING;
       New:BOOLEAN;

         BEGIN
         I:=1;
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
         ArrayValue:=I-1;
         AmendTenantId(New);
         AmendName('Surname',New);
         AmendName('Forename',New);
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





