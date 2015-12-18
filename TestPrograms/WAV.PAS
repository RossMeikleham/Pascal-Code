{This Program Play WAV files on PC speaker
 Enjoy :)

                                 Coded By

                                Jimmy Campo
                             Popayan - Colombia
                                   1997
Mail me :
                       E-Mail  : jandresc@hotmail.com

This program is Freeware. Spread it if you want. Credit me if you use it. ;)
Thaks To : Mark Feldman - PC-GPE
}

Program AccesWavFiles;
Uses Crt;
Const SPEAKER_PORT = $61;
       PIT_CONTROL = $43;
     PIT_CHANNEL_2 = $42;
          PIT_FREQ = $1234DD;

     DELAY_LENGTH = 35; {Please adjust it for best results on your machine}

Type _Header = Record
      rID : Array[1..4] Of Char; { Contains the characters "RIFF" }
      rLen : LongInt; {The length of the data in the next chunk}
     End;

     _Format = Record
      fId : Array[1..4] Of Char; {Contains the characters "fmt"}
      fLen : LongInt;            {  Length of data in the format chunk}
      wFormatTag  : longint;
      nChannels   : longint;     {  Number of channels, 1=mono, 2=stereo}
      nSamplesPerSec : longint;  {  Playback frequency}
      nAvgBytesPerSec: longint;
      nBlockAlign    : longint;
      FormatSpecific : longint
      ;  {  Format specific data area}
     End;

    _Data = Record
     dId : Array[1..4] Of Char; { Contains the characters "data"}
     dLen : LongInt;  {Length of data in the dData field}
    End;

Var Arch : File;
    Header : _Header;
    Format : _Format;
    Data   : _Data;
    Tmp : Array[1..4] Of Char;
    Tmp2 : Array[1..64] Of Char;
    Buff : Array[1..64000] Of Byte;
    Count_Values : array[0..255] of Byte;
    i, Loop : Word;


{************************************}
Function FileExists(FileName: String): Boolean;
Var
 F: file;
Begin
 {$I-}
 Assign(F, FileName);
 FileMode := 0;
 Reset(F);
 Close(F);
 {$I+}
 FileExists := (IOResult = 0) and (FileName <> '');
End;  { FileExists }
{************************************}
Procedure PlayFile;
Begin
  { Set up the count table }
  for i := 0 to 255 do
    count_values[i] := i * 54 div 255;
  { Set up the PIT and connect the speaker to it }
  Port[PIT_CONTROL] := $90;
  Port[SPEAKER_PORT] := Port[SPEAKER_PORT] or 3;
  { Play the sound }

  asm cli end;
  For i := 1 To Data.dLen Do
   Begin
    Port[PIT_CHANNEL_2] := count_values[Buff[i]];
    for loop := 0 to DELAY_LENGTH do;
    Port[PIT_CHANNEL_2] := count_values[Buff[i]];
    for loop := 0 to DELAY_LENGTH do;
   End;
   asm sti end;

  { Reprogram the speaker for normal operation }
  Port[SPEAKER_PORT] := Port[SPEAKER_PORT] and $FC;
  Port[PIT_CONTROL] := $B6;
End;
{************************************}
Procedure Play(NomArch : String);
Var NumRead:LONGINT;
i : Word;
Begin
 Assign(Arch,NomArch);
 Reset(Arch,1);
 BlockRead(Arch, Header, SizeOf(Header), NumRead);
 If (Header.rID = 'RIFF') Then
  Begin
   BlockRead(Arch, Tmp, 4, NumRead);
   If (Tmp <> 'WAVE') Then
    Begin
     Writeln('Is not a WAV file...');
     Halt(1);
    End;
    BlockRead(Arch, Format, SizeOf(Format), NumRead);
    BlockRead(Arch, Tmp2, 20-Format.fLen, NumRead);
    If (Format.nChannels <> 1) Then
     Begin
      Writeln('Only monoaural files...');
      Halt(1);
     End;
    BlockRead(Arch, Data, SizeOf(Data), NumRead);
    BlockRead(Arch, Buff, Data.dLen, NumRead);
    PlayFile;
  End
 Else
  Writeln('Is not a valid RIFF file...');
End;
{************************************}

Begin
   ClrScr;
   If ParamCount < 1 Then
     Writeln('Use : wav <archivo.wav>')
   Else
    If FileExists(ParamStr(1)) Then
     Play(ParamStr(1))     {Leyendo WAV}
    Else
     Writeln('Read error on WAV file...');
End.
