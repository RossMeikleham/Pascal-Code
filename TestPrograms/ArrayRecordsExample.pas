PROGRAM RECARRAYTEST;


     //õõõõõõõõõõõõõõõõõõõõõõõõõõõõõõõõõ
     //õ   Array Of Records Sample     õ
     //õ   Created by Ross Meikleham   õ
     //õ            2011              õ
     //õõõõõõõõõõõõõõõõõõõõõõõõõõõõõõõõõ
     //////////////////////////////////



USES CRT, SYSUTILS, Debug;


TYPE

   CustInfo= RECORD
                                        //Declare Types
       CustId       :STRING[6];
       CustSurname  :STRING[25];
       CustForename :STRING[25];

     END;

   CustArray=ARRAY[1..50] OF CustInfo;  //Array with 50 positions
                                        //for records of CustInfo




VAR

   Cust:CustInfo;   //Declare Variable Cust of Type Record 'Custinfo'

   Custs:CustArray;     //Declare Variable Custs of Type 'Cust Array'

   CustFile:FILE OF CustInfo;  //File of the type 'Custinfo'

   CustPosition:LONGINT;  //Current Position in array, useful
                          //to keep track of which record is being used
                          //when amending

   RecordFound:BOOLEAN; //Whether or not a searched record was located







   PROCEDURE ResetCusts; //Sets all keyfields of all
   VAR Pos:LONGINT;      //records from 'undefined' to a rogue value
                         //of '-1' before reading files in
      BEGIN;

         FOR Pos:= 1 TO 50 DO
            Custs[Pos].CustId:='-1';

      END;







   PROCEDURE Load; //Loads records from file into Custs
   VAR Pos:LONGINT;

      BEGIN
         ResetCusts; //Set all keyfields of undefined records to a rogue value

         Pos:=0;                                //Assign array position to 0
         ASSIGN(CustFile,'F:\CustFile.DTA'); //Assign File
         RESET(CustFile);                       //Set File marker to beginning


         WHILE NOT (EOF(CustFile)) AND (Pos < 50)  DO   //While not end of the file
                                                        //and all 50 array positions haven't been used up

            BEGIN

               INC(Pos);  //Increment position in array, same as Pos:=Pos+1
               READ(CustFile,Cust); //Read the next position on file

               Custs[Pos].CustId:=Cust.CustId;             //Reads current record fields
               Custs[Pos].CustSurname:=Cust.CustSurname;   //into current array position
               Custs[Pos].CustForename:=Cust.CustForename;

            END;

          CLOSE(CustFile); //All records in file are now in memory
                           //so file is no longer needed until saving
                           //and can be closed

      END;












   PROCEDURE Save; //Saves 'valid' records stored in Custs to file
   VAR Pos:LONGINT;

       TempPos,MaxTempPos:LONGINT;

       TempCusts:CustArray; //Temp Array of records

      BEGIN
        TempPos:=0;
        MaxTempPos:=0;
        ASSIGN(CustFile,'F:\CustFile.DTA');  //Assign file again, as it was closed
        REWRITE(CustFile);                      //when loaded, and rewrite the file

        FOR Pos:=1 TO 50 DO
           IF Custs[Pos].CustId<> '-1' THEN  //As the array was reset before reading in
                                             // all 'undefined' records in the array, the custid
                                            //was set to '-1', this can now be used as a rogue id to search for

              BEGIN

                 INC(TempPos);
                  //Reads all 'valid' records in the array into a new array
                 TempCusts[TempPos].CustId := Custs[Pos].CustId;
                 TempCusts[TempPos].CustSurname:= Custs[Pos].CustSurname;
                 TempCusts[TempPos].CustForename := Custs[Pos].CustForename

              END;

        MaxTempPos:=TempPos; //maximum position of array containing only valid records

        FOR TempPos:=1 TO MaxTempPos DO  //For total amount of valid records write to file

           BEGIN

              Cust.CustId:=TempCusts[TempPos].CustId;
              Cust.CustSurname:=TempCusts[TempPos].CustSurname;
              Cust.CustForename:=TempCusts[TempPos].CustForename;

              WRITE(CustFile,Cust); //Write current record to file

           END;

        CLOSE(CustFile); //Close the file

        Load;         //Reload the file from disk, permanantly deletes
                      //all the records marked for deletion still in memory
                      //as they are overwritten by the file being read in

      END;









   PROCEDURE DisplayCurrent;  //Displays specified record

   VAR Key: CHAR;

      BEGIN
         CLRSCR;

            //Display fields for current records in location [CustPosition]
            WRITE('Customer Id:       ');  WRITELN('   ',Custs[CustPosition].CustId);
            WRITE('Customer Surname:  ');  WRITELN('   ',Custs[CustPosition].CustSurname);
            WRITE('Customer Forename: ');  WRITELN('   ',Custs[CustPosition].CustForename);

            REPEAT

            Key:=UPCASE(ReadKey);

            UNTIL Key=#13; //Display current record until 'Enter' is pressed

         END;






   PROCEDURE DisplayAll;

   VAR Pos, MaxPos :LONGINT;

      BEGIN

         MaxPos:=50;

         FOR Pos:=1 TO 50 DO
          IF Custs[Pos].CustId <> '-1' THEN   //If current Customer isnt `invalid` then display

             BEGIN

                CustPosition:=Pos;  //Set the global variable 'CustPosition' to the current record position to be displayed
                DisplayCurrent;

             END;
      END;







   PROCEDURE Find; //Locates a record and sets the current position
                   //to the position of the specified record

   VAR Pos, MaxPos :LONGINT;
       TempId      :STRING;


      BEGIN

         MaxPos:=50;
         RecordFound:=FALSE;
         Pos:=0;
         CustPosition:=0;
         CLRSCR;

         WRITELN('Enter Customer Id');
         READLN(TempId);

         TempId:=UPPERCASE(TempId);

         WHILE (NOT RecordFound) AND (Pos<>MaxPos) DO //While Customer hasn't been found
                                                //and all records haven't been searched
            BEGIN

               IF TempId = Custs[Pos+1].CustId THEN
                  RecordFound:=TRUE;

                  Pos:=Pos+1;

            END;

         IF RecordFound THEN

            CustPosition:=Pos

         ELSE

            BEGIN

               WRITELN('Not Found, Press `Enter` to continue ...');
               READLN;

            END;

      END;







   PROCEDURE FindDisplay; //Performs a search then displays the record if found

      BEGIN

         Find;
         IF RecordFound THEN DisplayCurrent;

      END;







   PROCEDURE AmendSurname;

   VAR TempSurname:STRING;

      BEGIN

         CLRSCR;
         WRITELN('Enter new Surname: ');
         READLN(TempSurname);
         WRITELN('Surname has changed to: ',TempSurname);
         WRITELN('Press `Enter` to continue ...');
         READLN;

         Custs[CustPosition].CustSurname:=TempSurname;

      END;







   PROCEDURE AmendForename;

   VAR TempForename:STRING;

      BEGIN

         CLRSCR;
         WRITELN('Enter new Forename: ');
         READLN(TempForename);
         WRITELN('Forename has changed to: ',TempForename);
         WRITELN('Press `Enter` to continue ...');
         READLN;

         Custs[CustPosition].CustForename:=TempForename;
      END;







   PROCEDURE AmendCustId;

   VAR TempId:STRING;

      BEGIN

         CLRSCR;
         WRITELN('Enter new Customer Id: ');
         READLN(TempId);
         TempId:=UPPERCASE(TempId);
         WRITELN('Customer Id has changed to: ',TempId);
         WRITELN('Press `Enter` to continue ...');
         READLN;

         Custs[CustPosition].CustId:=TempId;

      END;






   PROCEDURE Amend;

   VAR Choice: CHAR;

      BEGIN

         Find;

         IF RecordFound THEN

            REPEAT

               //Display Amend Menu
               CLRSCR;
               WRITELN('                                Amend Menu'); WRITELN; WRITELN; WRITELN;
               WRITELN('                   `1`...... Amend Customer Id'); WRITELN;
               WRITELn('                   `2`...... Amend Customer Surname'); WRITELN;
               WRITELN('                   `3`...... Amend Customer Forename'); WRITELN;

               GOTOXY(1,25); TEXTBACKGROUND(BLUE);

               WRITE('                     Press `X` to return to the main menu                      ');

               TEXTBACKGROUND(BLACK);

               Choice:=UPCASE(READKEY);

               CASE Choice OF

               '1':AmendCustId;
               '2':AmendSurname;
               '3':AmendForename;

               'X':;

               END;

            UNTIL Choice='X';

            Save; //Save all changes made to file
      END;






   PROCEDURE Add;

   VAR Pos ,MaxPos :LONGINT;
       Space       :BOOLEAN;

      BEGIN

         Pos:=0;
         MaxPos:=50;
         Space:=FALSE;
         CLRSCR;

         WHILE (Pos<>MaxPos) AND (NOT Space) DO

            BEGIN

               IF Custs[Pos+1].CustId='-1' THEN
                  Space:=TRUE;

                  Pos:=Pos+1;
            END;

         IF Space = TRUE THEN

            BEGIN

               CustPosition:=Pos; //Set the record position

               AmendCustId;
               AmendSurname;
               AmendForename;
               Save;

               WRITELN('New record created, press `Enter` to continue ...');

            END ELSE

               WRITELN('Not enough space to create a new record, press `Enter` to continue ...');

               READLN;

      END;






   PROCEDURE Delete;

   VAR Key:CHAR;

      BEGIN

         Find;
         IF RecordFound THEN

            REPEAT

              CLRSCR;
              WRITELN('Are you sure you wish to delete record with id: ',Custs[CustPosition].CustId,'  ? (Y/N)');
              Key:=UPCASE(READKEY);

              IF Key='Y' THEN

                 BEGIN

                    Custs[CustPosition].CustId:='-1';
                    Save; //Since it's now a rogue value, won't be saved to file
                          //and the record is now gone forever when the program closes
                    WRITELN('Record Deleted!');

                 END;

              IF Key='N' THEN

                 WRITELN('Delete Process Aborted!');

            UNTIL (Key='Y') OR (Key='N');

            WRITELN('Press `Enter` to continue ...');
            READLN;

      END;







   PROCEDURE MainMenu;

   VAR Choice:CHAR;

      BEGIN
         TEXTCOLOR(WHITE);
         REPEAT

               //Display Main Menu

               WRITELN('                             Main Menu'); WRITELN; WRITELN; WRITELN;
               WRITELN('                     `1`...... Display All Customers'); WRITELN;
               WRITELn('                     `2`...... Find Customer'); WRITELN;
               WRITELN('                     `3`...... Amend Customer'); WRITELN;
               WRITELN('                     `4`...... Add Customer'); WRITELN;
               WRITELN('                     `5`...... Delete Customer');

               GOTOXY(1,25); TEXTBACKGROUND(BLUE);

               WRITE('                               Press `X` to Exit                               ');

               TEXTBACKGROUND(BLACK);

               Choice:=UPCASE(READKEY);

               CASE Choice OF

               '1':DisplayAll;
               '2':FindDisplay;
               '3':Amend;
               '4':Add;
               '5':Delete;

               'X':;

               END;

               CLRSCR;

            UNTIL Choice='X';

      END;



   PROCEDURE StartUp;

      BEGIN

         Load;
         MainMenu;

      END;


   BEGIN
      STARTCHECK;
      StartUp;

   END.
