PROGRAM COPYTEST;

USES DOS;

   VAR

   TempStore:ARRAY[1..1000] OF BYTE;  {can hold 1000bytes of data to copy}
   OLDFILE:FILE;
   NEWFILE:FILE;

   OldFilePath:STRING;
   NewFilePath:STRING;

   I,J:INTEGER;

   NumRead:LONGINT;
   NumWritten:LONGINT;
   Total:LONGINT;

   PROCEDURE ReadFile;

   BEGIN

   WRITELN('Enter location of the original file `DriveLetter:folder1\folder2..\FileName');
   READLN(OldFilePath);

   ASSIGN(OldFile,OldFilePath);
   RESET(OldFile);

   END;



   PROCEDURE WriteFile;

   BEGIN

   WRITELN('Enter Location you wish the new file to be');
   READLN(NewFilePath);

   ASSIGN(NewFile,NewFilePath);
   REWRITE(NewFile);

   Total:=0;
   REPEAT


   BLOCKREAD(OldFile,TempStore,SIZEOF(TempStore),NumRead);
   BLOCKWRITE(NewFile,TempStore,NumRead,NumWritten);

   UNTIL (NumRead=0) OR (NumWritten <> NumRead);

   WRITELN('Copy is sucessful...I hope');
   READLN;

   END;

BEGIN
ReadFile;
WriteFile;
CLOSE(OldFile);
CLOSE(NewFile);
END.
