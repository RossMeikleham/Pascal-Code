//��������������������������������������������������������
//�                                                      �
//�     Virtual Pascal Runtime Library.  Version 2.1     �
//�     Common Multimedia interface unit                 �
//�     ��������������������������������������������������
//�     Copyright (C) 2003 vpascal.com                   �
//�                                                      �
//��������������������������������������������������������

unit mmSystem;

{&AlignRec+,StdCall+,SmartLink+,OrgName+}

interface

uses
  Windows;

{---[ Various constants ]---}

const
  MaxpNameLen      =  32;       // max product name length (including nil)
  MaxErrorLength   = 128;       // max error text length (including nil)
  Max_JoystickOemVxdName = 260; // max oem vxd name length (including nil)

{---[ Vendor and product IDs ]---}
const
  MM_MICROSOFT            = 1;       { Microsoft Corp. }

  MM_MIDI_MAPPER          = 1;       { MIDI Mapper }
  MM_WAVE_MAPPER          = 2;       { Wave Mapper }
  MM_SNDBLST_MIDIOUT      = 3;       { Sound Blaster MIDI output port }
  MM_SNDBLST_MIDIIN       = 4;       { Sound Blaster MIDI input port  }
  MM_SNDBLST_SYNTH        = 5;       { Sound Blaster internal synthesizer }
  MM_SNDBLST_WAVEOUT      = 6;       { Sound Blaster waveform output }
  MM_SNDBLST_WAVEIN       = 7;       { Sound Blaster waveform input }
  MM_ADLIB                = 9;       { Ad Lib-compatible synthesizer }
  MM_MPU401_MIDIOUT       = 10;      { MPU401-compatible MIDI output port }
  MM_MPU401_MIDIIN        = 11;      { MPU401-compatible MIDI input port }
  MM_PC_JOYSTICK          = 12;      { Joystick adapter }

{ general data types }
type
  Version = UInt;               { major (high byte), minor (low byte) }
  mmVersion = UInt;             { major (high byte), minor (low byte) }
  mmResult = UInt;              { error return code, 0 means no error }

{ types for wType field in TMMTime struct }
const
  TIME_MS         = $0001;  { time in milliseconds }
  TIME_SAMPLES    = $0002;  { number of wave samples }
  TIME_BYTES      = $0004;  { current byte offset }
  TIME_SMPTE      = $0008;  { SMPTE time }
  TIME_MIDI       = $0010;  { MIDI time }
  TIME_TICKS      = $0020;  { Ticks within MIDI stream }

type
  PMMTime = ^TMMTime;
  mmtime_tag = record
    case wType: UInt of        { indicates the contents of the variant record }
     TIME_MS:      (ms: DWord);
     TIME_SAMPLES: (sample: DWord);
     TIME_BYTES:   (cb: DWord);
     TIME_TICKS:   (ticks: DWord);
     TIME_SMPTE: (
        hour: Byte;
        min: Byte;
        sec: Byte;
        frame: Byte;
        fps: Byte;
        dummy: Byte;
        pad: array[0..1] of Byte);
      TIME_MIDI : (songptrpos: DWord);
  end;
  TMMTime = mmtime_tag;
  MMTIME = mmtime_tag;

{---[ Windows messages for MM ]---}

const
{ joystick }
  MM_JOY1MOVE         = $3A0;
  MM_JOY2MOVE         = $3A1;
  MM_JOY1ZMOVE        = $3A2;
  MM_JOY2ZMOVE        = $3A3;
  MM_JOY1BUTTONDOWN   = $3B5;
  MM_JOY2BUTTONDOWN   = $3B6;
  MM_JOY1BUTTONUP     = $3B7;
  MM_JOY2BUTTONUP     = $3B8;

{ MCI }
  MM_MCINOTIFY        = $3B9;

{ waveform output }
  MM_WOM_OPEN         = $3BB;
  MM_WOM_CLOSE        = $3BC;
  MM_WOM_DONE         = $3BD;

{ waveform input }
  MM_WIM_OPEN         = $3BE;
  MM_WIM_CLOSE        = $3BF;
  MM_WIM_DATA         = $3C0;

{ MIDI input }
  MM_MIM_OPEN         = $3C1;
  MM_MIM_CLOSE        = $3C2;
  MM_MIM_DATA         = $3C3;
  MM_MIM_LONGDATA     = $3C4;
  MM_MIM_ERROR        = $3C5;
  MM_MIM_LONGERROR    = $3C6;

{ MIDI output }
  MM_MOM_OPEN         = $3C7;
  MM_MOM_CLOSE        = $3C8;
  MM_MOM_DONE         = $3C9;

  MM_DRVM_OPEN        = $3D0;
  MM_DRVM_CLOSE       = $3D1;
  MM_DRVM_DATA        = $3D2;
  MM_DRVM_ERROR       = $3D3;

  MM_STREAM_OPEN            = $3D4;
  MM_STREAM_CLOSE           = $3D5;
  MM_STREAM_DONE            = $3D6;
  MM_STREAM_ERROR           = $3D7;

  MM_MOM_POSITIONCB         = $3CA;

  MM_MCISIGNAL              = $3CB;
  MM_MIM_MOREDATA           = $3CC;

  MM_MIXM_LINE_CHANGE       = $3D0;
  MM_MIXM_CONTROL_CHANGE    = $3D1;

{---[ String resource numbers ]---}

const
  MMSYSERR_BASE          = 0;
  WAVERR_BASE            = 32;
  MIDIERR_BASE           = 64;
  TIMERR_BASE            = 96;
  JOYERR_BASE            = 160;
  MCIERR_BASE            = 256;
  MIXERR_BASE            = 1024;

  MCI_STRING_OFFSET      = 512;
  MCI_VD_OFFSET          = 1024;
  MCI_CD_OFFSET          = 1088;
  MCI_WAVE_OFFSET        = 1152;
  MCI_SEQ_OFFSET         = 1216;

