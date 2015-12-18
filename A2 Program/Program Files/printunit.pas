//ÛßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßÛ
//Û                                                      Û
//Û     Virtual Pascal Runtime Library.  Version 2.1     Û
//Û     Network Printer Interface Unit                   Û
//Û     ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÛ
//Û Copyright (C) 2010 Alex Williams,Edited by Aaron.W   Û
//Û                                                      Û
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß


unit NetworkPrint;




interface

function StartPrint : Boolean;
procedure PrintLn(str : string);
procedure Print(str:STRING);
procedure EndPrint;

procedure SetMaxLineLen(MaxLen : byte);
procedure SetLineHeight(LH : longint);
procedure SetTopMargin (TM : longint);
procedure SetLeftMargin(LM : longint);

implementation



uses windows, commdlg, sysutils;

var
   LineHeight : longint = 100;
   TopMargin  : longint = 400;
   LeftMargin : longint = 400;
   MaxLineLen : byte    = 100;

   dc                : HDC = 0;
   widPels, higPels  : integer;
   CurrentLine       : integer = 0;
   s                 : pChar = nil;


   bStarted          :  boolean = FALSE;


procedure SetMaxLineLen(MaxLen : byte); begin if MaxLen > 0 then MaxLineLen := MaxLen; end;
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




procedure Print(str:STRING);

BEGIN
   If Bstarted Then BEGIN

      //increment line number
      //inc(Currentline, LineHeight);
      if (CurrentLine + LineHeight * 2 >= higPels) then begin
            EndPage(dc);
            StartPage(dc);
            CurrentLine := TopMargin;
         end;

          //output text to current line on printer device
          s := strPCopy(s,str);

         TextOut(dc,LeftMargin,CurrentLine,s,StrLen(s));

   end;
end;


procedure PrintLn(str : string);
begin
   if bStarted then begin

      //increment line number
         inc(CurrentLine, LineHeight);
         if (CurrentLine + LineHeight * 2 >= higPels) then begin
            EndPage(dc);
            StartPage(dc);
            CurrentLine := TopMargin;
         end;



      //output text to current line on printer device
          s := strPCopy(s,str);

         TextOut(dc,LeftMargin,CurrentLine,s,StrLen(s));

   end;
end;

end.
