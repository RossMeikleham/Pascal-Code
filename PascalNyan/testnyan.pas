PROGRAM PASCALNYAN ;

USES CRT,DOS,SYSUTILS,MMSYSTEM, VPUTILS;


VAR  TextColr:ARRAY[1..6] OF INTEGER;
     OnOff:BOOLEAN;
     TextBckgrnd,Z,Hours,Mins,Secs,Sec100,Seconds:LONGINT;
     X,Y:ARRAY[1..13] OF LONGINT;
     Key:CHAR;
     Continue,NormalNyan:BOOLEAN;
     NyanSong:STRING;
     b:CHAR;

     Dir:STRING;
     SoundPath:STRING;
     PSoundPath:PCHAR;



//For locating sounds from disk the unit requires a PCHAR datatype
//which references a string
//this procedure assigns a Pchar to the appropriate string


PROCEDURE CopyStrtoPChr(SoundPath:STRING; VAR PSoundPath:PCHAR);
VAR NewStr:ANSISTRING;
    I:LONGINT;


   BEGIN

//Read data from old string into new string
      SETLENGTH(NewStr,LENGTH(SoundPath));
      FOR I:=1 TO (LENGTH(SoundPath)) DO
      NewStr[I]:=SoundPath[I];
      PSoundPath:=@NewStr[1]; //Assign Pchar to address location of new string
                            //pChar now refrences to that string
   END;




FUNCTION PlayNyanNormal(P:Pointer):LONGINT;
VAR SoundPath:STRING;
    PSoundPath:PCHAR;
   BEGIN
      SoundPath:=Dir+'\nyanlooped.wav';
      CopyStrtoPchr(SoundPath,PSoundPath);
      sndPLAYSOUND(PSoundPath,SND_NODEFAULT Or SND_ASYNC Or SND_LOOP);
   EXIT;
   END;




FUNCTION PlayNyanNew(P:Pointer):LONGINT;
VAR SoundPath:STRING;
    PSoundPath:PCHAR;
   BEGIN
      SoundPath:=Dir+'\nyan8bit.wav';
      CopyStrtoPchr(SoundPath,PsoundPath);
      sndPLAYSOUND(PSoundPath,SND_NODEFAULT Or SND_ASYNC Or SND_LOOP);
   END;


PROCEDURE InitialiseNyan;

   BEGIN

      HIGHVIDEO;
      TextColr[1]:=LIGHTRED;
      TextColr[2]:=BROWN;
      TextColr[3]:=YELLOW;
      TextColr[4]:=LIGHTGREEN;
      TextColr[5]:=CYAN;
      TextColr[6]:=LIGHTBLUE;

      X[1]:=79;
      X[2]:=60;
      X[3]:=40;
      X[4]:=20;
      X[5]:=70;
      X[6]:=50;
      X[7]:=30;
      X[8]:=10;
      X[9]:=75;
      X[10]:=55;
      X[11]:=35;
      X[12]:=15;

      Y[1]:=1;
      Y[2]:=1;
      Y[3]:=1;
      Y[4]:=1;
      Y[5]:=6;
      Y[6]:=6;
      Y[7]:=6;
      Y[8]:=6;
      Y[9]:=11;
      Y[10]:=11;
      Y[11]:=11;
      Y[12]:=11;

   END;

PROCEDURE DrawTitle;
BEGIN
TEXTCOLOR(WHITE);
TEXTBACKGROUND(Textbckgrnd);
WINDOW(15,2,80,6);
CLRSCR;
GOTOXY(1,1); WRITE('лллл  лл   ллл ллл  лл  л     л   л л   л  лл  л   л  л');
GOTOXY(1,2); WRITE('л  л л  л  л   л   л  л л     лл  л  л л  л  л лл  л  л');
GOTOXY(1,3); WRITE('ллл  лллл  л   л   лллл л     л л л   л   лллл л л л  л');
GOTOXY(1,4); WRITE('л    л  л  л   л   л  л л     л  лл   л   л  л л  лл   ');
GOTOXY(1,5); WRITE('л    л  л лл   ллл л  л ллл   л   л   л   л  л л   л  л');
WINDOW(1,1,80,25);
END;



PROCEDURE StartNyanCounter;

   BEGIN

      GETTIME(Hours,Mins,Secs,Sec100);

   END;