// Error codes
const
  MMSYSERR_NOERROR      = 0;                  { no error }
  MMSYSERR_ERROR        = MMSYSERR_BASE + 1;  { unspecified error }
  MMSYSERR_BADDEVICEID  = MMSYSERR_BASE + 2;  { device ID out of range }
  MMSYSERR_NOTENABLED   = MMSYSERR_BASE + 3;  { driver failed enable }
  MMSYSERR_ALLOCATED    = MMSYSERR_BASE + 4;  { device already allocated }
  MMSYSERR_INVALHANDLE  = MMSYSERR_BASE + 5;  { device handle is invalid }
  MMSYSERR_NODRIVER     = MMSYSERR_BASE + 6;  { no device driver present }
  MMSYSERR_NOMEM        = MMSYSERR_BASE + 7;  { memory allocation error }
  MMSYSERR_NOTSUPPORTED = MMSYSERR_BASE + 8;  { function isn't supported }
  MMSYSERR_BADERRNUM    = MMSYSERR_BASE + 9;  { error value out of range }
  MMSYSERR_INVALFLAG    = MMSYSERR_BASE + 10; { invalid flag passed }
  MMSYSERR_INVALPARAM   = MMSYSERR_BASE + 11; { invalid parameter passed }
  MMSYSERR_HANDLEBUSY   = MMSYSERR_BASE + 12; { handle being used
                                                simultaneously on another
                                                thread (eg callback) }
  MMSYSERR_INVALIDALIAS = MMSYSERR_BASE + 13; { specified alias not found }
  MMSYSERR_BADDB        = MMSYSERR_BASE + 14; { bad registry database }
  MMSYSERR_KEYNOTFOUND  = MMSYSERR_BASE + 15; { registry key not found }
  MMSYSERR_READERROR    = MMSYSERR_BASE + 16; { registry read error }
  MMSYSERR_WRITEERROR   = MMSYSERR_BASE + 17; { registry write error }
  MMSYSERR_DELETEERROR  = MMSYSERR_BASE + 18; { registry delete error }
  MMSYSERR_VALNOTFOUND  = MMSYSERR_BASE + 19; { registry value not found }
  MMSYSERR_NODRIVERCB   = MMSYSERR_BASE + 20; { driver does not call DriverCallback }
  MMSYSERR_LASTERROR    = MMSYSERR_BASE + 20; { last error in range }

type
  HDRVR = Integer;

const
{ Driver messages }
  DRV_LOAD                = $0001;
  DRV_ENABLE              = $0002;
  DRV_OPEN                = $0003;
  DRV_CLOSE               = $0004;
  DRV_DISABLE             = $0005;
  DRV_FREE                = $0006;
  DRV_CONFIGURE           = $0007;
  DRV_QUERYCONFIGURE      = $0008;
  DRV_INSTALL             = $0009;
  DRV_REMOVE              = $000A;
  DRV_EXITSESSION         = $000B;
  DRV_POWER               = $000F;
  DRV_RESERVED            = $0800;
  DRV_USER                = $4000;

type
{ LPARAM of DRV_CONFIGURE message }
  PDrvConfigInfo = ^TDrvConfigInfo;
  tagDRVCONFIGINFO = packed record
    dwDCISize: DWord;
    lpszDCISectionName: PWideChar;
    lpszDCIAliasName: PWideChar;
  end;
  TDrvConfigInfo = tagDRVCONFIGINFO;
  DRVCONFIGINFO = tagDRVCONFIGINFO;

const
{ Supported return values for DRV_CONFIGURE message }
  DRVCNF_CANCEL           = $0000;
  DRVCNF_OK               = $0001;
  DRVCNF_RESTART          = $0002;

// installable driver function prototypes
type
  TFNDriverProc = function(dwDriverId: DWord; hdrvr: HDRVR;
    msg: UInt; lparam1, lparam2: LPARAM): Longint;

function CloseDriver(hDriver: HDRVR; lParam1, lParam2: Longint): Longint;
function OpenDriver(szDriverName: PWideChar; szSectionName: PWideChar; lParam2: Longint): HDRVR;
function SendDriverMessage(hDriver: HDRVR; message: UInt; lParam1, lParam2: Longint): Longint;
function DrvGetModuleHandle(hDriver: HDRVR): HMODULE;
function GetDriverModuleHandle(hDriver: HDRVR): HMODULE;
function DefDriverProc(dwDriverIdentifier: DWord; hdrvr: HDRVR; uMsg: UInt;
  lParam1, lParam2: LPARAM): Longint;

{ return values from DriverProc() function }
const
  DRV_CANCEL             = DRVCNF_CANCEL;
  DRV_OK                 = DRVCNF_OK;
  DRV_RESTART            = DRVCNF_RESTART;

  DRV_MCI_FIRST          = DRV_RESERVED;
  DRV_MCI_LAST           = DRV_RESERVED + $FFF;


// Driver callback support

{ flags used with waveOutOpen(), waveInOpen(), midiInOpen(), and }
{ midiOutOpen() to specify the type of the dwCallback parameter. }

const
  CALLBACK_TYPEMASK   = $00070000;    { callback type mask }
  CALLBACK_NULL       = $00000000;    { no callback }
  CALLBACK_WINDOW     = $00010000;    { dwCallback is a HWND }
  CALLBACK_TASK       = $00020000;    { dwCallback is a HTASK }
  CALLBACK_FUNCTION   = $00030000;    { dwCallback is a FARPROC }
  CALLBACK_THREAD     = CALLBACK_TASK;{ thread ID replaces 16 bit task }
  CALLBACK_EVENT      = $00050000;    { dwCallback is an EVENT Handle }

// driver callback prototypes

type
  TFNDrvCallBack = procedure(hdrvr: HDRVR; uMsg: UInt; dwUser: DWord; dw1, dw2: DWord);

function mmsystemGetVersion: UInt;

// Sound functions

function sndPlaySound(lpszSoundName: PChar; uFlags: UInt): Bool;

{ flag values for wFlags parameter }
const
  SND_SYNC            = $0000;  { play synchronously (default) }
  SND_ASYNC           = $0001;  { play asynchronously }
  SND_NODEFAULT       = $0002;  { don't use default sound }
  SND_MEMORY          = $0004;  { lpszSoundName points to a memory file }
  SND_LOOP            = $0008;  { loop the sound until next sndPlaySound }
  SND_NOSTOP          = $0010;  { don't stop any currently playing sound }

  SND_NOWAIT          = $00002000;  { don't wait if the driver is busy }
  SND_ALIAS           = $00010000;  { name is a registry alias }
  SND_ALIAS_ID        = $00110000;  { alias is a predefined ID }
  SND_FILENAME        = $00020000;  { name is file name }
  SND_RESOURCE        = $00040004;  { name is resource name or atom }
  SND_PURGE           = $0040;      { purge non-static events for task }
  SND_APPLICATION     = $0080;      { look for application specific association }

  SND_ALIAS_START     = 0;   { alias base }

  SND_ALIAS_SYSTEMASTERISK       = SND_ALIAS_START + (Longint(Ord('S')) or (Longint(Ord('*')) shl 8));
  SND_ALIAS_SYSTEMQUESTION       = SND_ALIAS_START + (Longint(Ord('S')) or (Longint(Ord('?')) shl 8));
  SND_ALIAS_SYSTEMHAND           = SND_ALIAS_START + (Longint(Ord('S')) or (Longint(Ord('H')) shl 8));
  SND_ALIAS_SYSTEMEXIT           = SND_ALIAS_START + (Longint(Ord('S')) or (Longint(Ord('E')) shl 8));
  SND_ALIAS_SYSTEMSTART          = SND_ALIAS_START + (Longint(Ord('S')) or (Longint(Ord('S')) shl 8));
  SND_ALIAS_SYSTEMWELCOME        = SND_ALIAS_START + (Longint(Ord('S')) or (Longint(Ord('W')) shl 8));
  SND_ALIAS_SYSTEMEXCLAMATION    = SND_ALIAS_START + (Longint(Ord('S')) or (Longint(Ord('!')) shl 8));
  SND_ALIAS_SYSTEMDEFAULT        = SND_ALIAS_START + (Longint(Ord('S')) or (Longint(Ord('D')) shl 8));

function PlaySound(pszSound: PChar; hmod: HMODULE; fdwSound: DWord): Bool;

// WAV support

{ waveform audio error return values }
const
  WAVERR_BADFORMAT      = WAVERR_BASE + 0;    { unsupported wave format }
  WAVERR_STILLPLAYING   = WAVERR_BASE + 1;    { still something playing }
  WAVERR_UNPREPARED     = WAVERR_BASE + 2;    { header not prepared }
  WAVERR_SYNC           = WAVERR_BASE + 3;    { device is synchronous }
  WAVERR_LASTERROR      = WAVERR_BASE + 3;    { last error in range }

{ waveform audio data types }
type
  phWave = ^hWave;
  hWave = Integer;
  phWaveIn = ^hWaveIn;
  hWaveIn = Integer;
  phWaveOut = ^hWaveOut;
  hWaveOut = Integer;

type
  TFNWaveCallBack = TFNDrvCallBack;

{ wave callback messages }
const
  WOM_OPEN        = MM_WOM_OPEN;
  WOM_CLOSE       = MM_WOM_CLOSE;
  WOM_DONE        = MM_WOM_DONE;
  WIM_OPEN        = MM_WIM_OPEN;
  WIM_CLOSE       = MM_WIM_CLOSE;
  WIM_DATA        = MM_WIM_DATA;

{ device ID for wave device mapper }
  WAVE_MAPPER     = UInt(-1);

{ flags for dwFlags parameter in waveOutOpen() and waveInOpen() }
  WAVE_FORMAT_QUERY     = $0001;
  WAVE_ALLOWSYNC        = $0002;
  WAVE_MAPPED           = $0004;

{ wave data block header }
type
  PWaveHdr = ^TWaveHdr;
  wavehdr_tag = record
    lpData: PChar;              { pointer to locked data buffer }
    dwBufferLength: DWord;      { length of data buffer }
    dwBytesRecorded: DWord;     { used for input only }
    dwUser: DWord;              { for client's use }
    dwFlags: DWord;             { assorted flags (see defines) }
    dwLoops: DWord;             { loop control counter }
    lpNext: PWaveHdr;           { reserved for driver }
    reserved: DWord;            { reserved for driver }
  end;
  TWaveHdr = wavehdr_tag;
  WAVEHDR = wavehdr_tag;


{ flags for dwFlags field of WAVEHDR }
const
  WHDR_DONE       = $00000001;  { done bit }
  WHDR_PREPARED   = $00000002;  { set if this header has been prepared }
  WHDR_BEGINLOOP  = $00000004;  { loop start block }
  WHDR_ENDLOOP    = $00000008;  { loop end block }
  WHDR_INQUEUE    = $00000010;  { reserved for driver }

{ waveform output device capabilities structure }
type
  PWaveOutCaps = ^tagWaveOutCapsA;
  tagWAVEOUTCAPSA = record
    wMid: Word;                 { manufacturer ID }
    wPid: Word;                 { product ID }
    vDriverVersion: MMVERSION;       { version of the driver }
    szPname: array[0..MAXPNAMELEN-1] of AnsiChar;  { product name (NULL terminated string) }
    dwFormats: DWord;          { formats supported }
    wChannels: Word;            { number of sources supported }
    dwSupport: DWord;          { functionality supported by driver }
  end;
  tagWAVEOUTCAPSW = record
    wMid: Word;                 { manufacturer ID }
    wPid: Word;                 { product ID }
    vDriverVersion: MMVERSION;       { version of the driver }
    szPname: array[0..MAXPNAMELEN-1] of WideChar;  { product name (NULL terminated string) }
    dwFormats: DWord;          { formats supported }
    wChannels: Word;            { number of sources supported }
    dwSupport: DWord;          { functionality supported by driver }
  end;
  tagWAVEOUTCAPS = tagWAVEOUTCAPSA;
  TWaveOutCaps = tagWaveOutCapsA;
  WAVEOUTCAPS = tagWAVEOUTCAPSA;


{ flags for dwSupport field of WAVEOUTCAPS }
const
  WAVECAPS_PITCH          = $0001;   { supports pitch control }
  WAVECAPS_PLAYBACKRATE   = $0002;   { supports playback rate control }
  WAVECAPS_VOLUME         = $0004;   { supports volume control }
  WAVECAPS_LRVOLUME       = $0008;   { separate left-right volume control }
  WAVECAPS_SYNC           = $0010;
  WAVECAPS_SAMPLEACCURATE = $0020;
  WAVECAPS_DIRECTSOUND    = $0040;

{ waveform input device capabilities structure }
type
  PWaveInCapsA = ^TWaveInCapsA;
  PWaveInCapsW = ^TWaveInCapsW;
  PWaveInCaps = PWaveInCapsA;
  tagWAVEINCAPSA = record
    wMid: Word;                   { manufacturer ID }
    wPid: Word;                   { product ID }
    vDriverVersion: MMVERSION;         { version of the driver }
    szPname: array[0..MAXPNAMELEN-1] of AnsiChar;    { product name (NULL terminated string) }
    dwFormats: DWord;             { formats supported }
    wChannels: Word;              { number of channels supported }
    wReserved1: Word;             { structure packing }
  end;
  tagWAVEINCAPSW = record
    wMid: Word;                   { manufacturer ID }
    wPid: Word;                   { product ID }
    vDriverVersion: MMVERSION;         { version of the driver }
    szPname: array[0..MAXPNAMELEN-1] of WideChar;    { product name (NULL terminated string) }
    dwFormats: DWord;             { formats supported }
    wChannels: Word;              { number of channels supported }
    wReserved1: Word;             { structure packing }
  end;
  tagWAVEINCAPS = tagWAVEINCAPSA;
  TWaveInCapsA = tagWAVEINCAPSA;
  TWaveInCapsW = tagWAVEINCAPSW;
  TWaveInCaps = TWaveInCapsA;
  WAVEINCAPSA = tagWAVEINCAPSA;
  WAVEINCAPSW = tagWAVEINCAPSW;
  WAVEINCAPS = WAVEINCAPSA;


{ defines for dwFormat field of WAVEINCAPS and WAVEOUTCAPS }
const
  WAVE_INVALIDFORMAT     = $00000000;       { invalid format }
  WAVE_FORMAT_1M08       = $00000001;       { 11.025 kHz, Mono,   8-bit  }
  WAVE_FORMAT_1S08       = $00000002;       { 11.025 kHz, Stereo, 8-bit  }
  WAVE_FORMAT_1M16       = $00000004;       { 11.025 kHz, Mono,   16-bit }
  WAVE_FORMAT_1S16       = $00000008;       { 11.025 kHz, Stereo, 16-bit }
  WAVE_FORMAT_2M08       = $00000010;       { 22.05  kHz, Mono,   8-bit  }
  WAVE_FORMAT_2S08       = $00000020;       { 22.05  kHz, Stereo, 8-bit  }
  WAVE_FORMAT_2M16       = $00000040;       { 22.05  kHz, Mono,   16-bit }
  WAVE_FORMAT_2S16       = $00000080;       { 22.05  kHz, Stereo, 16-bit }
  WAVE_FORMAT_4M08       = $00000100;       { 44.1   kHz, Mono,   8-bit  }
  WAVE_FORMAT_4S08       = $00000200;       { 44.1   kHz, Stereo, 8-bit  }
  WAVE_FORMAT_4M16       = $00000400;       { 44.1   kHz, Mono,   16-bit }
  WAVE_FORMAT_4S16       = $00000800;       { 44.1   kHz, Stereo, 16-bit }

{ general waveform format structure (information common to all formats) }
type
  PWaveFormat = ^TWaveFormat;
  waveformat_tag = packed record
    wFormatTag: Word;         { format type }
    nChannels: Word;          { number of channels (i.e. mono, stereo, etc.) }
    nSamplesPerSec: DWord;  { sample rate }
    nAvgBytesPerSec: DWord; { for buffer estimation }
    nBlockAlign: Word;      { block size of data }
  end;
  TWaveFormat = waveformat_tag;
  WAVEFORMAT = waveformat_tag;

{ flags for wFormatTag field of WAVEFORMAT }
const
  WAVE_FORMAT_PCM     = 1;

{ specific waveform format structure for PCM data }
type
  PPCMWaveFormat = ^TPCMWaveFormat;
  pcmwaveformat_tag = record
      wf: TWaveFormat;
      wBitsPerSample: Word;
   end;
  TPCMWaveFormat = pcmwaveformat_tag;
  PCMWAVEFORMAT = pcmwaveformat_tag;


{ extended waveform format structure used for all non-PCM formats. this
  structure is common to all non-PCM formats. }

  PWaveFormatEx = ^TWaveFormatEx;
  tWAVEFORMATEX = packed record
    wFormatTag: Word;         { format type }
    nChannels: Word;          { number of channels (i.e. mono, stereo, etc.) }
    nSamplesPerSec: DWord;  { sample rate }
    nAvgBytesPerSec: DWord; { for buffer estimation }
    nBlockAlign: Word;      { block size of data }
    wBitsPerSample: Word;   { number of bits per sample of mono data }
    cbSize: Word;           { the count in bytes of the size of }
  end;


// Waveform audio function prototypes
function waveOutGetNumDevs: UInt;
function waveOutGetDevCaps(uDeviceID: UInt; lpCaps: PWaveOutCaps; uSize: UInt): mmResult;
function waveOutGetVolume(hwo: hWaveOut; lpdwVolume: pDWord): mmResult;
function waveOutSetVolume(hwo: hWaveOut; dwVolume: DWord): mmResult;
function waveOutGetErrorText(mmrError: mmResult; lpText: PChar; uSize: UInt): mmResult;
function waveOutOpen(lphWaveOut: PHWaveOut; uDeviceID: UInt; lpFormat: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWord): mmResult;
function waveOutClose(hWaveOut: hWaveOut): mmResult;
function waveOutPrepareHeader(hWaveOut: hWaveOut; lpWaveOutHdr: PWaveHdr; uSize: UInt): mmResult;
function waveOutUnprepareHeader(hWaveOut: hWaveOut; lpWaveOutHdr: PWaveHdr; uSize: UInt): mmResult;
function waveOutWrite(hWaveOut: hWaveOut; lpWaveOutHdr: PWaveHdr; uSize: UInt): mmResult;
function waveOutPause(hWaveOut: hWaveOut): mmResult;
function waveOutRestart(hWaveOut: hWaveOut): mmResult;
function waveOutReset(hWaveOut: hWaveOut): mmResult;
function waveOutBreakLoop(hWaveOut: hWaveOut): mmResult;
function waveOutGetPosition(hWaveOut: hWaveOut; lpInfo: PMMTime; uSize: UInt): mmResult;
function waveOutGetPitch(hWaveOut: hWaveOut; lpdwPitch: pDWord): mmResult;
function waveOutSetPitch(hWaveOut: hWaveOut; dwPitch: DWord): mmResult;
function waveOutGetPlaybackRate(hWaveOut: hWaveOut; lpdwRate: pDWord): mmResult;
function waveOutSetPlaybackRate(hWaveOut: hWaveOut; dwRate: DWord): mmResult;
function waveOutGetID(hWaveOut: hWaveOut; lpuDeviceID: pUInt): mmResult;
function waveOutMessage(hWaveOut: hWaveOut; uMessage: UInt; dw1, dw2: DWord): Longint;
function waveInGetNumDevs: UInt;
function waveInGetDevCaps(hwo: hWaveOut; lpCaps: PWaveInCaps; uSize: UInt): mmResult;
function waveInGetErrorText(mmrError: mmResult; lpText: PChar; uSize: UInt): mmResult;
function waveInOpen(lphWaveIn: phWaveIn; uDeviceID: UInt; lpFormatEx: PWaveFormatEx; dwCallback, dwInstance, dwFlags: DWord): mmResult;
function waveInClose(hWaveIn: hWaveIn): mmResult;
function waveInPrepareHeader(hWaveIn: hWaveIn; lpWaveInHdr: PWaveHdr; uSize: UInt): mmResult;
function waveInUnprepareHeader(hWaveIn: hWaveIn; lpWaveInHdr: PWaveHdr; uSize: UInt): mmResult;
function waveInAddBuffer(hWaveIn: hWaveIn; lpWaveInHdr: PWaveHdr; uSize: UInt): mmResult;
function waveInStart(hWaveIn: hWaveIn): mmResult;
function waveInStop(hWaveIn: hWaveIn): mmResult;
function waveInReset(hWaveIn: hWaveIn): mmResult;
function waveInGetPosition(hWaveIn: hWaveIn; lpInfo: PMMTime; uSize: UInt): mmResult;
function waveInGetID(hWaveIn: hWaveIn; lpuDeviceID: pUInt): mmResult;
function waveInMessage(hWaveIn: hWaveIn; uMessage: UInt; dw1, dw2: DWord): mmResult;

// MIDI support

{ MIDI error return values }
const
  MIDIERR_UNPREPARED    = MIDIERR_BASE + 0;   { header not prepared }
  MIDIERR_STILLPLAYING  = MIDIERR_BASE + 1;   { still something playing }
  MIDIERR_NOMAP         = MIDIERR_BASE + 2;   { no current map }
  MIDIERR_NOTREADY      = MIDIERR_BASE + 3;   { hardware is still busy }
  MIDIERR_NODEVICE      = MIDIERR_BASE + 4;   { port no longer connected }
  MIDIERR_INVALIDSETUP  = MIDIERR_BASE + 5;   { invalid setup }
  MIDIERR_BADOPENMODE   = MIDIERR_BASE + 6;   { operation unsupported w/ open mode }
  MIDIERR_DONT_CONTINUE = MIDIERR_BASE + 7;   { thru device 'eating' a message }
  MIDIERR_LASTERROR     = MIDIERR_BASE + 5;   { last error in range }

{ MIDI audio data types }
type
  phMidi = ^hMidi;
  hMidi = Integer;
  phMidiIn = ^hMidiIn;
  hMidiIn = Integer;
  phMidiOut = ^hMidiOut;
  hMidiOut = Integer;
  phMidiStrm = ^hMidiStrm;
  hMidiStrm = Integer;

type
  TFNMidiCallBack = TFNDrvCallBack;

const
  MIDIPATCHSIZE   = 128;

type
  PPatchArray = ^TPatchArray;
  TPatchArray = array[0..MIDIPATCHSIZE-1] of Word;

  PKeyArray = ^TKeyArray;
  TKeyArray = array[0..MIDIPATCHSIZE-1] of Word;


{ MIDI callback messages }
const
  MIM_OPEN        = MM_MIM_OPEN;
  MIM_CLOSE       = MM_MIM_CLOSE;
  MIM_DATA        = MM_MIM_DATA;
  MIM_LONGDATA    = MM_MIM_LONGDATA;
  MIM_ERROR       = MM_MIM_ERROR;
  MIM_LONGERROR   = MM_MIM_LONGERROR;
  MOM_OPEN        = MM_MOM_OPEN;
  MOM_CLOSE       = MM_MOM_CLOSE;
  MOM_DONE        = MM_MOM_DONE;

  MIM_MOREDATA    = MM_MIM_MOREDATA;
  MOM_POSITIONCB  = MM_MOM_POSITIONCB;

{ device ID for MIDI mapper }
  MIDIMAPPER     = UInt(-1);
  MIDI_MAPPER    = UInt(-1);

{ flags for dwFlags parm of midiInOpen() }
  MIDI_IO_STATUS = $00000020;

{ flags for wFlags parm of midiOutCachePatches(), midiOutCacheDrumPatches() }
  MIDI_CACHE_ALL      = 1;
  MIDI_CACHE_BESTFIT  = 2;
  MIDI_CACHE_QUERY    = 3;
  MIDI_UNCACHE        = 4;

{ MIDI output device capabilities structure }
type
  PMidiOutCapsA = ^TMidiOutCapsA;
  PMidiOutCapsW = ^TMidiOutCapsW;
  PMidiOutCaps = PMidiOutCapsA;
  tagMIDIOUTCAPSA = record
    wMid: Word;                  { manufacturer ID }
    wPid: Word;                  { product ID }
    vDriverVersion: MMVERSION;        { version of the driver }
    szPname: array[0..MAXPNAMELEN-1] of AnsiChar;  { product name (NULL terminated string) }
    wTechnology: Word;           { type of device }
    wVoices: Word;               { # of voices (internal synth only) }
    wNotes: Word;                { max # of notes (internal synth only) }
    wChannelMask: Word;          { channels used (internal synth only) }
    dwSupport: DWord;            { functionality supported by driver }
  end;
  tagMIDIOUTCAPSW = record
    wMid: Word;                  { manufacturer ID }
    wPid: Word;                  { product ID }
    vDriverVersion: MMVERSION;        { version of the driver }
    szPname: array[0..MAXPNAMELEN-1] of WideChar;  { product name (NULL terminated string) }
    wTechnology: Word;           { type of device }
    wVoices: Word;               { # of voices (internal synth only) }
    wNotes: Word;                { max # of notes (internal synth only) }
    wChannelMask: Word;          { channels used (internal synth only) }
    dwSupport: DWord;            { functionality supported by driver }
  end;
  tagMIDIOUTCAPS = tagMIDIOUTCAPSA;
  TMidiOutCapsA = tagMIDIOUTCAPSA;
  TMidiOutCapsW = tagMIDIOUTCAPSW;
  TMidiOutCaps = TMidiOutCapsA;
  MIDIOUTCAPSA = tagMIDIOUTCAPSA;
  MIDIOUTCAPSW = tagMIDIOUTCAPSW;
  MIDIOUTCAPS = MIDIOUTCAPSA;


{ flags for wTechnology field of MIDIOUTCAPS structure }
const
  MOD_MIDIPORT    = 1;  { output port }
  MOD_SYNTH       = 2;  { generic internal synth }
  MOD_SQSYNTH     = 3;  { square wave internal synth }
  MOD_FMSYNTH     = 4;  { FM internal synth }
  MOD_MAPPER      = 5;  { MIDI mapper }

{ flags for dwSupport field of MIDIOUTCAPS structure }
const
  MIDICAPS_VOLUME          = $0001;  { supports volume control }
  MIDICAPS_LRVOLUME        = $0002;  { separate left-right volume control }
  MIDICAPS_CACHE           = $0004;
  MIDICAPS_STREAM          = $0008;  { driver supports midiStreamOut directly }

{ MIDI output device capabilities structure }

type
  PMidiInCapsA = ^TMidiInCapsA;
  PMidiInCapsW = ^TMidiInCapsW;
  PMidiInCaps = PMidiInCapsA;
  tagMIDIINCAPSA = record
    wMid: Word;                  { manufacturer ID }
    wPid: Word;                  { product ID }
    vDriverVersion: MMVERSION;   { version of the driver }
    szPname: array[0..MAXPNAMELEN-1] of AnsiChar;  { product name (NULL terminated string) }
    dwSupport: DWord;            { functionality supported by driver }
  end;
  tagMIDIINCAPSW = record
    wMid: Word;                  { manufacturer ID }
    wPid: Word;                  { product ID }
    vDriverVersion: MMVERSION;   { version of the driver }
    szPname: array[0..MAXPNAMELEN-1] of WideChar;  { product name (NULL terminated string) }
    dwSupport: DWord;            { functionality supported by driver }
  end;
  tagMIDIINCAPS = tagMIDIINCAPSA;
  TMidiInCapsA = tagMIDIINCAPSA;
  TMidiInCapsW = tagMIDIINCAPSW;
  TMidiInCaps = TMidiInCapsA;
  MIDIINCAPSA = tagMIDIINCAPSA;
  MIDIINCAPSW = tagMIDIINCAPSW;
  MIDIINCAPS = MIDIINCAPSA;

{ MIDI data block header }
type
  PMidiHdr = ^TMidiHdr;
  midihdr_tag = record
    lpData: PChar;               { pointer to locked data block }
    dwBufferLength: DWord;       { length of data in data block }
    dwBytesRecorded: DWord;      { used for input only }
    dwUser: DWord;               { for client's use }
    dwFlags: DWord;              { assorted flags (see defines) }
    lpNext: PMidiHdr;            { reserved for driver }
    reserved: DWord;             { reserved for driver }
    dwOffset: DWord;             { Callback offset into buffer }
    dwReserved: array[0..7] of DWord; { Reserved for MMSYSTEM }
  end;
  TMidiHdr = midihdr_tag;
  MIDIHDR = midihdr_tag;

  PMidiEvent = ^TMidiEvent;
  midievent_tag = record
    dwDeltaTime: DWord;          { Ticks since last event }
    dwStreamID: DWord;           { Reserved; must be zero }
    dwEvent: DWord;              { Event type and parameters }
    dwParms: array[0..0] of DWord;  { Parameters if this is a long event }
  end;
  TMidiEvent = midievent_tag;
  MIDIEVENT = midievent_tag;

  PMidiStrmBuffVer = ^TMidiStrmBuffVer;
  midistrmbuffver_tag = record
    dwVersion: DWord;                  { Stream buffer format version }
    dwMid: DWord;                      { Manufacturer ID as defined in MMREG.H }
    dwOEMVersion: DWord;               { Manufacturer version for custom ext }
  end;
  TMidiStrmBuffVer = midistrmbuffver_tag;
  MIDISTRMBUFFVER = midistrmbuffver_tag;

{ flags for dwFlags field of MIDIHDR structure }
const
  MHDR_DONE       = $00000001;       { done bit }
  MHDR_PREPARED   = $00000002;       { set if header prepared }
  MHDR_INQUEUE    = $00000004;       { reserved for driver }
  MHDR_ISSTRM     = $00000008;       { Buffer is stream buffer }

{ Type codes which go in the high byte of the event DWord of a stream buffer

  Type codes 00-7F contain parameters within the low 24 bits
  Type codes 80-FF contain a length of their parameter in the low 24
  bits, followed by their parameter data in the buffer. The event
  DWord contains the exact byte length; the parm data itself must be
  padded to be an even multiple of 4 bytes long. }

  MEVT_F_SHORT       = $00000000;
  MEVT_F_LONG        = $80000000;
  MEVT_F_CALLBACK    = $40000000;

  MEVT_SHORTMSG     = $00;    { parm = shortmsg for midiOutShortMsg }
  MEVT_TEMPO        = $01;    { parm = new tempo in microsec/qn     }
  MEVT_NOP          = $02;    { parm = unused; does nothing         }

{ 0x04-0x7F reserved }

  MEVT_LONGMSG      = $80;    { parm = bytes to send verbatim       }
  MEVT_COMMENT      = $82;    { parm = comment data                 }
  MEVT_VERSION      = $84;    { parm = MIDISTRMBUFFVER struct       }

{ 0x81-0xFF reserved }

  MIDISTRM_ERROR    =  -2;

{ Structures and defines for midiStreamProperty }
  MIDIPROP_SET       = $80000000;
  MIDIPROP_GET       = $40000000;

{ These are intentionally both non-zero so the app cannot accidentally
  leave the operation off and happen to appear to work due to default
  action. }
  MIDIPROP_TIMEDIV   = $00000001;
  MIDIPROP_TEMPO     = $00000002;

type
  PMidiPropTimeDiv = ^TMidiPropTimeDiv;
  midiproptimediv_tag = record
    cbStruct: DWord;
    dwTimeDiv: DWord;
  end;
  TMidiPropTimeDiv = midiproptimediv_tag;
  MIDIPROPTIMEDIV = midiproptimediv_tag;

  PMidiPropTempo = ^TMidiPropTempo;
  midiproptempo_tag = record
    cbStruct: DWord;
    dwTempo: DWord;
  end;
  TMidiPropTempo = midiproptempo_tag;
  MIDIPROPTEMPO = midiproptempo_tag;

{ MIDI function prototypes }

function midiOutGetNumDevs: UInt;
function midiStreamOpen(phms: phMidiStrm; puDeviceID: pUInt; cMidi, dwCallback, dwInstance, fdwOpen: DWord): mmResult;
function midiStreamClose(hms: hMidiStrm): mmResult;
function midiStreamProperty(hms: hMidiStrm; lppropdata: pByte; dwProperty: DWord): mmResult;
function midiStreamPosition(hms: hMidiStrm; lpmmt: PMMTime; cbmmt: UInt): mmResult;
function midiStreamOut(hms: hMidiStrm; pmh: PMidiHdr; cbmh: UInt): mmResult;
function midiStreamPause(hms: hMidiStrm): mmResult;
function midiStreamRestart(hms: hMidiStrm): mmResult;
function midiStreamStop(hms: hMidiStrm): mmResult;
function midiConnect(hmi: hMidi; hmo: hMidiOut; pReserved: Pointer): mmResult;
function midiDisconnect(hmi: hMidi; hmo: hMidiOut; pReserved: Pointer): mmResult;
function midiOutGetDevCaps(uDeviceID: UInt; lpCaps: PMidiOutCaps; uSize: UInt): mmResult;
function midiOutGetVolume(hmo: hMidiOut; lpdwVolume: pDWord): mmResult;
function midiOutSetVolume(hmo: hMidiOut; dwVolume: DWord): mmResult;
function midiOutGetErrorText(mmrError: mmResult; pszText: PChar; uSize: UInt): mmResult;
function midiOutOpen(lphMidiOut: phMidiOut; uDeviceID: UInt; dwCallback, dwInstance, dwFlags: DWord): mmResult;
function midiOutClose(hMidiOut: hMidiOut): mmResult;
function midiOutPrepareHeader(hMidiOut: hMidiOut; lpMidiOutHdr: PMidiHdr; uSize: UInt): mmResult;
function midiOutUnprepareHeader(hMidiOut: hMidiOut; lpMidiOutHdr: PMidiHdr; uSize: UInt): mmResult;
function midiOutShortMsg(hMidiOut: hMidiOut; dwMsg: DWord): mmResult;
function midiOutLongMsg(hMidiOut: hMidiOut; lpMidiOutHdr: PMidiHdr; uSize: UInt): mmResult;
function midiOutReset(hMidiOut: hMidiOut): mmResult;
function midiOutCachePatches(hMidiOut: hMidiOut; uBank: UInt; lpwPatchArray: PWord; uFlags: UInt): mmResult;
function midiOutCacheDrumPatches(hMidiOut: hMidiOut; uPatch: UInt; lpwKeyArray: PWord; uFlags: UInt): mmResult;
function midiOutGetID(hMidiOut: hMidiOut; lpuDeviceID: pUInt): mmResult;
function midiOutMessage(hMidiOut: hMidiOut; uMessage: UInt; dw1, dw2: DWord): mmResult;
function midiInGetNumDevs: UInt;
function midiInGetDevCaps(DeviceID: UInt; lpCaps: PMidiInCaps; uSize: UInt): mmResult;
function midiInGetErrorText(mmrError: mmResult; pszText: PChar; uSize: UInt): mmResult;
function midiInOpen(lphMidiIn: phMidiIn; uDeviceID: UInt; dwCallback, dwInstance, dwFlags: DWord): mmResult;
function midiInClose(hMidiIn: hMidiIn): mmResult;
function midiInPrepareHeader(hMidiIn: hMidiIn; lpMidiInHdr: PMidiHdr; uSize: UInt): mmResult;
function midiInUnprepareHeader(hMidiIn: hMidiIn; lpMidiInHdr: PMidiHdr; uSize: UInt): mmResult;
function midiInAddBuffer(hMidiIn: hMidiIn; lpMidiInHdr: PMidiHdr; uSize: UInt): mmResult;
function midiInStart(hMidiIn: hMidiIn): mmResult;
function midiInStop(hMidiIn: hMidiIn): mmResult;
function midiInReset(hMidiIn: hMidiIn): mmResult;
function midiInGetID(hMidiIn: hMidiIn; lpuDeviceID: pUInt): mmResult;
function midiInMessage(hMidiIn: hMidiIn; uMessage: UInt; dw1, dw2: DWord): mmResult;


// Auxiliary audio support

{ device ID for aux device mapper }
const
  AUX_MAPPER     = UInt(-1);

{ Auxiliary audio device capabilities structure }
type
  PAuxCapsA = ^TAuxCapsA;
  PAuxCapsW = ^TAuxCapsW;
  PAuxCaps = PAuxCapsA;
  tagAUXCAPSA = record
    wMid: Word;                  { manufacturer ID }
    wPid: Word;                  { product ID }
    vDriverVersion: MMVERSION;        { version of the driver }
    szPname: array[0..MAXPNAMELEN-1] of AnsiChar;  { product name (NULL terminated string) }
    wTechnology: Word;           { type of device }
    dwSupport: DWord;            { functionality supported by driver }
  end;
  tagAUXCAPSW = record
    wMid: Word;                  { manufacturer ID }
    wPid: Word;                  { product ID }
    vDriverVersion: MMVERSION;        { version of the driver }
    szPname: array[0..MAXPNAMELEN-1] of WideChar;  { product name (NULL terminated string) }
    wTechnology: Word;           { type of device }
    dwSupport: DWord;            { functionality supported by driver }
  end;
  tagAUXCAPS = tagAUXCAPSA;
  TAuxCapsA = tagAUXCAPSA;
  TAuxCapsW = tagAUXCAPSW;
  TAuxCaps = TAuxCapsA;
  AUXCAPSA = tagAUXCAPSA;
  AUXCAPSW = tagAUXCAPSW;
  AUXCAPS = AUXCAPSA;

{ flags for wTechnology field in AUXCAPS structure }
const
  AUXCAPS_CDAUDIO    = 1;       { audio from internal CD-ROM drive }
  AUXCAPS_AUXIN      = 2;       { audio from auxiliary input jacks }

{ flags for dwSupport field in AUXCAPS structure }
const
  AUXCAPS_VOLUME     = $0001;  { supports volume control }
  AUXCAPS_LRVOLUME   = $0002;  { separate left-right volume control }

{ auxiliary audio function prototypes }
function auxGetNumDevs: UInt;
function auxGetDevCaps(uDeviceID: UInt; lpCaps: PAuxCaps; uSize: UInt): mmResult;
function auxSetVolume(uDeviceID: UInt; dwVolume: DWord): mmResult;
function auxGetVolume(uDeviceID: UInt; lpdwVolume: pDWord): mmResult;
function auxOutMessage(uDeviceID, uMessage: UInt; dw1, dw2: DWord): mmResult;


// Mixer Support

type
  phMixerObj = ^hMixerObj;
  hMixerObj = Integer;

  phMixer = ^hMixer;
  hMixer = Integer;

const
  MIXER_SHORT_NAME_CHARS   = 16;
  MIXER_LONG_NAME_CHARS    = 64;

{ mmResult error return values specific to the mixer API }

  MIXERR_INVALLINE            = (MIXERR_BASE + 0);
  MIXERR_INVALCONTROL         = (MIXERR_BASE + 1);
  MIXERR_INVALVALUE           = (MIXERR_BASE + 2);
  MIXERR_LASTERROR            = (MIXERR_BASE + 2);

  MIXER_OBJECTF_HANDLE    = $80000000;
  MIXER_OBJECTF_MIXER     = $00000000;
  MIXER_OBJECTF_HMIXER    = (MIXER_OBJECTF_HANDLE or MIXER_OBJECTF_MIXER);
  MIXER_OBJECTF_WAVEOUT   = $10000000;
  MIXER_OBJECTF_HWAVEOUT  = (MIXER_OBJECTF_HANDLE or MIXER_OBJECTF_WAVEOUT);
  MIXER_OBJECTF_WAVEIN    = $20000000;
  MIXER_OBJECTF_HWAVEIN   = (MIXER_OBJECTF_HANDLE or MIXER_OBJECTF_WAVEIN);
  MIXER_OBJECTF_MIDIOUT   = $30000000;
  MIXER_OBJECTF_HMIDIOUT  = (MIXER_OBJECTF_HANDLE or MIXER_OBJECTF_MIDIOUT);
  MIXER_OBJECTF_MIDIIN    = $40000000;
  MIXER_OBJECTF_HMIDIIN   = (MIXER_OBJECTF_HANDLE or MIXER_OBJECTF_MIDIIN);
  MIXER_OBJECTF_AUX       = $50000000;

function mixerGetNumDevs: UInt;

type
  PMixerCapsA = ^TMixerCapsA;
  PMixerCapsW = ^TMixerCapsW;
  PMixerCaps = PMixerCapsA;
  tagMIXERCAPSA = record
    wMid: WORD;                    { manufacturer id }
    wPid: WORD;                    { product id }
    vDriverVersion: MMVERSION;     { version of the driver }
    szPname: array [0..MAXPNAMELEN - 1] of AnsiChar;   { product name }
    fdwSupport: DWord;             { misc. support bits }
    cDestinations: DWord;          { count of destinations }
  end;
  tagMIXERCAPSW = record
    wMid: WORD;                    { manufacturer id }
    wPid: WORD;                    { product id }
    vDriverVersion: MMVERSION;     { version of the driver }
    szPname: array [0..MAXPNAMELEN - 1] of WideChar;   { product name }
    fdwSupport: DWord;             { misc. support bits }
    cDestinations: DWord;          { count of destinations }
  end;
  tagMIXERCAPS = tagMIXERCAPSA;
  TMixerCapsA = tagMIXERCAPSA;
  TMixerCapsW = tagMIXERCAPSW;
  TMixerCaps = TMixerCapsA;
  MIXERCAPSA = tagMIXERCAPSA;
  MIXERCAPSW = tagMIXERCAPSW;
  MIXERCAPS = MIXERCAPSA;

function mixerGetDevCaps(uMxId: UInt; pmxcaps: PMixerCaps; cbmxcaps: UInt): mmResult;
function mixerOpen(phmx: phMixer; uMxId: UInt; dwCallback, dwInstance, fdwOpen: DWord): mmResult;
function mixerClose(hmx: hMixer): mmResult;
function mixerMessage(hmx: hMixer; uMsg: UInt; dwParam1, dwParam2: DWord): DWord;

type
  PMixerLineA = ^TMixerLineA;
  PMixerLineW = ^TMixerLineW;
  PMixerLine = PMixerLineA;
  tagMIXERLINEA = record
    cbStruct: DWord;               { size of MIXERLINE structure }
    dwDestination: DWord;          { zero based destination index }
    dwSource: DWord;               { zero based source index (if source) }
    dwLineID: DWord;               { unique line id for mixer device }
    fdwLine: DWord;                { state/information about line }
    dwUser: DWord;                 { driver specific information }
    dwComponentType: DWord;        { component type line connects to }
    cChannels: DWord;              { number of channels line supports }
    cConnections: DWord;           { number of connections [possible] }
    cControls: DWord;              { number of controls at this line }
    szShortName: array[0..MIXER_SHORT_NAME_CHARS - 1] of AnsiChar;
    szName: array[0..MIXER_LONG_NAME_CHARS - 1] of AnsiChar;
    Target: record
      dwType: DWord;                 { MIXERLINE_TARGETTYPE_xxxx }
      dwDeviceID: DWord;             { target device ID of device type }
      wMid: WORD;                                   { of target device }
      wPid: WORD;                                   {      " }
      vDriverVersion: MMVERSION;                    {      " }
      szPname: array[0..MAXPNAMELEN - 1] of AnsiChar;  {      " }
         end;
  end;
  tagMIXERLINEW = record
    cbStruct: DWord;               { size of MIXERLINE structure }
    dwDestination: DWord;          { zero based destination index }
    dwSource: DWord;               { zero based source index (if source) }
    dwLineID: DWord;               { unique line id for mixer device }
    fdwLine: DWord;                { state/information about line }
    dwUser: DWord;                 { driver specific information }
    dwComponentType: DWord;        { component type line connects to }
    cChannels: DWord;              { number of channels line supports }
    cConnections: DWord;           { number of connections [possible] }
    cControls: DWord;              { number of controls at this line }
    szShortName: array[0..MIXER_SHORT_NAME_CHARS - 1] of WideChar;
    szName: array[0..MIXER_LONG_NAME_CHARS - 1] of WideChar;
    Target: record
      dwType: DWord;                 { MIXERLINE_TARGETTYPE_xxxx }
      dwDeviceID: DWord;             { target device ID of device type }
      wMid: WORD;                                   { of target device }
      wPid: WORD;                                   {      " }
      vDriverVersion: MMVERSION;                    {      " }
      szPname: array[0..MAXPNAMELEN - 1] of WideChar;  {      " }
         end;
  end;
  tagMIXERLINE = tagMIXERLINEA;
  TMixerLineA = tagMIXERLINEA;
  TMixerLineW = tagMIXERLINEW;
  TMixerLine = TMixerLineA;
  MIXERLINEA = tagMIXERLINEA;
  MIXERLINEW = tagMIXERLINEW;
  MIXERLINE = MIXERLINEA;

const
{ TMixerLine.fdwLine }

  MIXERLINE_LINEF_ACTIVE              = $00000001;
  MIXERLINE_LINEF_DISCONNECTED        = $00008000;
  MIXERLINE_LINEF_SOURCE              = $80000000;

{ TMixerLine.dwComponentType
  component types for destinations and sources }

  MIXERLINE_COMPONENTTYPE_DST_FIRST       = $00000000;
  MIXERLINE_COMPONENTTYPE_DST_UNDEFINED   = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 0);
  MIXERLINE_COMPONENTTYPE_DST_DIGITAL     = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 1);
  MIXERLINE_COMPONENTTYPE_DST_LINE        = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 2);
  MIXERLINE_COMPONENTTYPE_DST_MONITOR     = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 3);
  MIXERLINE_COMPONENTTYPE_DST_SPEAKERS    = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 4);
  MIXERLINE_COMPONENTTYPE_DST_HEADPHONES  = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 5);
  MIXERLINE_COMPONENTTYPE_DST_TELEPHONE   = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 6);
  MIXERLINE_COMPONENTTYPE_DST_WAVEIN      = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 7);
  MIXERLINE_COMPONENTTYPE_DST_VOICEIN     = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 8);
  MIXERLINE_COMPONENTTYPE_DST_LAST        = (MIXERLINE_COMPONENTTYPE_DST_FIRST + 8);

  MIXERLINE_COMPONENTTYPE_SRC_FIRST       = $00001000;
  MIXERLINE_COMPONENTTYPE_SRC_UNDEFINED   = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 0);
  MIXERLINE_COMPONENTTYPE_SRC_DIGITAL     = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 1);
  MIXERLINE_COMPONENTTYPE_SRC_LINE        = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 2);
  MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE  = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 3);
  MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 4);
  MIXERLINE_COMPONENTTYPE_SRC_COMPACTDISC = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 5);
  MIXERLINE_COMPONENTTYPE_SRC_TELEPHONE   = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 6);
  MIXERLINE_COMPONENTTYPE_SRC_PCSPEAKER   = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 7);
  MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT     = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 8);
  MIXERLINE_COMPONENTTYPE_SRC_AUXILIARY   = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 9);
  MIXERLINE_COMPONENTTYPE_SRC_ANALOG      = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 10);
  MIXERLINE_COMPONENTTYPE_SRC_LAST        = (MIXERLINE_COMPONENTTYPE_SRC_FIRST + 10);

