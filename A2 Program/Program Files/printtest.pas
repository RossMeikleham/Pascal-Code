PROGRAM PRINTTEST;

USES NETWORKPRINT;

   VAR
   Carryon: BOOLEAN;


   BEGIN
   Carryon:=STARTPRINT;
   IF (Carryon) THEN
      BEGIN
   PRINTLN('test1');
   PRINTLN('test2');
   PRINTLN('test3');
   PRINTLN('TEST4');
   PRINTLN('TEST5');
   PRINT('test6');
   PRINT('TEST7');
   PRINT('TeSt8');
      END;
   ENDPRINT;
   END.
