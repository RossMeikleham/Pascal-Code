UNIT DEBUG;

//This unit is designed to help save time debugging programs
//It contains 2 functions a variable watch and a InputOutput checker
//works using the power of multi threading 
//Created by Ross Meikleham 2011

INTERFACE

//PROCEDURE StartCheck;

PROCEDURE StartWatch;

PROCEDURE IntWatch(VAR I:LONGINT);

PROCEDURE StrWatch(VAR S:STRING);

PROCEDURE CharWatch(Var C:CHAR);

PROCEDURE BoolWatch(VAR B:BOOLEAN);

PROCEDURE RealWatch(VAR R:REAL);

PROCEDURE ResetWatch; //Initialises positions

IMPLEMENTATION

USES CRT,VPUTILS,DOS;

TYPE

IntArray=ARRAY[1..10] OF ^LONGINT;
RealArray=ARRAY[1..10] OF ^REAL;
BoolArray=ARRAY[1..10] OF ^BOOLEAN;
StrArray=ARRAY[1..10] OF ^STRING;
CharArray=ARRAY[1..10] OF ^CHAR;


VAR TotalVar:LONGINT;
    CUSTFILE: FILE;
    MaxPos:LONGINT;

    IntLocation:IntArray;
    RealLocation:RealArray;
    BoolLocation:BoolArray;
    StrLocation:StrArray;
    CharLocation:CharArray;

    StopWatch:BOOLEAN;

    IntPos,RealPos,BoolPos,StrPos,CharPos:LONGINT;

    UpdateThreadId,StartStopThreadId:LONGINT;






PROCEDURE IntWatch(VAR I:LONGINT);
  BEGIN
   IF IntPos<10 THEN
      BEGIN
      IntPos:=IntPos+1;
      IntLocation[IntPos]:=@I;
      END;
  END;


PROCEDURE StrWatch(VAR S:STRING);
   BEGIN
   IF StrPos<10 THEN
   BEGIN
   StrPos:=StrPos+1;
   StrLocation[StrPos]:=@S;
   END;
   END;

PROCEDURE BoolWatch(VAR B:BOOLEAN);
  BEGIN
   IF BoolPos<10 THEN
      BEGIN
      BoolPos:=BoolPos+1;
      BoolLocation[BoolPos]:=@B;
      END;
  END;

PROCEDURE RealWatch(VAR R:REAL);
   BEGIN
   IF RealPos<10 THEN
   BEGIN
   RealPos:=RealPos+1;
   RealLocation[RealPos]:=@R;
  END;
 END;


PROCEDURE CharWatch(VAR C:CHAR);
   BEGIN
   IF CharPos<10 THEN
   BEGIN
   CharPos:=CharPos+1;
   CharLocation[CharPos]:=@C; //Address in current array position
  END;                        //set to address of variable
 END;


PROCEDURE ResetWatch; //Initialises positions
 BEGIN
 IntPos:=0;
 RealPos:=0;
 StrPos:=0;
 BoolPos:=0;
 END;


//FUNCTION StartStop(Pointy:POINTER):LONGINT;
//VAR Key:Char;
//    Changed:BOOLEAN;
//   BEGIN
 //    REPEAT
     //   IF KEYPRESSED=TRUE
     //   THEN BEGIN
      //   Key:=UPCASE(READKEY);
 //        Changed:=FALSE;
 //       IF (Key=#27) AND (StopWatch=FALSE) THEN
 //          BEGIN
 //
 //          StopWatch:=TRUE;
 //          WINDOW(60,1,80,25);
 //          CLRSCR;
 //          WINDOW(1,1,80,25);
 //          Changed:=TRUE;
 //          END;

 //           IF Changed=FALSE THEN
 //       IF (Key=#27) AND (StopWatch=TRUE) THEN
 //       BEGIN
 //          StopWatch:=FALSE;
 //       END;

    //       Key:='0';
     //   END;
    // UNTIL 4=5;
  // END;

FUNCTION UpdateWatch(Pointy:POINTER):LONGINT;
VAR X,Y,I:LONGINT;
   BEGIN

      REPEAT
      WHILE StopWatch=FALSE DO
      BEGIN
      HIDECURSOR;
      WINDOW(60,1,80,25);
      GOTOXY(1,1);

      IF IntPos<>0 THEN
      FOR I:=1 TO IntPos DO
      WRITELN('IntVar',I,':',Intlocation[I]^);

      IF StrPos<>0 THEN
      FOR I:=1 TO StrPos DO
      BEGIN
      WRITE('StrVar',I,':');
      IF Strlocation[I]^='' THEN WRITELN('Not Initialised') ELSE
      WRITELN(StrLocation[I]^);
      END;

      IF CharPos<>0 THEN
      FOR I:=1 TO CharPos DO
      BEGIN
      WRITE('CharVar',I,':');
      IF Charlocation[I]^='' THEN WRITE('Not Initialised') ELSE
      WRITELN(CharLocation[I]^);
      END;

      IF RealPos<>0 THEN
      FOR I:=1 TO RealPos DO
      WRITELN('RealVar',I,':',Reallocation[I]^:9:5);

      IF BoolPos<>0 THEN
      FOR I:=1 TO BoolPos DO
      WRITELN('BoolVar',I,':',Boollocation[I]^);

      WINDOW(1,1,80,25);
      SHOWCURSOR;
      DELAY(100);
      END;
      UNTIL 4=5;
   END;



//FUNCTION InputOutputCheck(Pointy:Pointer) :LONGINT;

//VAR Result:LONGINT;

  // BEGIN
 //  REPEAT
 //  {$I-}
//   Result:=INOUTRES;
//   WRITELN(INOUTRES);
//   ASSIGN(CustFile,'F:\CustFile.DTA');
//     RESET(CustFile);
//   {$I+}

//   IF Result<>0 THEN
//     BEGIN

 //    CASE Result OF
 //    2: BEGIN

//     CLRSCR;
//     WRITELN('An Input/Ouput Error `2` has occured');
 //    WRITELN('This could mean one of the following:');
 //    WRITELN;
 //    WRITELN('You have tried to perform file operations on a file which hasn`t been assigned');
 //    WRITELN;
//     READLN;
 //    END ELSE BEGIn WRITELN('testt'); READLN;

 //   END;
 //  END;

// END;

// UNTIL 4=5;
//END;

//PROCEDURE StartCheck;
   //BEGIN
   //StartStopThreadId:=VPBEGINTHREAD(InputOutputCheck,0,NIL);

   //END;
PROCEDURE StartWatch;

   BEGIN
   StopWatch:=FALSE;
   UpdateThreadId:=VPBEGINTHREAD(UpdateWatch,0,NIL);
   END;




END.