{ TMixerLine.Target.dwType }

  MIXERLINE_TARGETTYPE_UNDEFINED      = 0;
  MIXERLINE_TARGETTYPE_WAVEOUT        = 1;
  MIXERLINE_TARGETTYPE_WAVEIN         = 2;
  MIXERLINE_TARGETTYPE_MIDIOUT        = 3;
  MIXERLINE_TARGETTYPE_MIDIIN         = 4;
  MIXERLINE_TARGETTYPE_AUX            = 5;

function mixerGetLineInfo(hmxobj: hMixerObj; pmxl: PMixerLine;
  fdwInfo: DWord): mmResult;

const
  MIXER_GETLINEINFOF_DESTINATION      = $00000000;
  MIXER_GETLINEINFOF_SOURCE           = $00000001;
  MIXER_GETLINEINFOF_LINEID           = $00000002;
  MIXER_GETLINEINFOF_COMPONENTTYPE    = $00000003;
  MIXER_GETLINEINFOF_TARGETTYPE       = $00000004;

  MIXER_GETLINEINFOF_QUERYMASK        = $0000000F;

function mixerGetID(hmxobj: hMixerObj; var puMxId: UInt; fdwId: DWord): mmResult;

type
  PMixerControlA = ^TMixerControlA;
  PMixerControlW = ^TMixerControlW;
  PMixerControl = PMixerControlA;
  tagMIXERCONTROLA = packed record
    cbStruct: DWord;           { size in bytes of MIXERCONTROL }
    dwControlID: DWord;        { unique control id for mixer device }
    dwControlType: DWord;      { MIXERCONTROL_CONTROLTYPE_xxx }
    fdwControl: DWord;         { MIXERCONTROL_CONTROLF_xxx }
    cMultipleItems: DWord;     { if MIXERCONTROL_CONTROLF_MULTIPLE set }
    szShortName: array[0..MIXER_SHORT_NAME_CHARS - 1] of AnsiChar;
    szName: array[0..MIXER_LONG_NAME_CHARS - 1] of AnsiChar;
    Bounds: record
      case Integer of
        0: (lMinimum, lMaximum: Longint);
        1: (dwMinimum, dwMaximum: DWord);
        2: (dwReserved: array[0..5] of DWord);
    end;
    Metrics: record
      case Integer of
        0: (cSteps: DWord);        { # of steps between min & max }
        1: (cbCustomData: DWord);  { size in bytes of custom data }
        2: (dwReserved: array[0..5] of DWord);
    end;
  end;
  tagMIXERCONTROLW = packed record
    cbStruct: DWord;           { size in bytes of MIXERCONTROL }
    dwControlID: DWord;        { unique control id for mixer device }
    dwControlType: DWord;      { MIXERCONTROL_CONTROLTYPE_xxx }
    fdwControl: DWord;         { MIXERCONTROL_CONTROLF_xxx }
    cMultipleItems: DWord;     { if MIXERCONTROL_CONTROLF_MULTIPLE set }
    szShortName: array[0..MIXER_SHORT_NAME_CHARS - 1] of WideChar;
    szName: array[0..MIXER_LONG_NAME_CHARS - 1] of WideChar;
    Bounds: record
      case Integer of
        0: (lMinimum, lMaximum: Longint);
        1: (dwMinimum, dwMaximum: DWord);
        2: (dwReserved: array[0..5] of DWord);
    end;
    Metrics: record
      case Integer of
        0: (cSteps: DWord);        { # of steps between min & max }
        1: (cbCustomData: DWord);  { size in bytes of custom data }
        2: (dwReserved: array[0..5] of DWord);
    end;
  end;
  tagMIXERCONTROL = tagMIXERCONTROLA;
  TMixerControlA = tagMIXERCONTROLA;
  TMixerControlW = tagMIXERCONTROLW;
  TMixerControl = TMixerControlA;
  MIXERCONTROLA = tagMIXERCONTROLA;
  MIXERCONTROLW = tagMIXERCONTROLW;
  MIXERCONTROL = MIXERCONTROLA;

const
{ TMixerControl.fdwControl }

  MIXERCONTROL_CONTROLF_UNIFORM   = $00000001;
  MIXERCONTROL_CONTROLF_MULTIPLE  = $00000002;
  MIXERCONTROL_CONTROLF_DISABLED  = $80000000;

{ MIXERCONTROL_CONTROLTYPE_xxx building block defines }

  MIXERCONTROL_CT_CLASS_MASK          = $F0000000;
  MIXERCONTROL_CT_CLASS_CUSTOM        = $00000000;
  MIXERCONTROL_CT_CLASS_METER         = $10000000;
  MIXERCONTROL_CT_CLASS_SWITCH        = $20000000;
  MIXERCONTROL_CT_CLASS_NUMBER        = $30000000;
  MIXERCONTROL_CT_CLASS_SLIDER        = $40000000;
  MIXERCONTROL_CT_CLASS_FADER         = $50000000;
  MIXERCONTROL_CT_CLASS_TIME          = $60000000;
  MIXERCONTROL_CT_CLASS_LIST          = $70000000;

  MIXERCONTROL_CT_SUBCLASS_MASK       = $0F000000;

  MIXERCONTROL_CT_SC_SWITCH_BOOLEAN   = $00000000;
  MIXERCONTROL_CT_SC_SWITCH_BUTTON    = $01000000;

  MIXERCONTROL_CT_SC_METER_POLLED     = $00000000;

  MIXERCONTROL_CT_SC_TIME_MICROSECS   = $00000000;
  MIXERCONTROL_CT_SC_TIME_MILLISECS   = $01000000;

  MIXERCONTROL_CT_SC_LIST_SINGLE      = $00000000;
  MIXERCONTROL_CT_SC_LIST_MULTIPLE    = $01000000;

  MIXERCONTROL_CT_UNITS_MASK          = $00FF0000;
  MIXERCONTROL_CT_UNITS_CUSTOM        = $00000000;
  MIXERCONTROL_CT_UNITS_BOOLEAN       = $00010000;
  MIXERCONTROL_CT_UNITS_SIGNED        = $00020000;
  MIXERCONTROL_CT_UNITS_UNSIGNED      = $00030000;
  MIXERCONTROL_CT_UNITS_DECIBELS      = $00040000; { in 10ths }
  MIXERCONTROL_CT_UNITS_PERCENT       = $00050000; { in 10ths }

{ Commonly used control types for specifying TMixerControl.dwControlType }

  MIXERCONTROL_CONTROLTYPE_CUSTOM         = (MIXERCONTROL_CT_CLASS_CUSTOM or MIXERCONTROL_CT_UNITS_CUSTOM);
  MIXERCONTROL_CONTROLTYPE_BOOLEANMETER   = (MIXERCONTROL_CT_CLASS_METER or MIXERCONTROL_CT_SC_METER_POLLED or MIXERCONTROL_CT_UNITS_BOOLEAN);
  MIXERCONTROL_CONTROLTYPE_SIGNEDMETER    = (MIXERCONTROL_CT_CLASS_METER or MIXERCONTROL_CT_SC_METER_POLLED or MIXERCONTROL_CT_UNITS_SIGNED);
  MIXERCONTROL_CONTROLTYPE_PEAKMETER      = (MIXERCONTROL_CONTROLTYPE_SIGNEDMETER + 1);
  MIXERCONTROL_CONTROLTYPE_UNSIGNEDMETER  = (MIXERCONTROL_CT_CLASS_METER or MIXERCONTROL_CT_SC_METER_POLLED or MIXERCONTROL_CT_UNITS_UNSIGNED);
  MIXERCONTROL_CONTROLTYPE_BOOLEAN        = (MIXERCONTROL_CT_CLASS_SWITCH or MIXERCONTROL_CT_SC_SWITCH_BOOLEAN or
    MIXERCONTROL_CT_UNITS_BOOLEAN);
  MIXERCONTROL_CONTROLTYPE_ONOFF          = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 1);
  MIXERCONTROL_CONTROLTYPE_MUTE           = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 2);
  MIXERCONTROL_CONTROLTYPE_MONO           = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 3);
  MIXERCONTROL_CONTROLTYPE_LOUDNESS       = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 4);
  MIXERCONTROL_CONTROLTYPE_STEREOENH      = (MIXERCONTROL_CONTROLTYPE_BOOLEAN + 5);
  MIXERCONTROL_CONTROLTYPE_BUTTON         = (MIXERCONTROL_CT_CLASS_SWITCH or MIXERCONTROL_CT_SC_SWITCH_BUTTON or
    MIXERCONTROL_CT_UNITS_BOOLEAN);
  MIXERCONTROL_CONTROLTYPE_DECIBELS       = (MIXERCONTROL_CT_CLASS_NUMBER or MIXERCONTROL_CT_UNITS_DECIBELS);
  MIXERCONTROL_CONTROLTYPE_SIGNED         = (MIXERCONTROL_CT_CLASS_NUMBER or MIXERCONTROL_CT_UNITS_SIGNED);
  MIXERCONTROL_CONTROLTYPE_UNSIGNED       = (MIXERCONTROL_CT_CLASS_NUMBER or MIXERCONTROL_CT_UNITS_UNSIGNED);
  MIXERCONTROL_CONTROLTYPE_PERCENT        = (MIXERCONTROL_CT_CLASS_NUMBER or MIXERCONTROL_CT_UNITS_PERCENT);
  MIXERCONTROL_CONTROLTYPE_SLIDER         = (MIXERCONTROL_CT_CLASS_SLIDER or MIXERCONTROL_CT_UNITS_SIGNED);
  MIXERCONTROL_CONTROLTYPE_PAN            = (MIXERCONTROL_CONTROLTYPE_SLIDER + 1);
  MIXERCONTROL_CONTROLTYPE_QSOUNDPAN      = (MIXERCONTROL_CONTROLTYPE_SLIDER + 2);
  MIXERCONTROL_CONTROLTYPE_FADER          = (MIXERCONTROL_CT_CLASS_FADER or MIXERCONTROL_CT_UNITS_UNSIGNED);
  MIXERCONTROL_CONTROLTYPE_VOLUME         = (MIXERCONTROL_CONTROLTYPE_FADER + 1);
  MIXERCONTROL_CONTROLTYPE_BASS           = (MIXERCONTROL_CONTROLTYPE_FADER + 2);
  MIXERCONTROL_CONTROLTYPE_TREBLE         = (MIXERCONTROL_CONTROLTYPE_FADER + 3);
  MIXERCONTROL_CONTROLTYPE_EQUALIZER      = (MIXERCONTROL_CONTROLTYPE_FADER + 4);
  MIXERCONTROL_CONTROLTYPE_SINGLESELECT   = (MIXERCONTROL_CT_CLASS_LIST or MIXERCONTROL_CT_SC_LIST_SINGLE or MIXERCONTROL_CT_UNITS_BOOLEAN);
  MIXERCONTROL_CONTROLTYPE_MUX            = (MIXERCONTROL_CONTROLTYPE_SINGLESELECT + 1);
  MIXERCONTROL_CONTROLTYPE_MULTIPLESELECT = (MIXERCONTROL_CT_CLASS_LIST or MIXERCONTROL_CT_SC_LIST_MULTIPLE or MIXERCONTROL_CT_UNITS_BOOLEAN);
  MIXERCONTROL_CONTROLTYPE_MIXER          = (MIXERCONTROL_CONTROLTYPE_MULTIPLESELECT + 1);
  MIXERCONTROL_CONTROLTYPE_MICROTIME      = (MIXERCONTROL_CT_CLASS_TIME or MIXERCONTROL_CT_SC_TIME_MICROSECS or
    MIXERCONTROL_CT_UNITS_UNSIGNED);
  MIXERCONTROL_CONTROLTYPE_MILLITIME      = (MIXERCONTROL_CT_CLASS_TIME or MIXERCONTROL_CT_SC_TIME_MILLISECS or
    MIXERCONTROL_CT_UNITS_UNSIGNED);


