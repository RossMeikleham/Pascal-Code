UNIT DATECALC;

INTERFACE

USES CRT,DOS,Draw;


    FUNCTION StrMonth(Month:LONGINT):STRING;

    PROCEDURE ValidateYear(YrStr:STRING;VAR validYear:BOOLEAN; VAR Year:LONGINT);

    PROCEDURE ValidateMonth(MonthStr:STRING;VAR validMonth:BOOLEAN; VAR Month:LONGINT);

    PROCEDURE ValidateDay(DayStr,MonthStr,YearStr:STRING; VAR ValidDay:BOOLEAN; VAR Day:LONGINT);

    PROCEDURE CalculateDateLength(Year,Month,Day,NewYear,NewMonth,NewDay:INTEGER; VAR DatePassed:BOOLEAN; VAR DaysPassed:LONGINT);

    FUNCTION ObtainDate:STRING;

    FUNCTION ObtainTime:STRING;

    PROCEDURE ValidateAgeRestriction(BirthYear, BirthMonth, BirthDay :INTEGER; VAR Valid:BOOLEAN);

    FUNCTION DaysInMonth(Year,Month:LONGINT):LONGINT;

    PROCEDURE SetMonths;

    TYPE

        MonthDays=ARRAY[1..12] OF LONGINT;

        Months=ARRAY[1..12] OF STRING;

VAR

    MonthArray:MonthDays;
    MonthName:Months;
    {Links Months to how many days are in each, with exception to february}


