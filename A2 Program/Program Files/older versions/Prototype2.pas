PROGRAM PROTOTYPE;
USES SYSUTILS,VPUTILS,CRT,TennantDat,KeyDat,Datecalc,Draw;

TYPE DataRecord= RECORD  {Creates record that stores time/date}

                   LastDate:STRING;
                   LastTime:STRING;

                 END;


  VAR Redisplay:BOOLEAN;
      DataRec:DataRecord;
      DataFile: FILE OF DataRecord;



   PROCEDURE DrawClock;
   VAR I:INTEGER;
       Time:STRING;

      BEGIN

         TEXTBACKGROUND(BLACK);

         HIDECURSOR;        {clock is constantly refreshing}
                            {hiding cursor stops 'flickering' effects'}
         TEXTCOLOR(GREEN);
         GOTOXY(65,6);
         ObtainTime(Time);   {uses obtaintime function in DateCalc Unit}
         WRITELN(Time);
         DELAY(50);

         SHOWCURSOR;

      END;



    PROCEDURE CurrentChoiceTest(Choice:BOOLEAN);   {Highlights the currently}
                                                  {Selected option with a background}
      BEGIN                                       {colour and text colour}

         IF Choice=TRUE THEN

         BEGIN

            TEXTBACKGROUND(RED);   {If option selected give}
            TEXTCOLOR(YELLOW);     {yellow text and red background}

         END ELSE

         BEGIN

            TEXTBACKGROUND(BLUE);  {If option not selected give}
            TEXTCOLOR(LIGHTCYAN);  {Lightcyan text and Blue background}

         END;

      END;






   PROCEDURE DrawRefresh(Menu:CHAR;CurrentChoice:INTEGER); {draws all parts that will be changed if selected}
                                                                   {e.g. text menu options}
      BEGIN
        TEXTCOLOR(WHITE);
      DrawClock;

      IF ReDisplay=TRUE THEN           {If the menu choice has changed then}
                                       {the menu needs to be reloaded else it stays the same}
      BEGIN

         TEXTBACKGROUND(BLUE);
         TEXTCOLOR(WHITE);
         GOTOXY(28,3);

         CASE Menu OF        {Writes title based on current menu}
         'T':WRITELN('Tennant Menu');
         'L':WRITELN('LandLord Menu');
         'K':WRITELN('Keys Menu');
         'H':WRITELN('Houses Menu');
         'P':WRITELN('Payments Menu');
         'M':WRITELN('OakHill Main Menu');

         END;


         GOTOXY(3,8);
         IF CurrentChoice=1 THEN                        {Test if the option is selected}
         CurrentChoiceTest(TRUE)                        {Write location of menu names}
         ELSE CurrentChoiceTest(FALSE);

         IF Menu='M' THEN
         WRITELN('1:Tennants       ')
         ELSE
         WRITELN('1:Display All    ');



         GOTOXY(3,10);
         IF CurrentChoice=2 THEN
         CurrentChoiceTest(TRUE)
          ELSE CurrentChoiceTest(FALSE);

         IF Menu='M' THEN
         WRITELN('2:LandLords      ')
         ELSE
         WRITELN('2:Find           ');



         GOTOXY(3,12);
         IF CurrentChoice=3 THEN
         CurrentChoiceTest(TRUE)
          ELSE CurrentChoiceTest(FALSE);

         IF Menu='M' THEN
         WRITELN('3:Keys           ')
         ELSE
         WRITELN('3:Amend          ');



         GOTOXY(3,14);
         IF CurrentChoice=4 THEN
         CurrentChoiceTest(TRUE)
          ELSE CurrentChoiceTest(FALSE);

         IF Menu='M' THEN
         WRITELN('4:Houses         ')
         ELSE
         WRITELN('4:Add            ');



         GOTOXY(3,16);
         IF CurrentChoice=5 THEN
         CurrentChoiceTest(TRUE)
          ELSE CurrentChoiceTest(FALSE);

         IF Menu='M' THEN
         WRITELN('5:Payments       ')
         ELSE
         WRITELN('5:Delete         ');


        END;

      END;




     PROCEDURE DrawMainMenu(LastDate,LastTime:STRING); {Draws the main menu which doesn't need to be reloaded}
      VAR I:INTEGER;                                   {except when after an option has finished}
          Date:STRING;

      BEGIN

          BEGIN

         TEXTCOLOR(LIGHTCYAN);
         TEXTBACKGROUND(BLUE);
         Fillbox(20,1,60,5); {Fills background within the 4 specified points with colour Custom Draw unit}
         Fillbox(2,8,20,17);

         Drawbox(20,1,60,5); {Draws a rectangle (startingX,StartingY,EndingX,EndingY) Custom Draw Unit}
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
         WRITE('     Press "X" Key To Exit');


         TEXTBACKGROUND(BLACK);
         TEXTCOLOR(GREEN);

         DRAWBOX(64,1,76,3);  {draws the Date/Time boxes}
         DRAWBOX(64,3,76,5);
         DRAWBOX(64,5,76,7);

      FOR I:=3 TO 6 DO

         BEGIN
            GOTOXY(64,I);
            WRITE(#195);
            GOTOXY(76,I);
            WRITE(#180);
            I:=I+1;


         END;


         TEXTCOLOR(GREEN);
         GOTOXY(65,2);
         WRITE('Date/Time');
         GOTOXY(65,4);
         ObtainDate(Date);  {Display Date function in custom DateCalc Unit}
         WRITELN(Date);


         FILLBOX(23,7,61,21);
         TEXTBACKGROUND(BLACK);
         TEXTCOLOR(RED);
         DRAWDOUBLEBOX(22,7,62,22); {Same as DrawBox but use a different ascii codes to}
         TEXTBACKGROUND(BLACK);     {display a double lined version}
         END;

         GOTOXY(19,23);
         WRITELN('Program last accessed: ',LastDate,' at ',LastTime);


         END;



   PROCEDURE DrawEnd; {when the program has been "exited"}
   VAR I:LONGINT;

     BEGIN

      CLRSCR;
         TEXTCOLOR(9);
         FOR I:=1 TO 1999 DO {25*80 writes to whole screen}
         WRITE('#');
            HIDECURSOR;
            WINDOW(20,10,60,16);
            TEXTBACKGROUND(BLUE);
            TEXTCOLOR(YELLOW);
            GOTOXY(2,2);
            WRITELN(' Thank you for using Oaktree Prototype');
            WRITELN('       Created by Ross Meikleham       ');
            WRITELN('            Press "X" to Exit..        ');
            WRITELN('                                       ');
            DRAWDOUBLEBOX(1,1,40,6);


     END;



    PROCEDURE SubOptions(Choice:CHAR;Menu:CHAR);  {Selects the function}
                                                  {to perform depending}
     BEGIN                                        {what the current menu is}
     WINDOW(23,8,61,21);                          {and what option has been}
     TEXTCOLOR(WHITE);                            {selected}

     CASE Menu OF

      'T':CASE Choice OF      {If on Tennant Menu}
        '1':AddCustomer;
        '2':AmendCustomer;
        '3':DisplayCustDetails;
        '4':DeleteCustomer;
        END;

     // 'L':CASE Choice OF      {If on LandLord Menu}
     //    '1':AddLandLord:
     //    '2':AmendLandLord:
     //    '3':DisplayLandLordDetails:
     //    '4':DeleteLandLord:
     //    '5'
     //   END;


     // 'K':CASE Choice OF       {If on Key Menu}
        //'1':AddKey;
        //'2':AmendKey;
        //'3':DisplayKey;
        //'4':DeleteKey;
      //  END;


      // 'H' CASE Choice OF      {If on House Menu}
        //'1':AddCustomer;
        //'2':AmendCustomer;
        //'3':DisplayCustDetails;
        //'4':DeleteCustomer;
      //  END;

     //  'P' CASE Choice OF     {If On Payment Menu}
          //'1':AddPayment;
          //'2':AmendPayment;
          //'3':DisplayPayment;
          //'4':DeletePayment;
       //  END;

     END;
        CLRSCR;
        WINDOW(1,1,80,25);   {sets window back to fullsize}
        ReDisplay:=TRUE;
        DrawMainMenu(DataRec.LastDate,DataRec.LastTime);

     END;






   PROCEDURE EndBox;  {message displayed when program ends}
   VAR I:INTEGER;
       Date:STRING;
       Time:STRING;
      BEGIN

           ObtainDate(Date);
         ObtainTime(Time);

         REWRITE(DataFile);

         DataRec.LastDate:=Date; {Reads current date into record}
         DataRec.LastTime:=Time; {Reads current time into record}

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
         DrawMainMenu(DataRec.LastDate,DataRec.LastTime);
         ChoiceCount:=1;
         ReDisplay:=TRUE;
         Menu:='M';
         DrawRefresh(Menu,ChoiceCount);

         REPEAT

            REPEAT DrawClock;    {reload the clock so time moves}

            UNTIL KEYPRESSED=TRUE; {repeats refreshing the clock until a key is pressed}

            Press:=UPCASE(READKEY); {same key pressed is assigned to 'Press'}
            CASE Press OF

            #80:BEGIN           {Down Arrow}

                   IF ChoiceCount <5 THEN
                   ChoiceCount:=ChoiceCount+1
                   ELSE              {If option highlighted is the last and down is pressed}
                   ChoiceCount:=1;   {return to the first option}

                   Redisplay:=TRUE;

                END;

         #72:BEGIN                   {Up Arrow}


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



         IF (Press=#13) AND (Menu<>'M') THEN      {If on a Submenu}
        BEGIN                                     {and enter has been pressed}
         CASE ChoiceCount OF                      {select a function from suboption}
         1:SubOptions('1',Menu);                  {procedure}
         2:SubOptions('2',Menu);
         3:SubOptions('3',Menu);
         4:SubOptions('4',Menu);
         5:SubOptions('5',Menu);
         END;
         ChoiceCount:=1;
        END;

         IF (Press=#13) AND (Menu='M') THEN      {If On MainMenu}
         CASE ChoiceCount OF                     {and enter has been pressed}
         1:Menu:='T';                            {set the variable determining}
         2:Menu:='L';                            {which is the current menu}
         3:Menu:='K';                            {to the one selected}
         4:Menu:='H';
         5:Menu:='P';
         END;


         IF (Press='X') AND (Menu<>'M') THEN     {If on a Submenu and x is pressed}
         BEGIN                                   {return to the main menu}
         Menu:='M';
         Press:='a'; {set to rogue value so program doesn't exit}
         END;

         DrawRefresh(Menu,ChoiceCount);

         UNTIL (Press='X') AND (Menu='M');      {If on Main Menu when X is pressed exits program}
         EndBox;

      END;



   PROCEDURE StartUpKeys(VAR Found:BOOLEAN); {Searches for keys file}
   VAR Loading:BOOLEAN;                      {displays if it's found and filesize}

      BEGIN
         Loading:=FALSE;
         WRITELN('Loading Keys File...');
         LoadKey(Loading);
         IF Loading=TRUE THEN

            BEGIN

               WRITELN('Keys File Loaded');
               WRITELN('Keys File Size: ',ROUND(FILESIZE(KeyFile)),'Bytes');

            END ELSE

            BEGIN

               WRITELN('Error, Keys File Not Found.');
               Found:=FALSE;

            END
      END;



   PROCEDURE StartUpTennant(VAR Found:BOOLEAN);
   VAR Loading:BOOLEAN;

      BEGIN

         WRITELN('Loading Tennant File...'); {Searches for Tennant File}
         LoadCustFile(Loading);              {displays if it's found and filesize}
         IF Loading=TRUE THEN

            BEGIN

            WRITELN('Tennant File Loaded');
            WRITELN('Tennant File Size: ',ROUND(FILESIZE(CustFile)),'Bytes');

         END ELSE

            BEGIN

            WRITELN('Error, Tennant File Not Found.');
            Found:=FALSE;

            END;

      END;


   PROCEDURE StartupData(VAR Found:BOOLEAN); {loads core data, e.g. the last time the program was run}

      BEGIN

      WRITELN('Loading Core Data');



      ASSIGN(DataFile,'D:\Computing\A2\Main Program\DataFile.DTA');  {Finds the file to be read from}


       IF NOT FILEEXISTS('D:\Computing\A2\Main Program\DataFile.DTA') THEN
       BEGIN
        Found:=FALSE;
        WRITELN('Error, Core Data File not found')
       END

         ELSE
         BEGIN
          RESET(DataFile);
         READ(DataFile,DataRec);
         WRITELN('Core Data Loaded');
            WRITELN('Core Data Size: ',ROUND(FILESIZE(DataFile)),'Bytes');
            END;


      END;


   PROCEDURE StartUp(VAR Found:BOOLEAN);

      BEGIN

         Found:=TRUE;
         WRITELN('Initiating Prototype Program');
         WRITELN;
         StartUpData(Found);
         WRITELN;
         StartUpTennant(Found);
         WRITELN;
         StartUpKeys(Found);
         WRITELN;{
         StartUpLandLord;
         WRITELN;
         StartUpHouses;
         WRITELN;
         StartUpPayments;}

      END;


   PROCEDURE Initiate(VAR Found:BOOLEAN);

      BEGIN

         IF Found= TRUE THEN

            BEGIN

               WRITELN;
               RESET(DataFile);
               Flash('All Files were loaded successfully, press any key to continue..');
               CLRSCR;
               MainMenu;

            END ELSE

            BEGIN

               WRITELN;
               Flash('One or more files could not be found, press any key to exit..');

            END;

      END;



   PROCEDURE Run;
   VAR Found:BOOLEAN;

      BEGIN
         Startup(Found);
         Initiate(Found);

      END;



BEGIN
Run;
END.
