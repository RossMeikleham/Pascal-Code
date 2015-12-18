PROGRAM PROTOTYPE;
USES DRAW,CRT,DATECALC;

  VAR Redisplay:BOOLEAN;
      Key:STRING;
      Found:BOOLEAN;

   PROCEDURE CurrentChoiceTest(Choice:BOOLEAN);   {Highlights the currently}
                                                  {Selected option with a background}
      BEGIN                                       {colour and text colour}

         IF Choice=TRUE THEN

         BEGIN

            TEXTBACKGROUND(RED);
            TEXTCOLOR(YELLOW);

         END ELSE

         BEGIN

            TEXTBACKGROUND(BLUE);
            TEXTCOLOR(LIGHTCYAN);
         END;

      END;



   PROCEDURE TimeWindow;
   VAR Time:STRING;
      BEGIN

         TEXTCOLOR(GREEN);
         DRAWBOX(64,2,76,4);

        REPEAT
         GOTOXY(65,3);
         ObtainTime(Time);
         WRITE(Time);
        IF KeyPressed=TRUE THEN
        Key:=UPCASE(READKEY);

        UNTIL (KeyPressed=TRUE) AND ((Key=#80) OR (Key=#72));

      END;



   PROCEDURE DrawMenu(CurrentChoice:INTEGER);
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
         DRAWBOX(20,13,60,10);  {creates a horizontal line}
         DRAWBOX(20,16,60,10);  {used to create sections for options}
         DRAWBOX(20,19,60,10);

         FOR I:=1 TO 4 DO
         BEGIN

            GOTOXY(20,7+(3*I));  {replaces points of lines joining}
            WRITE(#195);         {#195 for Ã left points}
            GOTOXY(60,7+(3*I));
            WRITE(#180);         {#180 for ´ right points}

         END;


         TEXTCOLOR(WHITE);
         GOTOXY(28,3);
         WRITELN('      Prototype Test');

         GOTOXY(21,8);
         IF CurrentChoice=1 THEN                        {Test if the option is selected}
         CurrentChoiceTest(TRUE)                        {Write location of menu names}
         ELSE CurrentChoiceTest(FALSE);
         WRITELN('                Display                ');
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



   PROCEDURE MainMenu;
   VAR ChoiceCount:INTEGER;

      BEGIN
         ChoiceCount:=1;
         REPEAT

            DrawMenu(ChoiceCount);
            Redisplay:=TRUE;
            GOTOXY(1,1);

            IF (Key=#80) AND (ChoiceCount <6) THEN
            BEGIN

            ChoiceCount:=ChoiceCount+1;
            DrawMenu(ChoiceCount);

            END;

            IF (Key=#72) AND (ChoiceCount >0) THEN
            BEGIN

            ChoiceCount:=ChoiceCount-1;
            DrawMenu(ChoiceCount);

            END;


            IF (Key=#80) AND (ChoiceCount =6) THEN
            BEGIN
                                                          {If at first option and option}
               ChoiceCount:=1;                            {to go back is selected then}
               DrawMenu(ChoiceCount);                     {goes to the last option}

           END;


            IF (Key=#72) AND (ChoiceCount =0) THEN
            BEGIN
                                                          {If at last option and option}
               ChoiceCount:=5;                            {to go foreward is selecred then}
               DrawMenu(ChoiceCount);                     {goes to the first option}

            END;

            IF (Key<>#80) AND (Key<>#72)
            THEN Redisplay:=FALSE;


       //  IF Key=#13 THEN
       //  CASE ChoiceCount OF
       //  1:DisplayCustDetails;
       //  2:DeleteCustomer;
       //  3:AddCustomer;
       //  4:AmendCustomer;
      ///   END;

         UNTIL (Key='X');                     {When X is pressed exits program}
      END;


BEGIN

//LOADCUSTFILE(Found);
Redisplay:=TRUE;
MainMenu;
END.