IMPLEMENTATION

   PROCEDURE SetMonths;

      BEGIN

         MonthArray[1]:=31; MonthName[1]:='January';
         MonthArray[2]:=28; MonthName[2]:='February';
         MonthArray[3]:=31; MonthName[3]:='March';
         MonthArray[4]:=30; MonthName[4]:='April';
         MonthArray[5]:=31; MonthName[5]:='May';
         MonthArray[6]:=30; MonthName[6]:='June';
         MonthArray[7]:=31; MonthName[7]:='July';
         MonthArray[8]:=31; MonthName[8]:='August';
         MonthArray[9]:=30; MonthName[9]:='September';
         MonthArray[10]:=31; MonthName[10]:='October';
         MonthArray[11]:=30; MonthName[11]:='November';
         MonthArray[12]:=31; MonthName[12]:='December';

      END;


   FUNCTION StrMonth(Month:LONGINT):STRING;

      BEGIN
      StrMonth:=MonthName[Month];
      END;


   PROCEDURE ValidateYear(YrStr:STRING; VAR ValidYear:BOOLEAN; VAR Year:LONGINT);
   VAR Errorval:LONGINT;

      BEGIN

         VAL(YrStr, Year, ErrorVal);
         IF (ErrorVal <> 0) OR (LENGTH(YrStr) <> 4) THEN

         ValidYear:=FALSE
         ELSE ValidYear:=TRUE

      END;


   PROCEDURE CalculateLeapYear(TempYear:LONGINT; VAR LeapYear:BOOLEAN);

        BEGIN

           IF (((TempYear/4) = Round(TempYear/4)) AND
           ((TempYear/100) <> Round(TempYear/100))) OR
           ((TempYear/400 =Round(TempYear/400))) THEN
              LeapYear:=TRUE
              ELSE
              LeapYear:=FALSE;




        END;



   PROCEDURE ValidateMonth(MonthStr:STRING;VAR ValidMonth:BOOLEAN; VAR Month:LONGINT);
   VAR ErrorVal:LONGINT;

      BEGIN

         VAL(MonthStr, Month, ErrorVal);
         IF (ErrorVal <> 0)
         OR (Month>12) OR (Month<1) THEN

         validMonth:=FALSE
         ELSE validMonth:=TRUE

      END;


  PROCEDURE ValidateDay(DayStr,MonthStr,YearStr:STRING; VAR ValidDay:BOOLEAN; VAR Day:LONGINT);
  VAR ErrorVal:LONGINT;
      Month,Year:LONGINT;
      ValidYear,ValidMonth,LeapYear:BOOLEAN;
      MonthDayStr:STRING;

      BEGIN
         ValidateYear(YearStr,ValidYear,Year);
         IF ValidYear=FALSE THEN
         ErrorMessage('Year must be a 4 digit integer');
         IF ValidYear=TRUE THEN
         BEGIN

            ValidateMonth(MonthStr,ValidMonth,Month);
            IF ValidMonth=FALSE THEN
            ErrorMessage('Month must be an integer value from 1-12');
            IF ValidMonth=TRUE THEN
            BEGIN
               CalculateLeapYear(Year,LeapYear);
               IF LeapYear= TRUE THEN MonthArray[2]:=29;

               VAL(DayStr, Day, ErrorVal);
               IF (ErrorVal <> 0)
               OR (Day <1)
               OR (Day > MonthArray[Month])    {If day is greater than number of days in current month}

               THEN validDay:=FALSE
               ELSE validDay:=TRUE;
               Str(MonthArray[Month],MonthDayStr);
               IF ValidDay=FALSE THEN ErrorMessage('Day must be an integer value from 1 to '+MonthDayStr+' for this month');
               MonthArray[2]:=28;
            END
         END;
      END;


  PROCEDURE CalculateDateLength(Year,Month,Day,NewYear,NewMonth,NewDay:INTEGER;VAR DatePassed:BOOLEAN; VAR DaysPassed:LONGINT);
  VAR Date1,Date2,YearDays,MonthDays,I,LeapDays:INTEGER;
      LeapYear:BOOLEAN;

     BEGIN

          LeapDays:=0;


             FOR I:=1 To Year DO
             BEGIN
             CalculateLeapYear(Year,LeapYear);
             IF LeapYear=TRUE THEN LeapDays:=LeapDays+1;
             END;

             MonthDays:=0;
             YearDays:=(Year*365);
             FOR I:=0 TO Month-1 DO
             MonthDays:=MonthDays+(MonthArray[I]);


          Date1:=YearDays+MonthDays+Day+LeapDays;

          YearDays:=0;
          MonthDays:=0;
          LeapDays:=0;

          FOR I:=1 TO NewYear DO
          BEGIN
          CalculateLeapYear(NewYear,LeapYear);
          IF LeapYear=TRUE THEN LeapDays:=LeapDays+1;
          END;

             YearDays:=(NewYear*365);
             FOR I:=0 TO NewMonth-1 DO  {Number of months passed, current month hasn't passed so -1}
             MonthDays:=MonthDays+(MonthArray[I]);  {adds all the days from months passed}



          Date2:=YearDays+MonthDays+NewDay+LeapDays;

          DaysPassed:=Date2-Date1;
          IF Date2-Date1 >0 THEN DatePassed:=TRUE
          ELSE DatePassed:=FALSE;

     END;





  FUNCTION ObtainDate:STRING; {saves the date as a string}
  VAR Year,Month,Day,WDay:LONGINT;
      StrY,StrM,StrD:STRING;
      ErrNum:LONGINT;

     BEGIN

        GetDate(Year,Month,Day,Wday);

        STR(Year,StrY);
        STR(Month,StrM);
        STR(Day,StrD);

        IF Day <10 THEN StrD:=('0'+StrD+'/') ELSE
                        StrD:=(StrD+'/');

        IF Month <10 THEN StrM:=('0'+StrM+'/') ELSE
                          StrM:=(StrM+'/');

        ObtainDate:=StrD+StrM+StrY;

     END;




  FUNCTION ObtainTime:STRING;
   VAR TempHour,Hour,Minute,Second,Sec100:LONGINT;
       StrH,StrM,StrS,Period:STRING;
       ErrNum:LONGINT;

    BEGIN

       GetTime(Hour,Minute,Second,Sec100);

         BEGIN

          IF Hour>12 THEN
          TempHour:=Hour-12
          ELSE TempHour:=Hour;

          STR(TempHour,StrH);

          IF TempHour <10 THEN
          StrH:=('0'+StrH)
          ELSE
          StrH:=(StrH);

           STR(Minute,StrM);
           STR(Second,StrS);

          IF Minute <10 THEN
          StrM:=(':0'+StrM)
          ELSE
          StrM:=(':'+StrM);

          IF Second <10 THEN
          StrS:=(':0'+StrS)
          ELSE
          StrS:=(':'+StrS);

          IF Hour>11 THEN
          Period:=' PM'
          ELSE Period:=' AM';

          ObtainTime:=StrH+StrM+StrS+Period;

        END;

      END;




   PROCEDURE ValidateAgeRestriction(BirthYear,BirthMonth,BirthDay:INTEGER; VAR Valid:BOOLEAN);
   VAR Year,Month,Day,Wday,Age:LONGINT;               {Validates ages}
                                                      {by taking year of clock}
      BEGIN                                           {date and tests if the current}
                                                      {year subtract the dob and if the result}
         GetDate(Year,Month,Day,WDay);                {is between 18 and 110}
         Age:=Year-BirthYear;                         {it is valid}

         IF (Age>110) OR (Age<18) THEN
         Valid:=FALSE;

         IF (Age=18) AND (BirthMonth>Month) THEN
         Valid:=FALSE;

         IF (Age=18) AND ((BirthMonth=Month) AND (BirthDay>Day)) THEN
         Valid:=FALSE;

         IF (Age=18) AND (BirthMonth<Month) THEN
         Valid:=TRUE;

         IF (Age=18) AND (BirthMonth=Month) AND (Birthday<Day) THEN
         Valid:=TRUE;

         IF Valid=FALSE THEN

         ErrorMessage('Age must be between 18 and 125');                                                                                                                            {the age is valid}


      END;



    FUNCTION DaysInMonth(Year,Month:LONGINT):LONGINT;
    VAR LeapYear:BOOLEAN;
         BEGIN
         CalculateLeapYear(Year,LeapYear);
         IF LeapYear=TRUE THEN MonthArray[2]:=29;
         DaysInMonth:=MonthArray[Month];
         MonthArray[2]:=28;
         END;
     END.





