       Uses Dos,SYSUTILS;
Var
    OldKbd: procedure;
    Done: boolean;

{$F+}
Procedure NewKbd;
Interrupt;
Var
        ScanCode: byte;
Begin
        ScanCode := Port[$60];
        If ScanCode < 128 then Writeln(ScanCode);
        If ScanCode = 1 then done := true;
        Asm
                mov ax,0C00h
                int 21h
        end;
        Inline($9C);    {Same as Asm pushf end}
        OldKbd
end;

{$F-}
Begin
        GetIntVec(9, @OldKbd);
        SetIntVec(9, addr(newKbd));
        Repeat until done;
        SetIntVec(9, @OldKbd);
end.
