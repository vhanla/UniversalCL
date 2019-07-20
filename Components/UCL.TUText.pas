unit UCL.TUText;

interface

uses
  UCL.Classes, UCL.TUThemeManager, UCL.Utils,
  System.Classes, System.SysUtils,
  Winapi.Windows, GdiPAPI, GdipObj,
  VCL.Controls, VCL.StdCtrls, VCL.Graphics;

type
  TUTextKind = (tkNormal, tkDescription, tkEntry, tkHeading, tkTitle);

  TUText = class(TLabel, IUThemeControl)
    private
      FThemeManager: TUThemeManager;
      FTextKind: TUTextKind;

      procedure SetThemeManager(const Value: TUThemeManager);
      procedure SetTextKind(Value: TUTextKind);

    public
      constructor Create(aOwner: TComponent); override;
      procedure UpdateTheme;
      procedure UpdateTextKind;

    protected
      procedure Paint; override;

    published
      property ThemeManager: TUThemeManager read FThemeManager write SetThemeManager;
      property TextKind: TUTextKind read FTextKind write SetTextKind default tkNormal;
  end;

implementation

{ THEME }

procedure TUText.SetThemeManager(const Value: TUThemeManager);
begin
  if Value <> FThemeManager then
    begin
      //  Disconnect current ThemeManager
      if FThemeManager <> nil then
        FThemeManager.DisconnectControl(Self);

      //  Connect to new ThemeManager
      if Value <> nil then
        Value.ConnectControl(Self);

      FThemeManager := Value;
      UpdateTheme;
    end;
end;

procedure TUText.UpdateTheme;
begin
  //  Font color
  if TextKind = tkDescription then
    Font.Color := $666666
  else if ThemeManager = nil then
    Font.Color := $000000
  else if ThemeManager.Theme = utLight then
    Font.Color := $000000
  else
    Font.Color := $FFFFFF;
end;

{ SETTERS }

procedure TUText.Paint;
var
  TextX, TextY, TextW, TextH: Integer;

  bmp: TBitmap;
  gfont: TGPFont;
  ggraph: TGPGraphics;
  gpen: TGPPen;
  gbrush: TGPSolidBrush;
  gstring: TGPStringFormat;
  gtxt: WideString;
begin
  inherited;
// Draw using GdiPlus
  bmp := TBitmap.Create;
  try
    bmp.PixelFormat := pf32bit;
    bmp.SetSize(Width, Height);

    //  Paint background
    bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha(Color);
    bmp.Canvas.FillRect(Rect(0, 0, Width, Height));

    ggraph := TGPGraphics.Create(bmp.Canvas.Handle);
    try
//      ggraph.SetSmoothingMode(SmoothingModeAntiAlias);

      gfont := TGPFont.Create(Font.Name, Font.Size, FontStyleRegular, UnitPoint);
      try
        gbrush := TGPSolidBrush.Create(MakeGDIPColor(clBlack));
        try
          gpen := TGPPen.Create(MakeGDIPColor(clBlack));
          try
            gstring := TGPStringFormat.Create;
            try
            //////////////////////////
              gbrush.SetColor(MakeGDIPColor(Font.Color));
              Canvas.Font := Font;
              TextW := Canvas.TextWidth(Text);
              TextH := Canvas.TextHeight(Text);

                  TextX := (Width - TextW) div 2;
                  TextY := (Height - TextH) div 2;

              ggraph.DrawString(Caption, Length(Caption),gfont, MakePoint(TextX,(1.0*TextY)), nil, gbrush);
            //////////////////////////
            finally
              gstring.Free;
            end;
          finally
            gpen.Free;
          end;
        finally
          gbrush.Free;
        end;
      finally
        gfont.Free;
      end;
    finally
      ggraph.Free;
    end;

    Canvas.Draw(0, 0, bmp);
  finally
    bmp.Free;
  end;
end;

procedure TUText.SetTextKind(Value: TUTextKind);
begin
  if Value <> FTextKind then
    begin
      FTextKind := Value;
      UpdateTextKind;
    end;
end;

{ MAIN CLASS }

constructor TUText.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  //  New properties
  FTextKind := tkNormal;

  Font.Name := 'Segoe UI';
  Font.Size := 10;

  //  Common properties
  //  Nothing

  UpdateTheme;
end;

procedure TUText.UpdateTextKind;
begin
  if csDesigning in ComponentState = false then
    exit;

  //  Font name
  if TextKind = tkEntry then
    Font.Name := 'Segoe UI Semibold'
  else
    Font.Name := 'Segoe UI';

  //  Font size
  case TextKind of
    tkNormal:
      Font.Size := 10;
    tkDescription:
      Font.Size := 10;
    tkEntry:
      Font.Size := 10;
    tkHeading:
      Font.Size := 15;
    tkTitle:
      Font.Size := 21;
  end;

  UpdateTheme;
end;

end.

