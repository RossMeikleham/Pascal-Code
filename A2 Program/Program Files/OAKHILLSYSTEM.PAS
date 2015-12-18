PROGRAM OAKHILLSYSTEM;

USES
     //Built In Pascal Units
     SYSUTILS,VPUTILS,CRT,

     //Custom Self Made Units
     TenantDat, //Manages information and files to do with Tenants
     PropertyDat, //Manages information and files to do with Properties
     LandLordDat, //Manages information and files to do with Landlords
     PaymentDat,  //Manages information and files to do with Payments

     Validate, //Contains validation sub-routines
     Datecalc, //Contains sub-routines for date calculations
     Draw,     //Contains sub-routines for creating the user interface

     //Custom Unit
     NetWorkPrint, //Contains Sub-Routines for printing
     Debug;                 //Edited to allow printing Of other Data Types other than
                      //String to save code converting



TYPE DataRecord=RECORD  //Creates record that stores information to
                                        //let the user know statistics about the system

                   LastDate:STRING; //Last Date the program was accessed
                   LastTime:STRING; //Last Time         the program was accessed
                   LastBackup:STRING; //Last Date the files were backed up
                 END;


  VAR Redisplay:BOOLEAN;  //Whether some of the interface needs to be changed
                          //Saves rewriting entire screen when a key is pressed

      DataRec:DataRecord; //Variable of Type DataRecord
      DataFile: FILE OF DataRecord; //File of the Record
      TitleText:STRING; //Text of the current Menu Title
      DriveLetter:CHAR; //Letter of the Drive that data is being read/written to
      BackupData: FILE OF DataRecord; //Backup File








   PROCEDURE Notifications;  //messages to the user, will include information
                               //about outstanding payments and taken keys
         BEGIN

            WINDOW(22,8,78,21); //Set Window Size
            TEXTBACKGROUND(RED);
            TEXTCOLOR(YELLOW);
            WRITELN('                    NOTIFICATIONS                       '); //Write title
            TEXTBACKGROUND(BLACK);
            TEXTCOLOR(CYAN);
            WRITELN('Program last accessed: ',DataRec.LastDate,' at ',DataRec.LastTime); //Write last date and time accessed
            WRITELN;

            DisplayMainOwed;   //Calculate Payments owed from Tenants
            WINDOW(1,1,80,25);

         END;



   PROCEDURE DrawRefresh(Menu:CHAR;CurrentMenuChoice:INTEGER); {draws all parts that will be changed if selected}
   VAR I:INTEGER;
                                                                   {e.g. text menu options}
      BEGIN
      TEXTCOLOR(WHITE);
      IF ReDisplay=TRUE THEN           {If the menu choice has changed then}
                                       {the menu needs to be reloaded else it stays the same}
      BEGIN

         TEXTBACKGROUND(BLUE);
         TEXTCOLOR(WHITE);
         GOTOXY(40,3);
         FOR I:= 1 TO Length(TitleText) DO   {erase previous text}
         WRITE(' ');

         CASE Menu OF        {Selects title based on current menu}

            'T':TitleText:='Tenant Menu';
            'L':TitleText:='LandLord Menu';
            'K':TitleText:='Keys Menu';
            'H':TitleText:='Properties Menu';
            'P':TitleText:='Payments Menu';
            'M':TitleText:='OakHill Main Menu';

         END;

         GOTOXY(40,3);
         WRITELN(TitleText); //Writes Title at the top of the screen
         GOTOXY(3,8);

         IF CurrentMenuChoice=1 THEN                        {Test if the option is selected}
            ChoiceSelected(TRUE)                        {Write location of menu names}
         ELSE
            ChoiceSelected(FALSE);

         IF Menu='M' THEN
            WRITELN('1:Tenants        ')
         ELSE
            WRITELN('1:Display All    ');



         GOTOXY(3,10);
         IF CurrentMenuChoice=2 THEN
            ChoiceSelected(TRUE)
         ELSE
            ChoiceSelected(FALSE);

         IF Menu='M' THEN
         WRITELN('2:LandLords      ')
         ELSE
         WRITELN('2:Find           ');



         GOTOXY(3,12);
         IF CurrentMenuChoice=3 THEN
         ChoiceSelected(TRUE)
          ELSE ChoiceSelected(FALSE);

         IF Menu='M' THEN
         WRITELN('3:Properties     ')
         ELSE
         WRITELN('3:Amend          ');



         GOTOXY(3,14);
         IF CurrentMenuChoice=4 THEN
         ChoiceSelected(TRUE)
          ELSE ChoiceSelected(FALSE);

         IF Menu='M' THEN
         WRITELN('4:Payments     ')
         ELSE
         WRITELN('4:Add          ');



         GOTOXY(3,16);
         IF CurrentMenuChoice=5 THEN
         ChoiceSelected(TRUE)
          ELSE ChoiceSelected(FALSE);

         IF Menu='M' THEN
         WRITELN('  Backup    ')
         ELSE
         WRITELN('5:Delete         ');

         Notifications;
        END;

      END;







     PROCEDURE DrawMainMenu(LastDate,LastTime:STRING); {Draws the main menu which doesn't need to be reloaded}
      VAR Year,Month,Day,I:INTEGER;                                   {except when after an option has finished}
          Date:STRING;

        BEGIN

           TEXTCOLOR(LIGHTCYAN);
           TEXTBACKGROUND(BLUE);
           Fillbox(30,1,70,5); {Fills background within the 4 specified points with colour Custom Draw unit}
           Fillbox(2,8,20,17);

           Drawbox(30,1,70,5); {Draws a rectangle (startingX,StartingY,EndingX,EndingY) Custom Draw Unit}
                             {Holds title}

           Drawbox(2,7,20,17);


           Drawbox(2,9,20,9);  {Draws boxes for left hand menu}
           Drawbox(2,11,20,9);
           Drawbox(2,13,20,9);
           Drawbox(2,15,20,9);

           FOR I:=1 TO 4 DO

              BEGIN

                 GOTOXY(2,7+(2*I));  {replaces points of lines joining}
                 WRITE(#195);         {#195 for left points}
                 GOTOXY(20,7+(2*I));
                 WRITE(#180);         {#180 for right points}

              END;

           TEXTBACKGROUND(BLUE);
           GOTOXY(1,25);
           TEXTCOLOR(WHITE);
           GOTOXY(1,25);
           WRITE(#24,#25,' To highlight option ');  {writes bottom line with intructions}
           WRITE('  `Enter` to select option');
           WRITE('     Press "X" Key To Exit    ');


           TEXTBACKGROUND(BLACK);
           TEXTCOLOR(GREEN);
           DrawBox(4,1,16,3);  {draws the Date box}
           DrawBox(4,3,16,5);


              BEGIN

                 GOTOXY(4,3);  //Places corners on Date Box
                 WRITE(#195);
                 GOTOXY(16,3);
                 WRITE(#180);

              END;



           TEXTCOLOR(GREEN);
           GOTOXY(8,2);
           WRITE('Date');
           GOTOXY(5,4);
           Date:=ObtainDate;
           WRITELN(Date);   {Display Date function in custom DateCalc Unit}


           FILLBOX(23,7,61,21);
           TEXTBACKGROUND(BLACK);
           TEXTCOLOR(RED);
           DrawDoubleBox(21,7,79,22); {Same as DrawBox but use a different ascii codes to}
           TEXTBACKGROUND(BLACK);     {display a double lined version}



        END;



   PROCEDURE DrawEnd; {when the program has been "exited"}
   VAR I:LONGINT;

     BEGIN

        CLRSCR;
        TEXTCOLOR(9);
        FOR I:=1 TO 1999 DO {25*80 writes to whole screen}

           WRITE('#');

        WINDOW(20,10,60,16);
        TEXTBACKGROUND(BLUE);
        TEXTCOLOR(YELLOW);

        GOTOXY(2,2);
        WRITELN('            You are now Exiting        ');
        WRITELN('          Oakhill Property System      ');
        WRITELN('            Press "X" to Exit..        ');
        WRITELN('                                       ');
        DRAWDOUBLEBOX(1,1,40,6);


     END;



   PROCEDURE LoadbackupDataFile(VAR Found:BOOLEAN);
   VAR Year,Month,Day:LONGINT;
       Date,FilePath:STRING;
       DriveLetter:CHAR;

      BEGIN
          DriveLetter:='A';
          Found:=FALSE;

      REPEAT

         FilePath:=DriveLetter+':\MainProgram\Backup\DataFile.BCK'; {Finds the file to be read from}


         IF FILEEXISTS(FilePath) THEN
            Found:=TRUE
         ELSE
            DriveLetter:=CHR(ORD(DriveLetter)+1); //increment the drive, e.g. driveletter of 'A' becomes 'B'

      UNTIL (Found) OR (DriveLetter=CHR(ORD('Z')+1));

      IF Found THEN

         BEGIN

            ASSIGN(BackupData,FilePath);
            ASSIGN(DataFile,DriveLetter+':\MainProgram\Files\DataFile.DTA');
            RESET(BackupData);
            Date:=ObtainDate;
            REWRITE(DataFile);
            READ(BackupData,DataRec); //Read the backup file

            DataRec.LastDate:=DataRec.LastDate;
            DataRec.LastTime:=DataRec.LastTime;
            DataRec.LastBackup:=Date;

            WRITE (DataFile,DataRec); //Write into the new 'Current File'
            Close(BackupData);
         END

      END;



    PROCEDURE BackupDataFile;
    VAR Year,Month,Day:LONGINT;
        DATE:STRING;

      BEGIN

         ASSIGN(BackupData,DriveLetter+':\MainProgram\backup\DataFile.BCK');
         Date:=ObtainDate;
         REWRITE(BackupData);
         RESET(BackupData);
         READ(DataFile,DataRec); //Read from original file into BackupFile

         DataRec.LastDate:=DataRec.LastDate;
         DataRec.LastTime:=DataRec.LastTime;
         DataRec.LastBackup:=Date;

         WRITE (BackupData,DataRec);
         CLOSE(BackupData);

      END;



   PROCEDURE LoadFromBackup;
   VAR Choice:CHAR;
       Found:BOOLEAN;

      BEGIN

         CLRSCR;
         WRITELN('The last backup was created on ',DataRec.LastBackup);
         WRITELN('Are you sure you wish to backup? all current data will be lost. Y/N');

         ValidateYN(Choice);

         IF Choice='Y' THEN

             BEGIN

                WRITELN;
                WRITELN('Loading backup files...');

                LoadBackupTenant(Found);   //Attempt to Load Backup Tenant File
                IF Found THEN
                   WRITELN('Tenant Succeed')
                ELSE
                   WRITELN('Tenant Backup File failed');

                LoadBackupPay(Found);  //Attempt to Load Backup Pay File
                IF Found THEN
                   WRITELN('Pay Succeed')
                ELSE
                   WRITELN('Payments Backup File failed');

                LoadBackupProp(Found);   //Attempt to Load Backup Property File
                IF Found THEN
                   WRITELN('Prop Succeed')
                ELSE
                   WRITELN('Property Backup File failed');

                LoadBackupLord(Found);   //Attempt to Load Backup Lord File
                IF Found THEN
                   WRITELN('Lord Succeed')
                ELSE
                   WRITELN('LordBackup Failed');

                LoadBackupDataFile(Found);   //Attempt to Load Backup Data File
                IF Found THEN
                   WRITELN('Data Succeed')
                ELSE
                   WRITELN('Data Backup File Failed');

                WRITELN;
                WRITELN('Backup restore is complete');
             END
             ELSE    //If selected not to backup
                WRITELN('Backup Aborted');

             WRITELN('Press `Enter` to continue...');
             READLN;

      END;



     PROCEDURE Backup; //Option from the Main Menu
     VAR Year,Month,Day:LONGINT;
       Choice:CHAR;
       Date:STRING;


        BEGIN

           CLRSCR;
           TEXTCOLOR(WHITE);
           WRITE('Do you wish to');  TEXTCOLOR(GREEN);
           WRITELN('Save Current Files To Backup (S)'); TEXTCOLOR(WHITE);
           WRITE('Or ');TEXTCOLOR(RED);WRITELN('Overwrite Current Files with backup (O)?');
           TEXTCOLOR(WHITE);
           Val2Char('O','S',Choice);

           IF Choice='S' THEN  //If saving current files to backup

              BEGIN

                 WRITELN('This will overwrite the previous Backup Files');
                 WRITELN('The last backup was created on: NEVER ');//,DataRec.LastBackup);
                 WRITELN('Are you sure you wish to backup?(Y/N)');
                 ValidateYN(Choice);

                 IF Choice='Y' THEN

                    BEGIN

                       WRITELN('Creating backups, please wait...');
                       SaveTenantFile(TRUE); //Save TenantFile Backup is True
                       SavePayFile(TRUE);  //Save PayFile Backup is True
                       SavePropFile(TRUE); //Save PropFile Backup is True
                       SaveLandLordFile(TRUE); //Save LandLordFile Backup is True
                       BackupDataFile; //Create backup of Data File
                       WRITELN('Backups complete');

                    END ELSE

                       WRITELN('Creating backups Aborted');


              END ELSE LoadFromBackup;

           READLN;
           ReDisplay:=TRUE;
           CLRSCR;

        END;




    PROCEDURE SubOptions(Choice:CHAR;Menu:CHAR);  {Selects the function}
                                                  {to perform depending}
       BEGIN                                        {what the current menu is}
                                                  {and what option has been}
          TEXTCOLOR(WHITE);                            {selected}
          TEXTBACKGROUND(BLACK);
          CLRSCR;

          CASE Menu OF

             'T':CASE Choice OF      {If on Tenant Menu}

                '1':DisplayAllTenant;
                '2':DisplaySearchTenant;
                '3':AmendTenant;
                '4':AddTenant;
                '5':DeleteTenant;

             END;

             'L':CASE Choice OF      {If on LandLord Menu}

                '1':DisplayAllLandLord;
                '2':DisplaySearchLandLord;
                '3':AmendLandLord;
                '4':AddLandLord;
                '5':DeleteLandLord;

             END;

             'H' :CASE Choice OF      {If on Property Menu}

                '1':DisplayAllProp;
                '2':DisplaySearchProp;
                '3':AmendProp;
                '4':AddProp;
                '5':DeleteProp;

             END;

             'P' :CASE Choice OF     {If On Payment Menu}

                '1':DisplayAllPay;
                '2':DisplaySearchPay;
                '3':AmendPay(FALSE);
                '4':AddPay;
                '5':DeletePay;

             END;

          END;

          WINDOW(1,1,80,25); //Set the screen back to the original size
          CLRSCR;
          WINDOW(1,1,80,25);
          ReDisplay:=TRUE;  //Everything needs to be redrawn
          DrawMainMenu(DataRec.LastDate,DataRec.LastTime); //Redraw the Main menu

       END;




    PROCEDURE EndBox;  {message displayed when program ends}
    VAR I:INTEGER;

       Date,Time:STRING;

       BEGIN

          Date:=ObtainDate;
          Time:=ObtainTime;
          REWRITE(DataFile);
          RESET(DataFile);
          DataRec.LastDate:=Date; {Reads current date into record}
          DataRec.LastTime:=Time; {Reads current time into record}
          DataRec.lastBackup:=DataRec.LastBackup;
          WRITE(DataFile,DataRec);  {Writes the date/time to file to be retrieved}
          CLOSE(DataFile);          {the next time the program starts up}

          REPEAT

            DrawEnd;

          UNTIL UPCASE(READKEY)='X'

       END;




    PROCEDURE MainMenu;
    VAR ChoiceCount:INTEGER;
        Press,Menu:CHAR;

       BEGIN
         INTWATCH(ChoiceCount);
         CHARWATCH(Press);
         STARTWATCH;
         DrawMainMenu(DataRec.LastDate,DataRec.LastTime);
         ChoiceCount:=1; //Set Current Menu Choice to 1
         ReDisplay:=TRUE; //Set to draw entire menu interface
         Menu:='M';    //Menu set to 'Main Menu'
         DrawRefresh(Menu,ChoiceCount);
         TitleText:='OakHill Main Menu';

         REPEAT

            Press:=UPCASE(READKEY); {same key pressed is assigned to 'Press'}

            CASE Press OF

               #80:BEGIN           //`Down` Key

                      IF ChoiceCount <5 THEN
                         ChoiceCount:=ChoiceCount+1
                      ELSE              {If option highlighted is the last and down is pressed}
                         ChoiceCount:=1;   {return to the first option}

                      Redisplay:=TRUE;


                   END;

               #72:BEGIN                   //'Up' Key

                      IF ChoiceCount >1 THEN
                        ChoiceCount:=ChoiceCount-1
                      ELSE              {If option highlighted is the first and up is pressed}
                         ChoiceCount:=5;   {return to the last option}

                      Redisplay:=TRUE;

                   END;

               #13:;  {enter key, will select a function or new menu}

               'X':;  {to exit the current menu or program}

            ELSE

               ReDisplay:=FALSE;  {Nothing has changed in the program so output doesn't need to be reloaded}
            END;



            IF (Press=#13) AND (Menu<>'M') THEN   {If on a Submenu}

               BEGIN
                                                     {and enter has been pressed}
                  CASE ChoiceCount OF
                                         {select a function from suboption}
                     1:SubOptions('1',Menu);                     {procedure}
                     2:SubOptions('2',Menu);
                     3:SubOptions('3',Menu);
                     4:SubOptions('4',Menu);
                     5:SubOptions('5',Menu);

                  END;

                  ChoiceCount:=1;

               END;

            IF (Press=#13) AND (Menu='M') THEN      {If On MainMenu}

            CASE ChoiceCount OF
                                                 {and enter has been pressed}
               1:Menu:='T';                            {set the variable determining}
               2:Menu:='L';                            {which is the current menu}
               3:Menu:='H';                            {to the one selected}
               4:Menu:='P';
               5:Backup;

            END;


            IF (Press='X') AND (Menu<>'M') THEN     {If on a Submenu and x is pressed}

               BEGIN
                                                {return to the main menu}
                  Menu:='M';
                  Press:='a'; {set to rogue value so program doesn't exit}

               END;

            DrawRefresh(Menu,ChoiceCount);

         UNTIL (Press='X') AND (Menu='M');      {If on Main Menu when X is pressed exits program}
         EndBox;

       END;



   PROCEDURE StartUpTenant(VAR Found:BOOLEAN);
   VAR Loading:BOOLEAN;

      BEGIN
         WRITELN('Loading Tenant File...');  //Searches for Tennant File}
         LoadTenantFile(Loading,DriveLetter);
         IF Loading=TRUE THEN

            BEGIN

               TEXTCOLOR(GREEN);
               WRITELN('Tenant File Loaded');
               WRITELN('Records in File: ',ROUND(FILESIZE(TenantFile)));  //Display File Size


               TEXTCOLOR(WHITE);

            END
            ELSE   //If file not Found

               BEGIN

                  TEXTCOLOR(RED);
                  WRITELN('Error, Tenant File Not Found.');
                  Found:=FALSE;
                  TEXTCOLOR(WHITE);

               END;

      END;



   PROCEDURE StartUpProperty(VAR Found:BOOLEAN);
   VAR Loading:BOOLEAN;

      BEGIN

         WRITELN('Loading Property File...');
         LoadProp(Loading,DriveLetter);
         IF Loading=TRUE THEN

            BEGIN
            TEXTCOLOR(GREEN);
            WRITELN('Property File Loaded');
            WRITELN('Records in File: ',ROUND(FILESIZE(PropFile)));
            TEXTCOLOR(WHITE);
            END ELSE

            BEGIN
            TEXTCOLOR(RED);
            WRITELN('Error, Property File Not Found.');
            Found:=FALSE;
            TEXTCOLOR(WHITE);
            END;
       END;


   PROCEDURE StartUpPayments(VAR Found:BOOLEAN);
   VAR Loading:BOOLEAN;

      BEGIN

         WRITELN('Loading Payment File...');
         LoadPay(Loading,FALSE,DriveLetter);
         IF Loading=TRUE THEN

            BEGIN
            TEXTCOLOR(GREEN);
            WRITELN('Payment File Loaded');
            WRITELN('Records in File: ',ROUND(FILESIZE(PayFile)));
            TEXTCOLOR(WHITE);
            END ELSE

            BEGIN
            TEXTCOLOR(RED);
            WRITELN('Error, Payment File Not Found.');
            Found:=FALSE;
            TEXTCOLOR(WHITE);
            END;
       END;


   PROCEDURE StartUpLandLord(VAR Found:BOOLEAN);
   VAR Loading:BOOLEAN;

      BEGIN

         WRITELN('Loading LandLord File...');
         LoadLandLordFile(Loading,DriveLetter);
         IF Loading=TRUE THEN

            BEGIN
            TEXTCOLOR(GREEN);
            WRITELN('LandLord File Loaded');
            WRITELN('Records In File: ',(FILESIZE(LandlordFile)));
            TEXTCOLOR(WHITE);
            END ELSE

            BEGIN
            TEXTCOLOR(RED);
            WRITELN('Error, LandLord File Not Found.');
            Found:=FALSE;
            TEXTCOLOR(WHITE);
            END;
       END;



   PROCEDURE StartupData(VAR Found:BOOLEAN); {loads core data, e.g. the last time the program was run}



      BEGIN

      WRITELN('Loading Core Data..');
      WRITELN;
      Found:=FALSE;
      DriveLetter:='A';

      WHILE (Found=FALSE) AND (DriveLetter <CHR(ORD('Z')+1)) DO

      BEGIN
      ASSIGN(DataFile,DriveLetter+':\MainProgram\Files\DataFile.DTA');  {Finds the file to be read from}
      WRITE('Searching Drive ',DriveLetter,' for files....');

       IF NOT FILEEXISTS(DriveLetter+':\MainProgram\Files\DataFile.DTA') THEN
       BEGIN
       Found:=FALSE;
       WRITELN('   Not Found in Drive ',DriveLetter,' ..');
       DriveLetter:=CHR(ORD(Driveletter)+1); //Increment the drive letter
       END ELSE
       Found:=TRUE;

       END;

         IF Found=FALSE THEN
         BEGIN
         TEXTCOLOR(RED);
         WRITELN('Error, Core Data File not found');
         TEXTCOLOR(WHITE);
         END
         ELSE
         BEGIN

          RESET(DataFile);
         READ(DataFile,DataRec);
         TEXTCOLOR(GREEN);
         WRITELN('   Files found in Drive ',DriveLetter,'..');
         WRITELN;
         WRITELN('Core Data Loaded');
         WRITELN('Records in File: ',(FILESIZE(DataFile)));
         TEXTCOLOR(WHITE);
            END;


      END;


   PROCEDURE StartUp(VAR Found:BOOLEAN);

      BEGIN

         Found:=TRUE;
         TEXTCOLOR(GREEN);
         WRITELN('[Initiating Oakhill Program]');
         TEXTCOLOR(WHITE);
         WRITELN;
         StartUpData(Found);
         WRITELN;
         StartUpTenant(Found);
         WRITELN;
         StartUpLandLord(Found);
         WRITELN;
         StartUpproperty(Found);
         WRITELN;
         StartUpPayments(Found);

      END;










   PROCEDURE Initiate(VAR Found:BOOLEAN);
   VAR Choice:CHAR;
      BEGIN

         IF Found= TRUE THEN //If all Files found

            BEGIN

               WRITELN;
               RESET(DataFile);
               TEXTCOLOR(GREEN);
               WRITELN('All Files were loaded successfully, press enter to continue..');
               WRITELN;
               WRITELN('Z to overwrite Files with Backup');
               TEXTCOLOR(WHITE);

                  REPEAT

                     Choice:=UPCASE(READKEY);
                     IF Choice='Z' THEN

                        LoadFromBackup;

                     IF Choice=#13 THEN

                        BEGIN

                           CLRSCR;

                           MainMenu;

                        END;

                  UNTIL (Choice='X') OR (Choice='Z') OR (Choice=#13);

            END ELSE   //If a file is missing

            BEGIN

               WRITELN;
               TEXTCOLOR(RED);
               WRITELN('One or more files could not be found, press any key to exit..');
               WRITELN;
               WRITELN('                X To attempt overwrite files with backups');
               TEXTCOLOR(WHITE);
               Choice:=UPCASE(READKEY);
               CLRSCR;
               IF Choice='X' THEN
                  LoadFromBackup; //Attempt to load files from backup
            END;

      END;



   PROCEDURE Run;
   VAR Found:BOOLEAN;

      BEGIN
         RESETWATCH;
         SetMonths;
         Startup(Found);
         Initiate(Found);

      END;



BEGIN
Run;
END.