type
  PMixerLineControlsA = ^TMixerLineControlsA;
  PMixerLineControlsW = ^TMixerLineControlsW;
  PMixerLineControls = PMixerLineControlsA;
  tagMIXERLINECONTROLSA = record
    cbStruct: DWord;               { size in bytes of MIXERLINECONTROLS }
    dwLineID: DWord;               { line id (from MIXERLINE.dwLineID) }
    case Integer of
      0: (dwControlID: DWord);     { MIXER_GETLINECONTROLSF_ONEBYID }
      1: (dwControlType: DWord;    { MIXER_GETLINECONTROLSF_ONEBYTYPE }
          cControls: DWord;        { count of controls pmxctrl points to }
          cbmxctrl: DWord;         { size in bytes of _one_ MIXERCONTROL }
          pamxctrl: PMixerControlA);   { pointer to first MIXERCONTROL array }
  end;
  tagMIXERLINECONTROLSW = record
    cbStruct: DWord;               { size in bytes of MIXERLINECONTROLS }
    dwLineID: DWord;               { line id (from MIXERLINE.dwLineID) }
    case Integer of
      0: (dwControlID: DWord);     { MIXER_GETLINECONTROLSF_ONEBYID }
      1: (dwControlType: DWord;    { MIXER_GETLINECONTROLSF_ONEBYTYPE }
          cControls: DWord;        { count of controls pmxctrl points to }
          cbmxctrl: DWord;         { size in bytes of _one_ MIXERCONTROL }
          pamxctrl: PMixerControlW);   { pointer to first MIXERCONTROL array }
  end;
  tagMIXERLINECONTROLS = tagMIXERLINECONTROLSA;
  TMixerLineControlsA = tagMIXERLINECONTROLSA;
  TMixerLineControlsW = tagMIXERLINECONTROLSW;
  TMixerLineControls = TMixerLineControlsA;
  MIXERLINECONTROLSA = tagMIXERLINECONTROLSA;
  MIXERLINECONTROLSW = tagMIXERLINECONTROLSW;
  MIXERLINECONTROLS = MIXERLINECONTROLSA;

function mixerGetLineControls(hmxobj: hMixerObj; pmxlc: PMixerLineControls; fdwControls: DWord): mmResult;

const
  MIXER_GETLINECONTROLSF_ALL          = $00000000;
  MIXER_GETLINECONTROLSF_ONEBYID      = $00000001;
  MIXER_GETLINECONTROLSF_ONEBYTYPE    = $00000002;

  MIXER_GETLINECONTROLSF_QUERYMASK    = $0000000F;

type
  PMixerControlDetails = ^TMixerControlDetails;
  tMIXERCONTROLDETAILS = record
    cbStruct: DWord;       { size in bytes of MIXERCONTROLDETAILS }
    dwControlID: DWord;    { control id to get/set details on }
    cChannels: DWord;      { number of channels in paDetails array }
    case Integer of
           0: (hwndOwner: HWND);        { for MIXER_SETCONTROLDETAILSF_CUSTOM }
           1: (cMultipleItems: DWord;   { if _MULTIPLE, the number of items per channel }
               cbDetails: DWord;        { size of _one_ details_XX struct }
               paDetails: Pointer);     { pointer to array of details_XX structs }
  end;

  PMixerControlDetailsListTextA = ^TMixerControlDetailsListTextA;
  PMixerControlDetailsListTextW = ^TMixerControlDetailsListTextW;
  PMixerControlDetailsListText = PMixerControlDetailsListTextA;
  tagMIXERCONTROLDETAILS_LISTTEXTA = record
    dwParam1: DWord;
    dwParam2: DWord;
    szName: array[0..MIXER_LONG_NAME_CHARS - 1] of AnsiChar;
  end;
  tagMIXERCONTROLDETAILS_LISTTEXTW = record
    dwParam1: DWord;
    dwParam2: DWord;
    szName: array[0..MIXER_LONG_NAME_CHARS - 1] of WideChar;
  end;
  tagMIXERCONTROLDETAILS_LISTTEXT = tagMIXERCONTROLDETAILS_LISTTEXTA;
  TMixerControlDetailsListTextA = tagMIXERCONTROLDETAILS_LISTTEXTA;
  TMixerControlDetailsListTextW = tagMIXERCONTROLDETAILS_LISTTEXTW;
  TMixerControlDetailsListText = TMixerControlDetailsListTextA;
  MIXERCONTROLDETAILS_LISTTEXTA = tagMIXERCONTROLDETAILS_LISTTEXTA;
  MIXERCONTROLDETAILS_LISTTEXTW = tagMIXERCONTROLDETAILS_LISTTEXTW;
  MIXERCONTROLDETAILS_LISTTEXT = MIXERCONTROLDETAILS_LISTTEXTA;

  PMixerControlDetailsBoolean = ^TMixerControlDetailsBoolean;
  tMIXERCONTROLDETAILS_BOOLEAN = record
    fValue: Longint;
  end;
  TMixerControlDetailsBoolean = tMIXERCONTROLDETAILS_BOOLEAN;
  MIXERCONTROLDETAILS_BOOLEAN = tMIXERCONTROLDETAILS_BOOLEAN;

  PMixerControlDetailsSigned = ^TMixerControlDetailsSigned;
  tMIXERCONTROLDETAILS_SIGNED = record
    lValue: Longint;
  end;
  TMixerControlDetailsSigned = tMIXERCONTROLDETAILS_SIGNED;
  MIXERCONTROLDETAILS_SIGNED = tMIXERCONTROLDETAILS_SIGNED;

  PMixerControlDetailsUnsigned = ^TMixerControlDetailsUnsigned;
  tMIXERCONTROLDETAILS_UNSIGNED = record
    dwValue: DWord;
  end;
  TMixerControlDetailsUnsigned = tMIXERCONTROLDETAILS_UNSIGNED;
  MIXERCONTROLDETAILS_UNSIGNED = tMIXERCONTROLDETAILS_UNSIGNED;

function mixerGetControlDetails(hmxobj: hMixerObj; pmxcd: PMixerControlDetails; fdwDetails: DWord): mmResult;

const
  MIXER_GETCONTROLDETAILSF_VALUE      = $00000000;
  MIXER_GETCONTROLDETAILSF_LISTTEXT   = $00000001;

  MIXER_GETCONTROLDETAILSF_QUERYMASK  = $0000000F;

function mixerSetControlDetails(hmxobj: hMixerObj; pmxcd: PMixerControlDetails; fdwDetails: DWord): mmResult;

const
  MIXER_SETCONTROLDETAILSF_VALUE      = $00000000;
  MIXER_SETCONTROLDETAILSF_CUSTOM     = $00000001;
  MIXER_SETCONTROLDETAILSF_QUERYMASK  = $0000000F;

// Timer Support

{ timer error return values }
const
  TIMERR_NOERROR        = 0;                  { no error }
  TIMERR_NOCANDO        = TIMERR_BASE+1;      { request not completed }
  TIMERR_STRUCT         = TIMERR_BASE+33;     { time struct size }

{ timer data types }
type
  TFNTimeCallBack = procedure(uTimerID, uMessage: UInt; dwUser, dw1, dw2: DWord);

{ flags for wFlags parameter of timeSetEvent() function }
const
  TIME_ONESHOT    = 0;   { program timer for single event }
  TIME_PERIODIC   = 1;   { program for continuous periodic event }
  TIME_CALLBACK_FUNCTION    = $0000;  { callback is function }
  TIME_CALLBACK_EVENT_SET   = $0010;  { callback is event - use SetEvent }
  TIME_CALLBACK_EVENT_PULSE = $0020;  { callback is event - use PulseEvent }

{ timer device capabilities data structure }
type
  PTimeCaps = ^TTimeCaps;
  timecaps_tag = record
    wPeriodMin: UInt;     { minimum period supported  }
    wPeriodMax: UInt;     { maximum period supported  }
  end;
  TTimeCaps = timecaps_tag;
  TIMECAPS = timecaps_tag;

{ timer function prototypes }
function timeGetSystemTime(lpTime: PMMTime; uSize: Word): mmResult;
function timeGetTime: DWord;
function timeSetEvent(uDelay, uResolution: UInt; lpFunction: TFNTimeCallBack; dwUser: DWord; uFlags: UInt): mmResult;
function timeKillEvent(uTimerID: UInt): mmResult;
function timeGetDevCaps(lpTimeCaps: PTimeCaps; uSize: UInt): mmResult;
function timeBeginPeriod(uPeriod: UInt): mmResult;
function timeEndPeriod(uPeriod: UInt): mmResult;


// Joystick Support

{ joystick error return values }
const
  JOYERR_NOERROR        = 0;                  { no error }
  JOYERR_PARMS          = JOYERR_BASE+5;      { bad parameters }
  JOYERR_NOCANDO        = JOYERR_BASE+6;      { request not completed }
  JOYERR_UNPLUGGED      = JOYERR_BASE+7;      { joystick is unplugged }

{ constants used with TJoyInfo and TJoyInfoEx structure and MM_JOY* messages }
const
  JOY_BUTTON1         = $0001;
  JOY_BUTTON2         = $0002;
  JOY_BUTTON3         = $0004;
  JOY_BUTTON4         = $0008;
  JOY_BUTTON1CHG      = $0100;
  JOY_BUTTON2CHG      = $0200;
  JOY_BUTTON3CHG      = $0400;
  JOY_BUTTON4CHG      = $0800;

{ constants used with TJoyInfoEx }
  JOY_BUTTON5         = $00000010;
  JOY_BUTTON6         = $00000020;
  JOY_BUTTON7         = $00000040;
  JOY_BUTTON8         = $00000080;
  JOY_BUTTON9         = $00000100;
  JOY_BUTTON10        = $00000200;
  JOY_BUTTON11        = $00000400;
  JOY_BUTTON12        = $00000800;
  JOY_BUTTON13        = $00001000;
  JOY_BUTTON14        = $00002000;
  JOY_BUTTON15        = $00004000;
  JOY_BUTTON16        = $00008000;
  JOY_BUTTON17        = $00010000;
  JOY_BUTTON18        = $00020000;
  JOY_BUTTON19        = $00040000;
  JOY_BUTTON20        = $00080000;
  JOY_BUTTON21        = $00100000;
  JOY_BUTTON22        = $00200000;
  JOY_BUTTON23        = $00400000;
  JOY_BUTTON24        = $00800000;
  JOY_BUTTON25        = $01000000;
  JOY_BUTTON26        = $02000000;
  JOY_BUTTON27        = $04000000;
  JOY_BUTTON28        = $08000000;
  JOY_BUTTON29        = $10000000;
  JOY_BUTTON30        = $20000000;
  JOY_BUTTON31        = $40000000;
  JOY_BUTTON32        = $80000000;

{ constants used with TJoyInfoEx }
  JOY_POVCENTERED       = -1;
  JOY_POVFORWARD        = 0;
  JOY_POVRIGHT          = 9000;
  JOY_POVBACKWARD       = 18000;
  JOY_POVLEFT           = 27000;

  JOY_RETURNX           = $00000001;
  JOY_RETURNY           = $00000002;
  JOY_RETURNZ           = $00000004;
  JOY_RETURNR           = $00000008;
  JOY_RETURNU           = $00000010; { axis 5 }
  JOY_RETURNV           = $00000020; { axis 6 }
  JOY_RETURNPOV         = $00000040;
  JOY_RETURNBUTTONS     = $00000080;
  JOY_RETURNRAWDATA     = $00000100;
  JOY_RETURNPOVCTS      = $00000200;
  JOY_RETURNCENTERED    = $00000400;
  JOY_USEDEADZONE               = $00000800;
  JOY_RETURNALL  = (JOY_RETURNX or JOY_RETURNY or JOY_RETURNZ or
    JOY_RETURNR or JOY_RETURNU or JOY_RETURNV or
    JOY_RETURNPOV or JOY_RETURNBUTTONS);
  JOY_CAL_READALWAYS    = $00010000;
  JOY_CAL_READXYONLY    = $00020000;
  JOY_CAL_READ3         = $00040000;
  JOY_CAL_READ4         = $00080000;
  JOY_CAL_READXONLY     = $00100000;
  JOY_CAL_READYONLY     = $00200000;
  JOY_CAL_READ5         = $00400000;
  JOY_CAL_READ6         = $00800000;
  JOY_CAL_READZONLY     = $01000000;
  JOY_CAL_READRONLY     = $02000000;
  JOY_CAL_READUONLY     = $04000000;
  JOY_CAL_READVONLY     = $08000000;

{ joystick ID constants }
const
  JOYSTICKID1         = 0;
  JOYSTICKID2         = 1;

{ joystick driver capabilites }
  JOYCAPS_HASZ          = $0001;
  JOYCAPS_HASR          = $0002;
  JOYCAPS_HASU          = $0004;
  JOYCAPS_HASV          = $0008;
  JOYCAPS_HASPOV                = $0010;
  JOYCAPS_POV4DIR               = $0020;
  JOYCAPS_POVCTS                = $0040;

{ joystick device capabilities data structure }
type
  PJoyCapsA = ^TJoyCapsA;
  PJoyCapsW = ^TJoyCapsW;
  PJoyCaps = PJoyCapsA;
  tagJOYCAPSA = record
    wMid: Word;                  { manufacturer ID }
    wPid: Word;                  { product ID }
    szPname: array[0..MAXPNAMELEN-1] of AnsiChar;  { product name (NULL terminated string) }
    wXmin: UInt;                 { minimum x position value }
    wXmax: UInt;                 { maximum x position value }
    wYmin: UInt;                 { minimum y position value }
    wYmax: UInt;                 { maximum y position value }
    wZmin: UInt;                 { minimum z position value }
    wZmax: UInt;                 { maximum z position value }
    wNumButtons: UInt;           { number of buttons }
    wPeriodMin: UInt;            { minimum message period when captured }
    wPeriodMax: UInt;            { maximum message period when captured }
    wRmin: UInt;                 { minimum r position value }
    wRmax: UInt;                 { maximum r position value }
    wUmin: UInt;                 { minimum u (5th axis) position value }
    wUmax: UInt;                 { maximum u (5th axis) position value }
    wVmin: UInt;                 { minimum v (6th axis) position value }
    wVmax: UInt;                 { maximum v (6th axis) position value }
    wCaps: UInt;                 { joystick capabilites }
    wMaxAxes: UInt;             { maximum number of axes supported }
    wNumAxes: UInt;             { number of axes in use }
    wMaxButtons: UInt;          { maximum number of buttons supported }
    szRegKey: array[0..MAXPNAMELEN - 1] of AnsiChar; { registry key }
    szOEMVxD: array[0..MAX_JOYSTICKOEMVXDNAME - 1] of AnsiChar; { OEM VxD in use }
  end;
  tagJOYCAPSW = record
    wMid: Word;                  { manufacturer ID }
    wPid: Word;                  { product ID }
    szPname: array[0..MAXPNAMELEN-1] of WideChar;  { product name (NULL terminated string) }
    wXmin: UInt;                 { minimum x position value }
    wXmax: UInt;                 { maximum x position value }
    wYmin: UInt;                 { minimum y position value }
    wYmax: UInt;                 { maximum y position value }
    wZmin: UInt;                 { minimum z position value }
    wZmax: UInt;                 { maximum z position value }
    wNumButtons: UInt;           { number of buttons }
    wPeriodMin: UInt;            { minimum message period when captured }
    wPeriodMax: UInt;            { maximum message period when captured }
    wRmin: UInt;                 { minimum r position value }
    wRmax: UInt;                 { maximum r position value }
    wUmin: UInt;                 { minimum u (5th axis) position value }
    wUmax: UInt;                 { maximum u (5th axis) position value }
    wVmin: UInt;                 { minimum v (6th axis) position value }
    wVmax: UInt;                 { maximum v (6th axis) position value }
    wCaps: UInt;                 { joystick capabilites }
    wMaxAxes: UInt;             { maximum number of axes supported }
    wNumAxes: UInt;             { number of axes in use }
    wMaxButtons: UInt;          { maximum number of buttons supported }
    szRegKey: array[0..MAXPNAMELEN - 1] of WideChar; { registry key }
    szOEMVxD: array[0..MAX_JOYSTICKOEMVXDNAME - 1] of WideChar; { OEM VxD in use }
  end;
  tagJOYCAPS = tagJOYCAPSA;
  TJoyCapsA = tagJOYCAPSA;
  TJoyCapsW = tagJOYCAPSW;
  TJoyCaps = TJoyCapsA;
  JOYCAPSA = tagJOYCAPSA;
  JOYCAPSW = tagJOYCAPSW;
  JOYCAPS = JOYCAPSA;

