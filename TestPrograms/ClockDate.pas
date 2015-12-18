PROGRAM TestTime;
USES CRT,DOS,USE32,DRAWTEST;

CONST DayArray:ARRAY[1..7] OF STRING[3]=('Sun','Mon','Tue','Wed','Thu','Fri','Sat');
      MonthArray:ARRAY[1..12] OF STRING[3]=('Jan','Feb','Mar','Apr','May','Jun',
                                            'Jul','Aug','Sep','Oct','Nov','Dec');


   PROCEDURE CalculateDate;
   VAR Year,Month,Day,WDay :WORD;

      BEGIN

         GetDate(Year,Month,Day,WDay);
         WRITELN('The Current Date is: ');
         GOTOXY(32,10);
         WRITELN(DayArray[WDay],', ',Day,' ',MonthArray[Month],' ',Year);
         WRITELN;

      END;


   PROCEDURE CalculateTime;
   VAR Hour, Minute, Second, Sec100: WORD;
       TempHour:INTEGER;

      BEGIN

         GetTime(Hour,Minute,Second,Sec100);
         WRITE('The Current Time is: ');
         GOTOXY(34,14);

         BEGIN

          IF Hour>12 THEN
          TempHour:=Hour-12
          ELSE TempHour:=Hour;

          IF TempHour <10 THEN
          WRITE('0',TempHour)
          ELSE
          WRITE(TempHour);

          IF Minute <10 THEN
          WRITE(':0',Minute)
          ELSE
          WRITE(':',Minute);

          IF second <10 THEN
          WRITE(':0',Second)
          ELSE
          WRITE(':',Second);

          IF Hour>11 THEN
          WRITELN(' PM')
          ELSE WRITELN(' AM');

        END;

      END;


   PROCEDURE Layout;

      BEGIN

         TEXTBACKGROUND(BLUE);
         FILL(17,15,62,19);
         FILL(17,11,62,15);
         FILL(17,7,62,19);
         TEXTCOLOR(11);
         DRAW(17,15,62,19);
         DRAW(17,11,62,15);
         DRAW(17,7,62,19);
         TEXTBACKGROUND(BLUE);
         GOTOXY(1,25);
         TEXTCOLOR(WHITE);
         GOTOXY(1,25);
         WRITE('                             ');
         WRITE('Press Any Key To Exit    ');
         WRITE('                             ');


      END;



   PROCEDURE DisplayTime;
   VAR Choice:CHAR;

      BEGIN

         TEXTCOLOR(7);
         WRITELN;
          Layout;
          GOTOXY(1,1);
          WRITE('                               ');
          WRITE('  CPU Date And Time');
          WRITE('                              ');
          GOTOXY(30,8);
          CalculateDate;
          REPEAT
          GOTOXY(30,12);
          CalculateTime;
          Delay(100);
          READKEY;
         UNTIL KeyPressed;

      END;

BEGIN
DisplayTime
END.