PROCEDURE NyanTime;
VAR SecHours,SecMins,TotalSec,TotalSec100:LONGINT;
    TempHour,TempMin,TempSec,TempSec100:LONGINT;
   BEGIN

      GETTIME(TempHour,TempMin,TempSec,TempSec100);

      SecHours:=(TempHour-Hours)*3600;
      SecMins:=(TempMin-Mins)*60;
      TotalSec:=(TempSec-Secs)+SecMins+SecHours;



      TEXTBACKGROUND(Textbckgrnd);
      WINDOW(30,21,50,25);
      CLRSCR;
      TEXTCOLOR(WHITE);
      WRITELN('YOU`VE NYANED FOR:');
      WRITELN('     ',TotalSec,' SECONDS!');

      GOTOXY(1,4); WRITELN('Press `X` to Exit');
      WINDOW(1,1,80,25);
   END;

PROCEDURE DrawBackGround(X,Y:LONGINT);
   BEGIN
   GOTOXY(X,Y); WRITE('Я');
   END;




PROCEDURE DrawNyanBow1(X:LONGINT);
VAR I:LONGINT;


   BEGIN
         GOTOXY(3,X);

   WRITE('ллллл');
   GOTOXY(12,X); WRITE('лллл');

   END;

PROCEDURE DrawNyanBow2(X:LONGINT);
   BEGIN

   GOTOXY(1,X);
   WRITE('лл');
   GOTOXY(8,X);
   WRITE('лллл');

   END;





PROCEDURE DrawNyanBow(First:BOOLEAN);
VAR X:LONGINT;
    Y:LONGINT;
   BEGIN

   WINDOW(1,10,15,16);
   TEXTBACKGROUND(Textbckgrnd);
   CLRSCR;
   WINDOW(1,1,80,25);
   IF First=TRUE THEN

   BEGIN

   FOR X:=10 TO 15 DO
   BEGIN
   TEXTCOLOR(TextColr[X-9]);
   DrawNyanBow1(X);
   Y := X + 1;
   DrawNyanBow2(Y);
   END;
   END ELSE

   BEGIN
   FOR X:=10 TO 15 DO
   BEGIN
   TEXTCOLOR(TextColr[X-9]);
   DrawNyanBow2(X);
   Y := X + 1;
   DrawNyanBow1(Y);
   END;

END;
END;





PROCEDURE DrawNyanCat(OnOff:BOOLEAN);
VAR X,I,Y:LONGINT;

   BEGIN
       IF OnOff=FALSE THEN Y:=12 ELSE Y:=11;
       WINDOW(16,5,36,17);
       CLRSCR;
       WINDOW(1,1,80,25);

       TEXTCOLOR(LIGHTMAGENTA);
       FOR X:=10 TO 15 DO
   BEGIN
       GOTOXY(16,Y+X-11);
          FOR I:=1 TO 15 DO
          WRITE('л');
     END;
      TEXTCOLOR(MAGENTA);
      GOTOXY(20,Y);
      WRITE('л');
      GOTOXY(26,Y);
      WRITE('л');
      GOTOXY(17,Y+1);
      WRITE('л');
      GOTOXY(24,Y+1);
      WRITE('л');
      GOTOXY(23,Y+3);
      WRITE('л');
      GOTOXY(18,Y+3);
  WRITE('л');


GOTOXY(16,Y+5);
TEXTCOLOR(LIGHTGRAY);
WRITE('л');
TEXTCOLOR(DARKGRAY);
WRITE('  л');
TEXTCOLOR(LIGHTGRAY);
GOTOXY(30,Y+5);
WRITE('л');
TEXTCOLOR(DARKGRAY);
GOTOXY(28,Y+5);
WRITE('л');


TEXTCOLOR(LIGHTGRAY);
GOTOXY(28,Y-1);
WRITE('л');
GOTOXY(36,Y-1);
WRITE('л');
GOTOXY(28,Y);
WRITE('ллллллллл');
GOTOXY(28,Y+1);
WRITE('ллллллллл');
GOTOXY(28,Y+2);
WRITE('ллллллллл');
GOTOXY(28,Y+3);
WRITE('ллллллллл');
GOTOXY(28,Y+4);
WRITE('ллллллллл');

TEXTCOLOR(LIGHTMAGENTA);
TEXTBACKGROUND(LIGHTGRAY);
GOTOXY(29,Y+3);
WRITE('ў');
GOTOXY(35,Y+3);
WRITE('ў');

TEXTCOLOR(BLACK);
TEXTBACKGROUND(LIGHTGRAY);
GOTOXY(30,Y+1);
WRITE('л');
GOTOXY(34,Y+1);
WRITE('л');

GOTOXY(30,Y+3);
WRITE('л л л');
GOTOXY(30,Y+4);
WRITE('ппппп');

   END;




PROCEDURE BeginNyan;
VAR Text:STRING;
    I:LONGINT;
    SoundPath:STRING;
    PSoundPath:PCHAR;

    MenuKey:CHAR;
   BEGIN