{ joystick information data structure }
type
  PJoyInfo = ^TJoyInfo;
  joyinfo_tag = record
    wXpos: UInt;                 { x position }
    wYpos: UInt;                 { y position }
    wZpos: UInt;                 { z position }
    wButtons: UInt;              { button states }
  end;
  TJoyInfo = joyinfo_tag;
  JOYINFO = joyinfo_tag;

  PJoyInfoEx = ^TJoyInfoEx;
  joyinfoex_tag = record
    dwSize: DWord;               { size of structure }
    dwFlags: DWord;              { flags to indicate what to return }
    wXpos: UInt;         { x position }
    wYpos: UInt;         { y position }
    wZpos: UInt;         { z position }
    dwRpos: DWord;               { rudder/4th axis position }
    dwUpos: DWord;               { 5th axis position }
    dwVpos: DWord;               { 6th axis position }
    wButtons: UInt;      { button states }
    dwButtonNumber: DWord;  { current button number pressed }
    dwPOV: DWord;           { point of view state }
    dwReserved1: DWord;          { reserved for communication between winmm & driver }
    dwReserved2: DWord;          { reserved for future expansion }
  end;
  TJoyInfoEx = joyinfoex_tag;
  JOYINFOEX = joyinfoex_tag;

{ joystick function prototypes }
function joyGetNumDevs: UInt;
function joyGetDevCaps(uJoyID: UInt; lpCaps: PJoyCaps; uSize: UInt): mmResult;
function joyGetPos(uJoyID: UInt; lpInfo: PJoyInfo): mmResult;
function joyGetPosEx(uJoyID: UInt; lpInfo: PJoyInfoEx): mmResult;
function joyGetThreshold(uJoyID: UInt; lpuThreshold: pUInt): mmResult;
function joyReleaseCapture(uJoyID: UInt): mmResult;
function joySetCapture(Handle: HWND; uJoyID, uPeriod: UInt; bChanged: Bool): mmResult;
function joySetThreshold(uJoyID, uThreshold: UInt): mmResult;


// MM File I/O Support

{ MMIO error return values }
const
  MMIOERR_BASE                = 256;
  MMIOERR_FILENOTFOUND        = MMIOERR_BASE + 1;  { file not found }
  MMIOERR_OUTOFMEMORY         = MMIOERR_BASE + 2;  { out of memory }
  MMIOERR_CANNOTOPEN          = MMIOERR_BASE + 3;  { cannot open }
  MMIOERR_CANNOTCLOSE         = MMIOERR_BASE + 4;  { cannot close }
  MMIOERR_CANNOTREAD          = MMIOERR_BASE + 5;  { cannot read }
  MMIOERR_CANNOTWRITE         = MMIOERR_BASE + 6;  { cannot write }
  MMIOERR_CANNOTSEEK          = MMIOERR_BASE + 7;  { cannot seek }
  MMIOERR_CANNOTEXPAND        = MMIOERR_BASE + 8;  { cannot expand file }
  MMIOERR_CHUNKNOTFOUND       = MMIOERR_BASE + 9;  { chunk not found }
  MMIOERR_UNBUFFERED          = MMIOERR_BASE + 10; { file is unbuffered }
  MMIOERR_PATHNOTFOUND        = MMIOERR_BASE + 11;  { path incorrect }
  MMIOERR_ACCESSDENIED        = MMIOERR_BASE + 12;  { file was protected }
  MMIOERR_SHARINGVIOLATION    = MMIOERR_BASE + 13;  { file in use }
  MMIOERR_NETWORKERROR        = MMIOERR_BASE + 14;  { network not responding }
  MMIOERR_TOOMANYOPENFILES    = MMIOERR_BASE + 15;  { no more file handles  }
  MMIOERR_INVALIDFILE         = MMIOERR_BASE + 16;  { default error file error }

{ MMIO constants }
const
  CFSEPCHAR       = '+';             { compound file name separator char. }

type
{ MMIO data types }
  FOURCC = DWord;                    { a four character code }

  PHMMIO = ^HMMIO;
  HMMIO = Integer;      { a handle to an open file }

  TFNMMIOProc = function(lpmmioinfo: PChar; uMessage: UInt; lParam1, lParam2: LPARAM): Longint;

{ general MMIO information data structure }
type
  PMMIOInfo = ^TMMIOInfo;
  _MMIOINFO = record
    { general fields }
    dwFlags: DWord;        { general status flags }
    fccIOProc: FOURCC;      { pointer to I/O procedure }
    pIOProc: TFNMMIOProc;        { pointer to I/O procedure }
    wErrorRet: UInt;      { place for error to be returned }
    hTask: HTASK;          { alternate local task }

    { fields maintained by MMIO functions during buffered I/O }
    cchBuffer: Longint;      { size of I/O buffer (or 0L) }
    pchBuffer: PChar;      { start of I/O buffer (or NULL) }
    pchNext: PChar;        { pointer to next byte to read/write }
    pchEndRead: PChar;     { pointer to last valid byte to read }
    pchEndWrite: PChar;    { pointer to last byte to write }
    lBufOffset: Longint;     { disk offset of start of buffer }

    { fields maintained by I/O procedure }
    lDiskOffset: Longint;    { disk offset of next read or write }
    adwInfo: array[0..2] of DWord;     { data specific to type of MMIOPROC }

    { other fields maintained by MMIO }
    dwReserved1: DWord;    { reserved for MMIO use }
    dwReserved2: DWord;    { reserved for MMIO use }
    hmmio: HMMIO;          { handle to open file }
  end;
  TMMIOInfo = _MMIOINFO;
  MMIOINFO = _MMIOINFO;


{ RIFF chunk information data structure }
type

  PMMCKInfo = ^TMMCKInfo;
  _MMCKINFO = record
    ckid: FOURCC;           { chunk ID }
    cksize: DWord;         { chunk size }
    fccType: FOURCC;        { form type or list type }
    dwDataOffset: DWord;   { offset of data portion of chunk }
    dwFlags: DWord;        { flags used by MMIO functions }
  end;
  TMMCKInfo = _MMCKINFO;
  MMCKINFO = _MMCKINFO;

{ bit field masks }
const
  MMIO_RWMODE     = $00000003;      { open file for reading/writing/both }
  MMIO_SHAREMODE  = $00000070;      { file sharing mode number }

{ constants for dwFlags field of MMIOINFO }
const
  MMIO_CREATE    = $00001000;     { create new file (or truncate file) }
  MMIO_PARSE     = $00000100;     { parse new file returning path }
  MMIO_DELETE    = $00000200;     { create new file (or truncate file) }
  MMIO_EXIST     = $00004000;     { checks for existence of file }
  MMIO_ALLOCBUF  = $00010000;     { mmioOpen() should allocate a buffer }
  MMIO_GETTEMP   = $00020000;     { mmioOpen() should retrieve temp name }

const
  MMIO_DIRTY     = $10000000;     { I/O buffer is dirty }

{ read/write mode numbers (bit field MMIO_RWMODE) }
const
  MMIO_READ       = $00000000;      { open file for reading only }
  MMIO_WRITE      = $00000001;      { open file for writing only }
  MMIO_READWRITE  = $00000002;      { open file for reading and writing }

{ share mode numbers (bit field MMIO_SHAREMODE) }
const
  MMIO_COMPAT     = $00000000;      { compatibility mode }
  MMIO_EXCLUSIVE  = $00000010;      { exclusive-access mode }
  MMIO_DENYWRITE  = $00000020;      { deny writing to other processes }
  MMIO_DENYREAD   = $00000030;      { deny reading to other processes }
  MMIO_DENYNONE   = $00000040;      { deny nothing to other processes }

{ various MMIO flags }
const
  MMIO_FHOPEN             = $0010;  { mmioClose: keep file handle open }
  MMIO_EMPTYBUF           = $0010;  { mmioFlush: empty the I/O buffer }
  MMIO_TOUPPER            = $0010;  { mmioStringToFOURCC: to u-case }
  MMIO_INSTALLPROC    = $00010000;  { mmioInstallIOProc: install MMIOProc }
  MMIO_GLOBALPROC     = $10000000;  { mmioInstallIOProc: install globally }
  MMIO_REMOVEPROC     = $00020000;  { mmioInstallIOProc: remove MMIOProc }
  MMIO_UNICODEPROC    = $01000000;  { mmioInstallIOProc: Unicode MMIOProc }
  MMIO_FINDPROC       = $00040000;  { mmioInstallIOProc: find an MMIOProc }
  MMIO_FINDCHUNK          = $0010;  { mmioDescend: find a chunk by ID }
  MMIO_FINDRIFF           = $0020;  { mmioDescend: find a LIST chunk }
  MMIO_FINDLIST           = $0040;  { mmioDescend: find a RIFF chunk }
  MMIO_CREATERIFF         = $0020;  { mmioCreateChunk: make a LIST chunk }
  MMIO_CREATELIST         = $0040;  { mmioCreateChunk: make a RIFF chunk }


{ message numbers for MMIOPROC I/O procedure functions }
const
  MMIOM_READ      = MMIO_READ;       { read }
  MMIOM_WRITE    = MMIO_WRITE;       { write }
  MMIOM_SEEK              = 2;       { seek to a new position in file }
  MMIOM_OPEN              = 3;       { open file }
  MMIOM_CLOSE             = 4;       { close file }
  MMIOM_WRITEFLUSH        = 5;       { write and flush }

const
  MMIOM_RENAME            = 6;       { rename specified file }

  MMIOM_USER         = $8000;       { beginning of user-defined messages }

{ standard four character codes }
const
  FOURCC_RIFF = $46464952;   { 'RIFF' }
  FOURCC_LIST = $5453494C;   { 'LIST' }

{ four character codes used to identify standard built-in I/O procedures }
const
  FOURCC_DOS  = $20532F44;   { 'DOS '}
  FOURCC_MEM  = $204D454D;   { 'MEM '}

{ flags for mmioSeek() }
const
  SEEK_SET        = 0;               { seek to an absolute position }
  SEEK_CUR        = 1;               { seek relative to current position }
  SEEK_END        = 2;               { seek relative to end of file }

{ other constants }
const
  MMIO_DEFAULTBUFFER      = 8192;    { default buffer size }

// MMIO function prototypes
function mmioStringToFOURCC(sz: PChar; uFlags: UInt): FOURCC;
function mmioInstallIOProc(fccIOProc: FOURCC; pIOProc: TFNMMIOProc; dwFlags: DWord): TFNMMIOProc;
function mmioOpen(szFileName: PChar; lpmmioinfo: PMMIOInfo; dwOpenFlags: DWord): HMMIO;
function mmioRename(szFileName, szNewFileName: PChar; lpmmioinfo: PMMIOInfo; dwRenameFlags: DWord): mmResult;
function mmioClose(hmmio: HMMIO; uFlags: UInt): mmResult;
function mmioRead(hmmio: HMMIO; pch: PChar; cch: Longint): Longint;
function mmioWrite(hmmio: HMMIO; pch: PChar; cch: Longint): Longint;
function mmioSeek(hmmio: HMMIO; lOffset: Longint; iOrigin: Integer): Longint;
function mmioGetInfo(hmmio: HMMIO; lpmmioinfo: PMMIOInfo; uFlags: UInt): mmResult;
function mmioSetInfo(hmmio: HMMIO; lpmmioinfo: PMMIOInfo; uFlags: UInt): mmResult;
function mmioSetBuffer(hmmio: HMMIO; pchBuffer: PChar; cchBuffer: Longint; uFlags: Word): mmResult;
function mmioFlush(hmmio: HMMIO; uFlags: UInt): mmResult;
function mmioAdvance(hmmio: HMMIO; lpmmioinfo: PMMIOInfo; uFlags: UInt): mmResult;
function mmioSendMessage(hmmio: HMMIO; uMessage: UInt; lParam1, lParam2: DWord): Longint;
function mmioDescend(hmmio: HMMIO; lpck: PMMCKInfo; lpckParent: PMMCKInfo; uFlags: UInt): mmResult;
function mmioAscend(hmmio: HMMIO; lpck: PMMCKInfo; uFlags: UInt): mmResult;
function mmioCreateChunk(hmmio: HMMIO; lpck: PMMCKInfo; uFlags: UInt): mmResult;


// MCI Support

type
  mciError = DWord;     { error return code, 0 means no error }
  mciDeviceId = UInt;   { MCI device ID type }

  TFNYieldProc = function(mciId: mciDeviceId; dwYieldData: DWord): UInt;

{ MCI function prototypes }
function mciSendCommand(mciId: mciDeviceId; uMessage: UInt; dwParam1, dwParam2: DWord): mciError;
function mciSendString(lpstrCommand, lpstrReturnString: PChar; uReturnLength: UInt; hWndCallback: HWND): mciError;
function mciGetDeviceID(pszDevice: PChar): mciDeviceId;
function mciGetDeviceIDFromElementID(dwElementID: DWord; lpstrType: PChar): mciDeviceId;
function mciGetErrorString(mcierr: mciError; pszText: PChar; uLength: UInt): Bool;
function mciSetYieldProc(mciId: mciDeviceId; fpYieldProc: TFNYieldProc; dwYieldData: DWord): Bool;
function mciGetCreatorTask(mciId: mciDeviceId): HTASK;
function mciGetYieldProc(mciId: mciDeviceId; lpdwYieldData: pDWord): TFNYieldProc;
function mciExecute(pszCommand: LPCSTR): Bool;


{ MCI error return values }
const
  MCIERR_INVALID_DEVICE_ID        = MCIERR_BASE + 1;
  MCIERR_UNRECOGNIZED_KEYWORD     = MCIERR_BASE + 3;
  MCIERR_UNRECOGNIZED_COMMAND     = MCIERR_BASE + 5;
  MCIERR_HARDWARE                 = MCIERR_BASE + 6;
  MCIERR_INVALID_DEVICE_NAME      = MCIERR_BASE + 7;
  MCIERR_OUT_OF_MEMORY            = MCIERR_BASE + 8;
  MCIERR_DEVICE_OPEN              = MCIERR_BASE + 9;
  MCIERR_CANNOT_LOAD_DRIVER       = MCIERR_BASE + 10;
  MCIERR_MISSING_COMMAND_STRING   = MCIERR_BASE + 11;
  MCIERR_PARAM_OVERFLOW           = MCIERR_BASE + 12;
  MCIERR_MISSING_STRING_ARGUMENT  = MCIERR_BASE + 13;
  MCIERR_BAD_INTEGER              = MCIERR_BASE + 14;
  MCIERR_PARSER_INTERNAL          = MCIERR_BASE + 15;
  MCIERR_DRIVER_INTERNAL          = MCIERR_BASE + 16;
  MCIERR_MISSING_PARAMETER        = MCIERR_BASE + 17;
  MCIERR_UNSUPPORTED_FUNCTION     = MCIERR_BASE + 18;
  MCIERR_FILE_NOT_FOUND           = MCIERR_BASE + 19;
  MCIERR_DEVICE_NOT_READY         = MCIERR_BASE + 20;
  MCIERR_INTERNAL                 = MCIERR_BASE + 21;
  MCIERR_DRIVER                   = MCIERR_BASE + 22;
  MCIERR_CANNOT_USE_ALL           = MCIERR_BASE + 23;
  MCIERR_MULTIPLE                 = MCIERR_BASE + 24;
  MCIERR_EXTENSION_NOT_FOUND      = MCIERR_BASE + 25;
  MCIERR_OUTOFRANGE               = MCIERR_BASE + 26;
  MCIERR_FLAGS_NOT_COMPATIBLE     = MCIERR_BASE + 28;
  MCIERR_FILE_NOT_SAVED           = MCIERR_BASE + 30;
  MCIERR_DEVICE_TYPE_REQUIRED     = MCIERR_BASE + 31;
  MCIERR_DEVICE_LOCKED            = MCIERR_BASE + 32;
  MCIERR_DUPLICATE_ALIAS          = MCIERR_BASE + 33;
  MCIERR_BAD_CONSTANT             = MCIERR_BASE + 34;
  MCIERR_MUST_USE_SHAREABLE       = MCIERR_BASE + 35;
  MCIERR_MISSING_DEVICE_NAME      = MCIERR_BASE + 36;
  MCIERR_BAD_TIME_FORMAT          = MCIERR_BASE + 37;
  MCIERR_NO_CLOSING_QUOTE         = MCIERR_BASE + 38;
  MCIERR_DUPLICATE_FLAGS          = MCIERR_BASE + 39;
  MCIERR_INVALID_FILE             = MCIERR_BASE + 40;
  MCIERR_NULL_PARAMETER_BLOCK     = MCIERR_BASE + 41;
  MCIERR_UNNAMED_RESOURCE         = MCIERR_BASE + 42;
  MCIERR_NEW_REQUIRES_ALIAS       = MCIERR_BASE + 43;
  MCIERR_NOTIFY_ON_AUTO_OPEN      = MCIERR_BASE + 44;
  MCIERR_NO_ELEMENT_ALLOWED       = MCIERR_BASE + 45;
  MCIERR_NONAPPLICABLE_FUNCTION   = MCIERR_BASE + 46;
  MCIERR_ILLEGAL_FOR_AUTO_OPEN    = MCIERR_BASE + 47;
  MCIERR_FILENAME_REQUIRED        = MCIERR_BASE + 48;
  MCIERR_EXTRA_CHARACTERS         = MCIERR_BASE + 49;
  MCIERR_DEVICE_NOT_INSTALLED     = MCIERR_BASE + 50;
  MCIERR_GET_CD                   = MCIERR_BASE + 51;
  MCIERR_SET_CD                   = MCIERR_BASE + 52;
  MCIERR_SET_DRIVE                = MCIERR_BASE + 53;
  MCIERR_DEVICE_LENGTH            = MCIERR_BASE + 54;
  MCIERR_DEVICE_ORD_LENGTH        = MCIERR_BASE + 55;
  MCIERR_NO_INTEGER               = MCIERR_BASE + 56;

