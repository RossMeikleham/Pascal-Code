//лллллллллллллллллллллллллллллллллллл
//лCopyright Ross Meikleham 2010}    л
//лRun this program...if you dare   л
//лллллллллллллллллллллллллллллллллллл
  ////////////////////////////////////

PROGRAM LoadingScreen;

USES CRT,VPUTILS,WINDOWS;

VAR I,P:INTEGER;
    Z:CHAR;

PROCEDURE Load(X,Y:INTEGER);

BEGIN

RANDOMIZE;
FOR I:=1 to 100 DO
BEGIN
HIDECURSOR;
GOTOXY(X,Y);
WRITE(I,'%');
DELAY(RANDOM(50));
END;

END;



BEGIN

TEXTCOLOR(YELLOW);
GOTOXY(30,2);
WRITELN('...PRESS ANY KEY TO BEGIN...');
Z:=READKEY;
TEXTCOLOR(LIGHTGREEN);
WRITELN;
WRITELN('Apart from that key ЊЊ, try again');
DELAY(1000);
Z:=READKEY;
Z:=READKEY;
WRITELN;
WRITELN('And that key.., you`re not very good at this are you? Y/N?');
DELAY(1000);
Z:=UPCASE(READKEY);
WHILE Z<>'N' DO
BEGIN
TEXTCOLOR(RED);
WRITELN('I said, you`re not very good at this are you?!');
Z:=UPCASE(READKEY);
TEXTCOLOR(LIGHTGREEN);
END;
WRITELN;
WRITELN('Good ',#1,' it`s nice to have you see things my way, now shall we play a game?');
DELAY(5000);
WRITELN;
WRITELN('Yeh, i`m not giving you a choice,');
WRITELN('there`s no readkey anywhere in there unfortunately');
DELAY(5000);
WRITELN;
WRITELN('Screen is a tad small don`t you recon, maybe we should change that?');
DELAY(5000);
//SETKEYBOARDSTATE(VK_NUMLOCK,TRUE);
//SETKEYBOARDSTATE(KBDSTF_INSERT_OFF,FALSE)
WRITELN;
WRITELN('Ah, that`s better');
DELAY(2000);
WRITELN('Lets load some data!',#2);
DELAY(3000);
CLRSCR;
P:=2000;
WRITELN('Loading gigapixels...');
Load(30,1);
WRITELN;
WRITELN;
WRITELN('Reconfoobling energymotron...');
Load(33,3);
WRITELN;
WRITELN;
WRITELN('Having a quick byte to eat ...');
Load(32,5);
WRITELN;
WRITELN;
WRITELN('Taking the red pill...');
Load(30,7);
WRITELN;
WRITELN;
WRITELN('Moving satelite into position ...');
Load(35,9);
WRITELN;
WRITELN;
WRITELN('checking the gravitational constant in your locale...');
Load(55,11);
WRITELN;
WRITELN;
WRITELN('Testing user patience ...');
Load(30,13);
WRITELN;
WRITELN;
WRITE('Testing data on Timi...');
Load(25,15);
WRITE(' ... ');
DELAY(500);
WRITE(' ... ');
DELAY(500);
WRITE(' ... ');
DELAY(500);
WRITE('We`re going to need another Timi.');
DELAY(3000);
WRITELN;
WRITELN;
WRITELN('Scanning your hard drive for credit card details. Please be patient...');
Load(73,17);
WRITELN;
WRITELN;
WRITELN('Creating Time-Loop Inversion Field');
Load(40,19);
WRITELN;
WRITELN;
WRITELN('Charging the flux capacitor to 1.21 JiggaWatts');
FOR I:=1 TO 121 DO
BEGIN
HIDECURSOR;
GOTOXY(48,21);
WRITE((I/100):1:2,'J');
DELAY(50);
END;
WRITELN;
WRITELN;
WRITELN('Increasing speed to 88.8mph');
FOR I:=1 TO 888 DO
BEGIN
GOTOXY(35,23);
WRITE((I/10):2:1,'Mph');
DELAY(10);
END;
WRITELN;
WRITELN;
WRITELN('Transporting you into the future one second at a time...');
DELAY(4000);
WRITELN;
WRITELN;
TEXTCOLOR(YELLOW);
WRITELN('LOADING COMPLETED. Press F13 to continue...');
DELAY(7000);
TEXTCOLOR(LIGHTGREEN);
WRITELN('Got you there, didn`t I ',#1);
DELAY(5000);
WRITELN;
WRITELN('Loading infinite monkeys....');
DELAY(2000);
FOR I:=1 TO 9001 DO
BEGIN
WRITELN('Monkey ',I,'......Loaded');
Delay(P);
IF P>100 THEN
P:=P-100;
IF (P<101) AND (P>10) THEN
P:=P-10;
IF (P<11) AND (P>0) THEN
P:=P-1;
END;
TEXTCOLOR(RED);
REPEAT
PLAYSOUND(495,400);
PLAYSOUND(510,400);
DELAY(450);
UNTIL KEYPRESSED;
WRITELN('ENRAGED MONKEY ERROR: OUT OF BANANAS!');
TEXTCOLOR(LIGHTGREEN);
DELAY(4000);
WRITELN;
WRITELN('Your underwear has conflicted our DB. Please change daily.');
DELAY(4000);
WRITELN;
WRITELN('This is a haiku');
DELAY(4000);
WRITELN('Your content is now loading');
DELAY(4000);
WRITELN('Be patient, will you?');
DELAY(4000);
WRITELN;
WRITE('Attempting to divide by 0 ...');
FOR I:=1 To 4 DO
BEGIN
WRITE(' ... ');
DELAY(400);
END;
WRITE('OH NO!');
DELAY(3000);
P:=500;
REPEAT
TEXTBACKGROUND(I);
CLRSCR;
PLAYSOUND(I*50,P);
I:=I+1;
Delay(P);
IF P>100 THEN
P:=P-100;
IF (P<101) AND (P>10) THEN
P:=P-10;
IF (P<11) AND (P>0) THEN
P:=P-1;
UNTIL I=70;

TEXTBACKGROUND(CYAN);
CLRSCR;
TEXTCOLOR(WHITE);
WRITELN('A fatal exception 0E has occurred at 0028:C0011E in VXD VMM(01) +');
WRITELN('00010E36...');
DELAY(4000);
WRITELN;
WRITELN('Wait a minute.');
DELAY(1000);
WRITELN('Damn it, we`ve lost it Searching......');
DELAY(2000);
WRITELN;

CLRSCR;
//UNTIL Z='Y';
TEXTBACKGROUND(BLACK);
CLRSCR;
//Playgame;
END.





