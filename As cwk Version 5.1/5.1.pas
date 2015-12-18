 PROGRAM MaintainBookings;
   USES
       WINDOWS,CRT,SYSUTILS,BOOKDAT;


   VAR
      Book           :BookingInfo;
      BookingFile    :FILE OF BookingInfo;
      hWindow        :hWnd;
      DC             :hDC;



   PROCEDURE ValidateBooking(Change:STRING);FORWARD;



   PROCEDURE SaveFile;
      BEGIN

         SEEK(BookingFile, FILEPOS(BookingFile) -1);
         WRITE(BookingFile,Book);

      END;


   PROCEDURE AssignBookingNo;
   VAR Part1:STRING;
       Part2:STRING;
       Part3:STRING;
       I: INTEGER;

      BEGIN

         Part1:='';
         Part2:='';
         Part3:='';
         FOR I:= 1 TO 3 DO

            Part1:= Part1 + Book.Surname[I];

         FOR I:=  1 TO 4 DO

            Part2:= Part2+Book.PostCode[I];

         Part3:=Part1+Part2;
         Book.BookingNo:=UPPERCASE(Part3); TEXTCOLOR(YELLOW);
         WRITELN;
         WRITELN('BookingNo has changed to ',Book.BookingNo);
         WRITELN('Press Any Key to continue...'); TEXTCOLOR(WHITE);
         READKEY;
      END;



   PROCEDURE ConfirmSurname(TempString:STRING);
      BEGIN

         Book.Surname:=TempString;
         SEEK(BookingFile, FILEPOS(BookingFile) -1);
         WRITE(BookingFile, Book);
         AssignBookingNo;

      END;



   PROCEDURE ConfirmPostCode(TempString:STRING);
      BEGIN

         Book.PostCode:=TempString;
         SEEK(BookingFile, FILEPOS(BookingFile) -1);
         WRITE(BookingFile,Book);
         AssignBookingNo;

      END;



   PROCEDURE YesOrNoValidate(VAR Choice:CHAR);
      BEGIN

         REPEAT

            Choice:=UPCASE(READKEY);
            IF (Choice <> 'Y') AND (Choice <> 'N') THEN

               BEGIN                       TEXTCOLOR(RED);

                  WRITELN;
                  WRITELN('Error - Invalid character you entered: ',Choice);
                  WRITELN('Please enter either Y or N');  TEXTCOLOR(WHITE);

               END;

         UNTIL (Choice ='Y') OR (Choice ='N');

      END;


   PROCEDURE IntegerValidate(VAR TempNewInt:INTEGER);
   VAR ErrorString:STRING;
       ErrorVal:INTEGER;

      BEGIN

         REPEAT

            READLN(ErrorString);
            VAL(ErrorString, TempNewInt, ErrorVal);
            IF (ErrorVal <> 0) THEN

               BEGIN

                  TEXTCOLOR(RED);
                  WRITE('Error you entered an illegal character: ');
                  WRITE(ErrorString);
                  WRITELN(' - Must be an integer number value');
                  WRITELN;
                  TEXTCOLOR(WHITE);

               END;
           IF (TempNewInt <0) AND (ErrorVal=0) THEN
           BEGIN
           TEXTCOLOR(RED);
           WRITELN('Error number has to be positive, you entered: ',TempNewInt);
           TEXTCOLOR(WHITE);
           ErrorVal:=1;
           END;
         UNTIL ErrorVal = 0;


      END;

   PROCEDURE PhoneNoValidate(VAR TempPhone:STRING;VAR Loop:BOOLEAN);
   VAR I:INTEGER;

      BEGIN

         I:=LENGTH(TempPhone);
         IF I <> 11 THEN

            BEGIN

               TEXTCOLOR(RED);
               WRITELN('Error, phone number length should be of 11');
               Loop:=TRUE;
               TEXTCOLOR(WHITE);

            END;

         FOR I:= 1 TO LENGTH(TempPhone) DO

            IF (TempPhone[I]<#48) OR (TempPhone[I]>#58) THEN

               BEGIN

                  TEXTCOLOR(RED);
                  WRITELN('Error you entered:',TempPhone);
                  WRITE('Please only enter characters 0-9');
                  Loop:=TRUE;
                  TEXTCOLOR(WHITE);

               END;

      END;


   PROCEDURE ValidateStringLetters(VAR TempString:STRING;VAR Loop:BOOLEAN);
   VAR I:INTEGER;

      BEGIN

         FOR I:= 1 TO LENGTH(TempString) DO

            IF (TempString[I]<#65)  OR (TempString[I]>#90) THEN

               BEGIN

                  WRITELN('Error you entered:',TempString);
                  WRITE('Please only enter characters A-Z');
                  Loop:=TRUE;

               END;

      END;



   PROCEDURE PostCodeValidate(PostCode:STRING;VAR Loop:BOOLEAN);
   VAR I:INTEGER;

      BEGIN

          IF ((LENGTH(PostCode)<3) OR (LENGTH(PostCode)>7)) THEN

             BEGIN                    TEXTCOLOR(RED);

                 WRITELN('Error - must be between 3 and 7 Characters Long');
                 Loop:=True;  TEXTCOLOR(WHITE);

             END
             ELSE Loop:=FALSE;

      END;



   PROCEDURE ValidateString(VAR TempString:STRING;StringName:STRING);
   VAR I:INTEGER;
      Loop:BOOLEAN;
      TempNewString:STRING;

      BEGIN

         REPEAT

            REPEAT

               READLN(TempString);
               TempNewString:=UPPERCASE(tempstring);
               FOR I:= 1 TO LENGTH(TempNewString)DO

                  IF (TempNewString[I]<#48) OR (TempNewString[I]>#57)
                  AND ((TempNewString[I]<#65)  OR (TempNewString[I]>#90)) THEN

                     BEGIN                                                        TEXTCOLOR(RED);

                        WRITE('Error invalid Character(s) entered');
                        WRITELN(' - Must only contain characters A-Z OR 0-9');    TEXTCOLOR(GREEN);
                        WRITE('Please Re-Enter',StringName,':');                   TEXTCOLOR(WHITE);

                        Loop:= TRUE
                     END
                     ELSE Loop:=FALSE;

            UNTIL Loop=FALSE;

            IF (StringName='CityOrTown') OR (StringName='Street')
            OR (StringName='County') THEN

               ValidateStringLetters(TempNewString,Loop);

            IF (StringName='PostCode') THEN

               PostCodeValidate(TempNewString,Loop);

            IF(StringName='Phone') THEN

               PhoneNoValidate(TempNewString,Loop);

         UNTIL Loop=FALSE;

     END;




  PROCEDURE CharValidate(FieldName:STRING;VAR TempChar:CHAR);

     BEGIN

        REPEAT

           WRITELN;
           TempChar:=UPCASE(READKEY);
           IF ((TempChar <> 'F') AND (TempChar <> 'M')) AND (FieldName='Gender') THEN

              BEGIN

                 TEXTCOLOR(RED);
                 WRITELN;
                 WRITELN('Error - Invalid character you entered: ',TempChar);
                 WRITELN('Please enter either F or M');
                 READLN;

              END;

           IF ((TempChar <> 'D') AND (TempChar <> 'N')) AND (FieldName='DayNight')  THEN

              BEGIN

                 TEXTCOLOR(RED);
                 WRITELN;
                 WRITELN('Error - Invalid character you entered: ',TempChar);
                 WRITELN('Please enter either D or N');
                 READLN;

              END;

           IF ((TempChar <> 'Y') AND (TempChar <> 'N')) AND (FieldName='Paid') THEN

              BEGIN

                 TEXTCOLOR(RED);
                 WRITELN;
                 WRITELN('Error - Invalid character, you entered ',TempChar);
                 WRITELN('Please enter either Y or N');
                 READLN;

              END;

           WRITELN;
           TEXTCOLOR(WHITE);

        UNTIL  (((TempChar ='M') OR (TempChar ='F')) AND (FieldName='Gender'))
        OR     ((TempChar ='D') OR (TempChar ='N')) AND (FieldName='DayNight')
        OR     ((TempChar ='Y') OR (TempChar ='N')) AND (FieldName= 'Paid');

     END;



  PROCEDURE SpeedTest;
  VAR
     ValidDistance:BOOLEAN;
     ValidMileage:REAL;
     ValidMileage2:LONGINT;


     BEGIN


        ValidDistance:=FALSE;
        ValidMileage:=(Book.Mileage/Book.HoursTravelling);
        ValidMileage2:=ROUND(ValidMileage);
        IF Validmileage2>70 THEN

        BEGIN

           WRITELN;
           TEXTCOLOR(RED);
           WRITE('The speed in which you are wanting the coach to travel at is: ',ValidMileage2);
           WRITELN(' MPH');
           WRITELN('This is too fast for our coaches and is breaking the speed limit.');
           WRITELN;
           WRITE('Please either change the mileage or recheck the number of ');
           WRITELN('hours that the coach is travelling for');

        END
        ELSE ValidDistance:= TRUE;

    END;


  PROCEDURE CharSave(TempChar:CHAR;FieldName:STRING);

     BEGIN

        IF  FieldName = 'Paid' THEN Book.Paid:=TempChar;
        IF  FieldName = 'DayNight' THEN Book.DayTravel:=TempChar;
        IF  FieldName = 'Gender' THEN Book.Gender:=TempChar;

     END;


  PROCEDURE CharDisplay(FieldName:STRING; TempChar:CHAR);

     BEGIN

        IF (FieldName='Gender') THEN

           BEGIN

              IF (TempChar='Z') AND (Book.Gender='M') THEN

                 WRITELN('Male');

              IF (TempChar='Z') AND (Book.Gender='F') THEN

                 WRITELN('Female');

              IF TempChar='M' THEN

                 WRITELN('Male');

              IF TempChar='F' THEN

                 WRITELN('Female');

           END;

        IF  (FieldName='DayNight') THEN

           BEGIN

              IF (TempChar='Z') AND (Book.DayTravel='D') THEN

                 WRITELN('Day');

              IF (TempChar='Z') AND (Book.DayTravel='N') THEN

                 WRITELN('Night');

              IF TempChar='D' THEN

                 WRITELN('Day');

              IF TempChar='N' THEN

                 WRITELN('Night');

           END;

        IF  (FieldName='Paid') THEN

           BEGIN

              IF (TempChar='Z') AND (Book.Paid='Y') THEN

                 WRITELN('Paid');

              IF (TempChar='Z') AND (Book.Paid='N') THEN

                 WRITELN('Not Paid');

              IF TempChar='Y' THEN

                 WRITELN('Paid');

              IF TempChar='N' THEN

                 WRITELN('Not Paid');

           END;

    END;


  PROCEDURE GatherData( Change,FieldName,DataType:STRING ; VAR TempString :STRING ; VAR TempInt : LONGINT);
  VAR

      YesNoChoice:CHAR;
      TempNewInt:INTEGER;
      CharChoice:CHAR;
      TempChar:CHAR;

     BEGIN

        YesNoChoice:='A';
        IF Change = 'AmendBooking' THEN

           BEGIN;

              WRITELN('The current ',FieldName,' is: ');
              IF DataType='S' THEN

                 WRITELN(TempString);

              IF DataType='I' THEN

                 WRITELN(TempInt);

              IF (DataType='C') THEN

                 BEGIN

                    CharDisplay(FieldName,'Z');

                 END;


           END;

           WRITELN;
           IF FieldName= 'Gender' THEN

              WRITELN('Enter new Gender F(Female)/M(Male):');

           IF FieldName= 'Day/Night' THEN

              WRITELN('Enter either D(DayTrip)/N(OverNightTrip):');

           IF (FieldName<>'Gender') AND (FieldName<>'Day/Night') THEN

              WRITELN('Enter new ',FieldName,':');

           REPEAT;

              IF DataType='I' THEN

                 BEGIN
                    TempNewInt:=0;
                    IntegerValidate(TempNewInt);
                 END;

              IF (DataType='S')  THEN

                 ValidateString(TempString,FieldName);


              IF DataType='C' THEN

                 BEGIN

                    TempChar:='x';
                    CharValidate(FieldName,TempChar);

                 END;

              WHILE (YesNoChoice <>'Y') AND (YesNoChoice<>'N') DO

                 BEGIN

                    WRITE('Is the new ',FieldName,' ');           TEXTCOLOR(YELLOW);
                    TEXTCOLOR(WHITE);
                    IF DataType='S' THEN

                       WRITE(TempString);

                    IF DataType='I' THEN

                       BEGIN

                          TEXTCOLOR(YELLOW);
                          WRITE('',TempNewInt);                   TEXTCOLOR(WHITE);

                       END;

                    IF DataType='C' THEN

                       BEGIN

                          TEXTCOLOR(Yellow);
                          CharDisplay(FieldName,TempChar);
                          TEXTCOLOR(White);

                       END;

                    WRITELN(' correct? Y/N');
                    YesOrNoValidate(YesNoChoice);

                 END;

              IF ((YesNoChoice)= 'N')  THEN

                 BEGIN

                    WRITELN;                   TEXTCOLOR(GREEN);
                    IF FieldName= 'Gender' THEN

                       WRITELN('Please re-enter either M(Male)/F(Female):');

                    IF FieldName= 'DayNight' THEN

                       WRITELN('Please re-enter either D(DayTrip)/N(OvernightTrip):');

                    IF (FieldName<>'Gender') AND (FieldName<>'DayNight') THEN

                       WRITELN('Please re-enter a new ',FieldName,':');         TEXTCOLOR(WHITE);
                       YesNoChoice := 'A';

                 END;

           UNTIL YesNoChoice='Y';

        IF (FieldName='Surname,') AND (Change='AmendBooking') THEN

           ConfirmSurname(TempString);

        IF (FieldName='PostCode') AND (Change='AmendBooking') THEN

            ConfirmPostCode(TempString);

        BEGIN

           WRITELN;
           WRITE('The ',FieldName,' has now changed to: ');                    TEXTCOLOR(YELLOW);
           IF DataType='S' THEN

              BEGIN

                 WRITELN(TempString);
                 IF Change='Amend Booking' THEN

                   SaveFile;

              END;

           IF DataType='I' THEN

              BEGIN

                 TempInt:=TempNewInt;
                 WRITELN(TempNewInt);
                 IF Change='Amend Booking' THEN

                    SaveFile;

              END;

           IF DataType='C' THEN

              BEGIN

                 CharDisplay(FieldName,TempChar);
                 CharSave(TempChar,FieldName);
                 IF Change='Amend Booking' THEN

                    SaveFile;

              END;

           READLN;
           WRITELN;

        END;

        IF  (Change='AmendBooking') AND ((FieldName='Miles Travelling') OR
            (FieldName='Hours Travelling') OR (FieldName='Hours waiting at destination')
            OR (FieldName='amount of Nights travelling'))    THEN

               BEGIN                               TEXTCOLOR(RED);

                  WRITELN;
                  WRITE('WARNING - since trip details have been changed the trip ');
                  WRITELN('the costs have also been recalulated.');

               END;

        IF   (Change='AmendBooking') AND ((FieldName='Miles Travelling') OR
             (FieldName='Hours Travelling')) THEN

           BEGIN                               TEXTCOLOR(RED);

              WRITELN;
              WRITE('WARNING - since travel details have been changed make sure ');
              WRITELN('to change the details of mileage etc.');
              READLN    ;

           END;                                 TEXTCOLOR(GREEN);


        YesNoChoice:='A';


     END;






  PROCEDURE CalculateCost;
     BEGIN

        IF Book.Mileage <= 75 THEN

           Book.MilesCost :=Book.Mileage*1.2

        ELSE Book.MilesCost:= ((75*1.2)+((Book.Mileage-75)*0.97));

         IF Book.DayTravel ='D' THEN

            Book.MilesCost:=Book.MilesCost*2;

        Book.HoursCost:=Book.HoursTravelling*25;

        IF Book.DayTravel ='D' THEN

           Book.HoursCost:=Book.HoursCost*2;

        IF Book.DayTravel = 'N' THEN

           Book.WaitingCost:=0

        ELSE Book.WaitingCost:=Book.WaitingTime*20.50;

        IF Book.DayTravel = 'D' THEN

           Book.OvernightCharge:=0

        ELSE Book.OvernightCharge:=Book.NoOfNights*200;

        Book.TotalCost:= Book.MilesCost+Book.HoursCost+Book.WaitingCost+Book.OvernightCharge;
     END;









  PROCEDURE AmendSurname(Change:STRING);
  VAR Temp:STRING;
      Dummy:LONGINT;

     BEGIN

        Temp:=Book.Surname;
        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','Surname','S',Temp,Dummy)

        ELSE BEGIN

           GatherData('AmendBooking','Surname,','S',Temp,Dummy);
           SaveFile;

        END;

        Book.Surname:=Temp;

     END;





  PROCEDURE AmendForename(Change:STRING);
  VAR Temp:STRING;
      Dummy:LONGINT;

     BEGIN

        Temp:=Book.Forename;
        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','Forename','S',Temp,Dummy)

        ELSE BEGIN

           GatherData('AmendBooking','Forename','S',Temp,Dummy);
           SaveFile;

        END;

        Book.Forename:=Temp;

     END;



  PROCEDURE AmendGender(Change:STRING);
     VAR Dummy:STRING;

     BEGIN

        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','Gender','C',Dummy,Book.Mileage)

        ELSE BEGIN

           GatherData('AmendBooking','Gender','C',Dummy,Book.Mileage);
           SaveFile;

        END;

     END;


  PROCEDURE AmendPhone(Change:STRING);
  VAR Temp:STRING;
     Dummy:LONGINT;

     BEGIN

        Temp:=Book.PhoneNo;
        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','Phone','S',Temp,Dummy)

        ELSE BEGIN

           GatherData('AmendBooking','Phone','S',Temp,Dummy);
           SaveFile;

        END;

        Book.PhoneNo:=Temp;

     END;


  PROCEDURE AmendHouseNo(Change:STRING);
  VAR Temp:STRING;
      Dummy:LONGINT;

     BEGIN

        Temp:=Book.HouseNoOrTitle;
        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','HouseNo Or Title','S',Temp,Dummy)

        ELSE BEGIN

           GatherData('AmendBooking','HouseNo Or Title','S',Temp,Dummy);
           SaveFile;

        END;

        Book.HouseNoOrTitle:=Temp;

     END;



  PROCEDURE AmendStreet(Change:STRING);
  VAR Temp:STRING;
      Dummy:LONGINT;

     BEGIN

        Temp:=Book.Street;
        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','Street','S',Temp,Dummy)

        ELSE BEGIN

           GatherData('AmendBooking','Street','S',Temp,Dummy);
           SaveFile;

        END;

        Book.Street:=Temp;

     END;


  PROCEDURE AmendCityTown(Change:STRING);
  VAR Temp:STRING;
      Dummy:LONGINT;

     BEGIN

        Temp:=Book.CityOrTown;
        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','City Or Town','S',Temp,Dummy)

        ELSE BEGIN

           GatherData('AmendBooking','City Or Town','S',Temp,Dummy);
           SaveFile;

        END;

        Book.CityOrTown:=Temp;

     END;


  PROCEDURE AmendCounty(Change:STRING);
  VAR Temp:STRING;
      Dummy:LONGINT;

     BEGIN

           Temp:=Book.County;
           IF Change = 'AddNewBooking' THEN

              GatherData('AddNewBooking','County','S',Temp,Dummy)

           ELSE BEGIN

              GatherData('AmendBooking','County','S',Temp,Dummy);
              SaveFile;

           END;

           Book.County:=Temp;

      END;


  PROCEDURE AmendPostcode(Change:STRING);
  VAR Temp:STRING;
      Dummy:LONGINT;

     BEGIN

        Temp:=Book.PostCode;
        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','PostCode','S',Temp,Dummy)

        ELSE BEGIN

           GatherData('AmendBooking','PostCode','S',Temp,Dummy);
           SaveFile;

        END;

        Book.PostCode:=Temp;

     END;



  PROCEDURE AmendOrigin(Change:STRING);
  VAR Temp:STRING;
      Dummy:LONGINT;

     BEGIN

        Temp:=Book.Origin;
        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','Trip Origin','S',Temp,Dummy)

        ELSE BEGIN

           GatherData('AmendBooking','Trip Origin','S',Temp,Dummy);
           SaveFile;

        END;

        Book.Origin:=Temp;

     END;


  PROCEDURE AmendDestination(Change:STRING);
  VAR Temp:STRING;
      Dummy:LONGINT;

     BEGIN

        Temp:=Book.Destination;
        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','Trip Destination','S',Temp,Dummy)

        ELSE BEGIN

           GatherData('AmendBooking','Trip Destination','S',Temp,Dummy);
           SaveFile;

        END;

        Book.Destination:=Temp;

     END;


  PROCEDURE AmendDayTravel(Change:STRING);
  VAR Dummy:STRING;

     BEGIN

        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','DayNight','C',Dummy,Book.Mileage)

        ELSE BEGIN

           GatherData('AmendBooking','DayNight','C',Dummy,Book.Mileage);
           SaveFile;

        END;

     END;



  PROCEDURE AmendHoursTravelling(Change:STRING);
  VAR Dummy:STRING;

     BEGIN

        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','Hours Travelling','I',Dummy,Book.HoursTravelling)

        ELSE BEGIN

           GatherData('AmendBooking','Hours Travelling','I',Dummy,Book.HoursTravelling);
           SaveFile;

        END;

     END;



  PROCEDURE AmendMileage(Change:STRING);
  VAR Dummy:STRING;

     BEGIN

        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','Miles Travelling','I',Dummy,Book.Mileage)

        ELSE BEGIN

           GatherData('AmendBooking','Miles Travelling','I',Dummy,Book.Mileage);
           SaveFile;

        END;

     END;



  PROCEDURE AmendWaitingTime(Change:STRING);
  VAR Dummy:STRING;

     BEGIN

        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','Hours Waiting at Destination','I',Dummy,Book.WaitingTime)

        ELSE BEGIN

           GatherData('AmendBooking','Hours Waiting at Destination','I',Dummy,Book.WaitingTime);
           SaveFile;

        END;

     END;


  PROCEDURE AmendNoOfNights(Change:STRING);
  VAR Dummy:STRING;

     BEGIN

        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','amount of Nights Travelling','I',Dummy,Book.NoOfNights)

        ELSE BEGIN

           GatherData('AmendBooking','amount of Nights Travelling','I',Dummy,Book.NoOfNights);
           SaveFile;

        END;

     END;


  PROCEDURE AmendPaid(Change:STRING);
  VAR Dummy:STRING;

     BEGIN

        IF Change = 'AddNewBooking' THEN

           GatherData('AddNewBooking','Paid','C',Dummy,Book.Mileage)

        ELSE BEGIN

           GatherData('AmendBooking','Paid','C',Dummy,Book.Mileage);
           SaveFile;

        END;

     END;




  PROCEDURE BookingsLayout;

     BEGIN

        WRITELN;
        TEXTCOLOR(CYAN);
        WRITELN('          BookingNo: ',Book.BookingNo);
        WRITELN;
        TEXTCOLOR(YELLOW);
        WRITELN('          Customer Details:');
        WRITELN('          ----------------');
        WRITELN;
        TEXTCOLOR(WHITE);
        WRITELN('Customer Forename:            ',Book.Forename);
        WRITELN('Customer Surname:             ',Book.Surname);
        WRITELN('Customer Gender:              ',Book.Gender);
        WRITELN('Customer PhoneNo:             ',Book.PhoneNo);
        WRITELN;
        TEXTCOLOR(YELLOW);
        WRITELN('            Customer Address:');
        WRITELN('            ----------------');
        TEXTCOLOR(WHITE);
        WRITELN;
        WRITELN('HouseNo/Title:                ',Book.HouseNoOrTitle);
        WRITELN('Street:                       ',Book.Street);
        WRITELN('City/Town:                    ',Book.CityOrTown);
        WRITELN('County:                       ',Book.County);
        WRITELN('Postcode:                     ',Book.Postcode);
        WRITELN;
        TEXTCOLOR(YELLOW);
        WRITELN('            Trip Details:');
        WRITELN('            ------------');
        WRITELN;
        TEXTCOLOR(WHITE);
        WRITELN('Origin:                       ',Book.Origin);
        WRITELN('Destination:                  ',Book.Destination);
        WRITE('Time Of Travel:               ');
        IF Book.DayTravel = 'D' THEN

           WRITELN('Day');

        IF Book.DayTravel = 'N' THEN

           WRITELN('Night');

        WRITELN('No of hours travelling for:   ',Book.HoursTravelling);
        WRITELN('No Of Miles:                  ',Book.Mileage);
        IF Book.DayTravel = 'D' THEN

           WRITELN('No of Hours Coach Waiting:    ',Book.WaitingTime)

        ELSE

           WRITELN('Number of nights travelling:  ',Book.NoOfNights);

        WRITELN;
        TEXTCOLOR(YELLOW);
        WRITELN('             Costs:');
        WRITELN('             -----:');
        WRITELN;
        TEXTCOLOR(WHITE);
        WRITELN('Mileage Cost:                œ',Book.MilesCost:6:2);
        WRITELN('Cost Of Driving Hours:       œ',Book.HoursCost:6:2);
        IF Book.DayTravel = 'D' THEN

           WRITELN('Waiting At Destination Cost: œ',Book.WaitingCost:6:2)

        ELSE

           WRITELN('Overnight Charge:            œ',Book.OvernightCharge:6:2);

        WRITELN('Total Cost:                  œ',Book.TotalCost:6:2);
        WRITELN('Has The Customer paid:        ',Book.Paid);
        WRITELN;

     END;


  PROCEDURE InvoiceBookingNo;
  VAR I:INTEGER;

     BEGIN

        RESET(BookingFile);
        I:=4;     TEXTCOLOR(YELLOW);
        WRITELN(' BookingNo');
        WRITELN(' ---------');
        TEXTCOLOR(WHITE);

           REPEAT

              GOTOXY(1,I);

                 BEGIN

                    READ(BookingFile,Book);
                    IF (Book.BookingNo <> '-1') THEN

                       BEGIN

                          WRITE('',Book.BookingNo);
                          I:=I+1;

                    END;

                 END;

           UNTIL EOF(BookingFile);
     END;



   PROCEDURE InvoiceSurname;
   VAR I:INTEGER;

      BEGIN

         RESET(BookingFile);
         I:=4;
         GOTOXY(12,1);
         TEXTCOLOR(YELLOW);
         BEGIN
         WRITELN(' Surname');
         GOTOXY(12,2);
         WRITELN(' -------');
         END;
         TEXTCOLOR(WHITE);

            REPEAT

               GOTOXY(12,I);

                  BEGIN

                     READ(BookingFile,Book);
                     IF (Book.BookingNo <> '-1') THEN

                        BEGIN

                           WRITE(Book.Surname);
                           I:=I+1;

                        END;

                  END;

            UNTIL EOF(BookingFile);

      END;


   PROCEDURE InvoicePhoneNo;
   VAR I:INTEGER;

      BEGIN

         RESET(BookingFile);
         I:=4;
         GOTOXY(22,1);

         BEGIN
         TEXTCOLOR(YELLOW);
         WRITELN(' PhoneNo');
         GOTOXY(22,2);
         WRITELN(' -------');
         END;
         TEXTCOLOR(WHITE);

            REPEAT

               GOTOXY(21,I);

                  BEGIN

                     READ(BookingFile,Book);
                     IF (Book.BookingNo <> '-1') THEN

                        BEGIN

                           WRITE(Book.PhoneNo);
                           I:=I+1;

                        END;

                  END;

            UNTIL EOF(BookingFile);

      END;


  PROCEDURE InvoiceDestination;
     VAR I:INTEGER;

        BEGIN

           RESET(BookingFile);
           I:=4;
           GOTOXY(35,1);
           TEXTCOLOR(YELLOW);
           BEGIN
           WRITELN('Destination');
           GOTOXY(35,2);
           WRITELN(' ----------');
           END;
           TEXTCOLOR(WHITE);

              REPEAT

                GOTOXY(35,I);

                   BEGIN

                      READ(BookingFile,Book);
                      IF (Book.BookingNo <> '-1') THEN

                         BEGIN

                            WRITE(Book.Destination);
                            I:=I+1;

                         END;

                   END;

              UNTIL EOF(BookingFile);

        END;



  PROCEDURE InvoiceCalculation;
  VAR I:INTEGER;
      TotalPaid:REAL;
      NoPaid:INTEGER;
      NoNotPaid:INTEGER;
      TotalOwed:REAL;

     BEGIN

        NoPaid:=0;
        NoNotPaid:=0;
        RESET(BookingFile);
        I:=4;
        GOTOXY(48,1);
        TEXTCOLOR(YELLOW);
        BEGIN
        WRITELN(' Total Cost');
        GOTOXY(48,2);
        WRITELN(' ----------');
        TEXTCOLOR(WHITE);
        END;

           REPEAT

              GOTOXY(48,I);

                 BEGIN

                    READ(BookingFile,Book);
                    IF (Book.BookingNo <> '-1') THEN

                       BEGIN

                          WRITE('œ',Book.TotalCost:5:2);
                          IF Book.Paid='Y' THEN

                             BEGIN

                                NoPaid:=NoPaid+1;
                                TotalPaid:=TotalPaid+Book.TotalCost;

                             END;

                          IF Book.Paid='N' THEN

                             BEGIN

                                NoNotPaid:=NoNotPaid+1;
                                TotalOwed:=TotalOwed+Book.TotalCost;

                             END;

                          I:=I+1;

                       END;

                 END;

           UNTIL (EOF(BookingFile));

        GOTOXY(60,1);
        TEXTCOLOR(Yellow);
        WRITELN(' Trip Paid');
        GOTOXY(60,2);
        WRITELN(' --------');
        TEXTCOLOR(WHITE);
        RESET(BookingFile);
        I:=4;

           REPEAT

              BEGIN

                 GOTOXY(60,I);
                 READ(BookingFile,Book);
                 IF (Book.BookingNo <> '-1') THEN

                    BEGIN

                       WRITE('   ',Book.Paid);
                       I:=I+1;

                    END;

              END;

           UNTIL (EOF(BookingFile));

        I:=I+2;
        GOTOXY(1,I);
        BEGIN
        TEXTCOLOR(Yellow);
        WRITE('Amount Of Customers Paid: ');
        TEXTCOLOR(WHITE);
        WRITELN(Nopaid);
        END;
        GOTOXY(30,I);
        BEGIN
        TEXTCOLOR(YELLOW);
        WRITE('Amount of Customers payment outstanding: ');
        TEXTCOLOR(RED);
        WRITELN(NoNotPaid);
        TEXTCOLOR(WHITE);
        END;
        I:=I+2;
        GOTOXY(1,I);
        BEGIN
        TEXTCOLOR(YELLOW);
        WRITE('Total Amount Paid:');
        TEXTCOLOR(WHITE);
        WRITELN('œ',TotalPaid:5:2);
        END;
        GOTOXY(30,I);
        BEGIN
        TEXTCOLOR(YELLOW);
        WRITE('Total Amount Owed:');
        TEXTCOLOR(RED);
        WRITELN('œ',TotalOwed:5:2);
        TEXTCOLOR(WHITE);
        END;
        I:=I+3;
     TEXTCOLOR(GREEN);
     GOTOXY(1,I);
     WRITELN('Press any key to return to the previous menu...');

     END;



  PROCEDURE DisplayInvoice;

     BEGIN

        CLRSCR;
        InvoiceBookingNo;
        InvoiceSurname;
        InvoicePhoneNo;
        InvoiceDestination;
        InvoiceCalculation;
        READKEY;

     END;


  PROCEDURE DisplaySeperate;

     BEGIN

        RESET(BookingFile);
        CLRSCR;
        WHILE NOT EOF(BookingFile) DO

           BEGIN

              READ(BookingFile,Book);
              WITH BOOK DO

                 BEGIN

                    CLRSCR;
                    IF BookingNo <> '-1' THEN

                       BookingsLayout;

                    IF EOF(BookingFile) THEN

                       BEGIN

                          TEXTCOLOR(YELLOW);
                          WRITELN('This is the last record, press enter to return to the main menu..');
                          TEXTCOLOR(WHITE);
                          READLN;

                       END;

                    IF NOT EOF(BookingFile) AND (BookingNo >'1') THEN

                       BEGIN

                          TEXTCOLOR(GREEN);
                          WRITELN('Press enter to continue to the next record..');
                          TEXTCOLOR(WHITE);
                          READLN;

                       END;


                 END;

           END;
     END;



  PROCEDURE DisplayBookings;
  VAR MenuChoice:CHAR;

     BEGIN

        REPEAT

           BEGIN;

              CLRSCR;
              WRITELN('Would you like to Display all bookings or each seperate booking?');
              WRITELN;
              WRITELN('1 Display Seperate Bookings');
              WRITELN;
              WRITELN('2 Display All Bookings');
              WRITELN;
              WRITELN('X to go back to the main menu');
              MenuChoice := UPCASE(READKEY);

              CASE MenuChoice OF

                 '1':DisplaySeperate;
                 '2':DisplayInvoice;
                 'X': ;

              ELSE

                 WRITELN;
                 WRITELN;                                                            TEXTCOLOR(RED);
                 WRITE('Error, you did not enter a valid character. You entered:');  TEXTCOLOR(YELLOW);
                 WRITELN(MenuChoice);                                                TEXTCOLOR(RED);
                 WRITELN;
                 WRITELN('Please press Enter and try again');                        TEXTCOLOR(WHITE);
                 READLN;

              END;

           END;

        UNTIL MenuChoice = 'X';

    END;





  PROCEDURE ShowCurrentBooking;

     BEGIN

        CLRSCR;
        WRITELN('The Current details of the record you are amending are:');
        BookingsLayout;
        TEXTCOLOR(GREEN);
        WRITELN('Press Enter to return to the Previous Menu..');
        TEXTCOLOR(WHITE);
        READLN;

     END;






   PROCEDURE AmendCustomerDetails;
   VAR
      MenuChoice:CHAR;

      BEGIN

         REPEAT

           CLRSCR;
           TEXTCOLOR(YELLOW);
           WRITELN;
           WRITELN('                 AMEND CUSTOMER DETAILS MENU');
           WRITELN('                 ===========================');
           WRITELN;
           WRITE('1 ');                      TEXTCOLOR(WHITE);
           WRITE('OR ');                     TEXTCOLOR(YELLOW);
           WRITE('N ');                      TEXTCOLOR(WHITE);
           WRITE('To Enter a new ');         TEXTCOLOR(YELLOW);
           WRITE('S');                       TEXTCOLOR(WHITE);
           WRITELN('urname');
           WRITELN;                          TEXTCOLOR(YELLOW);
           WRITE('2 ');                      TEXTCOLOR(WHITE);
           WRITE('OR ');                     TEXTCOLOR(YELLOW);
           WRITE('F ');                      TEXTCOLOR(WHITE);
           WRITE('To enter a new ');         TEXTCOLOR(YELLOW);
           WRITE('F');                       TEXTCOLOR(WHITE);
           WRITELN('orename');
           WRITELN;                          TEXTCOLOR(YELLOW);
           WRITE('3 ');                      TEXTCOLOR(WHITE);
           WRITE('OR ');                     TEXTCOLOR(YELLOW);
           WRITE('G ');                      TEXTCOLOR(WHITE);
           WRITE('To Enter a new ');         TEXTCOLOR(YELLOW);
           WRITE('G');                       TEXTCOLOR(WHITE);
           WRITELN('ender');
           WRITELN;                          TEXTCOLOR(YELLOW);
           WRITE('4 ');                      TEXTCOLOR(WHITE);
           WRITE('OR ');                     TEXTCOLOR(YELLOW);
           WRITE('O ');                      TEXTCOLOR(WHITE);
           WRITE('To Enter a new Ph');       TEXTCOLOR(YELLOW);
           WRITE('o');                       TEXTCOLOR(WHITE);
           WRITELN('ne Number');
           WRITELN;                          TEXTCOLOR(YELLOW);
           WRITE('5 ');                      TEXTCOLOR(WHITE);
           WRITE('OR ');                     TEXTCOLOR(YELLOW);
           WRITE('H ');                      TEXTCOLOR(WHITE);
           WRITE('To Enter a new ');         TEXTCOLOR(YELLOW);
           WRITE('H');                       TEXTCOLOR(WHITE);
           WRITELN('ouseNo Or Title');
           WRITELN;                          TEXTCOLOR(YELLOW);
           WRITE('6 ');                      TEXTCOLOR(WHITE);
           WRITE('OR ');                     TEXTCOLOR(YELLOW);
           WRITE('S ');                      TEXTCOLOR(WHITE);
           WRITE('To Enter a new ');         TEXTCOLOR(YELLOW);
           WRITE('S');                       TEXTCOLOR(WHITE);
           WRITELN('treet');
           WRITELN;                          TEXTCOLOR(YELLOW);
           WRITE('7 ');                      TEXTCOLOR(WHITE);
           WRITE('OR ');                     TEXTCOLOR(YELLOW);
           WRITE('T ');                      TEXTCOLOR(WHITE);
           WRITE('To enter a new City Or '); TEXTCOLOR(YELLOW);
           WRITE('T');                       TEXTCOLOR(WHITE);
           WRITELN('own');
           WRITELN;                      TEXTCOLOR(YELLOW);
           WRITE('8 ');                  TEXTCOLOR(WHITE);
           WRITE('OR ');                 TEXTCOLOR(YELLOW);
           WRITE('C ');                  TEXTCOLOR(WHITE);
           WRITE('To enter a new ');     TEXTCOLOR(YELLOW);
           WRITE('C');                   TEXTCOLOR(WHITE);
           WRITELN('ounty');
           WRITELN;                      TEXTCOLOR(YELLOW);
           WRITE('9 ');                  TEXTCOLOR(WHITE);
           WRITE('OR ');                 TEXTCOLOR(YELLOW);
           WRITE('P ');                  TEXTCOLOR(WHITE);
           WRITE('To enter a new ');     TEXTCOLOR(YELLOW);
           WRITE('P');                   TEXTCOLOR(WHITE);
           WRITELN('ostcode');
           WRITELN;                      TEXTCOLOR(RED);
           WRITELN('X To go back  ');
           WRITELN;                      TEXTCOLOR(GREEN);
           WRITELN('Enter choice ->');   TEXTCOLOR(WHITE);

           MenuChoice:=UPCASE(READKEY);
           CASE MenuChoice OF

             '1','N':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);AmendSurname('AmendBooking'); END;
             '2','F':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);AmendForename('AmendBooking'); END;
             '3','G':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);AmendGender('AmendBooking');   END;
             '4','O':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);AmendPhone('AmendBooking');    END;
             '5','H':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);AmendHouseNo('AmendBooking');  END;
             '6','S':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);AmendStreet('AmendBooking'); END;
             '7','T':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);AmendCityTown('AmendBooking'); END;
             '8','C':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);AmendCounty('AmendBooking'); END;
             '9','P':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);AmendPostcode('AmendBooking'); END;
             'X': BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
                           WRITELN('Press Enter to be go back to the Amend Menu');
                           READLN;
                     END;

          ELSE
               WRITELN;
               WRITELN;                                                           TEXTCOLOR(RED);
               WRITE('Error, you did not enter a valid character. You entered:'); TEXTCOLOR(YELLOW);
               WRITELN(MenuChoice);                                               TEXTCOLOR(RED);
               WRITELN;
               WRITELN('Please press Enter and try again');                       TEXTCOLOR(WHITE);
               READLN;

          END;

         UNTIL MenuChoice = 'X';

      SEEK(BookingFile, FILEPOS(BookingFile) -1);
      WRITE(BookingFile,Book);

   END;



  PROCEDURE AmendBookingDetails;
     VAR
        MenuChoice:CHAR;

     BEGIN

        REPEAT

           CLRSCR;                         TEXTCOLOR(YELLOW);
           WRITELN;
           WRITELN('                 AMEND TRIP DETAILS MENU');
           WRITELN('                 =======================');
           WRITELN;
           WRITE('1 ');                    TEXTCOLOR(WHITE);
           WRITE('OR ');                   TEXTCOLOR(YELLOW);
           WRITE('O ');                    TEXTCOLOR(WHITE);
           WRITE('To enter a new ');       TEXTCOLOR(YELLOW);
           WRITE('O');                     TEXTCOLOR(WHITE);
           WRITELN('rigin');
           WRITELN;                        TEXTCOLOR(YELLOW);
           WRITE('2 ');                    TEXTCOLOR(WHITE);
           WRITE('OR ');                   TEXTCOLOR(YELLOW);
           WRITE('D ');                    TEXTCOLOR(WHITE);
           WRITE('To Enter a new ');       TEXTCOLOR(YELLOW);
           WRITE('D');                     TEXTCOLOR(WHITE);
           WRITELN('estination');
           WRITELN;                        TEXTCOLOR(YELLOW);
           WRITE('3 ');                    TEXTCOLOR(WHITE);
           WRITE('OR ');                   TEXTCOLOR(YELLOW);
           WRITE('Y ');                    TEXTCOLOR(WHITE);
           WRITE('To Select either Da');   TEXTCOLOR(YELLOW);
           WRITE('y ');                    TEXTCOLOR(WHITE);
           WRITELN('or Overnight Booking');
           WRITELN;                        TEXTCOLOR(YELLOW);
           WRITE('4 ');                    TEXTCOLOR(WHITE);
           WRITE('OR ');                   TEXTCOLOR(YELLOW);
           WRITE('H ');                    TEXTCOLOR(WHITE);
           WRITE('To Enter a new No Of '); TEXTCOLOR(YELLOW);
           WRITE('H');                     TEXTCOLOR(WHITE);
           WRITELN('ours being travelled');
           WRITELN;                        TEXTCOLOR(YELLOW);
           WRITE('5 ');                    TEXTCOLOR(WHITE);
           WRITE('OR ');                   TEXTCOLOR(YELLOW);
           WRITE('M ');                    TEXTCOLOR(WHITE);
           WRITE('To Enter a new No Of '); TEXTCOLOR(YELLOW);
           WRITE('M');                     TEXTCOLOR(WHITE);
           WRITELN('iles being travelled');
           WRITELN;                        TEXTCOLOR(YELLOW);
           WRITE('6 ');                    TEXTCOLOR(WHITE);
           WRITE('OR ');                   TEXTCOLOR(YELLOW);
           WRITE('W ');                    TEXTCOLOR(WHITE);
           WRITE('To enter a new ');       TEXTCOLOR(YELLOW);
           WRITE('W');                     TEXTCOLOR(WHITE);
           WRITELN('aiting time the coach will be at the destination for');
           WRITELN;                        TEXTCOLOR(YELLOW);
           WRITE('7 ');                    TEXTCOLOR(WHITE);
           WRITE('OR ');                   TEXTCOLOR(YELLOW);
           WRITE('N ');                    TEXTCOLOR(WHITE);
           WRITE('To enter a new No Of '); TEXTCOLOR(YELLOW);
           WRITE('N');                     TEXTCOLOR(WHITE);
           WRITELN('ights travelling for');
           WRITELN;                        TEXTCOLOR(YELLOW);
           WRITE('8 ');                    TEXTCOLOR(WHITE);
           WRITE('OR ');                   TEXTCOLOR(YELLOW);
           WRITE('P ');                    TEXTCOLOR(WHITE);
           WRITE('To enter if the customer has '); TEXTCOLOR(YELLOW);
           WRITE('P');                     TEXTCOLOR(WHITE);
           WRITELN('aid for thier booking'); TEXTCOLOR(RED);
           WRITE('X to quit');
           WRITELN;
           WRITELN;                        TEXTCOLOR(GREEN);
           WRITE('Enter choice ->');       TEXTCOLOR(WHITE);
           MenuChoice:=UPCASE(READKEY);
           CASE MenuChoice OF

              '1','O':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);

              AmendOrigin('AmendBooking');
              END;
              '2','D':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
              AmendDestination('AmendBooking');
              END;
              '3','Y':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
              AmendDayTravel('AmendBooking');
              END;
              '4','H':  BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
              AmendHoursTravelling('AmendBooking');
              END;
              '5','M': BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
              AmendMileage('AmendBooking');
              END;
              '6','W': BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
              AmendWaitingTime('AmendBooking');
              END;
              '7','N': BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
              AmendNoOfNights('AmendBooking');
              END;
              '8','P': BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
              AmendPaid('AmendBooking');
              END;
              'X':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
                           WRITELN('Press Enter to be go back to the Amend Menu');
                           READLN;
                     END;


           ELSE

              WRITELN;
              WRITELN;                                                           TEXTCOLOR(RED);
              WRITE('Error, you did not enter a valid character. You entered:'); TEXTCOLOR(YELLOW);
              WRITELN(MenuChoice);                                               TEXTCOLOR(RED);
              WRITELN;
              WRITELN('Please press Enter and try again');                       TEXTCOLOR(WHITE);
              READLN;

           END;


        UNTIL MenuChoice = 'X';

        CalculateCost;
        SEEK(BookingFile, FILEPOS(BookingFile) -1);
        WRITE(BookingFile,Book);

     END;



  PROCEDURE AmendBookingMenu;
     VAR MenuChoice:CHAR;

        BEGIN

           REPEAT

              CLRSCR;                        TEXTCOLOR(CYAN);
              WRITE('Customer Name: ',Book.Forename,' ',Book.Surname);
              GOTOXY(35,1);
              WRITE('BookingNo: ',Book.BookingNo);
              GOTOXY(55,1);
              WRITE('Destination: ',Book.Destination);
              GOTOXY(1,1);
              TEXTCOLOR(YELLOW);
              WRITELN;
              WRITELN;
              WRITELN;
              WRITELN('                 Amend Bookings Menu');
              WRITELN('                 ===================');
              WRITELN;
              WRITE('1 ');               TEXTCOLOR(WHITE);
              WRITE('OR ');              TEXTCOLOR(YELLOW);
              WRITE('C ');               TEXTCOLOR(WHITE);
              WRITE('to Edit ');         TEXTCOLOR(YELLOW);
              WRITE('C');                TEXTCOLOR(WHITE);
              WRITELN('ustomer Details');
              WRITELN;                   TEXTCOLOR(YELLOW);
              WRITE('2 ');               TEXTCOLOR(WHITE);
              WRITE('OR ');              TEXTCOLOR(YELLOW);
              WRITE('B ');               TEXTCOLOR(WHITE);
              WRITE('to edit ');         TEXTCOLOR(YELLOW);
              WRITE('B');                TEXTCOLOR(WHITE);
              WRITELN('ooking Details');
              WRITELN;                   TEXTCOLOR(YELLOW);
              WRITE('3 ');               TEXTCOLOR(WHITE);
              WRITE('OR ');              TEXTCOLOR(YELLOW);
              WRITE('V ');               TEXTCOLOR(WHITE);
              WRITE('to ');              TEXTCOLOR(YELLOW);
              WRITE('V');                TEXTCOLOR(WHITE);
              WRITELN('iew the current Record Details');
              WRITELN;                   TEXTCOLOR(RED);
              WRITELN('X To go back');
              WRITELN;                   TEXTCOLOR(GREEN);
              WRITE('Enter choice ->');
              TEXTCOLOR(WHITE);

              MenuChoice:=UPCASE(READKEY);
              CASE MenuChoice OF

                 '1','C':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
                           WRITELN('Press Enter to be redirected to the Amend Customer Details Menu');
                           READLN;
                 AmendCustomerDetails;
                 END;
                 '2','T':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
                           WRITELN('Press Enter to be redirected to the Amend Bookings Menu');
                           READLN;
                 AmendBookingDetails;
                 END;
                 '3','V':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
                           WRITELN('Press Enter to be go to the details for the record you are currently amending');
                           READLN;
                 ShowCurrentBooking;
                 END;
                 'X':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
                           WRITELN('Press Enter to be go back to the Main Menu');
                           READLN;
                     END;

              ELSE

              TEXTCOLOR(RED);
              WRITELN('Error, you did not enter a valid character. You entered:');
              WRITELN(MenuChoice);
              WRITELN;
              TEXTCOLOR(GREEN);
              WRITELN('Please press Enter and try again..');
              TEXTCOLOR(WHITE);
              READLN;

              END;

        UNTIL MenuChoice = 'X';

     END;






  PROCEDURE AddBooking;

     BEGIN

        RESET(BookingFile);

           BEGIN

              REPEAT

                 READ(BookingFile, Book);

              UNTIL (Book.BookingNo = '-1') OR (EOF(BookingFile));

              AmendSurname('AddNewBooking');
              AmendForename('AddNewBooking');
              AmendGender('AddNewBooking');
              AmendPhone('AddNewBooking');
              AmendHouseNo('AddNewBooking');
              AmendStreet('AddNewBooking');
              AmendCityTown('AddNewBooking');
              AmendCounty('AddNewBooking');
              AmendPostCode('AddNewBooking');
              AmendOrigin('AddNewBooking');
              AmendDestination('AddNewBooking');
              AmendDayTravel('AddNewBooking');
              AmendHoursTravelling('AddNewBooking');
              AmendMileage('AddNewBooking');
              IF Book.DayTravel ='D' THEN

                 AmendWaitingTime('AddNewBooking')

              ELSE

                 AmendNoOfNights('AddNewBooking');

              AmendPaid('AddNewBooking');
              IF Book.BookingNo ='-1' THEN

                 SaveFile

              ELSE

                 WRITE (BookingFile,Book);

              AssignBookingNo;
              TEXTCOLOR(CYAN);
              WRITELN;
              WRITELN('New Booking Has been created sucessfully');
              WRITELN('Press Any Key to return to the main menu...');
              READKEY;
              CalculateCost;
              SaveFile;

           END;

     END;


  PROCEDURE DeleteBooking;
  VAR YesNoChoice:CHAR;

     BEGIN

        WRITELN;
        WRITELN('Delete booking - are you sure? (Y/N)');
        YesNoChoice:=READKEY;
        YesOrNoValidate(YesNoChoice);

           BEGIN

              Book.Surname:='';    {sets all fields in the deleted booking to null}
              Book. Forename:='';  {so the data from a delete file doesn't fill the fields}
              Book. Gender:='#';
              Book.PhoneNo:='';
              Book.HouseNoOrTitle:='';
              Book.Street:='' ;
              Book.CityOrTown:='';
              Book.County:='';
              Book.PostCode:='';
              Book.Origin:='';
              Book.Destination:='';
              Book.DayTravel:='#';
              Book.HoursTravelling:=0;
              Book.Mileage:=0;
              Book.WaitingTime:=0;
              Book.NoOfNights:=0;
              Book.MilesCost:=0;
              Book.HoursCost:=0;
              Book.WaitingCost:=0;
              Book.TotalCost:=0;
              Book.OvernightCharge:=0;
              Book.Paid:='#';
              Book.BookingNo:='-1'; {Gives the booking a rouge value}
              SEEK(BookingFile, FILEPOS(BookingFile) -1);
              WRITE(BookingFile,Book);
              WRITELN('Booking deleted');

           END;

        IF YesNoChoice = 'N' THEN

           BEGIN

              TEXTCOLOR(GREEN);
              WRITELN;
              WRITELN('Booking NOT deleted, Press Enter to return to the main menu..'); TEXTCOLOR(WHITE);
              READLN;

           END;

     END;



  PROCEDURE FindAmendBooking;


     BEGIN

        ValidateBooking('Edit');

     END;


  PROCEDURE ShowBooking;

     BEGIN
        ValidateBooking('Find');

     END;


  PROCEDURE FindDeleteBooking;

     BEGIN

        ValidateBooking('Delete');

     END;




  PROCEDURE Booking(Amend:STRING);
  VAR Answer:CHAR;

     BEGIN

        IF Amend = 'Show' THEN
        WITH Book DO

           BEGIN

              CLRSCR;
              BookingsLayout;    TEXTCOLOR(GREEN);
              WRITELN('Press Any Key to return to the main menu...');
              READKEY;

           END;


         IF Amend = 'Find' THEN

            BEGIN

               WITH Book DO

                  BEGIN

                     WRITE('You have entered to amend the record of BookingNo: ');
                     TEXTCOLOR(YELLOW);
                     WRITELN(Book.BookingNo);
                     WRITELN;
                     WRITE('Name:',Book.Forename);
                     WRITELN(' ',Book.Surname);
                     TEXTCOLOR(WHITE);
                     WRITELN;
                     TEXTCOLOR(GREEN);
                     WRITELN('Is this the right record? Y/N:');
                     Answer:= 'A';
                     YesOrNoValidate(Answer);
                     TEXTCOLOR(WHITE);
                     IF Answer='Y' THEN

                        AmendBookingMenu;

                     IF Answer='N' THEN

                        BEGIN

                           WRITELN;
                           TEXTCOLOR(GREEN);
                           WRITELN('Press Any Key to return..');
                           TEXTCOLOR(WHITE);
                           READKEY;

                        END;

                  END;

            END;
     END;



    PROCEDURE ValidateBooking(Change:STRING);
    VAR  EnteredBookingNo:STRING;
         I           :INTEGER;
         ErrorMes    :BOOLEAN;
         Loop        :BOOLEAN;
         Found       :BOOLEAN;

       BEGIN

           Loop:= TRUE;

          REPEAT

              WRITELN('Enter BookingNo');
              READLN(EnteredBookingNo);
              EnteredBookingNo:=UPPERCASE(EnteredBookingNo);
              FOR I:= 1 TO LENGTH(EnteredBookingNo)DO

                 IF (EnteredBookingNo[I]<#48) OR (EnteredBookingNo[I]>#57)
                 AND ((EnteredBookingNo[I]<#65)  OR (EnteredBookingNo[I]>#90)) THEN

                    ErrorMes := TRUE

                 ELSE

                    ErrorMes := FALSE;

              IF ErrorMes = TRUE THEN

                 BEGIN         TEXTCOLOR(RED);

                    WRITE('Error invalid Character(s) entered');
                    WRITELN(' - Must only contain characters A-Z OR 0-9');    TEXTCOLOR(WHITE);

                 END;

              IF ErrorMes = FALSE THEN

                 BEGIN;

                    IF (LENGTH(EnteredBookingNo)<>7)
                    THEN
                    BEGIN                                                   TEXTCOLOR(RED);

                          WRITELN('Error - must 7 Characters Long');           TEXTCOLOR(WHITE);

                       END ELSE

                          Loop := FALSE;

                 END;

          UNTIL Loop = FALSE OR (FILESIZE(BookingFile) = 0);


          BEGIN

             IF FILESIZE(BookingFile) = 0 THEN

                BEGIN

                   WRITELN;
                   TEXTCOLOR(RED);
                   WRITELN('Error - file is empty');
                   TEXTCOLOR(WHITE);

                END ELSE

                   BEGIN

                      RESET(BookingFile);
                      Found:= FALSE;

                         REPEAT

                            READ(BookingFile, Book);
                            IF EnteredBookingNo=Book.BookingNo  THEN


                               Found := TRUE;

                         UNTIL (Found=True) OR (EOF(BookingFile));

                         IF (Found= TRUE) AND (Change = 'Edit') THEN

                            Booking('Find');

                         IF (Found= TRUE) AND (Change ='Find') THEN

                            Booking('Show');

                         IF (Found= TRUE) AND (Change ='Delete') THEN

                            DeleteBooking;

                         IF (Found= FALSE) THEN

                            BEGIN

                               WRITE('Error - Booking not found');
                               READLN;

                            END;

                   END;

          END;

     END;









  PROCEDURE MainMenu;
     VAR MenuChoice:CHAR;

        BEGIN

           REPEAT

              CLRSCR;
              TEXTCOLOR(YELLOW);
              WRITELN;
              WRITELN('                 MAIN MENU');
              WRITELN('                 =========');
              WRITELN;
              WRITE('1 ');              TEXTCOLOR(WHITE);
              WRITE('OR ');             TEXTCOLOR(YELLOW);
              WRITE('D ');              TEXTCOLOR(WHITE);
              WRITE('to ');             TEXTCOLOR(YELLOW);
              WRITE('D');               TEXTCOLOR(WHITE);
              WRITELN('isplay all bookings');
              WRITELN;                  TEXTCOLOR(YELLOW);
              WRITE('2 ');              TEXTCOLOR(WHITE);
              WRITE('OR ');             TEXTCOLOR(YELLOW);
              WRITE('F ');              TEXTCOLOR(WHITE);
              WRITE('to ');             TEXTCOLOR(YELLOW);
              WRITE('F');               TEXTCOLOR(WHITE);
              WRITELN('ind a booking');
              WRITELN;                  TEXTCOLOR(YELLOW);
              WRITE('3 ');              TEXTCOLOR(WHITE);
              WRITE('OR ');             TEXTCOLOR(YELLOW);
              WRITE('M ');              TEXTCOLOR(WHITE);
              WRITE('to A');            TEXTCOLOR(YELLOW);
              WRITE('m');               TEXTCOLOR(WHITE);
              WRITELN('end a booking');
              WRITELN;                  TEXTCOLOR(YELLOW);
              WRITE('4 ');              TEXTCOLOR(WHITE);
              WRITE('OR ');             TEXTCOLOR(YELLOW);
              WRITE('A ');              TEXTCOLOR(WHITE);
              WRITE('to ');             TEXTCOLOR(YELLOW);
              WRITE('A');               TEXTCOLOR(WHITE);
              WRITELN('dd a new booking');
              WRITELN;                  TEXTCOLOR(YELLOW);
              WRITE('5 ');              TEXTCOLOR(WHITE);
              WRITE('OR ');             TEXTCOLOR(YELLOW);
              WRITE('E ');              TEXTCOLOR(WHITE);
              WRITE('to D');            TEXTCOLOR(YELLOW);
              WRITE('e');               TEXTCOLOR(WHITE);
              WRITELN('lete a booking');
              WRITELN;
              WRITELN;                  TEXTCOLOR(RED);
              WRITE('X to quit');
              WRITELN;
              WRITELN;                  TEXTCOLOR(GREEN);
              WRITE('Enter choice ->');
                                     TEXTCOLOR(WHITE);

              MenuChoice := UPCASE(READKEY);
              CASE MenuChoice OF

                 '1','D':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
                           WRITELN('Press Enter to be redirected to the Display Bookings Menu');
                           READLN;
                 DisplayBookings;
                 END;
                 '2','F':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
                           WRITELN('Press Enter to search for a booking ');
                           READLN;
                 ShowBooking;
                 END;
                 '3','M':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
                           WRITELN('Press Enter to Amend a booking');
                           READLN;
                 FindAmendBooking;
                 END;
                 '4','A':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
                           WRITELN('Press Enter to Add a new booking');
                           READLN;
                 AddBooking;
                 END;
                 '5','E':BEGIN
                           WRITELN('You have entered the key ',MenuChoice);
                           WRITELN('Press Enter to Delete a Booking');
                           READLN;
                 FindDeleteBooking;
                 END;
                 'X': ;

              ELSE

               WRITELN;
               WRITELN;                                                            TEXTCOLOR(RED);
               WRITE('Error, you did not enter a valid character. You entered:');  TEXTCOLOR(YELLOW);
               WRITELN(MenuChoice);                                                TEXTCOLOR(RED);
               WRITELN;
               WRITELN('Please press Enter and try again');                        TEXTCOLOR(WHITE);
               READLN;

              END;

           UNTIL MenuChoice = 'X';

           CLOSE(BookingFile);

        END;


BEGIN {Main Program}

   ASSIGN(BookingFile,'D:\Computing\As\Version 5.1\BOOKINGS.DTA');
   RESET(BookingFile);
   TEXTCOLOR(WHITE);
   MainMenu;
END.
