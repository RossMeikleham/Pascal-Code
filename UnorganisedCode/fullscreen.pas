UNIT FullScreen;

INTERFACE
USES
    Windows;

PROCEDURE StartFullScreen;
PROCEDURE EndFullScreen;

IMPLEMENTATION

PROCEDURE StartFullScreen;
BEGIN

keybd_event(VK_MENU,56,0,0);
//VK_MENU is virtual-key code of ALT.
//56 is scan code of ALT.
keybd_event(VK_RETURN,28,0,0);
//VK_RETURN is virtual-key code of ENTER.
//28 is scan code of ENTER.
//Both Alt and Enter are being 'pressed.'

Keybd_event(VK_MENU,56,KEYEVENTF_KEYUP,0);
//Alt is up.
keybd_event(VK_RETURN,28,KEYEVENTF_KEYUP,0);
//Enter i
END;



PROCEDURE EndFullScreen;

BEGIN
Keybd_event(VK_MENU,56,KEYEVENTF_KEYUP,1);
Keybd_event(VK_RETURN,28,KEYEVENTF_KEYUP,1);
END;

END.
