UNIT WINDOWTEST;

INTERFACE

USES CRT,DRAWTEST;

TYPE
   ScreenImage=ARRAY[0..1999] OF WORD;
   FrameRec   =RECORD

                 UpperLeft:WORD;
                 LowerRight:WORD;
                 ScreenMemory:ScreenImage;
              END;



 VAR
    SnapShot:^ScreenImage;
    FrameStore:Array[1..10] OF ^FrameRec;
    WindowNumber:BYTE;

PROCEDURE OpenWindow(x1,y1,x2,y2:BYTE);
PROCEDURE CloseWindow;
PROCEDURE Snap;

IMPLEMENTATION

   PROCEDURE OpenWindow(x1,y1,x2,y2:BYTE);

      BEGIN

         WindowNumber:=WindowNumber+1;
         New(Framestore[WindowNumber]);
         WITH Framestore[WindowNumber]^ DO

         BEGIN

            ScreenMemory:=Snapshot^;
            UpperLeft:=WindMin;
            LowerRight:=WindMax;

         END;

         Window(x1,y1,x2,y2);

     END;



   PROCEDURE CloseWindow;

      BEGIN

         WITH FrameStore[WindowNumber]^ DO

         BEGIN

            SnapShot^:=ScreenMemory;
            Window( (Lo(UpperLeft)+1), (Hi(UpperLeft)+1),
                    (Lo(LowerRight)+1), (Hi(LowerRight)+1) );

         END;

         Dispose(FrameStore[WindowNumber]);
         WindowNumber:=WindowNumber-1;

     END;





PROCEDURE Snap;
BEGIN;
SnapShot:=ptr($B800,$0000);
END;
END.