const
  MCIERR_WAVE_OUTPUTSINUSE        = MCIERR_BASE + 64;
  MCIERR_WAVE_SETOUTPUTINUSE      = MCIERR_BASE + 65;
  MCIERR_WAVE_INPUTSINUSE         = MCIERR_BASE + 66;
  MCIERR_WAVE_SETINPUTINUSE       = MCIERR_BASE + 67;
  MCIERR_WAVE_OUTPUTUNSPECIFIED   = MCIERR_BASE + 68;
  MCIERR_WAVE_INPUTUNSPECIFIED    = MCIERR_BASE + 69;
  MCIERR_WAVE_OUTPUTSUNSUITABLE   = MCIERR_BASE + 70;
  MCIERR_WAVE_SETOUTPUTUNSUITABLE = MCIERR_BASE + 71;
  MCIERR_WAVE_INPUTSUNSUITABLE    = MCIERR_BASE + 72;
  MCIERR_WAVE_SETINPUTUNSUITABLE  = MCIERR_BASE + 73;

  MCIERR_SEQ_DIV_INCOMPATIBLE     = MCIERR_BASE + 80;
  MCIERR_SEQ_PORT_INUSE           = MCIERR_BASE + 81;
  MCIERR_SEQ_PORT_NONEXISTENT     = MCIERR_BASE + 82;
  MCIERR_SEQ_PORT_MAPNODEVICE     = MCIERR_BASE + 83;
  MCIERR_SEQ_PORT_MISCERROR       = MCIERR_BASE + 84;
  MCIERR_SEQ_TIMER                = MCIERR_BASE + 85;
  MCIERR_SEQ_PORTUNSPECIFIED      = MCIERR_BASE + 86;
  MCIERR_SEQ_NOMIDIPRESENT        = MCIERR_BASE + 87;

  MCIERR_NO_WINDOW                = MCIERR_BASE + 90;
  MCIERR_CREATEWINDOW             = MCIERR_BASE + 91;
  MCIERR_FILE_READ                = MCIERR_BASE + 92;
  MCIERR_FILE_WRITE               = MCIERR_BASE + 93;

  MCIERR_NO_IDENTITY              = MCIERR_BASE + 94;

{ all custom device driver errors must be >= this value }
const
  MCIERR_CUSTOM_DRIVER_BASE       = mcierr_Base + 256;

{ MCI command message identifiers }
const
  MCI_OPEN       = $0803;
  MCI_CLOSE      = $0804;
  MCI_ESCAPE     = $0805;
  MCI_PLAY       = $0806;
  MCI_SEEK       = $0807;
  MCI_STOP       = $0808;
  MCI_PAUSE      = $0809;
  MCI_INFO       = $080A;
  MCI_GETDEVCAPS = $080B;
  MCI_SPIN       = $080C;
  MCI_SET        = $080D;
  MCI_STEP       = $080E;
  MCI_RECORD     = $080F;
  MCI_SYSINFO    = $0810;
  MCI_BREAK      = $0811;
  MCI_SOUND      = $0812;
  MCI_SAVE       = $0813;
  MCI_STATUS     = $0814;
  MCI_CUE        = $0830;
  MCI_REALIZE    = $0840;
  MCI_WINDOW     = $0841;
  MCI_PUT        = $0842;
  MCI_WHERE      = $0843;
  MCI_FREEZE     = $0844;
  MCI_UNFREEZE   = $0845;
  MCI_LOAD       = $0850;
  MCI_CUT        = $0851;
  MCI_COPY       = $0852;
  MCI_PASTE      = $0853;
  MCI_UPDATE     = $0854;
  MCI_RESUME     = $0855;
  MCI_DELETE     = $0856;

{ all custom MCI command messages must be >= this value }
const
  MCI_USER_MESSAGES               = $400 + drv_MCI_First;
  MCI_LAST                        = $0FFF;

{ device ID for "all devices" }
const
  MCI_ALL_DEVICE_ID               = UInt(-1);

{ constants for predefined MCI device types }
const
  MCI_DEVTYPE_VCR                 = MCI_STRING_OFFSET + 1;
  MCI_DEVTYPE_VIDEODISC           = MCI_STRING_OFFSET + 2;
  MCI_DEVTYPE_OVERLAY             = MCI_STRING_OFFSET + 3;
  MCI_DEVTYPE_CD_AUDIO            = MCI_STRING_OFFSET + 4;
  MCI_DEVTYPE_DAT                 = MCI_STRING_OFFSET + 5;
  MCI_DEVTYPE_SCANNER             = MCI_STRING_OFFSET + 6;
  MCI_DEVTYPE_ANIMATION           = MCI_STRING_OFFSET + 7;
  MCI_DEVTYPE_DIGITAL_VIDEO       = MCI_STRING_OFFSET + 8;
  MCI_DEVTYPE_OTHER               = MCI_STRING_OFFSET + 9;
  MCI_DEVTYPE_WAVEFORM_AUDIO      = MCI_STRING_OFFSET + 10;
  MCI_DEVTYPE_SEQUENCER           = MCI_STRING_OFFSET + 11;

  MCI_DEVTYPE_FIRST              = MCI_DEVTYPE_VCR;
  MCI_DEVTYPE_LAST               = MCI_DEVTYPE_SEQUENCER;

  MCI_DEVTYPE_FIRST_USER         = 1000;

{ return values for 'status mode' command }
const
  MCI_MODE_NOT_READY              = MCI_STRING_OFFSET + 12;
  MCI_MODE_STOP                   = MCI_STRING_OFFSET + 13;
  MCI_MODE_PLAY                   = MCI_STRING_OFFSET + 14;
  MCI_MODE_RECORD                 = MCI_STRING_OFFSET + 15;
  MCI_MODE_SEEK                   = MCI_STRING_OFFSET + 16;
  MCI_MODE_PAUSE                  = MCI_STRING_OFFSET + 17;
  MCI_MODE_OPEN                   = MCI_STRING_OFFSET + 18;

{ constants used in 'set time format' and 'status time format' commands }
const
  MCI_FORMAT_MILLISECONDS         = 0;
  MCI_FORMAT_HMS                  = 1;
  MCI_FORMAT_MSF                  = 2;
  MCI_FORMAT_FRAMES               = 3;
  MCI_FORMAT_SMPTE_24             = 4;
  MCI_FORMAT_SMPTE_25             = 5;
  MCI_FORMAT_SMPTE_30             = 6;
  MCI_FORMAT_SMPTE_30DROP         = 7;
  MCI_FORMAT_BYTES                = 8;
  MCI_FORMAT_SAMPLES              = 9;
  MCI_FORMAT_TMSF                 = 10;

{ MCI time format conversion macros }

function mci_MSF_Minute(msf: Longint): Byte;
function mci_MSF_Second(msf: Longint): Byte;
function mci_MSF_Frame(msf: Longint): Byte;
function mci_Make_MSF(m, s, f: Byte): Longint;
function mci_TMSF_Track(tmsf: Longint): Byte;
function mci_TMSF_Minute(tmsf: Longint): Byte;
function mci_TMSF_Second(tmsf: Longint): Byte;
function mci_TMSF_Frame(tmsf: Longint): Byte;
function mci_Make_TMSF(t, m, s, f: Byte): Longint;
function mci_HMS_Hour(hms: Longint): Byte;
function mci_HMS_Minute(hms: Longint): Byte;
function mci_HMS_Second(hms: Longint): Byte;
function mci_Make_HMS(h, m, s: Byte): Longint;

{ flags for wParam of MM_MCINOTIFY message }
const
  MCI_NOTIFY_SUCCESSFUL           = $0001;
  MCI_NOTIFY_SUPERSEDED           = $0002;
  MCI_NOTIFY_ABORTED              = $0004;
  MCI_NOTIFY_FAILURE              = $0008;

{ common flags for dwFlags parameter of MCI command messages }
const
  MCI_NOTIFY                      = $00000001;
  MCI_WAIT                        = $00000002;
  MCI_FROM                        = $00000004;
  MCI_TO                          = $00000008;
  MCI_TRACK                       = $00000010;

{ flags for dwFlags parameter of MCI_OPEN command message }
const
  MCI_OPEN_SHAREABLE              = $00000100;
  MCI_OPEN_ELEMENT                = $00000200;
  MCI_OPEN_ALIAS                  = $00000400;
  MCI_OPEN_ELEMENT_ID             = $00000800;
  MCI_OPEN_TYPE_ID                = $00001000;
  MCI_OPEN_TYPE                   = $00002000;

{ flags for dwFlags parameter of MCI_SEEK command message }
const
  MCI_SEEK_TO_START               = $00000100;
  MCI_SEEK_TO_END                 = $00000200;

{ flags for dwFlags parameter of MCI_STATUS command message }
const
  MCI_STATUS_ITEM                 = $00000100;
  MCI_STATUS_START                = $00000200;

{ flags for dwItem field of the MCI_STATUS_PARMS parameter block }
const
  MCI_STATUS_LENGTH               = $00000001;
  MCI_STATUS_POSITION             = $00000002;
  MCI_STATUS_NUMBER_OF_TRACKS     = $00000003;
  MCI_STATUS_MODE                 = $00000004;
  MCI_STATUS_MEDIA_PRESENT        = $00000005;
  MCI_STATUS_TIME_FORMAT          = $00000006;
  MCI_STATUS_READY                = $00000007;
  MCI_STATUS_CURRENT_TRACK        = $00000008;

{ flags for dwFlags parameter of MCI_INFO command message }
const
  MCI_INFO_PRODUCT                = $00000100;
  MCI_INFO_FILE                   = $00000200;
  MCI_INFO_MEDIA_UPC              = $00000400;
  MCI_INFO_MEDIA_IDENTITY         = $00000800;
  MCI_INFO_NAME                   = $00001000;
  MCI_INFO_COPYRIGHT              = $00002000;

{ flags for dwFlags parameter of MCI_GETDEVCAPS command message }
const
  MCI_GETDEVCAPS_ITEM             = $00000100;

{ flags for dwItem field of the MCI_GETDEVCAPS_PARMS parameter block }
const
  MCI_GETDEVCAPS_CAN_RECORD       = $00000001;
  MCI_GETDEVCAPS_HAS_AUDIO        = $00000002;
  MCI_GETDEVCAPS_HAS_VIDEO        = $00000003;
  MCI_GETDEVCAPS_DEVICE_TYPE      = $00000004;
  MCI_GETDEVCAPS_USES_FILES       = $00000005;
  MCI_GETDEVCAPS_COMPOUND_DEVICE  = $00000006;
  MCI_GETDEVCAPS_CAN_EJECT        = $00000007;
  MCI_GETDEVCAPS_CAN_PLAY         = $00000008;
  MCI_GETDEVCAPS_CAN_SAVE         = $00000009;

{ flags for dwFlags parameter of MCI_SYSINFO command message }
const
  MCI_SYSINFO_QUANTITY            = $00000100;
  MCI_SYSINFO_OPEN                = $00000200;
  MCI_SYSINFO_NAME                = $00000400;
  MCI_SYSINFO_INSTALLNAME         = $00000800;

{ flags for dwFlags parameter of MCI_SET command message }
const
  MCI_SET_DOOR_OPEN               = $00000100;
  MCI_SET_DOOR_CLOSED             = $00000200;
  MCI_SET_TIME_FORMAT             = $00000400;
  MCI_SET_AUDIO                   = $00000800;
  MCI_SET_VIDEO                   = $00001000;
  MCI_SET_ON                      = $00002000;
  MCI_SET_OFF                     = $00004000;

{ flags for dwAudio field of MCI_SET_PARMS or MCI_SEQ_SET_PARMS }
const
  MCI_SET_AUDIO_ALL               = $00000000;
  MCI_SET_AUDIO_LEFT              = $00000001;
  MCI_SET_AUDIO_RIGHT             = $00000002;

{ flags for dwFlags parameter of MCI_BREAK command message }
const
  MCI_BREAK_KEY                   = $00000100;
  MCI_BREAK_HWND                  = $00000200;
  MCI_BREAK_OFF                   = $00000400;

{ flags for dwFlags parameter of MCI_RECORD command message }
const
  MCI_RECORD_INSERT               = $00000100;
  MCI_RECORD_OVERWRITE            = $00000200;

{ flags for dwFlags parameter of MCI_SOUND command message }
const
  MCI_SOUND_NAME                  = $00000100;

{ flags for dwFlags parameter of MCI_SAVE command message }
const
  MCI_SAVE_FILE                   = $00000100;

{ flags for dwFlags parameter of MCI_LOAD command message }
const
  MCI_LOAD_FILE                   = $00000100;

{ generic parameter block for MCI command messages with no special parameters }
type
  PMCI_Generic_Parms = ^TMCI_Generic_Parms;
  tagMCI_GENERIC_PARMS = record
    dwCallback: DWord;
  end;
  TMCI_Generic_Parms = tagMCI_GENERIC_PARMS;
  MCI_GENERIC_PARMS = tagMCI_GENERIC_PARMS;

{ parameter block for MCI_OPEN command message }
type
  PMCI_Open_ParmsA = ^TMCI_Open_ParmsA;
  PMCI_Open_ParmsW = ^TMCI_Open_ParmsW;
  PMCI_Open_Parms = PMCI_Open_ParmsA;
  tagMCI_OPEN_PARMSA = record
    dwCallback: DWord;
    wDeviceID: mciDeviceId;
    lpstrDeviceType: PAnsiChar;
    lpstrElementName: PAnsiChar;
    lpstrAlias: PAnsiChar;
  end;
  tagMCI_OPEN_PARMSW = record
    dwCallback: DWord;
    wDeviceID: mciDeviceId;
    lpstrDeviceType: PWideChar;
    lpstrElementName: PWideChar;
    lpstrAlias: PWideChar;
  end;
  tagMCI_OPEN_PARMS = tagMCI_OPEN_PARMSA;
  TMCI_Open_ParmsA = tagMCI_OPEN_PARMSA;
  TMCI_Open_ParmsW = tagMCI_OPEN_PARMSW;
  TMCI_Open_Parms = TMCI_Open_ParmsA;
  MCI_OPEN_PARMSA = tagMCI_OPEN_PARMSA;
  MCI_OPEN_PARMSW = tagMCI_OPEN_PARMSW;
  MCI_OPEN_PARMS = MCI_OPEN_PARMSA;

{ parameter block for MCI_PLAY command message }
type
  PMCI_Play_Parms = ^TMCI_Play_Parms;
  tagMCI_PLAY_PARMS = record
    dwCallback: DWord;
    dwFrom: DWord;
    dwTo: DWord;
  end;
  TMCI_Play_Parms = tagMCI_PLAY_PARMS;
  MCI_PLAY_PARMS = tagMCI_PLAY_PARMS;

{ parameter block for MCI_SEEK command message }
type
  PMCI_Seek_Parms = ^TMCI_Seek_Parms;
  tagMCI_SEEK_PARMS = record
    dwCallback: DWord;
    dwTo: DWord;
  end;
  TMCI_Seek_Parms = tagMCI_SEEK_PARMS;
  MCI_SEEK_PARMS = tagMCI_SEEK_PARMS;


{ parameter block for MCI_STATUS command message }
type
  PMCI_Status_Parms = ^TMCI_Status_Parms;
  tagMCI_STATUS_PARMS = record
    dwCallback: DWord;
    dwReturn: DWord;
    dwItem: DWord;
    dwTrack: DWord;
  end;
  TMCI_Status_Parms = tagMCI_STATUS_PARMS;
  MCI_STATUS_PARMS = tagMCI_STATUS_PARMS;

{ parameter block for MCI_INFO command message }
type
  PMCI_Info_ParmsA = ^TMCI_Info_ParmsA;
  PMCI_Info_ParmsW = ^TMCI_Info_ParmsW;
  PMCI_Info_Parms = PMCI_Info_ParmsA;
  tagMCI_INFO_PARMSA = record
    dwCallback: DWord;
    lpstrReturn: PAnsiChar;
    dwRetSize: DWord;
  end;
  tagMCI_INFO_PARMSW = record
    dwCallback: DWord;
    lpstrReturn: PWideChar;
    dwRetSize: DWord;
  end;
  tagMCI_INFO_PARMS = tagMCI_INFO_PARMSA;
  TMCI_Info_ParmsA = tagMCI_INFO_PARMSA;
  TMCI_Info_ParmsW = tagMCI_INFO_PARMSW;
  TMCI_Info_Parms = TMCI_Info_ParmsA;
  MCI_INFO_PARMSA = tagMCI_INFO_PARMSA;
  MCI_INFO_PARMSW = tagMCI_INFO_PARMSW;
  MCI_INFO_PARMS = MCI_INFO_PARMSA;

{ parameter block for MCI_GETDEVCAPS command message }
type
  PMCI_GetDevCaps_Parms = ^TMCI_GetDevCaps_Parms;
  tagMCI_GETDEVCAPS_PARMS = record
    dwCallback: DWord;
    dwReturn: DWord;
    dwItem: DWord;
  end;
  TMCI_GetDevCaps_Parms = tagMCI_GETDEVCAPS_PARMS;
  MCI_GETDEVCAPS_PARMS = tagMCI_GETDEVCAPS_PARMS;

{ parameter block for MCI_SYSINFO command message }
type
  PMCI_SysInfo_ParmsA = ^TMCI_SysInfo_ParmsA;
  PMCI_SysInfo_ParmsW = ^TMCI_SysInfo_ParmsW;
  PMCI_SysInfo_Parms = PMCI_SysInfo_ParmsA;
  tagMCI_SYSINFO_PARMSA = record
    dwCallback: DWord;
    lpstrReturn: PAnsiChar;
    dwRetSize: DWord;
    dwNumber: DWord;
    wDeviceType: UInt;
  end;
  tagMCI_SYSINFO_PARMSW = record
    dwCallback: DWord;
    lpstrReturn: PWideChar;
    dwRetSize: DWord;
    dwNumber: DWord;
    wDeviceType: UInt;
  end;
  tagMCI_SYSINFO_PARMS = tagMCI_SYSINFO_PARMSA;
  TMCI_SysInfo_ParmsA = tagMCI_SYSINFO_PARMSA;
  TMCI_SysInfo_ParmsW = tagMCI_SYSINFO_PARMSW;
  TMCI_SysInfo_Parms = TMCI_SysInfo_ParmsA;
  MCI_SYSINFO_PARMSA = tagMCI_SYSINFO_PARMSA;
  MCI_SYSINFO_PARMSW = tagMCI_SYSINFO_PARMSW;
  MCI_SYSINFO_PARMS = MCI_SYSINFO_PARMSA;

{ parameter block for MCI_SET command message }
type
  PMCI_Set_Parms = ^TMCI_Set_Parms;
  tagMCI_SET_PARMS = record
    dwCallback: DWord;
    dwTimeFormat: DWord;
    dwAudio: DWord;
  end;
  TMCI_Set_Parms = tagMCI_SET_PARMS;
  MCI_SET_PARMS = tagMCI_SET_PARMS;


{ parameter block for MCI_BREAK command message }
type
  PMCI_Break_Parms = ^TMCI_BReak_Parms;
  tagMCI_BREAK_PARMS = record
    dwCallback: DWord;
    nVirtKey: Integer;
    hWndBreak: HWND;
  end;
  TMCI_BReak_Parms = tagMCI_BREAK_PARMS;
  MCI_BREAK_PARMS = tagMCI_BREAK_PARMS;

{ parameter block for MCI_SOUND command message }
type
  PMCI_Sound_Parms = ^TMCI_Sound_Parms;
  TMCI_Sound_Parms = record
    dwCallback: Longint;
    lpstrSoundName: PChar;
  end;

{ parameter block for MCI_SAVE command message }
type
  PMCI_Save_ParmsA = ^MCI_SAVE_PARMSA;
  PMCI_Save_ParmsW = ^MCI_SAVE_PARMSW;
  PMCI_Save_Parms = PMCI_Save_ParmsA;
  MCI_SAVE_PARMSA = record
    dwCallback: DWord;
    lpfilename: PAnsiChar;
  end;
  MCI_SAVE_PARMSW = record
    dwCallback: DWord;
    lpfilename: PWideChar;
  end;
  MCI_SAVE_PARMS = MCI_SAVE_PARMSA;
  TMCI_SaveParmsA = MCI_SAVE_PARMSA;
  LPMCI_SAVE_PARMSA = PMCI_Save_ParmsA;
  TMCI_SaveParmsW = MCI_SAVE_PARMSW;
  LPMCI_SAVE_PARMSW = PMCI_Save_ParmsW;
  TMCI_SaveParms = TMCI_SaveParmsA;

