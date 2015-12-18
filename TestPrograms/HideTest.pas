PROGRAM HIDETEST;

uses WINCRT,windows,DOS,CRT;

const _title_='Hidden application demo';
      _message1_='To exit, press Alt+Control+X';
      _message2_='Unable to register window class';
      _message3_='Unable to register hotkey, could be used by an another application';
      _message4_='Unable to create window';
      _message5_='Program terminated';

var _exit_:boolean;

function w_proc(hw:hwnd;amsg:uint;wp:wparam;lp:lparam):hresult;stdcall;export;
 begin
  w_proc:=0;
  case amsg of
   wm_create:begin
             end;
   wm_close:destroywindow(hw);
   wm_destroy:begin
               postquitmessage(0);
               _exit_:=true;
              end;
   else w_proc:=defwindowproc(hw,amsg,wp,lp);
  end;
 end;

function w_create:hwnd; { Create window }
var w:hwnd;
 begin
  w:=createwindowex(0,_title_,_title_,
                    ws_overlappedwindow or ws_minimize,
                    cw_usedefault,cw_usedefault,cw_usedefault,cw_usedefault,
                    0,0,
                    system.maininstance,nil);
  if w<>0 then begin
//   showwindow(w,cmdshow); { <-- This will show the window, without the program stays hidden }
   updatewindow(w);
  end;
  w_create:=w;
 end;


function win_reg:boolean; { register a window class }
 var wc:wndclassex;
 begin
  with wc do begin
   cbsize:=sizeof(wc);
   style:=0;
   lpfnwndproc:=@w_proc;
   cbclsextra:=0;
   cbwndextra:=0;
   hinstance:=system.maininstance;
   hicon:=loadicon(system.maininstance,'');
   hiconsm:=loadicon(system.maininstance,'');
   hcursor:=loadcursor(0,idc_arrow);
   hbrbackground:=getstockobject(gray_brush);
   lpszmenuname:=_title_;
   lpszclassname:=_title_;
  end;
  win_reg:=registerclassex(@wc)<>0;
 end;

var s:msg;

{### Main #####################################################################}
begin
 _exit_:=false;
 if not(win_reg) then begin
  messagebox(0,_message2_,nil,mb_ok);
  halt(4);
 end;
 if not(registerhotkey(0,1,mod_control or mod_alt,ord('X'))) then begin
  messagebox(0,_message3_,nil,mb_ok);
  halt(5);
 end;
 if w_create=0 then messagebox(0,_message4_,nil,mb_ok) else
 if not(messagebox(0,pchar(_message1_),pchar(_title_),mb_okcancel)=idok) then halt(6);
 repeat
  if getmessage(@s,0,0,0) then begin // <-- needs to be in every loop, otherwise program will hang
   if s.message=wm_hotkey then _exit_:=true; //      and will eat up all cpu time
   translatemessage(@s);
   dispatchmessage (@s);
  end;
 until _exit_;
 messagebox(0,_message5_,pchar(_title_),mb_ok);
end.
