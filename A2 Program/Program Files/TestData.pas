PROGRAM LOAD;

 USES TENANTDAT,PROPERTYDAT,LANDLORDDAT,PAYMENTDAT,CRT;

 TYPE DataRecord= RECORD

                   LastDate:STRING;
                   LastTime:STRING;
                   LastBackup:STRING;

                 END;


  VAR  DataRec:DataRecord;
       DataFile: FILE OF DataRecord;
       DriveLetter:CHAR;
       I:INTEGER;


  PROCEDURE SelectDrive;
  VAR Valid:BOOLEAN;
     BEGIN
       Valid:=FALSE;
        WRITELN('Enter Drive Letter to load the files to (A-Z)');
        REPEAT
        DriveLetter:=UPCASE(READKEY);
        IF (DriveLetter <'A') OR (DriveLetter >'Z') THEN

           BEGIN

              Valid:=FALSE;
              WRITELN('Error, must be between A and Z');

           END ELSE

           Valid:=TRUE;


        UNTIL Valid=TRUE;

     END;




  PROCEDURE CreateTenantFile;
  VAR I:INTEGER;
    BEGIN
       I:=1;
       ASSIGN(TenantFile,DriveLetter+':\MainProgram\Files\TenantDet.DTA');
       REWRITE(TenantFile);
    WITH Tenant DO
       BEGIN

          TenantId:='TEN123';
          Surname:='Jenkins';
          Forename:='James';
          Gender:='M';
          DayOfBirth:=1;
          MonthOfBirth:=2;
          YearOfBirth:=1973;
          HouseNum:='5';
          Street:='Maple Street';
          City:='SpringField';
          PhoneNum:='01987 654345';
          PostCode:='SP4 2FD';
          PropertyId:='PROP12';
          PaymentId:='PAY123';

          WRITE(TenantFile,Tenant);

          TenantId:='TEN456';
          Surname:='Jones';
          Forename:='Sarah';
          Gender:='F';
          DayOfBirth:=13;
          MonthOfBirth:=11;
          YearOfBirth:=1987;
          HouseNum:='25';
          Street:='Port Drive';
          City:='Manchester';
          PhoneNum:='01384 355940';
          PostCode:='MA9 3WR';
          PropertyId:='PROP13';
          PaymentId:='PAY456';

          WRITE(TenantFile,Tenant);

          TenantId:='TEN789';
          Surname:='Florence';
          Forename:='Bill';
          Gender:='M';
          DayOfBirth:=10;
          MonthOfBirth:=2;
          YearOfBirth:=1990;
          HouseNum:='Silburry House';
          Street:='Jilberry Lane';
          City:='Brighton';
          PhoneNum:='01439 756693';
          PostCode:='BR2 6DF';
          PropertyId:='PROP14';
          PaymentId:='PAY789';

          WRITE(TenantFile,Tenant);

          WRITELN('Tenant File Created..');


       END;

          CLOSE(Tenantfile);
    END;


  PROCEDURE CreatePropFile;
  VAR I:INTEGER;
     BEGIN
       I:=1;
       ASSIGN(PropFile,DriveLetter+':\MainProgram\Files\PropData.DTA');
       REWRITE(PropFile);
       WITH Prop DO


          BEGIN

             PropertyId:='PROP12';
             PropertyAvailable:=TRUE;
             TotalKeys:=3;
             KeysTaken:=1;
             LandLordId:='LORD12';
             TenantId:='TEN123';

             WRITE(PropFile,Prop);

             PropertyId:='PROP13';
             PropertyAvailable:=FALSE;
             TotalKeys:=1;
             KeysTaken:=0;
             LandLordId:='LORD13';
             TenantId:='TEN456';

             WRITE(PropFile,Prop);

             PropertyId:='PROP14';
             PropertyAvailable:=TRUE;
             TotalKeys:=5;
             KeysTaken:=3;
             LandLordID:='LORD14';
             TenantId:='TEN789';

             WRITE(PropFile,Prop);

             WRITELN('Property File Created');

          END;

          Close(PropFile);
     END;




      PROCEDURE CreateLandLordFile;
  VAR I:INTEGER;
     BEGIN
       I:=1;
       ASSIGN(LandLordFile,DriveLetter+':\MainProgram\Files\LandLordDet.DTA');
       REWRITE(LandLordFile);
       WITH lan DO


          BEGIN

             LandLordId  :='LORD12';
             Surname     :='Michelin';
             Forename    :='James';
             Gender      :='M';
             DayOfBirth  :=10;
             MonthOfBirth:=3;
             YearOfBirth :=1967;
             HouseNum    :='2';
             Street      :='Cookson lane';
             City        :='Milton Keynes';
             PhoneNum    :='01908 644732';
             Postcode    :='MK2 4JG';
             Properties[1]:='PROP15';
             Properties[2]:='PROP16';
             Properties[3]:='PROP17';
             FOR I:= 4 TO 10 DO
             Properties[I]:='0';
             WRITE(LandLordFile,Lan);



             LandLordId  :='LORD13';
             Surname     :='Boyle';
             Forename    :='Jess';
             Gender      :='F';
             DayOfBirth  :=23;
             MonthOfBirth:=7;
             YearOfBirth :=1959;
             HouseNum    :='6';
             Street      :='Ravendale Close';
             City        :='Milton Keynes';
             PhoneNum    :='01908 856403';
             Postcode    :='MK8 3FK';
             Properties[1]:='PROP12';
             Properties[2]:='PROP13';
             Properties[3]:='PROP14';
             FOR I:= 4 TO 10 DO
             Properties[I]:='0';
             WRITE(LandLordFile,Lan);

             LandLordId  :='LORD14';
             Surname     :='Hull';
             Forename    :='Jake';
             Gender      :='M';
             DayOfBirth  :=8;
             MonthOfBirth:=3;
             YearOfBirth :=1990;
             HouseNum    :='45';
             Street      :='Stoke Lane';
             City        :='Liverpool';
             PhoneNum    :='01762 487539';
             Postcode    :='LP2 9DS';
             Properties[1]:='PROP21';
             Properties[2]:='PROP22';
             FOR I:= 3 TO 10 DO
             Properties[I]:='0';
             WRITE(LandLordFile,Lan);





             WRITELN('LandLord File Created');

          END;

          Close(LandLordFile);
     END;



  PROCEDURE CreatePaymentFile;
  VAR I:INTEGER;

     BEGIN
        ASSIGN(PayFile,DriveLetter+':\MainProgram\Files\PaymentFile.DTA');
        REWRITE(PayFile);

        WITH Pay DO

           BEGIN
              PaymentId:='PAY123';
              TenantId:='TEN123';
              CurrentPayment:=603.1;
              TotalOwed:=1342.5;
              YearStarted:=2011;
              MonthStarted:=1;
              DayStarted:=3;
              PaymentCost[2011,1]:=304.6;
              PaymentCost[2011,2]:=603.1;
              PaymentCost[2011,3]:=603.1;
              PaymentCost[2011,4]:=603.1;
              PaymentsMade[2011,1]:=TRUE;
              PaymentsMade[2011,2]:=FALSE;
              PaymentsMade[2011,3]:=FALSE;
              PaymentsMade[2011,4]:=TRUE;
              DateLetterSent:='17/03/2011';

              WRITE (PayFile,Pay);


              PaymentId:='PAY456';
              TenantId:='TEN456';
              CurrentPayment:=508.1;
              TotalOwed:=342.5;
              YearStarted:=2011;
              MonthStarted:=1;
              DayStarted:=10;
              PaymentCost[2011,1]:=217.6;
              PaymentCost[2011,2]:=508.1;
              PaymentCost[2011,3]:=508.1;
              PaymentCost[2011,4]:=508.1;
              PaymentsMade[2011,1]:=FALSE;
              PaymentsMade[2011,2]:=FALSE;
              PaymentsMade[2011,3]:=TRUE;
              PaymentsMade[2011,4]:=FALSE;
              DateLetterSent:='10/02/2011';

              WRITE (PayFile,Pay);

              PaymentId:='PAY789';
              TenantId:='TEN789';
              CurrentPayment:=629.1;
              TotalOwed:=0;
              YearStarted:=2011;
              MonthStarted:=2;
              DayStarted:=10;
              PaymentCost[2011,2]:=314.6;
              PaymentCost[2011,3]:=629.1;
              PaymentCost[2011,4]:=629.1;
              PaymentsMade[2011,2]:=TRUE;
              PaymentsMade[2011,3]:=TRUE;
              PaymentsMade[2011,4]:=TRUE;
              DateLetterSent:='';

              WRITE (PayFile,Pay);
            END;
              CLOSE(PayFile);

              END;



  PROCEDURE CreateDataFile;
  VAR I:INTEGER;

     BEGIN
        ASSIGN(DataFile,DriveLetter+':\MainProgram\Files\DataFile.DTA');
        REWRITE(DataFile);

        WITH DataRec DO

           BEGIN

           LastDate:='01/01/2011';
           LastTime:='00:00:00 AM';
           LastBackup:='01/01/2011';

           WRITE(DataFile,DataRec);

       WRITELN('DataFile Created');
     END;

           CLOSE(DataFile);

     END;
 BEGIN
 SelectDrive;
 CreateTenantFile;
 CreatepropFile;
 CreateLandLordFile;
 CreatePaymentFile;
 CreateDataFile;
 WRITELN('Files created, Press Enter to exit ');
 READLN;
 END.

