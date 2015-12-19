PROGRAM PointerFileTest;

TYPE TestRec=RECORD

              Number:INTEGER;


               END;


VAR
    X:^FILE;
    Rec:TestRec;
    YFile:File Of TestRec;




   PROCEDURE Initialise; {Creates and saves file}
   VAR I:INTEGER;

      BEGIN

         ASSIGN(YFile,'F:\Computing\A2\TestPrograms\Pointtest.TST');
         REWRITE(YFile);
         FOR I:=1 TO 5 DO

            BEGIN

               Rec.Number:=I;
               WRITE(YFile,Rec);

            END;

         CLOSE(YFile);

      END;

BEGIN
Initialise;
WRITELN('1');
X:=@YFile;  {Points to memory location of Y File}
WRITELN('2');
ASSIGN(X^,'F:\Computing\A2\TestPrograms\Pointtest.TST');
WRITELN('3');
RESET(YFile);
X:=@YFile;
WHILE NOT EOF(X^) DO

   BEGIN
      READ(YFile,Rec);
      X:=@YFile;
      WRITELN(Rec.Number);
      WRITE('x');
   END;

READLN;
END.
