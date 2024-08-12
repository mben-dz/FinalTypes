unit API.FinalTypes;

interface

uses
  System.Classes,

{$IF Defined(FRAMEWORK_FMX)}
  FMX.Graphics,
  FMX.Controls;
{$ELSEIF Defined(FRAMEWORK_VCL)}
  Vcl.Graphics,
  Vcl.Controls;
{$ELSE}
  {$MESSAGE ERROR 'No framework defined'}
{$ENDIF}

type
  {$IF Defined(FRAMEWORK_FMX)}
  TPresentedTextControlHelper = class helper for FMX.StdCtrls.TPresentedTextControl
  private
    function GetTxt: string;
    procedure SetTxt(const aValue: string);
  public
    property Txt: string read GetLabel write SetLabel;
  end;
 {$ELSEIF Defined(FRAMEWORK_VCL)}
  TControl = class helper for Vcl.Controls.TControl
  private
    function GetTxt: string;
    procedure SetTxt(const aValue: string);
  public
    property Txt: string read GetTxt write SetTxt;
  end;
 {$ENDIF}


  TFinalPicture = class;

  {$IF Defined(FRAMEWORK_FMX)}
  TBitmapFmxHelper = class helper for FMX.Graphics.TBitmap
  public
    function ToFinalPicture: TFinalPicture;
  end;
  {$ELSEIF Defined(FRAMEWORK_VCL)}
  TPictureHelper = class helper for Vcl.Graphics.TPicture
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
  {$ENDIF}
  end;
//  TFinalPictureMETA = class of TFinalPicture;

  TMemoryStreamHelper = class helper for TMemoryStream
    function DecodeBase64: TMemoryStream;
  end;
  TStringStreamHelper = class helper for TStringStream
    function DecodeBase64: TMemoryStream;
  end;

implementation

uses
  System.NetEncoding,
  System.SysUtils,
  Vcl.Imaging.jpeg,
  Vcl.Imaging.GIFImg,
  Vcl.Imaging.pngimage;

{ TFinalPicture }

class function TFinalPicture.GetFinalPicture: TFinalPicture;
begin
  Result := TFinalPicture.Create;
end;

{$IF Defined(FRAMEWORK_FMX)}
class function TFinalPicture.GetFinalPicture(aWidth, aHeight: Integer): TFinalPicture;
begin
  Result := TFinalPicture.Create(aWidth, aHeight);
end;
{$ENDIF}

{$IF Defined(FRAMEWORK_FMX)}

{ TBitmapFmxHelper }

function TBitmapFmxHelper.ToFinalPicture: TFinalPicture;
begin
  Result := TFinalPicture(Self);
end;
{$ELSEIF Defined(FRAMEWORK_VCL)}

{ TPictureHelper }

function TPictureHelper.ToFinalPicture: TFinalPicture;
begin
  Result := TFinalPicture(Self);
end;
{$ENDIF}

{ TMemoryStreamHelper }
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

{ TStringStreamHelper }

function TStringStreamHelper.DecodeBase64: TMemoryStream;
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
{$IF Defined(FRAMEWORK_FMX)}
 {TPresentedTextControlHelper}

function TPresentedTextControl.GetTxt: string;
begin
  Result := Self.Text;
end;

procedure TPresentedTextControl.SetTxt(const aValue: string);
begin
  Self.Text := aValue;
end;
{$ELSEIF Defined(FRAMEWORK_VCL)}
{ TControl }

function TControl.GetTxt: string;
begin
  Result := Self.Text;
end;

procedure TControl.SetTxt(const aValue: string);
begin
  Self.Text := aValue;
end;
{$ENDIF}

end.
