unit API.FinalTypes;

interface

uses
  System.Classes
{$IF Defined(FRAMEWORK_FMX)}
  , FMX.Graphics,
  FMX.Controls;
{$ELSEIF Defined(FRAMEWORK_VCL)}
  , Vcl.Graphics,
  Vcl.Controls;
{$ELSE}
  {$MESSAGE ERROR 'No framework defined'}
{$ENDIF}

type

{$IF Defined(FRAMEWORK_FMX)}

  TFMXControlHelper = class helper for FMX.Controls.TControl
  strict private
    function GetTxt: string;
    procedure SetTxt(const aValue: string);
  public
    property Txt: string read GetTxt write SetTxt;
  end;

{$ELSEIF Defined(FRAMEWORK_VCL)}

  TControlHelper = class helper for Vcl.Controls.TControl
  strict private
    function GetTxt: string;
    procedure SetTxt(const aValue: string);
  public
    property Txt: string read GetTxt write SetTxt;
  end;

{$ENDIF}


  TFinalPicture = class;

{$IF Defined(FRAMEWORK_FMX)}

  TFmxBitmapHelper = class helper for FMX.Graphics.TBitmap
  public
    function ToFinalPicture: TFinalPicture;
  end;

{$ELSEIF Defined(FRAMEWORK_VCL)}

  TVclPictureHelper = class helper for Vcl.Graphics.TPicture
  public
    function ToFinalPicture: TFinalPicture;
  end;

{$ENDIF}

  TFinalPicture = class(
    {$IF Defined(FRAMEWORK_FMX)}
      FMX.Graphics.TBitmap)
    {$ELSE}
      Vcl.Graphics.TPicture)
    {$ENDIF}
  public
    class function GetFinalPicture: TFinalPicture; overload; static;
  {$IF Defined(FRAMEWORK_FMX)}
    class function GetFinalPicture(aWidth, aHeight: Integer): TFinalPicture; overload; static;
  {$ELSEIF Defined(FRAMEWORK_VCL)}

  {$ENDIF}
  end;

  TMemoryStreamHelper = class helper for TMemoryStream
  public
    function DecodeBase64: TMemoryStream;
  end;

implementation

uses
  System.NetEncoding,
  System.SysUtils
{$IF Defined(FRAMEWORK_FMX)}
  , FMX.Memo,
  FMX.ActnList // ICaption
{$ELSEIF Defined(FRAMEWORK_VCL)}
  , Vcl.StdCtrls,
  Vcl.Imaging.jpeg,
  Vcl.Imaging.GIFImg,
  Vcl.Imaging.pngimage
  {$ENDIF};

{$REGION '  TFinalPicture .. '}
class function TFinalPicture.GetFinalPicture: TFinalPicture;
begin
  Result := TFinalPicture.Create;
end;

{$IF Defined(FRAMEWORK_FMX)}
class function TFinalPicture.GetFinalPicture(aWidth, aHeight: Integer): TFinalPicture;
begin
  Result := TFinalPicture.Create(aWidth, aHeight);
end;
{$ELSEIF Defined(FRAMEWORK_VCL)}
{$ENDIF}

{$IF Defined(FRAMEWORK_FMX)}

function TFmxBitmapHelper.ToFinalPicture: TFinalPicture;
begin
  Result := TFinalPicture(Self);
end;

{$ELSEIF Defined(FRAMEWORK_VCL)}
function TVclPictureHelper.ToFinalPicture: TFinalPicture;
begin
  Result := TFinalPicture(Self);
end;
{$ENDIF}
{$ENDREGION}

{$REGION '  [FMX.TControl|VCL.TControl] Helpers .. '}
{$IF Defined(FRAMEWORK_FMX)}

function TFMXControlHelper.GetTxt: string;
var
  LCaptionControl: ICaption;
begin
  // Check if the control supports the ICaption interface
  if Supports(Self, ICaption, LCaptionControl) then
    Result := LCaptionControl.Text else
  if (Self) is (TMemo) then // in VCL is just a Derived TControl !!
    Result := TMemo(Self).Text else
    raise Exception.Create('This control does not support setting text.');
end;

procedure TFMXControlHelper.SetTxt(const aValue: string);
var
  LCaptionControl: ICaption;
begin
  // Check if the control supports the ICaption interface
  if Supports(Self, ICaption, LCaptionControl) then
    LCaptionControl.Text := aValue else
  if (Self) is (TMemo) then
    TMemo(Self).Text := aValue else
    raise Exception.Create('This control does not support setting text.');
end;

{$ELSEIF Defined(FRAMEWORK_VCL)}

function TControlHelper.GetTxt: string;
begin
  Result := Self.Text;
end;

procedure TControlHelper.SetTxt(const aValue: string);
begin
  Self.Text := aValue;
end;
{$ENDIF}
{$ENDREGION}

{$REGION '  TMemoryStream Helper .. '}
function TMemoryStreamHelper.DecodeBase64: TMemoryStream;
var
  LOutput: TMemoryStream;
begin
  LOutput := TMemoryStream.Create;
  try
    Position := 0;

    TNetEncoding.Base64.Decode(Self, LOutput);
    LOutput.Position := 0;
    Clear;
    LOutput.SaveToStream(Self);
  finally
    LOutput.Free;
  end;
  Position := 0;
  Result := Self;
end;
{$ENDREGION}

end.
