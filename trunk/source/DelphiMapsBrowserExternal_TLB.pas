unit DelphiMapsBrowserExternal_TLB;

// ************************************************************************ //
// WARNING
// -------
// The types declared in this file were generated from data read from a
// Type Library. If this type library is explicitly or indirectly (via
// another type library referring to this type library) re-imported, or the
// 'Refresh' command of the Type Library Editor activated while editing the
// Type Library, the contents of this file will be regenerated and all
// manual modifications will be lost.
// ************************************************************************ //

// $Rev: 31855 $
// File generated on 28-10-2010 1:54:02 from Type Library described below.

// ************************************************************************  //
// Type Lib: H:\Program Files\Borland\Delphi7\Lib\ARS\DelphiMaps\trunk\source\DelphiMapsBrowserExternal (1)
// LIBID: {517F7078-5E73-4E5A-B8A2-8F0FF14EF21B}
// LCID: 0
// Helpfile:
// HelpString: DephiMaps Library
// DepndLst:
//   (1) v2.0 stdole, (H:\WINDOWS\system32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}
interface

uses Windows, ActiveX, Classes, Graphics, StdVCL, Variants;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  DelphiMapsBrowserExternalMajorVersion = 1;
  DelphiMapsBrowserExternalMinorVersion = 0;

  LIBID_DelphiMapsBrowserExternal: TGUID = '{517F7078-5E73-4E5A-B8A2-8F0FF14EF21B}';

  IID_IDelphiMaps: TGUID = '{49F434EE-0C48-4D7A-B32D-7D31D2C7154D}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IDelphiMaps = interface;
  IDelphiMapsDisp = dispinterface;

// *********************************************************************//
// Interface: IDelphiMaps
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {49F434EE-0C48-4D7A-B32D-7D31D2C7154D}
// *********************************************************************//
  IDelphiMaps = interface(IDispatch)
    ['{49F434EE-0C48-4D7A-B32D-7D31D2C7154D}']
    procedure triggerEvent(const EventName: WideString); safecall;
    procedure showMessage(const aText: WideString); safecall;
  end;

// *********************************************************************//
// DispIntf:  IDelphiMapsDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {49F434EE-0C48-4D7A-B32D-7D31D2C7154D}
// *********************************************************************//
  IDelphiMapsDisp = dispinterface
    ['{49F434EE-0C48-4D7A-B32D-7D31D2C7154D}']
    procedure triggerEvent(const EventName: WideString); dispid 202;
    procedure showMessage(const aText: WideString); dispid 203;
  end;

implementation

uses ComObj;

end.

