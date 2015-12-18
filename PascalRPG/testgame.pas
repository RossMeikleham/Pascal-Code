PROGRAM TestGame;


USES CRT,SYSUTILS,VPUTILS,DOS,DRAW;


CONST BlazeCost=[2,5,8,8];    //MP Cost Of Spells
      FreezeCost=[3,7,10,10];
      BoltCost=[8,15,20,20];
      HealCost=[3,5,10,20];

      BlazeDamage=[7,9,14,40];
      FreezeDamage=[9,11,18,50];
      BoltDamage=[14,16,25,60];
      HealAmount=[15,15,30,255];

       Up=#72;
       Down=#80;
       Left=#75;
       Right=#77;

TYPE



      Spells=RECORD   //Lvls of spells available to char 0-4 {0 means unavail}
            BlazeAvail:INTEGER;
            FreezeAvail:INTEGER;
            BoltAvail:INTEGER;
            HealAvail:INTEGER;
          END;

      AttribRec=RECORD

           Title:STRING;
           Attack:INTEGER;
           Defence:INTEGER;
           HealthMax:INTEGER;
           Health:INTEGER;
           MpMax:INTEGER;
           Mp:INTEGER;
           Spell:Spells;

      END;


VAR X,Y,Z:LONGINT;
    Test:REAL;

    MainCharStats:AttribRec;
    Monster1CharStats:AttribRec;
    CurrentMon:AttribRec;

PROCEDURE Initialise;
   BEGIN
         WITH MainCharstats DO
    BEGIN
       Title:='Red';
       Attack:=25;
       Defence:=10;
       Health:=50;
       HealthMax:=50;
       Mp:=20;
       MpMax:=20;
       Spell.BlazeAvail:=4;
       Spell.FreezeAvail:=2;
       Spell.BoltAvail:=3;
       Spell.HealAvail:=1;

    END;

        WITH Monster1CharStats DO

       BEGIN
       Title:='Green Square';
       Attack:=20;
       Defence:=8;
       Health:=20;
       HealthMax:=20;
       Mp:=0;
       MpMax:=0;
       Spell.BlazeAvail:=0;
       Spell.FreezeAvail:=0;
       Spell.BoltAvail:=0;
       Spell.HealAvail:=0;
    END;

END;




 PROCEDURE DrawMain(StartX,StartY:INTEGER);

   BEGIN

   GOTOXY(StartX,StartY);        TEXTCOLOR(LIGHTRED); WRITE('лм');
   GOTOXY(StartX,StartY+1);                          WRITE('ллллл');
   GOTOXY(StartX,StartY+2); TEXTCOLOR(WHITE);       WRITE('л');
   TEXTBACKGROUND(YELLOW); TEXTCOLOR(BLINK); WRITE('м м');
   GOTOXY(StartX-1,StartY+3); TEXTCOLOR(WHITE); WRITE('лл');
   TEXTCOLOR(LIGHTRED); WRITE('ллл');
   GOTOXY(StartX,StartY+4); WRITE('ллллл'); TEXTCOlOR(BLINK); WRITE(' ');
   GOTOXY(StartX-1,StartY+5); TEXTBACKGROUND(RED); TEXTCOLOR(BLINK);
   WRITE('      ');



   END;




PROCEDURE DrawEnemy(StartX,StartY:INTEGER);
VAR I,J,K:INTEGER;
   BEGIN
   RANDOMIZE;
   GOTOXY(StartX,StartY);
   FOR I:=1 TO 5 DO
      FOR J:=1 TO 5 DO
         BEGIN
         TEXTCOLOR(LIGHTGREEN);
         GOTOXY(I+Startx,J+StartY);
         WRITE('л');

         END;
   END;





