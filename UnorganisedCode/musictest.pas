PROGRAM TheSickness;

USES CRT,DRAW,VPUTILS;

VAR I:INTEGER;



PROCEDURE DrawPic;
BEGIN

TEXTCOLOR(RED);
GOTOXY(23,1);
WRITELN('MMMMMMMMMMMMMMMMMMMMMMMMMMMNNNNMMM');
GOTOXY(23,2);
WRITELN('MMMMNNNNNMMMMMMMMMMMMMMMMMNNNNNNMM');
GOTOXY(23,3);
WRITELN('MMNyohdmmNNNNNNMMMMMMMMMNNmmdysdNM');
GOTOXY(23,4);
WRITELN('MMNmy..-/shmmNNNMMMMMMNNNd+-`.hNNM');
GOTOXY(23,5);
WRITELN('MMMNNd/```.ohmNMMMMMMMMNd:``/dNMMM');
GOTOXY(23,6);
WRITELN('MMMMNNNdsssosdNMMMMMMMNmsydmNNNNMM');
GOTOXY(23,7);
WRITELN('MMMMMNNNNNNNNNNMMMMMMMNNNMMMMMMMMM');
GOTOXY(23,8);
WRITELN('MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNM');
GOTOXY(23,9);
WRITELN('MMNmNNMMMMMMMMMMMMMMMMMMMMMMMMMMMM');
GOTOXY(23,10);
WRITELN('MNNNmdNMMMMMMMMMMMMMMMMMMMNNmMMMMM');
GOTOXY(23,11);
WRITELN('MMMNNmNNNmNNMMMMMMMMMMNNdmdmNMMMMM');
GOTOXY(23,12);
WRITELN('MMMMNNNNNmsmddNNNNNNddymyhmNNMMMMM');
GOTOXY(23,13);
WRITELN('MMMMMNdddmdNyyhddsym+hyNmmmmNMMMMM');
GOTOXY(23,14);
WRITELN('MMMMMMMNdmdNmmyhdsymhNmhNmNMMMMMMM');
GOTOXY(23,15);
WRITELN('MMMMMMMMMMNNydshmNNNNysdNmMMMMMMMM');
GOTOXY(23,16);
WRITELN('MMMMMMMMMMMNmdyyyodsmdmMMMMMMMMMMM');
GOTOXY(23,17);
WRITELN('MMMMMMMMMMMMMMNNNmNMMMMMMMMMMMMMMM');


END;

PROCEDURE Title;

BEGIN
GOTOXY(30,25);
WRITELN('Press `Any Key` To start..');
GOTOXY(30,18);
FLASHCOLOUR('Down With The Pascal >:)');
TEXTBACKGROUND(RED);
TEXTCOLOR(WHITE);
GOTOXY(21,23);
WRITELN('Loading (Not really but it looks good)');
TEXTBACKGROUND(BLACK);
END;

PROCEDURE Start;
BEGIN

HIDECURSOR;

TEXTBACKGROUND(RED);
FILLBOX(20,19,60,24);
TEXTBACKGROUND(BLACK);

TEXTCOLOR(WHITE);
DrawDoubleBox(20,19,60,24);

Title;
WINDOW(25,21,55,21);
CLRSCR;
TEXTCOLOR(BLUE);

FOR I:=1 TO 30 DO
BEGIN
WRITE(#178);
DELAY(200);
END;
WINDOW(1,1,80,25);
TEXTCOLOR(WHITE);
END;

PROCEDURE Intro;

BEGIN
CLRSCR;
PLAYSOUND(90,150);
DELAY(20);
PLAYSOUND(40,150);
PLAYSOUND(40,150);
PLAYSOUND(90,150);
PLAYSOUND(40,300);
DELAY(300);

FOR I:=1 To 3 DO

BEGIN

BEGIN
PLAYSOUND(90,150);
DELAY(20);
PLAYSOUND(40,150);
PLAYSOUND(40,150);
PLAYSOUND(90,150);
PLAYSOUND(40,300);
TEXTBACKGROUND(RED);
CLRSCR;
IF I=2 THEN
WRITELN('Can you feel that?..');
IF I=3 THEN
WRITELN('Oh Shit..');
DELAY(100);
END;

BEGIN
PLAYSOUND(90,150);
PLAYSOUND(40,150);
DELAY(10);
PLAYSOUND(90,150);
DELAY(20);
PLAYSOUND(40,150);
PLAYSOUND(40,150);
PLAYSOUND(90,150);
PLAYSOUND(40,300);
TEXTBACKGROUND(BLACK);
CLRSCR;
DELAY(100);
END;

END;

END;


PROCEDURE Main;

BEGIN

TEXTBACKGROUND(BLACK);
CLRSCR;
PLAYSOUND(390,150);
DELAY(20);
PLAYSOUND(340,150);
PLAYSOUND(340,150);
PLAYSOUND(390,150);
PLAYSOUND(340,300);

For I:=1 TO 4 DO
BEGIN

PLAYSOUND(390,150);
PLAYSOUND(340,150);
DELAY(10);
TEXTBACKGROUND(RED);
CLRSCR;
PLAYSOUND(390,150);
DELAY(20);
TEXTBACKGROUND(BLACK);
CLRSCR;
PLAYSOUND(340,150);
PLAYSOUND(340,150);
PLAYSOUND(390,150);
PLAYSOUND(340,300);

END;
DELAY(100);
END;


PROCEDURE Finish;

BEGIN

FOR I:=1 To 4 DO

BEGIN

TEXTBACKGROUND(RED);
CLRSCR;

CASE I OF
1:WRITELN('OH..');
2:WRITELN('OH-WAHA..');
3:WRITELN('OH-WAHA-WAH..');
4:WRITELN('OH-WAHA-WAH-AH');

END;


PLAYSOUND(470,100);
DELAY(150);
TEXTBACKGROUND(BLACK);
DELAY(50);

END;
END;


BEGIN
DrawPic;
Start;
Intro;
Main;
Finish;
END.
