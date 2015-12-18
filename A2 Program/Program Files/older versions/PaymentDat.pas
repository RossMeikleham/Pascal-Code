UNIT PAYMENTDAT;

INTERFACE
   TYPE

      PayDateArray=ARRAY[2011..2061,1..12] OF BOOLEAN;  {Paid True Or False}
      CostArray=ARRAY[2011..2061,1..12] OF REAL;

      PayInfo=RECORD

         PaymentId:STRING;
         TenantId:STRING;
         CurrentPayment:REAL;
         PaymentCost:CostArray;
         PaymentsMade:PayDateArray;
         TotalOwed:REAL;
         YearStarted:LONGINT;
         MonthStarted:LONGINT;
         DayStarted:LONGINT;

      END;

      Payments=ARRAY[1..50] OF PayInfo;



   VAR
   Pay:PayInfo;
   PayArray:Payments;
   PayFile:FILE OF PayInfo;
   TempPayRec:PayInFo;
   TempPayArray:Payments;
   GlobalDriveLetter:CHAR;
   ArrayValue:LONGINT;
   New:BOOLEAN;
   OutStandingPayments:ARRAY[1..50] OF REAL;
   OutStandingPaymentsDate:ARRAY[1..50] OF STRING;

   BackupPay:FILE OF PayInfo;




PROCEDURE ResetPay;

PROCEDURE LoadPay(VAR Found:BOOLEAN; Backup:BOOLEAN;DriveLetter:CHAR);

PROCEDURE FindPay(PaymentID:STRING; VAR Found:BOOLEAN);

PROCEDURE LoadBackupPay(VAR Found:BOOLEAN);

PROCEDURE AddPay;

PROCEDURE AmendPay(New:BOOLEAN);

PROCEDURE DisplayAllPay;

PROCEDURE DisplaySearchPay;

PROCEDURE DeletePay;

PROCEDURE SavePayFile(Backup:BOOLEAN);

PROCEDURE CalculateTotalOwed(VAR TotalNo,Pos:LONGINT; VAR TotalCost:REAL);

PROCEDURE DisplayMainOwed;

PROCEDURE AddNextPayment;

PROCEDURE PrintOut;

IMPLEMENTATION