{ parameter block for MCI_LOAD command message }
type
  PMCI_Load_ParmsA = ^TMCI_Load_ParmsA;
  PMCI_Load_ParmsW = ^TMCI_Load_ParmsW;
  PMCI_Load_Parms = PMCI_Load_ParmsA;
  tagMCI_LOAD_PARMSA = record
    dwCallback: DWord;
    lpfilename: PAnsiChar;
  end;
  tagMCI_LOAD_PARMSW = record
    dwCallback: DWord;
    lpfilename: PWideChar;
  end;
  tagMCI_LOAD_PARMS = tagMCI_LOAD_PARMSA;
  TMCI_Load_ParmsA = tagMCI_LOAD_PARMSA;
  TMCI_Load_ParmsW = tagMCI_LOAD_PARMSW;
  TMCI_Load_Parms = TMCI_Load_ParmsA;
  MCI_LOAD_PARMSA = tagMCI_LOAD_PARMSA;
  MCI_LOAD_PARMSW = tagMCI_LOAD_PARMSW;
  MCI_LOAD_PARMS = MCI_LOAD_PARMSA;

{ parameter block for MCI_RECORD command message }
type
  PMCI_Record_Parms = ^TMCI_Record_Parms;
  tagMCI_RECORD_PARMS = record
    dwCallback: DWord;
    dwFrom: DWord;
    dwTo: DWord;
  end;
  TMCI_Record_Parms = tagMCI_RECORD_PARMS;
  MCI_RECORD_PARMS = tagMCI_RECORD_PARMS;


{ MCI extensions for videodisc devices }

{ flag for dwReturn field of MCI_STATUS_PARMS }
{ MCI_STATUS command, (dwItem == MCI_STATUS_MODE) }
const
  MCI_VD_MODE_PARK                = MCI_VD_OFFSET + 1;

{ flag for dwReturn field of MCI_STATUS_PARMS }
{ MCI_STATUS command, (dwItem == MCI_VD_STATUS_MEDIA_TYPE) }
const
  MCI_VD_MEDIA_CLV                = MCI_VD_OFFSET + 2;
  MCI_VD_MEDIA_CAV                = MCI_VD_OFFSET + 3;
  MCI_VD_MEDIA_OTHER              = MCI_VD_OFFSET + 4;

const
  MCI_VD_FORMAT_TRACK             = $4001;

{ flags for dwFlags parameter of MCI_PLAY command message }
const
  MCI_VD_PLAY_REVERSE             = $00010000;
  MCI_VD_PLAY_FAST                = $00020000;
  MCI_VD_PLAY_SPEED               = $00040000;
  MCI_VD_PLAY_SCAN                = $00080000;
  MCI_VD_PLAY_SLOW                = $00100000;

{ flag for dwFlags parameter of MCI_SEEK command message }
const
  MCI_VD_SEEK_REVERSE             = $00010000;

{ flags for dwItem field of MCI_STATUS_PARMS parameter block }
const
  MCI_VD_STATUS_SPEED             = $00004002;
  MCI_VD_STATUS_FORWARD           = $00004003;
  MCI_VD_STATUS_MEDIA_TYPE        = $00004004;
  MCI_VD_STATUS_SIDE              = $00004005;
  MCI_VD_STATUS_DISC_SIZE         = $00004006;

{ flags for dwFlags parameter of MCI_GETDEVCAPS command message }
const
  MCI_VD_GETDEVCAPS_CLV           = $00010000;
  MCI_VD_GETDEVCAPS_CAV           = $00020000;

  MCI_VD_SPIN_UP                  = $00010000;
  MCI_VD_SPIN_DOWN                = $00020000;

{ flags for dwItem field of MCI_GETDEVCAPS_PARMS parameter block }
const
  MCI_VD_GETDEVCAPS_CAN_REVERSE   = $00004002;
  MCI_VD_GETDEVCAPS_FAST_RATE     = $00004003;
  MCI_VD_GETDEVCAPS_SLOW_RATE     = $00004004;
  MCI_VD_GETDEVCAPS_NORMAL_RATE   = $00004005;

{ flags for the dwFlags parameter of MCI_STEP command message }
const
  MCI_VD_STEP_FRAMES              = $00010000;
  MCI_VD_STEP_REVERSE             = $00020000;

{ flag for the MCI_ESCAPE command message }
const
  MCI_VD_ESCAPE_STRING            = $00000100;

{ parameter block for MCI_PLAY command message }
type
  PMCI_VD_Play_Parms = ^TMCI_VD_Play_Parms;
  tagMCI_VD_PLAY_PARMS = record
    dwCallback: DWord;
    dwFrom: DWord;
    dwTo: DWord;
    dwSpeed: DWord;
  end;
  TMCI_VD_Play_Parms = tagMCI_VD_PLAY_PARMS;
  MCI_VD_PLAY_PARMS = tagMCI_VD_PLAY_PARMS;

{ parameter block for MCI_STEP command message }
type
  PMCI_VD_Step_Parms = ^TMCI_VD_Step_Parms;
  tagMCI_VD_STEP_PARMS = record
    dwCallback: DWord;
    dwFrames: DWord;
  end;
  TMCI_VD_Step_Parms = tagMCI_VD_STEP_PARMS;
  MCI_VD_STEP_PARMS = tagMCI_VD_STEP_PARMS;

{ parameter block for MCI_ESCAPE command message }
type
  PMCI_VD_Escape_ParmsA = ^TMCI_VD_Escape_ParmsA;
  PMCI_VD_Escape_ParmsW = ^TMCI_VD_Escape_ParmsW;
  PMCI_VD_Escape_Parms = PMCI_VD_Escape_ParmsA;
  tagMCI_VD_ESCAPE_PARMSA = record
    dwCallback: DWord;
    lpstrCommand: PAnsiChar;
  end;
  tagMCI_VD_ESCAPE_PARMSW = record
    dwCallback: DWord;
    lpstrCommand: PWideChar;
  end;
  tagMCI_VD_ESCAPE_PARMS = tagMCI_VD_ESCAPE_PARMSA;
  TMCI_VD_Escape_ParmsA = tagMCI_VD_ESCAPE_PARMSA;
  TMCI_VD_Escape_ParmsW = tagMCI_VD_ESCAPE_PARMSW;
  TMCI_VD_Escape_Parms = TMCI_VD_Escape_ParmsA;
  MCI_VD_ESCAPE_PARMSA = tagMCI_VD_ESCAPE_PARMSA;
  MCI_VD_ESCAPE_PARMSW = tagMCI_VD_ESCAPE_PARMSW;
  MCI_VD_ESCAPE_PARMS = MCI_VD_ESCAPE_PARMSA;

{ MCI extensions for CD audio devices }

{ flags for the dwItem field of the MCI_STATUS_PARMS parameter block }
const
  MCI_CDA_STATUS_TYPE_TRACK       = $00004001;

{ flags for the dwReturn field of MCI_STATUS_PARMS parameter block }
{ MCI_STATUS command, (dwItem == MCI_CDA_STATUS_TYPE_TRACK) }
  MCI_CDA_TRACK_AUDIO             = MCI_CD_OFFSET + 0;
  MCI_CDA_TRACK_OTHER             = MCI_CD_OFFSET + 1;

{ MCI extensions for waveform audio devices }
  MCI_WAVE_PCM                    = MCI_WAVE_OFFSET + 0;
  MCI_WAVE_MAPPER                 = MCI_WAVE_OFFSET + 1;

{ flags for the dwFlags parameter of MCI_OPEN command message }
const
  MCI_WAVE_OPEN_BUFFER            = $00010000;

{ flags for the dwFlags parameter of MCI_SET command message }
const
  MCI_WAVE_SET_FORMATTAG          = $00010000;
  MCI_WAVE_SET_CHANNELS           = $00020000;
  MCI_WAVE_SET_SAMPLESPERSEC      = $00040000;
  MCI_WAVE_SET_AVGBYTESPERSEC     = $00080000;
  MCI_WAVE_SET_BLOCKALIGN         = $00100000;
  MCI_WAVE_SET_BITSPERSAMPLE      = $00200000;

{ flags for the dwFlags parameter of MCI_STATUS, MCI_SET command messages }
const
  MCI_WAVE_INPUT                  = $00400000;
  MCI_WAVE_OUTPUT                 = $00800000;

{ flags for the dwItem field of MCI_STATUS_PARMS parameter block }
const
  MCI_WAVE_STATUS_FORMATTAG       = $00004001;
  MCI_WAVE_STATUS_CHANNELS        = $00004002;
  MCI_WAVE_STATUS_SAMPLESPERSEC   = $00004003;
  MCI_WAVE_STATUS_AVGBYTESPERSEC  = $00004004;
  MCI_WAVE_STATUS_BLOCKALIGN      = $00004005;
  MCI_WAVE_STATUS_BITSPERSAMPLE   = $00004006;
  MCI_WAVE_STATUS_LEVEL           = $00004007;

{ flags for the dwFlags parameter of MCI_SET command message }
const
  MCI_WAVE_SET_ANYINPUT           = $04000000;
  MCI_WAVE_SET_ANYOUTPUT          = $08000000;

{ flags for the dwFlags parameter of MCI_GETDEVCAPS command message }
const
  MCI_WAVE_GETDEVCAPS_INPUTS      = $00004001;
  MCI_WAVE_GETDEVCAPS_OUTPUTS     = $00004002;

{ parameter block for MCI_OPEN command message }
type
  PMCI_Wave_Open_ParmsA = ^TMCI_Wave_Open_ParmsA;
  PMCI_Wave_Open_ParmsW = ^TMCI_Wave_Open_ParmsW;
  PMCI_Wave_Open_Parms = PMCI_Wave_Open_ParmsA;
  tagMCI_WAVE_OPEN_PARMSA = record
    dwCallback: DWord;
    wDeviceID: mciDeviceId;
    lpstrDeviceType: PAnsiChar;
    lpstrElementName: PAnsiChar;
    lpstrAlias: PAnsiChar;
    dwBufferSeconds: DWord;
  end;
  tagMCI_WAVE_OPEN_PARMSW = record
    dwCallback: DWord;
    wDeviceID: mciDeviceId;
    lpstrDeviceType: PWideChar;
    lpstrElementName: PWideChar;
    lpstrAlias: PWideChar;
    dwBufferSeconds: DWord;
  end;
  tagMCI_WAVE_OPEN_PARMS = tagMCI_WAVE_OPEN_PARMSA;
  TMCI_Wave_Open_ParmsA = tagMCI_WAVE_OPEN_PARMSA;
  TMCI_Wave_Open_ParmsW = tagMCI_WAVE_OPEN_PARMSW;
  TMCI_Wave_Open_Parms = TMCI_Wave_Open_ParmsA;
  MCI_WAVE_OPEN_PARMSA = tagMCI_WAVE_OPEN_PARMSA;
  MCI_WAVE_OPEN_PARMSW = tagMCI_WAVE_OPEN_PARMSW;
  MCI_WAVE_OPEN_PARMS = MCI_WAVE_OPEN_PARMSA;

{ parameter block for MCI_DELETE command message }
type
  PMCI_Wave_Delete_Parms = ^TMCI_Wave_Delete_Parms;
  tagMCI_WAVE_DELETE_PARMS = record
    dwCallback: DWord;
    dwFrom: DWord;
    dwTo: DWord;
  end;
  TMCI_Wave_Delete_Parms = tagMCI_WAVE_DELETE_PARMS;
  MCI_WAVE_DELETE_PARMS = tagMCI_WAVE_DELETE_PARMS;

{ parameter block for MCI_SET command message }
type
  PMCI_Wave_Set_Parms = ^TMCI_Wave_Set_Parms;
  tagMCI_WAVE_SET_PARMS = record
    dwCallback: DWord;
    dwTimeFormat: DWord;
    dwAudio: DWord;
    wInput: UInt;
    wOutput: UInt;
    wFormatTag: Word;
    wReserved2: Word;
    nChannels: Word;
    wReserved3: Word;
    nSamplesPerSec: DWord;
    nAvgBytesPerSec: DWord;
    nBlockAlign: Word;
    wReserved4: Word;
    wBitsPerSample: Word;
    wReserved5: Word;
  end;
  TMCI_Wave_Set_Parms = tagMCI_WAVE_SET_PARMS;
  MCI_WAVE_SET_PARMS = tagMCI_WAVE_SET_PARMS;


{ MCI extensions for MIDI sequencer devices }

{ flags for the dwReturn field of MCI_STATUS_PARMS parameter block }
{ MCI_STATUS command, (dwItem == MCI_SEQ_STATUS_DIVTYPE) }
const
  MCI_SEQ_DIV_PPQN            = 0 + MCI_SEQ_OFFSET;
  MCI_SEQ_DIV_SMPTE_24        = 1 + MCI_SEQ_OFFSET;
  MCI_SEQ_DIV_SMPTE_25        = 2 + MCI_SEQ_OFFSET;
  MCI_SEQ_DIV_SMPTE_30DROP    = 3 + MCI_SEQ_OFFSET;
  MCI_SEQ_DIV_SMPTE_30        = 4 + MCI_SEQ_OFFSET;

{ flags for the dwMaster field of MCI_SEQ_SET_PARMS parameter block }
{ MCI_SET command, (dwFlags == MCI_SEQ_SET_MASTER) }
const
  MCI_SEQ_FORMAT_SONGPTR      = $4001;
  MCI_SEQ_FILE                = $4002;
  MCI_SEQ_MIDI                = $4003;
  MCI_SEQ_SMPTE               = $4004;
  MCI_SEQ_NONE                = 65533;
  MCI_SEQ_MAPPER              = 65535;

{ flags for the dwItem field of MCI_STATUS_PARMS parameter block }
const
  MCI_SEQ_STATUS_TEMPO            = $00004002;
  MCI_SEQ_STATUS_PORT             = $00004003;
  MCI_SEQ_STATUS_SLAVE            = $00004007;
  MCI_SEQ_STATUS_MASTER           = $00004008;
  MCI_SEQ_STATUS_OFFSET           = $00004009;
  MCI_SEQ_STATUS_DIVTYPE          = $0000400A;
  MCI_SEQ_STATUS_NAME             = $0000400B;
  MCI_SEQ_STATUS_COPYRIGHT        = $0000400C;

{ flags for the dwFlags parameter of MCI_SET command message }
const
  MCI_SEQ_SET_TEMPO               = $00010000;
  MCI_SEQ_SET_PORT                = $00020000;
  MCI_SEQ_SET_SLAVE               = $00040000;
  MCI_SEQ_SET_MASTER              = $00080000;
  MCI_SEQ_SET_OFFSET              = $01000000;

{ parameter block for MCI_SET command message }
type
  PMCI_Seq_Set_Parms = ^TMCI_Seq_Set_Parms;
  tagMCI_SEQ_SET_PARMS = record
    dwCallback: DWord;
    dwTimeFormat: DWord;
    dwAudio: DWord;
    dwTempo: DWord;
    dwPort: DWord;
    dwSlave: DWord;
    dwMaster: DWord;
    dwOffset: DWord;
  end;
  TMCI_Seq_Set_Parms = tagMCI_SEQ_SET_PARMS;
  MCI_SEQ_SET_PARMS = tagMCI_SEQ_SET_PARMS;

{ MCI extensions for animation devices }

{ flags for dwFlags parameter of MCI_OPEN command message }
const
  MCI_ANIM_OPEN_WS                = $00010000;
  MCI_ANIM_OPEN_PARENT            = $00020000;
  MCI_ANIM_OPEN_NOSTATIC          = $00040000;

{ flags for dwFlags parameter of MCI_PLAY command message }
const
  MCI_ANIM_PLAY_SPEED             = $00010000;
  MCI_ANIM_PLAY_REVERSE           = $00020000;
  MCI_ANIM_PLAY_FAST              = $00040000;
  MCI_ANIM_PLAY_SLOW              = $00080000;
  MCI_ANIM_PLAY_SCAN              = $00100000;

{ flags for dwFlags parameter of MCI_STEP command message }
const
  MCI_ANIM_STEP_REVERSE           = $00010000;
  MCI_ANIM_STEP_FRAMES            = $00020000;

{ flags for dwItem field of MCI_STATUS_PARMS parameter block }
const
  MCI_ANIM_STATUS_SPEED           = $00004001;
  MCI_ANIM_STATUS_FORWARD         = $00004002;
  MCI_ANIM_STATUS_HWND            = $00004003;
  MCI_ANIM_STATUS_HPAL            = $00004004;
  MCI_ANIM_STATUS_STRETCH         = $00004005;

{ flags for the dwFlags parameter of MCI_INFO command message }
const
  MCI_ANIM_INFO_TEXT              = $00010000;

{ flags for dwItem field of MCI_GETDEVCAPS_PARMS parameter block }
const
  MCI_ANIM_GETDEVCAPS_CAN_REVERSE = $00004001;
  MCI_ANIM_GETDEVCAPS_FAST_RATE   = $00004002;
  MCI_ANIM_GETDEVCAPS_SLOW_RATE   = $00004003;
  MCI_ANIM_GETDEVCAPS_NORMAL_RATE = $00004004;
  MCI_ANIM_GETDEVCAPS_PALETTES    = $00004006;
  MCI_ANIM_GETDEVCAPS_CAN_STRETCH = $00004007;
  MCI_ANIM_GETDEVCAPS_MAX_WINDOWS = $00004008;

{ flags for the MCI_REALIZE command message }
const
  MCI_ANIM_REALIZE_NORM           = $00010000;
  MCI_ANIM_REALIZE_BKGD           = $00020000;

{ flags for dwFlags parameter of MCI_WINDOW command message }
const
  MCI_ANIM_WINDOW_HWND            = $00010000;
  MCI_ANIM_WINDOW_STATE           = $00040000;
  MCI_ANIM_WINDOW_TEXT            = $00080000;
  MCI_ANIM_WINDOW_ENABLE_STRETCH  = $00100000;
  MCI_ANIM_WINDOW_DISABLE_STRETCH = $00200000;

{ flags for hWnd field of MCI_ANIM_WINDOW_PARMS parameter block }
{ MCI_WINDOW command message, (dwFlags == MCI_ANIM_WINDOW_HWND) }
const
  MCI_ANIM_WINDOW_DEFAULT         = $00000000;

{ flags for dwFlags parameter of MCI_PUT command message }
const
  MCI_ANIM_RECT                   = $00010000;
  MCI_ANIM_PUT_SOURCE             = $00020000;
  MCI_ANIM_PUT_DESTINATION        = $00040000;

{ flags for dwFlags parameter of MCI_WHERE command message }
const
  MCI_ANIM_WHERE_SOURCE           = $00020000;
  MCI_ANIM_WHERE_DESTINATION      = $00040000;

{ flags for dwFlags parameter of MCI_UPDATE command message }
const
  MCI_ANIM_UPDATE_HDC             = $00020000;

{ parameter block for MCI_OPEN command message }
type
  PMCI_Anim_Open_ParmsA = ^TMCI_Anim_Open_ParmsA;
  PMCI_Anim_Open_ParmsW = ^TMCI_Anim_Open_ParmsW;
  PMCI_Anim_Open_Parms = PMCI_Anim_Open_ParmsA;
  tagMCI_ANIM_OPEN_PARMSA = record
    dwCallback: DWord;
    wDeviceID: mciDeviceId;
    lpstrDeviceType: PAnsiChar;
    lpstrElementName: PAnsiChar;
    lpstrAlias: PAnsiChar;
    dwStyle: DWord;
    hWndParent: HWND;
  end;
  tagMCI_ANIM_OPEN_PARMSW = record
    dwCallback: DWord;
    wDeviceID: mciDeviceId;
    lpstrDeviceType: PWideChar;
    lpstrElementName: PWideChar;
    lpstrAlias: PWideChar;
    dwStyle: DWord;
    hWndParent: HWND;
  end;
  tagMCI_ANIM_OPEN_PARMS = tagMCI_ANIM_OPEN_PARMSA;
  TMCI_Anim_Open_ParmsA = tagMCI_ANIM_OPEN_PARMSA;
  TMCI_Anim_Open_ParmsW = tagMCI_ANIM_OPEN_PARMSW;
  TMCI_Anim_Open_Parms = TMCI_Anim_Open_ParmsA;
  MCI_ANIM_OPEN_PARMSA = tagMCI_ANIM_OPEN_PARMSA;
  MCI_ANIM_OPEN_PARMSW = tagMCI_ANIM_OPEN_PARMSW;
  MCI_ANIM_OPEN_PARMS = MCI_ANIM_OPEN_PARMSA;

