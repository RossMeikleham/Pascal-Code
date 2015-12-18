//ÛßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßÛ
//Û                                                      Û
//Û     Virtual Pascal Runtime Library.  Version 2.1     Û
//Û     Network Printer Interface Unit                   Û
//Û     ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÛ
//Û Copyright (C) 2010 Alex Williams,Edited by Aaron.W   Û
//Û     2011 Edited by Alistair.S                        Û
//Û     Further functions added by Ross.M                Û                                        Û
//Û                                                      Û
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


unit NetworkPrintNew;




interface

function StartPrint : Boolean;
procedure PrintLn(str : string);
procedure EndPrint;

procedure SetMaxLineLen(MaxLen : LONGINT);
procedure SetLineHeight(LH : longint);
procedure SetTopMargin (TM : longint);
procedure SetLeftMargin(LM : longint);

PROCEDURE PRINT(str : string);

PROCEDURE PrintReal(Rl:Real;One,Two:LONGINT);
PROCEDURE PrintInt(Int:LONGINT);
PROCEDURE PrintRealLn(Rl:Real;One,Two:LONGINT);
PROCEDURE PrintIntLn(Int:LONGINT);

implementation



uses windows, commdlg, sysutils, VPUTILS;

var
   LineHeight : longint = 100;
   TopMargin  : longint = 400;
   LeftMargin : longint = 400;
   MaxLineLen : LONGINT    = 100;

   dc                : HDC = 0;
   widPels, higPels  : integer;
   CurrentLine       : integer = 0;
   s                 : pChar = nil;


   bStarted          :  boolean = FALSE;

   TempLeftMargin: Longint =400;

procedure SetMaxLineLen(MaxLen : LONGINT); begin if MaxLen > 0 then MaxLineLen := MaxLen; end;
procedure SetLineHeight(LH : longint); begin if LH > 0 then LineHeight := LH; end;
procedure SetTopMargin (TM : longint); begin if TM > 0 then TopMargin := TM; end;
procedure SetLeftMargin(LM : longint); begin if LM > 0 then LeftMargin := LM; end;





function StartPrint : Boolean;
var
   di       : PDocInfo;
   pd       : TPrintDLG;

begin
   // if it's already in progress, than don't start a new doc!
   if not bStarted then begin

      //get device context handle of printer of user's choice
         zeromemory(@pd,sizeof(pd));
         pd.lStructSize := sizeof(pd);
         pd.hwndOwner := 0;
         pd.Flags := PD_RETURNDC;
         pd.hInstance := System.hInstance;

         Result := PrintDlg(pd);

         if Result then begin
            dc := pd.hDC;


         //get printer paper dimensions (pels)
            widPels := GetDeviceCaps(dc,HORZRES);
            higPels := GetDeviceCaps(dc,VERTRES);

            CurrentLine := TopMargin - LineHeight;  (* 233 pels between each line, start at line 0 *)


         //create document information structure
            new(di);
            zeromemory(di,sizeof(di^));

            with di^ do begin
               cbSize := sizeof(di^);
               lpszDocName := 'Pascal Printer';
               lpszOutput := nil;
            end;

         //create a new print document for writing to
            StartDoc(dc,di^);
            dispose(di);

            StartPage(dc);

            s := StrAlloc(MaxLineLen);
            bStarted := TRUE;
         end;
   end;
end;

procedure EndPrint;
begin
   EndPage(dc);
   EndDoc(dc);
   DeleteDC(dc);
   StrDispose(s);
   bStarted := FALSE;
end;





procedure PRINT(str : string);
VAR I,X:LONGINT;
    TempStr:STRING;

begin
   TempStr:='';
   if bStarted then begin

          //increment line number
         if (CurrentLine + LineHeight * 2 >= higPels) then begin
            EndPage(dc);                    //If end of page reached, start a new page
            StartPage(dc);
            CurrentLine := TopMargin;
         end;

         //IF LeftMargin+(LENGTH(STR)*50) >(MaxLineLen*50) THEN  //If text exceeds line limit
            BEGIN
               //FOR I:=1 TO (MaxLineLen-ROUND(LeftMargin/50)) DO
               //TempStr:=TempStr+Str[I];                         //Obtain text which can be printed on the same line
               //s:= strPCopy(s,TempStr);
               //TextOut(dc,LeftMargin,CurrentLine,s,StrLen(s));
               //inc(CurrentLine, LineHeight);  //Set to the next Line
               //LeftMargin:=400; //Reset Left Margin

               //TempStr:='';
               //FOR X:=I TO LENGTH(Str) DO  //Write the remaining text on the next line
               //TempStr:=TempStr+Str[X];
               //s := strPCopy(s,TempStr);
               //TextOut(dc,LeftMargin,CurrentLine,s,StrLen(s));

               //LeftMargin:=400+(LENGTH(TempStr)*50)  //set the left margin
            END //ELSE

            //BEGIN

         //s := strPCopy(s,Str);
         //TextOut(dc,LeftMargin,CurrentLine,s,StrLen(s));
         //LeftMargin:=LeftMargin+(LENGTH(Str)*50);
         {50*leftmargin= 1 character space to move over}
            //END;
   end;
end;


PROCEDURE PrntLn(Str:STRING);
BEGIN
Print(Str);
inc(CurrentLine, LineHeight);  //Set to the next Line
LeftMargin:=400; //Reset Left Margin
END;

PROCEDURE PrintIntLn(Int:LONGINT);
VAR Str:STRING;

BEGIN
Str:=INT2STR(INT)+(' ');
PRINTLN(STR);
END;


PROCEDURE PrintInt(Int:LONGINT);
VAR Str:STRING;

BEGIN
Str:=INT2STR(Int)+(' ');
PRINT(Str);
END;



PROCEDURE PrintRealLn(Rl:Real;One,Two:LONGINT);
VAR S:STRING;
BEGIN

Str(Rl:One:Two,S);
PrintLN(S+' ');
END;

PROCEDURE PrintReal(Rl:Real;One,Two:LONGINT);
VAR S:STRING;
BEGIN

Str(Rl:One:Two,S);
Print(S+' ');
END;

end.