PROCEDURE DrawField;

   BEGIN
      TEXTBACKGROUND(WHITE);
      TEXTCOLOR(BLINK);
      CLRSCR;
      TEXTCOLOR(BLACK);
         FOR X:=1 TO 15 DO
         FOR Y:=1 TO 25 DO
            BEGIN
               GOTOXY(4*X,Y);
               WRITE('Г');
            END;


         FOR Y:=1 TO 6 DO
         FOR X:=1 TO 60 DO
            BEGIN
                GOTOXY(X,4*Y);
                Test:=WHEREX/4;
                IF TRUNC(Test)=Test THEN WRITE('Х')
                ELSE WRITE('Ф');

             END;

   END;


PROCEDURE EndingMessage(Winner:STRING);
   BEGIN
     TEXTBACKGROUND(BLACK);
   TEXTCOLOR(LIGHTRED);
   FILLBOX(10,1,50,4);
   DRAWDOUBLEBOX(10,1,50,4);
   WINDOW(11,2,49,3);

   IF Winner=MainCharStats.Title THEN
   BEGIN
   WRITE(MainCharStats.Title,' has defeated the enemy!');
   PLAYSOUND(300,400);
   END ELSE
   WRITE(MainCharStats.Title,' was defeated :(');
   WINDOW(1,1,60,26);
   READLN;
   END;




PROCEDURE Menu;

   BEGIN
      TEXTBACKGROUND(BLACK);
      FILLBOX(1,15,60,26);
      TEXTCOLOR(LIGHTRED);
      DRAWDOUBLEBOX(1,15,60,26);

END;


PROCEDURE DrawMainMenu;
VAR I,X,Y:LONGINT;
    Percentage:REAL;
    RoundedPercentage:LONGINT;
   BEGIN
     WINDOW(2,16,59,25);
     TEXTBACKGROUND(BLACK);
     TEXTCOLOR(LIGHTRED);
     CLRSCR;
     WINDOW(1,1,80,26);
     GOTOXY(9,16);
     WRITELN('HP: ',MainCharStats.Health,'/',MainCharStats.HealthMax);
     DRAWBOX(3,17,24,19);
     WINDOW(4,18,24,18);

     Percentage:=(MainCharStats.Health/MainCharStats.HealthMax)*20;
     RoundedPercentage:=ROUND(Percentage);


     TEXTCOLOR(LIGHTRED);
     FOR I:=1 TO RoundedPercentage DO WRITE('В');
     TEXTCOLOR(YELLOW);
     IF RoundedPercentage<20 THEN
     FOR I:=1 TO (20-RoundedPercentage) DO WRITE('В');

     WINDOW(1,1,80,26);


     GOTOXY(40,16);
     TEXTCOLOR(CYAN);
     WRITELN('MP: ',MainCharStats.Mp,'/',MainCharStats.MPmax);
     DRAWBOX(34,17,55,19);
     WINDOW(35,18,55,18);
     TEXTCOLOR(CYAN);
     FOR I:=1 TO 20 DO WRITE('В');


     WINDOW(1,1,80,26);


     FOR X:=1 TO 4 DO
     BEGIN

     TEXTBACKGROUND(RED);
     Y:=(14*x)-9;
     FILLBOX(Y,20,Y+10,23);
     TEXTCOLOR(DARKGRAY);
     FOR I:=22 TO 24 DO
      BEGIN
         GOTOXY(Y+11,I);
         WRITE('В');
      END;

     FOR I:=(Y+1) TO (Y+11) DO
        BEGIN
           GOTOXY(I,24);
           WRITE('В');
        END;
     END;
     TEXTCOLOR(BLACK);
     GOTOXY(7,22);
     WRITE('ATTACK');
     GOTOXY(21,22);
     WRITE('MAGIC');
     GOTOXY(35,22);
     WRITE('ITEM');
     GOTOXY(49,22);
     WRITE('FLEE');

   END;