{ parameter block for MCI_PLAY command message }
type
  PMCI_Anim_Play_Parms = ^TMCI_Anim_Play_Parms;
  tagMCI_ANIM_PLAY_PARMS = record
    dwCallback: DWord;
    dwFrom: DWord;
    dwTo: DWord;
    dwSpeed: DWord;
  end;
  TMCI_Anim_Play_Parms = tagMCI_ANIM_PLAY_PARMS;
  MCI_ANIM_PLAY_PARMS = tagMCI_ANIM_PLAY_PARMS;

{ parameter block for MCI_STEP command message }
type
  PMCI_Anim_Step_Parms = ^TMCI_Anim_Step_Parms;
  tagMCI_ANIM_STEP_PARMS = record
    dwCallback: DWord;
    dwFrames: DWord;
  end;
  TMCI_Anim_Step_Parms = tagMCI_ANIM_STEP_PARMS;
  MCI_ANIM_STEP_PARMS = tagMCI_ANIM_STEP_PARMS;

{ parameter block for MCI_WINDOW command message }
type
  PMCI_Anim_Window_ParmsA = ^TMCI_Anim_Window_ParmsA;
  PMCI_Anim_Window_ParmsW = ^TMCI_Anim_Window_ParmsW;
  PMCI_Anim_Window_Parms = PMCI_Anim_Window_ParmsA;
  tagMCI_ANIM_WINDOW_PARMSA = record
    dwCallback: DWord;
    Wnd: HWND;  { formerly "hWnd" }
    nCmdShow: UInt;
    lpstrText: PAnsiChar;
  end;
  tagMCI_ANIM_WINDOW_PARMSW = record
    dwCallback: DWord;
    Wnd: HWND;  { formerly "hWnd" }
    nCmdShow: UInt;
    lpstrText: PWideChar;
  end;
  tagMCI_ANIM_WINDOW_PARMS = tagMCI_ANIM_WINDOW_PARMSA;
  TMCI_Anim_Window_ParmsA = tagMCI_ANIM_WINDOW_PARMSA;
  TMCI_Anim_Window_ParmsW = tagMCI_ANIM_WINDOW_PARMSW;
  TMCI_Anim_Window_Parms = TMCI_Anim_Window_ParmsA;
  MCI_ANIM_WINDOW_PARMSA = tagMCI_ANIM_WINDOW_PARMSA;
  MCI_ANIM_WINDOW_PARMSW = tagMCI_ANIM_WINDOW_PARMSW;
  MCI_ANIM_WINDOW_PARMS = MCI_ANIM_WINDOW_PARMSA;

{ parameter block for MCI_PUT, MCI_UPDATE, MCI_WHERE command messages }
type
  PMCI_Anim_Rect_Parms = ^ TMCI_Anim_Rect_Parms;
  tagMCI_ANIM_RECT_PARMS = record
    dwCallback: DWord;
    rc: TRect;
  end;
  TMCI_Anim_Rect_Parms = tagMCI_ANIM_RECT_PARMS;
  MCI_ANIM_RECT_PARMS = tagMCI_ANIM_RECT_PARMS;

{ parameter block for MCI_UPDATE PARMS }
type
  PMCI_Anim_Update_Parms = ^TMCI_Anim_Update_Parms;
  tagMCI_ANIM_UPDATE_PARMS = record
    dwCallback: DWord;
    rc: TRect;
    hDC: HDC;
  end;
  TMCI_Anim_Update_Parms = tagMCI_ANIM_UPDATE_PARMS;
  MCI_ANIM_UPDATE_PARMS = tagMCI_ANIM_UPDATE_PARMS;

{ MCI extensions for video overlay devices }

{ flags for dwFlags parameter of MCI_OPEN command message }
const
  MCI_OVLY_OPEN_WS                = $00010000;
  MCI_OVLY_OPEN_PARENT            = $00020000;

{ flags for dwFlags parameter of MCI_STATUS command message }
const
  MCI_OVLY_STATUS_HWND            = $00004001;
  MCI_OVLY_STATUS_STRETCH         = $00004002;

{ flags for dwFlags parameter of MCI_INFO command message }
const
  MCI_OVLY_INFO_TEXT              = $00010000;

{ flags for dwItem field of MCI_GETDEVCAPS_PARMS parameter block }
const
  MCI_OVLY_GETDEVCAPS_CAN_STRETCH = $00004001;
  MCI_OVLY_GETDEVCAPS_CAN_FREEZE  = $00004002;
  MCI_OVLY_GETDEVCAPS_MAX_WINDOWS = $00004003;

{ flags for dwFlags parameter of MCI_WINDOW command message }
const
  MCI_OVLY_WINDOW_HWND            = $00010000;
  MCI_OVLY_WINDOW_STATE           = $00040000;
  MCI_OVLY_WINDOW_TEXT            = $00080000;
  MCI_OVLY_WINDOW_ENABLE_STRETCH  = $00100000;
  MCI_OVLY_WINDOW_DISABLE_STRETCH = $00200000;

{ flags for hWnd parameter of MCI_OVLY_WINDOW_PARMS parameter block }
const
  MCI_OVLY_WINDOW_DEFAULT         = $00000000;

{ flags for dwFlags parameter of MCI_PUT command message }
const
  MCI_OVLY_RECT                   = $00010000;
  MCI_OVLY_PUT_SOURCE             = $00020000;
  MCI_OVLY_PUT_DESTINATION        = $00040000;
  MCI_OVLY_PUT_FRAME              = $00080000;
  MCI_OVLY_PUT_VIDEO              = $00100000;

{ flags for dwFlags parameter of MCI_WHERE command message }
const
  MCI_OVLY_WHERE_SOURCE           = $00020000;
  MCI_OVLY_WHERE_DESTINATION      = $00040000;
  MCI_OVLY_WHERE_FRAME            = $00080000;
  MCI_OVLY_WHERE_VIDEO            = $00100000;

{ parameter block for MCI_OPEN command message }
type
  PMCI_Ovly_Open_ParmsA = ^TMCI_Ovly_Open_ParmsA;
  PMCI_Ovly_Open_ParmsW = ^TMCI_Ovly_Open_ParmsW;
  PMCI_Ovly_Open_Parms = PMCI_Ovly_Open_ParmsA;
  tagMCI_OVLY_OPEN_PARMSA = record
    dwCallback: DWord;
    wDeviceID: mciDeviceId;
    lpstrDeviceType: PAnsiChar;
    lpstrElementName: PAnsiChar;
    lpstrAlias: PAnsiChar;
    dwStyle: DWord;
    hWndParent: HWND;
  end;
  tagMCI_OVLY_OPEN_PARMSW = record
    dwCallback: DWord;
    wDeviceID: mciDeviceId;
    lpstrDeviceType: PWideChar;
    lpstrElementName: PWideChar;
    lpstrAlias: PWideChar;
    dwStyle: DWord;
    hWndParent: HWND;
  end;
  tagMCI_OVLY_OPEN_PARMS = tagMCI_OVLY_OPEN_PARMSA;
  TMCI_Ovly_Open_ParmsA = tagMCI_OVLY_OPEN_PARMSA;
  TMCI_Ovly_Open_ParmsW = tagMCI_OVLY_OPEN_PARMSW;
  TMCI_Ovly_Open_Parms = TMCI_Ovly_Open_ParmsA;
  MCI_OVLY_OPEN_PARMSA = tagMCI_OVLY_OPEN_PARMSA;
  MCI_OVLY_OPEN_PARMSW = tagMCI_OVLY_OPEN_PARMSW;
  MCI_OVLY_OPEN_PARMS = MCI_OVLY_OPEN_PARMSA;

{ parameter block for MCI_WINDOW command message }
type
  PMCI_Ovly_Window_ParmsA = ^TMCI_Ovly_Window_ParmsA;
  PMCI_Ovly_Window_ParmsW = ^TMCI_Ovly_Window_ParmsW;
  PMCI_Ovly_Window_Parms = PMCI_Ovly_Window_ParmsA;
  tagMCI_OVLY_WINDOW_PARMSA = record
    dwCallback: DWord;
    WHandle: HWND; { formerly "hWnd"}
    nCmdShow: UInt;
    lpstrText: PAnsiChar;
  end;
  tagMCI_OVLY_WINDOW_PARMSW = record
    dwCallback: DWord;
    WHandle: HWND; { formerly "hWnd"}
    nCmdShow: UInt;
    lpstrText: PWideChar;
  end;
  tagMCI_OVLY_WINDOW_PARMS = tagMCI_OVLY_WINDOW_PARMSA;
  TMCI_Ovly_Window_ParmsA = tagMCI_OVLY_WINDOW_PARMSA;
  TMCI_Ovly_Window_ParmsW = tagMCI_OVLY_WINDOW_PARMSW;
  TMCI_Ovly_Window_Parms = TMCI_Ovly_Window_ParmsA;
  MCI_OVLY_WINDOW_PARMSA = tagMCI_OVLY_WINDOW_PARMSA;
  MCI_OVLY_WINDOW_PARMSW = tagMCI_OVLY_WINDOW_PARMSW;
  MCI_OVLY_WINDOW_PARMS = MCI_OVLY_WINDOW_PARMSA;

{ parameter block for MCI_PUT, MCI_UPDATE, and MCI_WHERE command messages }
type
  PMCI_Ovly_Rect_Parms = ^ TMCI_Ovly_Rect_Parms;
  tagMCI_OVLY_RECT_PARMS = record
    dwCallback: DWord;
    rc: TRect;
  end;
  TMCI_Ovly_Rect_Parms = tagMCI_OVLY_RECT_PARMS;
  MCI_OVLY_RECT_PARMS = tagMCI_OVLY_RECT_PARMS;

{ parameter block for MCI_SAVE command message }
type
  PMCI_Ovly_Save_ParmsA = ^TMCI_Ovly_Save_ParmsA;
  PMCI_Ovly_Save_ParmsW = ^TMCI_Ovly_Save_ParmsW;
  PMCI_Ovly_Save_Parms = PMCI_Ovly_Save_ParmsA;
  tagMCI_OVLY_SAVE_PARMSA = record
    dwCallback: DWord;
    lpfilename: PAnsiChar;
    rc: TRect;
  end;
  tagMCI_OVLY_SAVE_PARMSW = record
    dwCallback: DWord;
    lpfilename: PWideChar;
    rc: TRect;
  end;
  tagMCI_OVLY_SAVE_PARMS = tagMCI_OVLY_SAVE_PARMSA;
  TMCI_Ovly_Save_ParmsA = tagMCI_OVLY_SAVE_PARMSA;
  TMCI_Ovly_Save_ParmsW = tagMCI_OVLY_SAVE_PARMSW;
  TMCI_Ovly_Save_Parms = TMCI_Ovly_Save_ParmsA;
  MCI_OVLY_SAVE_PARMSA = tagMCI_OVLY_SAVE_PARMSA;
  MCI_OVLY_SAVE_PARMSW = tagMCI_OVLY_SAVE_PARMSW;
  MCI_OVLY_SAVE_PARMS = MCI_OVLY_SAVE_PARMSA;

{ parameter block for MCI_LOAD command message }
type
  PMCI_Ovly_Load_ParmsA = ^TMCI_Ovly_Load_ParmsA;
  PMCI_Ovly_Load_ParmsW = ^TMCI_Ovly_Load_ParmsW;
  PMCI_Ovly_Load_Parms = PMCI_Ovly_Load_ParmsA;
  tagMCI_OVLY_LOAD_PARMSA = record
    dwCallback: DWord;
    lpfilename: PAnsiChar;
    rc: TRect;
  end;
  tagMCI_OVLY_LOAD_PARMSW = record
    dwCallback: DWord;
    lpfilename: PWideChar;
    rc: TRect;
  end;
  tagMCI_OVLY_LOAD_PARMS = tagMCI_OVLY_LOAD_PARMSA;
  TMCI_Ovly_Load_ParmsA = tagMCI_OVLY_LOAD_PARMSA;
  TMCI_Ovly_Load_ParmsW = tagMCI_OVLY_LOAD_PARMSW;
  TMCI_Ovly_Load_Parms = TMCI_Ovly_Load_ParmsA;
  MCI_OVLY_LOAD_PARMSA = tagMCI_OVLY_LOAD_PARMSA;
  MCI_OVLY_LOAD_PARMSW = tagMCI_OVLY_LOAD_PARMSW;
  MCI_OVLY_LOAD_PARMS = MCI_OVLY_LOAD_PARMSA;


// Display driver extensions

const
  NEWTRANSPARENT  = 3;           { use with SetBkMode() }
  QUERYROPSUPPORT = 40;          { use to determine ROP support }

// DIB driver extensions

const
  SELECTDIB       = 41;                      { DIB.DRV select dib escape }

function DIBIndex(N: Integer): Longint;

// Support for screen savers

// The current application will receive a syscommand of SC_SCREENSAVE just
// before the screen saver is invoked.  If the app wishes to prevent a
// screen save, return a non-zero value, otherwise call DefWindowProc().

const
  SC_SCREENSAVE   = $F140;

implementation

function mciExecute;                    external;
function mciGetCreatorTask;             external;
function mciGetDeviceID;                external;
function mciGetDeviceIDFromElementID;   external;
function mciGetErrorString;             external;
function mciGetYieldProc;               external;
function mciSendCommand;                external;
function mciSendString;                 external;
function mciSetYieldProc;               external;
function midiConnect;                   external;
function midiDisconnect;                external;
function midiInAddBuffer;               external;
function midiInClose;                   external;
function midiInGetDevCaps;              external;
function midiInGetErrorText;            external;
function midiInGetID;                   external;
function midiInGetNumDevs;              external;
function midiInMessage;                 external;
function midiInOpen;                    external;
function midiInPrepareHeader;           external;
function midiInReset;                   external;
function midiInStart;                   external;
function midiInStop;                    external;
function midiInUnprepareHeader;         external;
function midiOutCacheDrumPatches;       external;
function midiOutCachePatches;           external;
function midiOutClose;                  external;
function midiOutGetDevCaps;             external;
function midiOutGetErrorText;           external;
function midiOutGetID;                  external;
function midiOutGetNumDevs;             external;
function midiOutGetVolume;              external;
function midiOutLongMsg;                external;
function midiOutMessage;                external;
function midiOutOpen;                   external;
function midiOutPrepareHeader;          external;
function midiOutReset;                  external;
function midiOutSetVolume;              external;
function midiOutShortMsg;               external;
function midiOutUnprepareHeader;        external;
function midiStreamClose;               external;
function midiStreamOpen;                external;
function midiStreamOut;                 external;
function midiStreamPause;               external;
function midiStreamPosition;            external;
function midiStreamProperty;            external;
function midiStreamRestart;             external;
function midiStreamStop;                external;
function auxGetDevCaps;                 external;
function auxGetNumDevs;                 external;
function auxGetVolume;                  external;
function auxOutMessage;                 external;
function auxSetVolume;                  external;
function CloseDriver;                   external;
function DefDriverProc;                 external;
function DrvGetModuleHandle;            external;
function GetDriverModuleHandle;         external;
function joyGetDevCaps;                 external;
function joyGetNumDevs;                 external;
function joyGetPos;                     external;
function joyGetPosEx;                   external;
function joyGetThreshold;               external;
function joyReleaseCapture;             external;
function joySetCapture;                 external;
function joySetThreshold;               external;
function mixerClose;                    external;
function mixerGetControlDetails;        external;
function mixerGetDevCaps;               external;
function mixerGetID;                    external;
function mixerGetLineControls;          external;
function mixerGetLineInfo;              external;
function mixerGetNumDevs;               external;
function mixerMessage;                  external;
function mixerOpen;                     external;
function mixerSetControlDetails;        external;
function mmioAdvance;                   external;
function mmioAscend;                    external;
function mmioClose;                     external;
function mmioCreateChunk;               external;
function mmioDescend;                   external;
function mmioFlush;                     external;
function mmioGetInfo;                   external;
function mmioInstallIOProc;             external;
function mmioOpen;                      external;
function mmioRead;                      external;
function mmioRename;                    external;
function mmioSeek;                      external;
function mmioSendMessage;               external;
function mmioSetBuffer;                 external;
function mmioSetInfo;                   external;
function mmioStringToFOURCC;            external;
function mmioWrite;                     external;
function mmsystemGetVersion;            external;
function OpenDriver;                    external;
function PlaySound;                     external;
function SendDriverMessage;             external;
function sndPlaySound;                  external;
function timeBeginPeriod;               external;
function timeEndPeriod;                 external;
function timeGetDevCaps;                external;
function timeGetSystemTime;             external;
function timeGetTime;                   external;
function timeKillEvent;                 external;
function timeSetEvent;                  external;
function waveInAddBuffer;               external;
function waveInClose;                   external;
function waveInGetDevCaps;              external;
function waveInGetErrorText;            external;
function waveInGetID;                   external;
function waveInGetNumDevs;              external;
function waveInGetPosition;             external;
function waveInMessage;                 external;
function waveInOpen;                    external;
function waveInPrepareHeader;           external;
function waveInReset;                   external;
function waveInStart;                   external;
function waveInStop;                    external;
function waveInUnprepareHeader;         external;
function waveOutBreakLoop;              external;
function waveOutClose;                  external;
function waveOutGetDevCaps;             external;
function waveOutGetErrorText;           external;
function waveOutGetID;                  external;
function waveOutGetNumDevs;             external;
function waveOutGetPitch;               external;
function waveOutGetPlaybackRate;        external;
function waveOutGetPosition;            external;
function waveOutGetVolume;              external;
function waveOutMessage;                external;
function waveOutOpen;                   external;
function waveOutPause;                  external;
function waveOutPrepareHeader;          external;
function waveOutReset;                  external;
function waveOutRestart;                external;
function waveOutSetPitch;               external;
function waveOutSetPlaybackRate;        external;
function waveOutSetVolume;              external;
function waveOutUnprepareHeader;        external;
function waveOutWrite;                  external;

function mci_MSF_Minute(msf: Longint): Byte;
begin
  Result := LoByte(LoWord(msf));
end;

function mci_MSF_Second(msf: Longint): Byte;
begin
  Result := HiByte(LoWord(msf));
end;

function mci_MSF_Frame(msf: Longint): Byte;
begin
  Result := LoByte(HiWord(msf));
end;

function mci_Make_MSF(m, s, f: Byte): Longint;
begin
  Result := Longint(m or (s shl 8) or (f shl 16));
end;

function mci_TMSF_Track(tmsf: Longint): Byte;
begin
  Result := LoByte(LoWord(tmsf));
end;

function mci_TMSF_Minute(tmsf: Longint): Byte;
begin
  Result := HiByte(LoWord(tmsf));
end;

function mci_TMSF_Second(tmsf: Longint): Byte;
begin
  Result := LoByte(HiWord(tmsf));
end;

function mci_TMSF_Frame(tmsf: Longint): Byte;
begin
  Result := HiByte(HiWord(tmsf));
end;

function mci_Make_TMSF(t, m, s, f: Byte): Longint;
begin
  Result := Longint(t or (m shl 8) or (s shl 16) or (f shl 24));
end;

function mci_HMS_Hour(hms: Longint): Byte;
begin
  Result := LoByte(LoWord(hms));
end;

function mci_HMS_Minute(hms: Longint): Byte;
begin
  Result := HiByte(LoWord(hms));
end;

function mci_HMS_Second(hms: Longint): Byte;
begin
  Result := LoByte(HiWord(hms));
end;

function mci_Make_HMS(h, m, s: Byte): Longint;
begin
  Result := Longint(h or (m shl 8) or (s shl 16));
end;

function DIBIndex(N: Integer): Longint;
begin
  Result := MakeLong(N, $10FF);
end;

end.
