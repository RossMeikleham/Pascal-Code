UNIT TetrisDebug;

INTERFACE

USES TetrisFunc,CRT;


   PROCEDURE DrawBoardState(X,Y:INTEGER;Board:TBoard);

IMPLEMENTATION

      PROCEDURE DrawBoardState(X,Y:INTEGER;Board:TBoard);
      VAR X1,Y1:INTEGER;
         BEGIN
            TEXTCOLOR(GREEN);
            FOR Y1:= 0 TO BoardMaxY-1 DO
               BEGIN
                  GOTOXY(X,Y+Y1);
                  FOR X1:=1 TO BoardMaxX DO
                     IF Board.BoardState[X1,Y1+1].Occupied=FALSE THEN
                        WRITE('0')
                     ELSE WRITE('1');
               END;


         END;
END.
