UNIT VPUTILSPLUS;

INTERFACE

PROCEDURE CopyFile(SourceP,DestP:STRING); //Copies File in 1 location
                                          //to specified location
IMPLEMENTATION


PROCEDURE CopyFile(SourceP,DestP:STRING);

 VAR DestF:FILE;
     SourceF:FILE;
     Buffer:Pointer;
     Count,BuffSize:LONGINT;

  BEGIN

   ASSIGN(SourceF,SourceP);            //Assigns both files
   ASSIGN(DestF,DestP);

   RESET(SourceF,1);   //Resets the 'Source' File
   REWRITE(DestF,1);   //Rewrites the 'Destination' File
   BuffSize:=32000; //Maximum Size of Memory to read file into

   GETMEM(Buffer,BuffSize);  //Allocates 32,000 bytes of memory to the buffer

   WHILE NOT EOF(SourceF) DO    //Read the Source File
                                //Into the destination File
     BEGIN
        WRITELN('test');
        READLN;

        BLOCKREAD(SourceF,BuffSize,Count);
        WRITELN('test2');
        READLN;
        BLOCKWRITE(DestF,Count,Count);

     END;
     CLOSE(SourceF);
     CLOSE(DestF);

  END;


 END.