PROCEDURE TestAttack(Attacker,Defender:STRING;Attack,Defence:LONGINT; VAR Health:LONGINT);
VAR InitialDamage,VariableRoundedDamage,RandomDamage,FinalDamage,I:LONGINT;
    VariableDamage:REAL;
    Text:STRING;

   BEGIN     {Damage calculated as Attack-Defence +/- up to 15%}
   InitialDamage:=Attack-Defence;
   VariableDamage:=InitialDamage*0.15;
   VariableRoundedDamage:=ROUND(VariableDamage);
   RandomDamage:=RANDOM(2*VariableRoundedDamage);
   FinalDamage:=InitialDamage+RandomDamage-VariableRoundedDamage;
   IF FinalDamage<0 THEN FinalDamage:=0;   {Can't be negative, so minimum is 0}


   Health:=Health-FinalDamage;
   IF CurrentMon.Health<0 THEN Health:=0;
   IF MainCharStats.Health<0 THEN Health:=0;

   TEXTBACKGROUND(BLACK);
   TEXTCOLOR(LIGHTRED);
   FILLBOX(10,1,50,4);
   DRAWDOUBLEBOX(10,1,50,4);
   WINDOW(11,2,49,3);

   Text:=Attacker+' does '+INT2STR(FinalDamage)+' damage to '+Defender;

   FOR I:=1 TO Length(Text) DO
      BEGIN
      WRITE(Text[I]);
      DELAY(30);
      END;
   WINDOW(1,1,80,26);
   DELAY(1000);


   DrawField;
   DrawMain(5,7);
   DrawEnemy(40,7);
    Menu;
   DrawMainMenu;
   END;



PROCEDURE HighlightMainOption(Option:INTEGER);
VAR X,I:LONGINT;

   BEGIN
      DrawMainMenu;
      X:=(14*Option)-9;

       TEXTBACKGROUND(LIGHTRED);
       TEXTCOLOR(BLINK);
       FILLBOX(X,20,X+10,23);
       TEXTCOLOR(LIGHTGRAY);
       FOR I:=22 TO 24 DO
          BEGIN
          GOTOXY(X+11,I);
          WRITE('В');
          END;

      FOR I:=(X+1) TO (X+11) DO
          BEGIN
           GOTOXY(I,24);
           WRITE('В');
        END;

        GOTOXY(X+2,22);
     TEXTCOLOR(BLINK);
     CASE Option OF
     1:WRITE('ATTACK');
     2:WRITE('MAGIC');
     3:WRITE('ITEM');
     4:WRITE('FLEE');

     END;
   END;


PROCEDURE ProcessMainMenuKeys;
VAR I,Option:LONGINT;
    Key:CHAR;

   BEGIN
      Option:=1;
      REPEAT
         Key:=UPCASE(ReadKey);
            CASE Key OF

         Left:BEGIN
                 IF Option=1 THEN Option:=4 ELSE
                  DEC(Option);
              END;

         Right:BEGIN
                  IF Option=4 THEN Option:=1 ELSE
                  INC(Option);
               END;
         #13:;

             END;

      HighlightMainOption(Option);
      UNTIL Key=#13;


      CASE Option  OF
      1:TestAttack(MainCharStats.Title,CurrentMon.Title,MainCharStats.Attack,CurrentMon.Defence,CurrentMon.Health);
     // 2:MagicMenu
     // 3:ItemMenu
     // 4:
      END;
   END;





PROCEDURE BeginBattle;


VAR Winner:STRING;
   BEGIn
   CurrentMon:=Monster1CharStats;

      REPEAT
      HighlightMainOption(1);
      ProcessMainMenuKeys;
      IF (CurrentMon.Health=0) OR (MainCharStats.Health=0) THEN BREAK;
      TestAttack(CurrentMon.Title,MainCharStats.Title,CurrentMon.Attack,MainCharStats.Defence,MainCharStats.Health);
      UNTIL (CurrentMon.Health=0) OR (MainCharStats.Health=0);

    IF CurrentMon.Health=0 THEN BEGIN Winner:='Player'; EndingMessage(MainCharStats.Title); END;
    IF MainCharStats.Health=0 THEN BEGIN Winner:='Monster';  EndingMessage(CurrentMon.Title); END;

      END;







BEGIN
HIDECURSOR;
SETVIDEOMODE(60,26);
DrawField;
Initialise;
DrawMain(5,7);
DrawEnemy(40,7);
Menu;
DrawMainMenu;
BeginBattle;
END.
