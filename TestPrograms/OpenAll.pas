PROGRAM OpenFiles;  //Opens All ProgrammingFiles
                    //Useful if using multiple units to save time opening them
USES DOS,SYSUTILS;

VAR Path:STRING;
    FOUND:BOOLEAN;
    I,DriveLetter:CHAR;
    DataFile:FILE;



PROCEDURE GetDrive;


BEGIN
Found:=FALSE;                  //Search for drive to open programming files
                               //from
DriveLetter:='A';
WHILE (Found=FALSE) AND (ORD(DriveLetter) < (ORD('Z')+1)) DO

      BEGIN
      ASSIGN(DataFile,DriveLetter+':\MainProgram\OAKHILLSYSTEM.Pas');  {Finds the file to be read from}
      WRITE('Searching Drive ',DriveLetter,' for files....');

       IF NOT FILEEXISTS(DriveLetter+':\MainProgram\OAKHILLSYSTEM.Pas') THEN
       BEGIN
       Found:=FALSE;
       WRITELN('   Not Found in Drive ',DriveLetter,' ..');
       DriveLetter:=CHR(Ord(DriveLetter)+1);
       END ELSE
       Found:=TRUE;
       END;

IF Found=TRUE THEN
WRITELN('    Found in Drive',DriveLetter);

END;


BEGIN
GetDrive;
IF Found=TRUE THEN
BEGIN
Path:=' '+DriveLetter+':\MainProgram\';

WRITELN(Path+'Validate.Pas'+Path+'Draw.Pas'+Path+'TennantDat.Pas'
     +Path+'LandLordDat.Pas'+Path+'DateCalc.Pas'+Path+'PaymentDat.Pas'
     +Path+'OakHillSystem.Pas'+Path+'PropertyDat.Pas');
READLN;

EXEC('C:\vp21\bin.w32\Vp.exe',   //Executes the compiler with the command
                                 //of opening every file path specified
      Path+'Validate.Pas'+Path+'Draw.Pas'+Path+'TennantDat.Pas'
     +Path+'LandLordDat.Pas'+Path+'DateCalc.Pas'+Path+'PaymentDat.Pas'
     +Path+'OakHillSystem.Pas'+Path+'PropertyDat.Pas');

CLOSE(DataFile);
END;
END.
