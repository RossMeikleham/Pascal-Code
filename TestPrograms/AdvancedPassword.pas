PROGRAM AdvancedPassword;

USES CRT,DOS;

TYPE

   TimeRec=RECORD
       HourTime:LONGINT;
       MinTime:LONGINT;
       SecTime:LONGINT;
       TotalSecTime:LONGINT
      END;


VAR
TimeFile:FILE OF TimeRec;
UnlockTime:TimeRec;
PassKey:CHAR;
TempPass:STRING[30];
I:INTEGER;
CorrectPass,Locked:BOOLEAN;
Password:STRING;
FailSafe:INTEGER;





   PROCEDURE CreateFile;
   BEGIN
   REWRITE(TimeFile);
   WITH UnlockTime DO
   BEGIN
   SecTime:=0;
   MinTime:=0;
   HourTime:=0;
   TotalSecTime:=0;
   END;
   WRITE(TimeFile,UnlockTime);
   END;


   PROCEDURE TestTime;
   VAR Hour,Min,Sec,Sec100:LONGINT;
    BEGIN
      IF (UnlockTime.SecTime=0) AND
         (UnlockTime.HourTime=0) AND
         (UnlockTime.MinTime=0)  THEN Locked:=FALSE;

      GetTime(Hour,Min,Sec,Sec100);
      IF (Hour*3600)+(Min*60)+Sec < UnlockTime.TotalSecTime THEN Locked:=TRUE;
      IF (Hour*3600)+(Min*60)+Sec < UnlockTime.TotalSecTime-301 THEN Locked:=FALSE;
      IF (Hour*3600)+(Min*60)+Sec > UnlockTime.TotalSecTime THEN Locked:=FALSE;
     END;


   PROCEDURE NextTime;
   VAR Sec,Min,Hour,Sec100:LONGINT;

   BEGIN
      SetFAttr(TimeFile,$00);
      REWRITE(TimeFile);
      GetTime(Hour,Min,Sec,Sec100);

      IF Min>54 THEN BEGIN
      UnlockTime.HourTime:=Hour+1;
      UnlockTime.MinTime:=min-55;
      END ELSE BEGIN

      UnlockTime.HourTime:=Hour;
      UnlockTime.MinTime:=Min+5;
      END;

      UnlockTime.SecTime:=Sec;
      UnlockTime.TotalSecTime:=(Hour*3600)+(Min*60)+Sec+300;

      WRITE(TimeFile,UnlockTime);

   END;

   PROCEDURE Create;

      BEGIN

         CLRSCR;
         GOTOXY(28,3);
         WRITELN('(--------Enter Password----------)');
         WRITELN;
         GOTOXY(28,5);
         WRITELN('(--------------------------------)');
         GOTOXY(27,4);
         WRITE(' ');

      END;



   PROCEDURE Back;

      BEGIN
      IF I>0 THEN  BEGIN
      TempPass[I]:=#0;
      I:=I-1;
      GOTOXY(WHEREX-1,WHEREY);
      WRITE(' ');
      GOTOXY(WHEREX-1,WHEREY);
      END;
      END;

   PROCEDURE GetPass;

       BEGIN

       I:=0;
       REPEAT

          PassKey:=UPCASE(READKEY);
          IF PassKey<>#13 THEN BEGIN
          IF (PassKey=#8) THEN
          Back ELSE
            IF I<25 THEN
             BEGIN
                I:=I+1;
                TempPass[I]:=PassKey;
                WRITE('*');
             END;
             END;
       UNTIL (PassKey=#13) OR (PassKey=#27);

       END;


   PROCEDURE Check;

      BEGIN
      CorrectPass:=TRUE;
      FOR I:=1 TO 30 DO
      IF TempPass[I]<>Password[I] THEN CorrectPass:=FALSE;
      IF CorrectPass=TRUE THEN BEGIN
      GOTOXY(24,8);
      WRITELN('SUCCESS');
      READLN;

      END ELSE
      BEGIN
      FailSafe:=FailSafe+1;
      GOTOXY(24,8);
      WRITELN('ERROR - WRONG PASSWORD');
      IF FailSafe=5 THEN
      NextTime;


      IF FailSafe=5 THEN BEGIN

      WRITELN('You Have Until ',UnlockTime.HourTime,':',UnlockTime.MinTime,':',UnlockTime.SecTime);
      WRITELN('To attempt again');

      END ELSE
      BEGIN

      WRITELN('Press `Enter` and try again');
      FOR I:=1 TO 30 DO
      TempPass[I]:=#0;
      READLN;
      Create;
      END;
      END;

       END;




BEGIN
LOCKED:=TRUE;
ASSIGN(TimeFile,'F:\Computing\A2\TestPrograms\TimeFile.Tme');


{$I-}
RESET(TimeFile);
READ(TimeFile,UnlockTime);
IF IOResult<>0 THEN  {File Doesn't Exist}
BEGIN
WRITELN(IORESULT);
READLN;
CreateFile;
END;
{$I+}
TestTime;
WRITELN(Locked);
READLN;

IF Locked=FALSE THEN
BEGIN
FailSafe:=0;
Password:='ABCDEFG';
Create;
CorrectPass:=FALSE;
REPEAT
GetPass;
IF PassKey<>#27 THEN Check;
UNTIL (CorrectPass=TRUE) OR (PassKey=#27) OR (FailSafe=5);
BEGIN
IF FailSafe<5 THEN
CreateFile;
END;
END ELSE
BEGIN
WRITELN('You Have Until ',UnlockTime.HourTime,':',UnlockTime.MinTime,':',UnlockTime.SecTime);
WRITELN('To attempt again');
END;
READLN;
SetFAttr(TimeFile,$01);
SetFAttr(TimeFile,$02);
READLN;
CLOSE(TimeFile);
END.


