PROGRAM Protocols;

USES CRT, draw;


VAR Choice,TempChoice:INTEGER;
    UpDown:CHAR;





   PROCEDURE Startup;
   VAR I:INTEGER;

   BEGIN

   TEXTCOLOR(WHITE);
   TEXTBACKGROUND(RED);
   FillBox(10,15,70,20);

   DrawDoublebox(10,15,70,20);

   GOTOXY(17,16);
   WRITE('Press Any Key to begin the Protocols presentation..');

   GOTOXY(21,18);
   TEXTBACKGROUND(WHITE);
   FOR I:=1 TO 37 DO
   WRITE(' ');

   GOTOXY(18,19);
   TEXTBACKGROUND(RED);
   FlashColour('Created by Ross Meikleham and Alistair Searing');

   WINDOW(21,18,59,18);
   TEXTCOLOR(WHITE);
   TEXTBACKGROUND(MAGENTA);
   GOTOXY(1,1);
   FOR I:=1 TO 37 DO

   BEGIN
   WRITE(#177);
   DELAY(100);
   END;

   WINDOW(1,1,80,25);


   END;



   PROCEDURE Main;

   BEGIN;

   CLRSCR;

   TEXTCOLOR(WHITE);

   Drawdoublebox(1,1,79,24);
   TEXTBACKGROUND(RED);
   Fillbox(20,2,60,5);
   Drawbox(20,2,60,5);

   FILLBOX(14,8,70,22);
   DRAWBOX(14,8,70,22);

   TEXTCOLOR(WHITE);

   END;


   PROCEDURE Bottom(Pageno:INTEGER);

   BEGIN

      WINDOW(1,1,80,25);
      TEXTBACKGROUND(BLACK);
      CLRSCR;
      Main;

      GOTOXY(35,3);

      CASE PageNo OF

         1:WRITE('PROTOCOLS');
         2:WRITE('TCP/IP');
         3:WRITE('TCP/IP');
         4:WRITE('HTTP');
         5:WRITE('FTP');
         6:WRITE('SMTP');
         7:WRITE('POP3');
         8:WRITE('IMAP');
         9:WRITE('VoIP');
         10:WRITE('WAP');


      END;

      GOTOXY(1,25);
      TEXTCOLOR(WHITE);
      TEXTBACKGROUND(BLUE);
      WRITE('Page ',PageNo,' Of 10    ',#24,' for previous page   ',#25,' for next page.     X to exit          ');
      TEXTBACKGROUND(RED);
      TEXTBACKGROUND(WHITE);
      WINDOW(15,9,69,22);

   END;



   PROCEDURE ProtocolMain;

   BEGIN

   CLRSCR;

   Bottom(1);
   TEXTBACKGROUND(RED);

   WRITELN('Protocols allow computers to communicate ');
   WRITELN('with each other without the user');
   WRITELN('knowing what is happening in the background');

   WRITELN;
   WRITELN('If there were no protocols then computers');
   WRITELN('would not be able to interpret other');
   WRITELN('computer`s data');

   WRITELN;

   WRITELN('There are a number of protocols for networks');
   WRITELN('on the internet with the most common being');
   WRITELN('TCP/IP');


   END;




   PROCEDURE TCPIP;

      BEGIN

      CLRSCR;

      Bottom(2);
      TEXTBACKGROUND(RED);

      WRITELN('TCP/IP is a basic communication protocol of');
      WRITELN('the internet. When you are set up with');
      WRITELN('internet access, your computer is provided');
      WRITELN('with a copy of the TCP/IP program so that you');
      WRITELN('may send messages to get information from another');
      WRITELN('Computer with this program.');

      WRITELN;

      WRITELN('TCP/IP is a two layer program. The higher layer');
      WRITELN('TCP controls the assembling of the message/file');
      WRITELN('into packets. They are transmitted across the');
      WRITELN('internet then reassembled by the TCP layer. The');
      WRITELN('lower layer (IP) handles the address part so that');
      WRITELN('it reaches the correct destination.');

   END;



   PROCEDURE TCPIP2;

      BEGIN

      CLRSCR;

      Bottom(3);
      TEXTBACKGROUND(RED);

      WRITELN('Each gateway computer checks this address to see where');
      WRITELN('to forward the message to. Some packets are routed');
      WRITELN('differently and then are reassembled at destination.');

      END;


   PROCEDURE HTTP;

      BEGIN

         CLRSCR;
         Bottom(4);
         TEXTBACKGROUND(RED);

         WRITELN('HTTP is a set of rules that govern how multimedia');
         WRITELN('files are transferred around the internet.');

         WRITELN;

         WRITELN('The content of the internet is text,graphics,video');
         WRITELN('and sound. HTTP ensures that these files can be');
         WRITELN('transferred and recieved in a common format.');

         WRITELN;

         WRITELN('Commonly it transfers displayable web pages and');
         WRITELN('their related files');

         WRITELN;

         WRITELN('HTTP is an application protocol that runs on top');
         WRITELN('of TCP/IP');


     END;





   PROCEDURE FTP;

      BEGIN

         CLRSCR;
         Bottom(5);
         TEXTBACKGROUND(RED);

         WRITELN('FTP is the simplest way to exchange and transfer');
         WRITELN('files between computers over the internet.');

         WRITELN;

         WRITELN('FTP is commonly used to transfer web page files from');
         WRITELN('their creator to everyone on the internet. It`s also');
         WRITELN('commonly used to download programs and other files');
         WRITELN('to your computer from other servers.');

         WRITELN;

         WRITELN('Any FTP client program with a GUI usually must be');
         WRITELN('downloaded from the company that makes it.');

     END;




   PROCEDURE SMTP;

      BEGIN

         CLRSCR;
         Bottom(6);
         TEXTBACKGROUND(RED);

         WRITELN('SMTP is a TCP/IP protocol used in sending and ');
         WRITELN('receiving e-mail. However since it is limited');
         WRITELN('in it`s ability to queue messages at the recieving');
         WRITELN('end, it is usually used with one or two other');
         WRITELN('protocols, POP3 or IMAP, which lets the user save');
         WRITELN('messages in a server mailbox and download them');
         WRITELN('periodically from the server');

         WRITELN;

         WRITELN('TCP/IP, HTTP, FTP and SMTP are often included');
         WRITELN('together within a suite of protocols. They are');
         WRITELN('also known as the `foundation protocols of the');
         WRITELN('internet');


      END;



   PROCEDURE POP3;

      BEGIN

         CLRSCR;
         Bottom(7);
         TEXTBACKGROUND(RED);

         WRITELN('POP3 is the most recent version of a standard');
         WRITELN('protocol for receiving email. POP3 is a protocol');
         WRITELN('in which email is received and held for you by your');
         WRITELN('internet server. Periodically you (or your e-mail');
         WRITELN('receiver) checks your mail-box on the server and');
         WRITELN('downloads any mail, probably using POP3.');

         WRITELN;

         WRITELN('POP3 deals with the receiving of e-mail and is not to');
         WRITELN('be confused with SMTP, which transfers emails across');
         WRITELN('the internet');


     END;




   PROCEDURE IMAP;

      BEGIN

         CLRSCR;
         Bottom(8);
         TEXTBACKGROUND(RED);

         WRITELN('IMAP is a protocol for accessing e-mail from your');
         WRITELN('server. It is a protocol in which e-mail is received');
         WRITELN('and held for you by your internet server. You (or your');
         WRITELN('email client) can view just the heading and the sender');
         WRITELN('of the letter and then decide whether to download the');
         WRITELN('mail');

         WRITELN;

         WRITELN('You can also create and manipulate multiple folders or');
         WRITELN('mail boxes on the server, delete messages, or search');
         WRITELN('for certain parts or an entire note. IMAP deals with');
         WRITELN('the reveiving of e-mail and isn`t to be confused with');
         WRITELN('the SMTP which transfers e-mails across the internet');


    END;


   PROCEDURE VoIP;

      BEGIN

         CLRSCR;
         Bottom(9);
         TEXTBACKGROUND(RED);

         WRITELN('VoIP is an IP telephony term for a set of facilities');
         WRITELN('used to manage the delivery of voice information');
         WRITELN('over the internet.');

         WRITELN;

         WRITELN('It involves sending voice information');
         WRITELN('in digital form in discrete packets. A major advantage');
         WRITELN('of VoIP and Internet telepony is that it avoids the');
         WRITELN('tolls charged by ordinary telephone services.');

      END;


   PROCEDURE WAP;

      BEGIN

         CLRSCR;
         Bottom(10);
         TEXTBACKGROUND(RED);

         WRITELN('WAP is a specification for a set of 4 layer');
         WRITELN('communication protocols to standardise the way that');
         WRITELN('wireless devices such as mobile phones and radio');
         WRITELN('transceivers work.');
         WRITELN('(Ogres have layers, WAP has layers :D');

         WRITELN;

         WRITELN('It can be used for Internet access, including e-mail');
         WRITELN('and instant messaging');

     END;


BEGIN
Startup;
TempChoice:=0;
Choice:=1;
ProtocolMain;
REPEAT


IF TempChoice<>Choice THEN

CASE Choice OF
1:ProtocolMain;
2:TCPIP;
3:TCPIP2;
4:HTTP;
5:FTP;
6:SMTP;
7:POP3;
8:IMAP;
9:VoIP;
10:WAP;
END;

TempChoice:=Choice;
UpDown:=UPCASE(READKEY);

IF (UpDown=#80) AND (Choice<>10) THEN
Choice:=Choice+1;

IF (UpDown=#72) AND (Choice<>1) THEN
Choice:=Choice-1;

UNTIL UpDown='X';

END.