USES CRT, SYSUTILS, DOS, Draw, Validate, DateCalc, TenantDat,
     NETWORKPRINT;




   PROCEDURE AddNextpayment; //If the month changes, the cost for the month must be changed from a rogue value
                             //to the current cost each month of the property
   VAR I,J,Year,Month,Day,WDay:LONGINT;

     BEGIN
     GETDATE(Year,Month,Day,WDay);
     I:=1;
     WHILE (I<51) AND (PayArray[I].PaymentId<>'0') DO
     BEGIN
     IF PayArray[I].PaymentCost[Year,Month]=-1 THEN
     BEGIN
     PayArray[I].PaymentCost[Year,Month]:=PayArray[I].CurrentPayment;
     END;
     I:=I+1;
     END;
     SavePayFile(FALSE);
     END;

   PROCEDURE ResetPay;
   VAR I,J,K:INTEGER;

      BEGIN

         FOR I:= 1 TO 50 DO

            BEGIN
            PayArray[I].PaymentId:='0';
            TempPayArray[I].PaymentId:='0';


        FOR J:=2011 TO 2061 DO
         FOR K:=1 TO 12 DO
            BEGIN
            PayArray[I].PaymentCost[J,K]:=-1;
            PayArray[I].PaymentsMade[J,K]:=FALSE;
            END;
            END;
      END;




    PROCEDURE LoadData(I:LONGINT);
     VAR K,J:LONGINT;

      BEGIN
             WITH Pay DO BEGIN
                      PayArray[I].PaymentId:=PaymentId;
                      PayArray[I].TenantId:=TenantId;
                      PayArray[I].CurrentPayment:=CurrentPayment;
                      PayArray[I].TotalOwed:=TotalOwed;
                      PayArray[I].YearStarted:=YearStarted;
                      PayArray[I].MonthStarted:=MonthStarted;
                      PayArray[I].DayStarted:=DayStarted;

                      J:=YearStarted;
                      K:=MonthStarted;

                      WHILE PaymentCost[J,K]<>0 DO
                      BEGIN
                      PayArray[I].PaymentCost[J,K]:=PaymentCost[J,K];
                      K:=K+1;
                      IF K=13 THEN
                      BEGIN
                      K:=1;
                      J:=J+1;
                      END;
                      END;


                      J:=YearStarted;
                      K:=MonthStarted;

                      WHILE PaymentCost[J,K]<>0 DO
                      BEGIN
                      PayArray[I].PaymentsMade[J,K]:=PaymentsMade[J,K];
                      K:=K+1;
                      IF K=13 THEN
                      BEGIN
                      K:=1;
                      J:=J+1;
                      END;
                      END;
                      END;
                   END;


    PROCEDURE LoadPay(VAR Found:BOOLEAN;Backup:BOOLEAN;DriveLetter:CHAR);
    VAR I,J,k:INTEGER;
        Path:STRING;

      BEGIN
         GlobalDriveLetter:=DriveLetter;


         Path:=':\MainProgram\Files\PaymentFile.DTA';
         ASSIGN(PayFile,GlobalDriveLetter+Path);  {Finds the file to be read from}




         IF NOT FILEEXISTS(GlobalDriveLetter+Path) THEN  {if file not found}
         Found:=FALSE

         ELSE

         BEGIN
         Found:=TRUE;

         RESET(PayFile);

         ResetPay;

         BEGIN
              I:=1;
               WITH Pay DO

                 WITH Pay DO
                 IF Backup=FALSE THEN BEGIN
                 WHILE (NOT EOF(PayFile)) AND (PaymentID<>'0')  DO

                  BEGIN
                      READ(PayFile,Pay);
                      LoadData(I);
                      I:=I+1;
                  END;


         END;
        END;
         END;
         END;


     PROCEDURE LoadBackupPay(VAR Found:BOOLEAN); {Puts data from file into the array}
   VAR
      I:INTEGER;
      FilePath:STRING;
      DriveLetter:CHAR;

      BEGIN
         FOUND:=FALSE;
         DriveLetter:='A';

         REPEAT
         FilePath:=DriveLetter+':\MainProgram\Backup\PaymentFile.BCK'; {Finds the file to be read from}


         IF FILEEXISTS(FilePath) THEN Found:=TRUE  ELSE

                               {if file not found}
         DriveLetter:=CHR(ORD(DriveLetter)+1); //increment the drive, e.g. driveletter of 'A' becomes 'B'

        UNTIL (Found) OR (DriveLetter=CHR(ORD('Z')+1)); //Letter of drive passes 'Z'

        IF Found THEN

        BEGIN

         ASSIGN(BackupPay,FilePath);
         RESET(BackupPay);

         IF FILESIZE(BackupPay)=0 THEN WRITELN ('No Data in Backup Tenant File')
         ELSE BEGIN


         ASSIGN(PayFile,DriveLetter+':\MainProgram\Files\PaymentFile.DTA');

       //  ResetPay;  //Sets all records in the array with a rogue value
                       //Marking them for deletion

      //   SavePayFile(FALSE);   //All current payment records (if any) are wiped
                     //since they are all marked for deletion
              I:=1;

               WITH Pay DO

               BEGIN
               REWRITE(PayFile);
               RESET(PayFile);

               WHILE (NOT EOF(BackupPay)) AND (PaymentID<>'0')  DO

                  BEGIN
                      READ(BackupPay,Pay);
                      LoadData(I);
                      WRITE(PayFile,Pay);
                      I:=I+1;
                  END;
                  CLOSE(BackupPay);

        END;
    END;
      END;
   END;



   PROCEDURE SavePayFile(Backup:BOOLEAN);
   VAR I:INTEGER;
       J:INTEGER;
       K,L,M:INTEGER;
       FOUND:BOOLEAN;
       FileName:STRING;
      BEGIN
         I:=1;
         J:=1;
         WHILE J<51 DO
         BEGIN
            IF PayArray[J].PaymentID <> '0' THEN
            WITH Pay DO                                {If PaymentId is rogue value of 0}
            BEGIN                                        {then it is not added to the temp array}
             TempPayArray[I].PaymentId:=PayArray[J].PaymentID;   {so any Payments deleted are just not saved into the file}
             TempPayArray[I].TenantId:=PayArray[J].TenantId;
             TempPayArray[I].CurrentPayment:=PayArray[J].CurrentPayment;
             TempPayArray[I].TotalOwed:=PayArray[J].TotalOwed;
             TempPayArray[I].YearStarted:=PayArray[J].YearStarted;
             TempPayArray[I].MonthStarted:=PayArray[J].MonthStarted;
             TempPayArray[I].DayStarted:=PayArray[J].DayStarted;

             L:=YearStarted; M:=MonthStarted;

             WHILE  PayArray[J].PaymentCost[L,M] <>-1 DO
             BEGIN
             TempPayArray[I].PaymentCost[L,M]:=PayArray[J].PaymentCost[L,M];
             TempPayArray[I].PaymentsMade[L,M]:=PayArray[J].Paymentsmade[L,M];
             M:=M+1;
             IF M=13 THEN
             BEGIN
             M:=1;
             L:=L+1;
             END;
             END;                                                   {when it is rewritten}
             I:=I+1;                                    {'I' will count as the total amount of}
           END;                                          {subscripts that are 'valid' within the array}
           J:=J+1;
       END;
       I:=I-1;
       M:=M-1;
       IF M=0 THEN BEGIN
       M:=12;
       L:=L-1;
       END;

       IF Backup=TRUE THEN
         BEGIN
         ASSIGN(BackupPay,GlobalDriveLetter+':\MainProgram\Backup\PaymentFile.BCK');
         REWRITE(BackupPay);
         RESET(BackupPay);
         END;

       IF Backup=FALSE THEN
       BEGIN
       REWRITE(PayFile);  {Rewrites the valid records}
       RESET(PayFile);
       END;

       FOR K:=1 TO I DO  {For total amount of valid subscripts}
       WITH Pay DO
       BEGIN
       PaymentId:=TempPayArray[K].PaymentId;
       TenantId:=TempPayArray[K].TenantId;
       CurrentPayment:=TempPayArray[K].CurrentPayment;
       TotalOwed:=TempPayArray[K].TotalOwed;
       YearStarted:=TempPayArray[K].YearStarted;
       MonthStarted:=TempPayArray[K].MonthStarted;
       DayStarted:=TempPayArray[K].DayStarted;

       J:=YearStarted;
       I:=MonthStarted;
       REPEAT
         BEGIN
         PaymentCost[J,I]:=TempPayArray[K].PaymentCost[J,I];
         PaymentsMade[J,I]:=TempPayArray[K].PaymentsMade[J,I];
         I:=I+1;
         IF I=13 THEN BEGIN
         I:=1;
         J:=J+1;
         END;
         END;
       UNTIL (J>L) OR ((J=L) AND (I>M));
       IF Backup=TRUE THEN
       WRITE(BackupPay,Pay) ELSE
       WRITE(PayFile,Pay);
       END;
       IF Backup=FALSE THEN
       BEGIN
       Close(PayFile);
       FOUND:=TRUE;
       LoadPay(FOUND,FALSE,GlobalDriveLetter); {loads the file back into the PayArray}
       END ELSE
       CLOSE(BackupPay);
     END;




    PROCEDURE SortPays; {Bubble sort's Pays by Payid}

   VAR Pos,Finish:LONGINT;  {sorts from largest to smallest as invalid or empty records contain an ID of "0"}
       Swapped:BOOLEAN;     {and if done smallest to largest will send all the valid data to the back}

      BEGIN

         Finish:=49;

         REPEAT

            Swapped:=FALSE;
            FOR Pos:=1 TO Finish DO

               BEGIN

                  IF PayArray[Pos].PaymentId < PayArray[Pos+1].PaymentId THEN

                     BEGIN //Swap

                        TempPayRec:=PayArray[Pos]; {Assigns temporary record}
                        PayArray[Pos]:=PayArray[Pos+1];
                        PayArray[Pos+1]:=TempPayRec;
                        Swapped:=TRUE;

                     END;

               END;

            Finish:=Finish-1;

         UNTIL (NOT Swapped) OR (Finish=0);

      END;


   PROCEDURE FindPay(PaymentID:STRING; VAR Found:BOOLEAN);
   VAR I,Start,Finish:INTEGER;
       TempStart,TempFinish:INTEGER;
       NoChange:BOOLEAN;
       Value:INTEGER;
      BEGIN

         RESET(PayFile);
         Start:=0;
         Finish:=50;
         IF FILESIZE(PayFile) <>0 THEN

         BEGIN
            NoChange:=FALSE;
            SortPays;  {Tennants sorted into sequential order}
            Found:=FALSE;
            arrayvalue:=0;
            WHILE (NoChange=FALSE) AND (Found=FALSE) DO {Binary Search}
            BEGIN

            arrayvalue:=ROUND((Start+Finish)/2);

            TempStart:=Start;
            TempFinish:= Finish;

            IF PayArray[arrayvalue].PaymentId < PaymentId  THEN
            Finish:=arrayvalue;

            IF PayArray[arrayvalue].PaymentId > PaymentId  THEN
            Start:=arrayvalue;

            IF PaymentID=PayArray[arrayvalue].PaymentID THEN
            Found:=TRUE;

            IF (TempStart=Start) AND (TempFinish=Finish) THEN
            NoChange:=TRUE;
            END;

         END;
     END;

   PROCEDURE DisplayPayDetails(Pos:LONGINT);
   VAR I,J,K,Year,Month,Day,Wday,NoOwed:LONGINT;
       PreviousCosts:ARRAY[1..5] OF REAL;


         BEGIN

         I:=0; J:=0; K:=0;
         GETDATE(Year,Month,Day,Wday);
         CalculateTotalOwed(NoOwed,Pos,PayArray[Pos].TotalOwed);

         WHILE (I<5) AND (Year-J>2010) DO

         BEGIN

         IF PayArray[Pos].PaymentsMade[Year-J,Month-K]=TRUE THEN

            BEGIN
            I:=I+1;
            PreviousCosts[I]:=PayArray[Pos].PaymentCost[Year-J,Month-K];
            END;
         K:=K+1;
         IF Month-K=0 THEN

            BEGIN
            K:=K-12;
            J:=J+1;
            END;
         END;

         //CLRSCR;
         DRAWBOX(18,1,42,3);
         GOTOXY(20,2);
         WRITE('PayId: '); WRITELN(PayArray[Pos].PaymentID);
         GOTOXY(1,5);
         WRITE(' Current Payment:         '); WRITELN('œ',PayArray[Pos].CurrentPayment:4:2,' ');
         WRITELN;
         WRITE(' Previous  Payments:      '); IF I=0 THEN WRITE('NONE') ELSE
         FOR J:=1 TO I DO WRITE('œ',PreviousCosts[I]:4:2);
         WRITELN;
         WRITELN;
         WRITE(' No Of Payments Owed:     '); WRITELN(NoOwed);
         WRITELN;
         WRITE(' Total Owed:              '); WRITELN(PayArray[Pos].TotalOwed:5:2);
         WRITELN;
         WRITE(' TenantId                 '); WRITELN(PayArray[Pos].TenantId);
         WRITELN;
         IF NoOwed>0 THEN
         BEGIN
         TESTCOLOR(GREEN);
         WRITELN('Press `P` to print out a letter requesting for outstanding payments');

           FOR I :=6 TO 18 DO
         BEGIN
         DRAWBOX(1,4,70,I);
         I:=I+1;

         END;

       END;

   PROCEDURE FindPayDetails(VAR Found:BOOLEAN);
   VAR TempPay:STRING;
       Valid:BOOLEAN;

      BEGIN
         CLRSCR;
         WRITELN('Enter the Pay ID: ');
         REPEAT
         READLN(TempPay);
         ValStrLetNum(TempPay,Valid);
         UNTIL Valid=TRUE;
         TempPay:=UPPERCASE(TempPay);
         FindPay(TempPay,Found);

         IF Found=FALSE THEN
         ErrorMessage('Not Found');

      END;


   PROCEDURE DisplaySearchPay;
   VAR Found:BOOLEAN;
       Pos:LONGINT;

      BEGIN

      FindPayDetails(Found);
      Pos:=ArrayValue;
      IF Found=TRUE THEN
      DisplayPayDetails(Pos);
      READLN;

      END;


   PROCEDURE DisplayAllPay;
   VAR TempPayId:INTEGER;
       Total,Pos:INTEGER;
       Pay:CHAR;
       Print:BOOLEAN;

      BEGIN

         Total:=1;
         Pos:=1;
         WHILE (PayArray[Total].PaymentId <> '0') DO
         Total:=Total+1;

         Total:=Total-1;
         IF Total<>0 THEN
         REPEAT
         CLRSCR;
         GOTOXY(1,25);
         TEXTBACKGROUND(BLUE);
         WRITE('Record ',Pos,' Of ',Total,'     ',#24,#25,' to select Record      `X` to exit     ');
         TEXTBACKGROUND(BLACK);

         DisplayPayDetails(Pos,Print);
         Pay:=UPCASE(READKey);
         IF (Pay=#80) AND (Pos<>Total) THEN Pos:=Pos+1; //Down
         IF (Pay=#72) AND (Pos<>1) THEN Pos:=Pos+-1; //up
         IF (Print=TRUE) AND (Pay='P') THEN

         UNTIL Pay='X'
         ELSE
         Errormessage('No records in the file');


      END;




   PROCEDURE DeletePay;
    VAR Found,Valid:BOOLEAN;
        Value:INTEGER;
        ConfirmDelete:CHAR;
        TempPay:STRING;

      BEGIN

         CLRSCR;
         arrayvalue:=1;
         WRITE('Enter PayID to Delete');
         REPEAT
         REPEAT

         READLN(TempPay);
         ValStrLetNum(TempPay,Valid);

         UNTIL Valid=TRUE;
           IF LENGTH(TempPay)<>6 THEN
               BEGIN
               ErrorMessage('Must be 6 characters in length');
               Valid:=FALSE;
               END;
          UNTIL Valid=TRUE;
         TempPay:=UPPERCASE(TempPay);
         FindPay(TempPay,FOUND);


         IF Found=TRUE THEN

         BEGIN

            WRITELN('Pay found, would you like to delete? Y/N');
            ValidateYN(ConfirmDelete);

            IF ConfirmDelete='Y' THEN

            BEGIN

               PayArray[arrayvalue].PaymentId:='0'; {sets the TenantId of the record to an invalid record}



            SavePayFile(FALSE);
            WRITELN('Deleted');
            READLN;

         END ELSE

         BEGIN

            WRITELN('Not Deleted');
            READLN;

         END;

        END ELSE

        ErrorMessage('Pay Not Found');


    END;



   PROCEDURE CalculateTotalOwed(VAR TotalNo,Pos:LONGINT; VAR TotalCost:REAL);
      VAR I,J,Year,Month,Day,WDay,X:LONGINT;
          TempYear,TempMonth:STRING;


      BEGIN
      TotalCost:=0;
      TotalNo:=0;
      X:=1;
      GetDate(Year,Month,Day,WDay);

      FOR I:=1 TO 50 DO
      BEGIN
         OutStandingPayments[I]:=0;  //Reset Arrays
         OutStandingPaymentsDate[I]:='0';
      END;

      FOR I:=PayArray[Pos].YearStarted TO Year DO

      BEGIN
      IF (I=PayArray[Pos].YearStarted) AND (I=Year) THEN BEGIN
        FOR J:=PayArray[Pos].MonthStarted TO Month DO
            IF PayArray[Pos].PaymentsMade[I,J] =FALSE THEN
              BEGIN

              TotalNo:=TotalNo+1;

              TotalCost:=TotalCost+PayArray[Pos].PaymentCost[I,J];
              Str(I,TempYear);
              TempMonth:=StrMonth(J);

              OutstandingPayments[X]:=PayArray[Pos].PaymentCost[I,J];
              OutStandingPaymentsDate[X]:=TempMonth+' '+TempYear;
              X:=X+1;
              END;
              END;

      IF (I=PayArray[Pos].YearStarted) AND (I<>Year) THEN BEGIN
         FOR J:=PayArray[Pos].MonthStarted TO 12 DO
            IF PayArray[Pos].PaymentsMade[I,J] =FALSE THEN
             BEGIN
             TotalNo:=TotalNo+1;

             TotalCost:=TotalCost+PayArray[Pos].PaymentCost[I,J];
               Str(I,TempYear);
              TempMonth:=StrMonth(J);

              OutstandingPayments[X]:=PayArray[Pos].PaymentCost[I,J];
              OutStandingPaymentsDate[X]:=TempMonth+' '+TempYear;
             X:=X+1;
             END;
             END;


       IF (I<>PayArray[Pos].YearStarted) AND (I=Year) THEN BEGIN
         FOR J:=1 TO Month DO
            IF PayArray[Pos].PaymentsMade[I,J] =FALSE THEN
             BEGIN
             TotalNo:=TotalNo+1;

             TotalCost:=TotalCost+PayArray[Pos].PaymentCost[I,J];
               Str(I,TempYear);
              TempMonth:=StrMonth(J);

              OutstandingPayments[X]:=PayArray[Pos].PaymentCost[I,J];
              OutStandingPaymentsDate[X]:=TempMonth+' '+TempYear;
             X:=X+1;
             END;
             END;

     IF (I<>PayArray[Pos].YearStarted) AND (I<>Year) THEN BEGIN
        FOR J:=1 TO 12 DO
            IF PayArray[Pos].PaymentsMade[I,J] =FALSE THEN
             BEGIN
             TotalNo:=TotalNo+1;

             TotalCost:=TotalCost+PayArray[Pos].PaymentCost[I,J];
               Str(I,TempYear);
              TempMonth:=StrMonth(J);

              OutstandingPayments[X]:=PayArray[Pos].PaymentCost[I,J];
              OutStandingPaymentsDate[X]:=TempMonth+' '+TempYear;
             X:=X+1;
             END;
             END;
             END;


        PayArray[ArrayValue].TotalOwed:=TotalCost;

    END;


   PROCEDURE DisplayMainOwed;
    VAR I,NoOwed:LONGINT;
        Cost:REAL;

       BEGIN
       I:=1;
       Cost:=0;
       NoOwed:=0;

       WHILE (PayArray[I].PaymentId <> '0') AND (I<51) DO
          BEGIN
          CalculateTotalOwed(NoOwed,I,Cost);
          IF NoOwed>0 THEN WRITELN(NoOwed,' Payments owed from Tenant ',PayArray[I].TenantId,' Total owed: œ',Cost:5:2);
          I:=I+1;
          END;

       END;

   PROCEDURE AmendPreviousCosts(New:BOOLEAN);
   VAR TempYear,TempMonth1,TempMonth2,TempCost:STRING;
       Year,Month1,Month2,Y,M:LONGINT;
       NewCost:REAL;
       Valid:BOOLEAN;
       Choice:CHAR;

      BEGIN
      Valid:=FALSE;
      REPEAT
      WRITELN('Enter the Year which you wish to amend');
      READLN(TempYear);
      ValidateYear(TempYear,Valid,Year);
      IF Valid=FALSE THEN ErrorMessage('Year must be a 4 digit integer');
      UNTIL Valid=TRUE;
      REPEAT
      WRITELN('Enter the start Month in which you wish to amend (1-12)');
      READLN(TempMonth1);
      ValidateMonth(TempMonth1,Valid,Month1);
      IF Valid=FALSE THEN ErrorMessage('Month must be an integer between 1 and 12');
      UNTIL Valid=TRUE;
      WRITELN('Enter the End Month in which you wish to amend');
      WRITELN('(enter a month equal to or greater than the previously entered month)');

      REPEAT
         REPEAT

            READLN(TempMonth2);
            ValidateMonth(TempMonth2,Valid,Month2);
            IF Valid=FALSE THEN ErrorMessage('Month must be an integer between 1 and 12');

         UNTIL Valid=TRUE;

         IF Month2 < Month1 THEN ErrorMessage('Month must be greater than the previous month');
         Valid:=FALSE;

      UNTIL Valid=TRUE;

      REPEAT
      REPEAT
      REPEAT;
         WRITELN('Enter new monthly payment for the dates selected');
         WRITE('œ');
         READLN(TempCost);
         ValidateReal(TempCost,Valid,NewCost);

      UNTIL Valid=TRUE;
         IF NewCost<0 THEN
            BEGIN
            ErrorMessage('Cannot be a negative value');
            Valid:=FALSE;
            END;
       UNTIL Valid=TRUE;
         IF NewCost>1000 THEN
            BEGIN
            WRITELN; WRITELN('The New Payment: œ',NewCost:4:2,' is abnomrally large');
            WRITELN('Are you sure this is correct? (Y/N)');
            Choice:=UPCASE(READKEY);
            ValidateYN(Choice);
            IF Choice='N' THEN Valid:=FALSE;
            END;
     UNTIL Valid=TRUE;

      WRITELN('You are about to change the payments for:');
      WRITELN('    ',TempMonth1,' ',TempYear,' To ',TempMonth2,' ',TempYear);
      WRITELN('    To a cost of:',(NewCost));
      WRITELN;
      WRITELN('Are you sure you wish to do this? (Y/N)');
      Choice:=UPCASE(READKEY);
      ValidateYN(Choice);
      IF Choice='Y' THEN

         FOR M:=Month1 TO Month2 DO
      PayArray[ArrayValue].PaymentCost[Year,M]:=NewCost;


      SavePayFile(FALSE);
    END;



   PROCEDURE AmendNewCosts(New:BOOLEAN);
   VAR I:LONGINT;
       TempPay,TempPay1,TempPay2:STRING;
       Valid:BOOLEAN;
       Choice:CHAR;
       NewPay:REAL;
       NewPay1,NewPay2:LONGINT;

      BEGIN
      REPEAT
      REPEAT
      REPEAT
      REPEAT
      IF New=FALSE THEN
      WRITELN('The Current Cost is: œ',PayArray[ArrayValue].CurrentPayment);
      WRITELN('Enter new cost per month of rent in œ');
      READLN(TempPay1);
      ValidateInt(TempPay1,Valid,NewPay1);
      UNTIL Valid=TRUE;
      WRITELN('Enter cost per month in Pence:');
      READLN(TempPay2);
      ValidateInt(TempPay2,Valid,NewPay2);
      IF LENGTH(TempPay2) >2 THEN
      BEGIN
      ErrorMessage('Must be 1-2 digits in length');
      Valid:=FALSE;
      END;
      UNTIL Valid=TRUE;
      NewPay:=NewPay1+(NewPay2/100);
         IF NewPay<0 THEN
            BEGIN
            ErrorMessage('Cannot be a negative value');
            Valid:=FALSE;
            END;
            UNTIL Valid=TRUE;
      IF NewPay>1000 THEN
      BEGIN
         WRITELN('The new cost of œ',NewPay,' seems abnormally large');
         WRITELN;
         WRITELN('Are you sure that it is correct? (Y/N)');
         Choice:=UPCASE(READKEY);
         ValidateYN(Choice);
         IF Choice='N' THEN Valid:=FALSE;
     END;
     UNTIL Valid=TRUE;

      WRITELN('Would you like to change the old cost of rent per month: œ',PayArray[ArrayValue].CurrentPayment:4:2);
      WRITELN('                                                     To: œ',NewPay:4:2,'?');

      ValidateYN(Choice);
      IF Choice='Y' THEN
      PayArray[ArrayValue].CurrentPayment:=NewPay;
      END;




   PROCEDURE UpdatePayments(OldYear,OldMonth,NewDay,NewMonth,NewYear:LONGINT);
     VAR TempDay,TempMonth,TempYear,Length:LONGINT;
         TempPayment:REAL;
     Passed:BOOLEAN;

      BEGIN

      TempDay:=DaysInMonth(NewYear,NewMonth);
      CalculateDateLength(NewYear,NewMonth,NewYear,NewMonth,NewDay,TempDay,Passed,Length);
      IF Length<> 0 THEN
      BEGIN
      TempPayment:=PayArray[ArrayValue].CurrentPayment/Length;
      PayArray[ArrayValue].PaymentCost[NewYear,NewMonth]:=TempPayment;
      END ELSE
      PayArray[ArrayValue].PaymentCost[NewYear,NewMonth]:=0;

      IF NewMonth=12 THEN  //If the month is 12 set the year to the next one
      PayArray[ArrayValue].PaymentCost[NewYear+1,1]:=PayArray[ArrayValue].CurrentPayment
      ELSE
      PayArray[ArrayValue].PaymentCost[NewYear,NewMonth+1]:=PayArray[ArrayValue].CurrentPayment;

      IF New=FALSE THEN   //If not creating a new record then take the old start date and change the cost
      PayArray[ArrayValue].PaymentCost[OldYear,OldMonth]:=PayArray[ArrayValue].CurrentPayment;
      END;


   PROCEDURE AmendDateStarted(New:BOOLEAN);
   VAR TempYear,TempMonth,TempDay,StrCurrentYr,PreviousDate:STRING;
       Year,Month,Day,CurrentYr,CurrentMnth,CurrentDay,CurrentWDay:LONGINT;
       Valid:BOOLEAN;

      BEGIN

      IF New=FALSE THEN
      BEGIN
      WITH PayArray[ArrayValue] DO
      ObtainDate(YearStarted,MonthStarted,DayStarted,PreviousDate);
      WRITELN('The Current Date The Tenant Moved in is: ',PreviousDate);
      END;
      GetDate(CurrentYr,CurrentMnth,CurrentDay,CurrentWDay);
      Str(CurrentYr,StrCurrentYr);
      REPEAT
      REPEAT
      WRITELN('Enter the Year that the Tenant moved in');
      READLN(TempYear);
      ValidateYear(TempYear,Valid,Year);
      IF Valid=FALSE THEN ErrorMessage('Must be a 4 digit integer');
      UNTIL Valid=TRUE;
      If (Year>CurrentYr) OR (Year<2011) THEN
      BEGIN
      Valid:=FALSE;
      ErrorMessage('Year must be between 2011 and '+StrCurrentYr);
      END;
      UNTIL Valid=TRUE;

      REPEAT
      WRITELN('Enter the Month that the Tenant moved in');
      Readln(TempMonth);
      ValidateMonth(TempMonth,Valid,Month);
      IF Valid=FALSE THEN ErrorMessage('Must be a number from 1 to 12');
      UNTIL Valid=TRUE;

      REPEAT
      WRITELN('Enter the Day that the Tenant moved in');
      READLN(TempDay);
      ValidateDay(TempDay,TempMonth,TempYear,Valid,Day);
      UNTIL Valid=TRUE;

      IF New=FALSE THEN
      UpdatePayments(0,0,Year,Month,Day)
      ELSE
      UpdatePayments(PayArray[ArrayValue].YearStarted,PayArray[ArrayValue].MonthStarted,Year,Month,Day);

      PayArray[ArrayValue].YearStarted:=Year;
      PayArray[ArrayValue].MonthStarted:=Month;
      PayArray[ArrayValue].DayStarted:=Day;
      SavePayFile(FALSE);
      END;


   PROCEDURE UpdatePaymentsMade;
   VAR TempYear,TempMonth,StrStartMonth:STRING;
       Year,Month:LONGINT;
       Key:CHAR;
       Valid:BOOLEAN;

         BEGIN

         REPEAT
         REPEAT
         WRITELN('Select the year in which you wish to amend');
         READLN(TempYear);
         ValidateYear(TempYear,Valid,Year);
         IF Valid=FALSE THEN Errormessage('Must be a 4 digit integer');
         UNTIL Valid=TRUE;
         IF Year<PayArray[ArrayValue].YearStarted THEN BEGIN
         ErrorMessage('Must be greater than '+TempYear);
         Valid:=FALSE;
         END;
         UNTIL Valid=TRUE;

         REPEAT
         WRITELN('Select the month in which you wish to amend');
         READLN(TempMonth);
         ValidateMonth(TempMonth,Valid,Month);
         IF Valid=FALSE THEN ErrorMessage('Must be a number from 1 to 12');
         UNTIL Valid=TRUE;
         IF (Year=PayArray[ArrayValue].YearStarted) AND (Month<PayArray[ArrayValue].MonthStarted)
         THEN BEGIN
         Str(PayArray[ArrayValue].MonthStarted,StrStartMonth);
         ErrorMessage('Month for this year cannot be lower than '+StrStartMonth);
         Valid:=FALSE;
         END;
         WRITELN('Has the Tenant paid for the month: ',StrMonth(Month),' ',Year,'? (Y/N)');
         ValidateYN(Key);
         IF Key='Y' THEN PayArray[ArrayValue].PaymentsMade[Year,Month]:=TRUE;
         IF Key='N' THEN PayArray[ArrayValue].PaymentsMade[Year,Month]:=FALSE;
         SavePayFile(FALSE);
         END;


   PROCEDURE AmendPayId;
   VAR NewpayId:STRING;
       Valid:BOOLEAN;
       I:LONGINT;

     BEGIN
       CLRSCR;
         WRITELN('Enter PayId');
         WRITELN('(6 Characters long)');
         REPEAT

         READLN(NewPayid);
         ValStrLetNum(NewPayid,Valid);
         IF LENGTH(NewPayid) <> 6 THEN
            BEGIN
               ErrorMessage('Must be 6 characters');
               Valid:=FALSE;
            END;

         UNTIL Valid=TRUE;
         PayArray[I].PaymentId:=NewPayId;

         SavePayFile(FALSE);
       END;


   PROCEDURE AmendTenantId;

   VAR I,J,Pos,MaxPos:LONGINT;
       SearchArray:ARRAY[1..50] OF STRING;
       TempId:STRING;
       Found:BOOLEAN;

   BEGIN

      I:=1;
      Pos:=1;

      BEGIN

        WHILE (TenantArray[Pos].TenantId<>'0') AND (Pos<51) DO

         BEGIN

               SearchArray[Pos]:=TenantArray[Pos].TenantId;
               Pos:=Pos+1;      {add 1 to the total number of available tenants}

            END;


         END;

         IF Pos=1 THEN  {If no available tenants}
         ErrorMessage('No available tenants') ELSE

         BEGIN

            MaxPos:=Pos;
            FOR Pos:=1 TO MaxPos DO
            WRITELN(SearchArray[Pos]);
            WRITELN;
            WRITELN('Enter 1 of the above tenant Id`s to use');
            READLN(TempId);
            TempId:=UPPERCASE(TempId);
            Pos:=1;

               WHILE (TempId<>SearchArray[Pos]) AND (Pos<>MaxPos) DO
                  Pos:=Pos+1;

            IF TempId=SearchArray[Pos] THEN Found:=TRUE ELSE
            Found:=FALSE;

            IF Found=TRUE THEN

               BEGIN

               PayArray[ArrayValue].tenantId:=SearchArray[Pos];

               J:=1;
               WHILE SearchArray[Pos] <> TenantArray[J].TenantId DO {Already know the tenant exists}
               J:=J+1;                                         {so find position}

               TenantArray[J].PaymentId:=PayArray[ArrayValue].PaymentId;

               SaveTenantFile(FALSE);
               SavePayFile(FALSE);

               END;



         END;



      END;




   PROCEDURE AmendPay(New:BOOLEAN);
   VAR
       TempPay:STRING;
       Found,Valid,AllFilled:BOOLEAN;
       FieldChoice:CHAR;
       I:LONGINT;


     BEGIN




         CLRSCR;
         arrayvalue:=1;
         WRITELN('Enter Pay Id To Amend');

         READLN(TempPay);


         FindPay(TempPay,FOUND);
         IF Found=TRUE

         THEN BEGIN

        REPEAT
        CLRSCR;
        WRITELN('Select Field To Amend');
        WRITELN('1: PaymentId');
        WRITELN('2: Payments Made');
        WRITELN('3: Start Date');
        WRITELN('4: Current Cost');
        WRITELN('5: Previous Costs');
        WRITELN('6: tenant Id');
        WRITELN('7: PrintOut test');




        FieldChoice:=UPCASE(READKEY);


        CASE FieldChoice OF
        '1':AmendPayId;
        '2':UpdatePaymentsMade;
        '3':AmendDateStarted;
        '4':AmendNewCosts;
        '5':AmendPreviousCosts;
        '6':AmendtenantId;
        '7':PrintOut;

        'X':;
        ELSE
        ErrorMessage('Only enter digits 1-6 OR X');
        END;



        END
        ELSE ErrorMessage('Pay Record Not Found');


     END;


   PROCEDURE AddPay;
   VAR I:INTEGER;
       Full,Valid:BOOLEAN;
       NewPayId:STRING;
       New:BOOLEAN;

         BEGIN
         I:=1;
         WHILE (I<51) AND (Full=TRUE) DO
         IF PayArray[I].PaymentId = '0' THEN Full:=FALSE
         ELSE I:=I+1;

         IF Full=TRUE THEN

         BEGIN

            WRITE('All Records have been filled, no remaining space is');
            WRITELN(' available. Please delete a record to add a new one.');
            READLN;


         END ELSE

         BEGIN
         I:=I-1;
         ArrayValue:=I;
         New:=TRUE;

         AmendPayId(New);
         UpdatePaymentsMade(New);
         AmendDateStarted(New);
         AmendNewCosts(New);
         AmendPreviousCosts(New);
         AmendtenantId(New);

         WRITELN('New Pay with Pay Id ',PayArray[I].PaymentID,' has been created');
         WRITELN;

         SavePayFile(FALSE);
         READLN;


         END;

      END;


    PROCEDURE PrintOut;
      VAR Carryon:BOOLEAN;
       Year,Month,Day,I:LONGINT;
       DateStr:STRING;
       X:REAL;


      BEGIN
         CalculateTotalOwed(FALSE,ArrayValue,I,X);
         ObtainDate(Year,Month,Day,DateStr);
         Carryon:=STARTPRINT;
         I:=1;
         FOR I:=1 to 10 DO
         BEGIN
         WRITELN(OutStandingPaymentsDate[I]);
         WRITELN(OutStandingPayments[I]);
         END;

         IF (Carryon) THEN

         WITH TenantArray[ArrayValue] DO

         BEGIN

            PRINTLN('                                                                          Oakhill Lettings');
            PRINTLN('                                                                   153 Midsummer Boulevard');
            PRINTLN('                                                                             Milton Keynes');
            PRINTLN('                                                                                   MK9 461');
            PRINTLN('');
            PRINTLN('                                                                                 '+DateStr);
            PRINTLN('');
            IF Gender='M' THEN
            PRINTLN('Mr '+Forename+' '+Surname) ELSE
            PRINTLN('Ms '+Forename+' '+Surname);
            PRINTLN(HouseNum+' '+Street);
            PRINTLN(City);
            PRINTLN(PostCode);
            PRINTLN('');
            PRINTLN('TennantId: '+'Ten123'{TenantId});
            PRINTLN('PaymentId: '+'Pay123'{PaymentId});
            PRINTLN('');
            PRINTLN('                  IMPORTANT INFORMATION REGARDING PAYMENTS');
            PRINTLN('');
            IF Gender='M' THEN
            PRINTLN('Dear Mr '+Forename+' '+Surname) ELSE
            PRINTLN('Dear Ms '+Forename+' '+Surname);
            PRINTLN('It has come to our attention that you are overdue on making payments ');//for the');
        //    PRINTLN('following date(s):');
        //    PRINTLN('');
         //   PRINTLN('');
         //   PRINTLN('  Date             PaymentCost(Pounds)');
         //   PRINTLN('  ____             ___________________');

            END;

      //      WHILE (OutstandingPayments[I] <> 0) AND (I<51) DO

      //         BEGIN

      //         PRINT(' '+OutStandingPaymentsDate[I]+'          ');
     //          PRINTRealLn(OutStandingPayments[I],4,2);
     //          I:=I+1;

     //          END;

           PRINTLN('');
           PRINTLN('');
           PRINT('Totaling');//TotalOwed: ');
           PRINTREAL(PayArray[ArrayValue].TotalOwed,5,2);
           PRINTLN('');
           PRINTLN('');
           PRINT('We request you make the full payments for ');
           PRINTREAL(PayArray[ArrayValue].TotalOwed,5,2);
           PRINTLN('(Pounds) by 14 days of the date of ');
           PRINTLN('this letter being sent');
           PRINTLN('');
           PRINTLN('In the case that the payment isn`t made, we will be forced to take further action');
           PRINTLN('');
           PRINTLN('Please disregard this letter if you have made the payment(s)');
           PRINTLN('');
           PRINTLN('If you have any problems contact us on out number 01908 537543 or talk to one of our');
           PRINTLN('employees in the agency by visiting the address on the top of this letter');
           PRINTLN('');
           PRINTLN('Thank you for your co-operation');
           PRINTLN('');
           PRINTLN('Yours Faithfully');
           PRINTLN('');
           PRINTLN(''); //Space for signature
           PRINTLN('');
           PRINTLN('Harry Turner');
           PRINTLN('Head of Oakhill Lettings Agency');



   ENDPRINT;

    END;

   END.