SoundPath:=Dir+'\nyan8bit.wav';
CopyStrtoPchr(SoundPath,PSoundPath);
sndPLAYSOUND(PSoundPath,SND_NODEFAULT Or SND_ASYNC Or SND_LOOP);

WINDOW(15,2,80,6);
CLRSCR;
TEXTCOLOR(LIGHTRED);
GOTOXY(1,1); WRITE('лллл  лл   ллл ллл  лл  л     л   л л   л  лл  л   л  л');
TEXTCOLOR(YELLOW);
GOTOXY(1,2); WRITE('л  л л  л  л   л   л  л л     лл  л  л л  л  л лл  л  л');
TEXTCOLOR(LIGHTGREEN);
GOTOXY(1,3); WRITE('ллл  лллл  л   л   лллл л     л л л   л   лллл л л л  л');
TEXTCOLOR(LIGHTBLUE);
GOTOXY(1,4); WRITE('л    л  л  л   л   л  л л     л  лл   л   л  л л  лл   ');
TEXTCOLOR(MAGENTA);
GOTOXY(1,5); WRITE('л    л  л лл   ллл л  л ллл   л   л   л   л  л л   л  л');
WINDOW(1,1,80,25);

TEXTCOLOR(WHITE);
GOTOXY(28,8); Text:='CREATED BY ROSS MEIKLEHAM';
FOR I:=1 TO LENGTH(Text) DO
BEGIN
WRITE(Text[I]);
DELAY(30);
END;
DELAY(150);

GOTOXY(28,25);
Text:='И NYANTENDO 2011';
FOR I:=1 TO LENGTH(TEXT) DO
BEGIN
WRITE(Text[I]);
DELAY(30);
END;
DELAY(150);
Text:='PRESS `C` TO `NYAN` WITH CURRENT MUSIC';
GOTOXY(20,12);
FOR I:=1 TO LENGTH(TEXT) DO
BEGIN
WRITE(Text[I]);
DELAY(30);
END;
DELAY(150);
TEXT:='PRESS `N` TO `NYAN` WITH NORMAL NYAN CAT MUSIC';
GOTOXY(20,15);
FOR I:=1 TO LENGTH(TEXT) DO
BEGIN
WRITE(Text[I]);
DELAY(30);
END;

DELAY(150);
TEXT:='PRESS `X` TO EXIT =[';
GOTOXY(30,20);
FOR I:=1 TO LENGTH(TEXT) DO
BEGIN
WRITE(Text[I]);
DELAY(30);
END;


Continue:=TRUE;

REPEAT
MenuKey:=UPCASE(READKEY);

CASE MenuKey OF
   'N':NormalNyan:=TRUE;
   'C':NormalNyan:=FALSE;
   'X':Continue:=FALSE;

   END;

UNTIL  (MenuKey='C') OR (MenuKey='X') OR (MenuKey='N');



END;





BEGIN
DIR:=GETCURRENTDIR; //Obtain the current directory
b := chr(219);

BeginNyan;
IF Continue=TRUE THEN

BEGIN
SoundPath:=Dir+'\SelectOption.wav';
CopyStrtoPchr(SoundPath,PSoundPath);
sndPLAYSOUND(PsoundPath,SND_NODEFAULT);

FOR Z:=25 DOWNTO 1 DO
BEGIN
GOTOXY(1,Z);
CLREOL;
DELAY(50);
END;
DELAY(400);
HIDECURSOR;
StartNyanCounter;
InitialiseNyan;
IF NormalNyan=TRUE THEN
VPBEGINTHREAD(PlayNyanNormal,16384,NIL) ELSE
VPBEGINTHREAD(PlayNyanNew,16384,NIL);
RANDOMIZE;

 REPEAT
   REPEAT
       Textbckgrnd:=RANDOM(9);
       TEXTBACKGROUND(TextBckgrnd);
       CLRSCR;
       TEXTCOLOR(WHITE);


       FOR Z:=1 TO 12 DO

       BEGIN

       DrawBackground(X[Z],Y[Z]);

       DEC(X[Z]);
       INC(Y[Z]);

       IF X[Z]=0 THEN X[Z]:=79;
       IF Y[Z]=20 THEN Y[Z]:=0

       END;

       DrawNyanBow(OnOff);
       DrawNyanCat(OnOff);
       OnOff:=NOT(OnOff);
       DrawTitle;
       NyanTime;
       IF NOT KEYPRESSED THEN
       DELAY(400);

    UNTIL KEYPRESSED;
   Key:=UPCASE(READKEY);
 UNTIL Key='X';

END;
END.



