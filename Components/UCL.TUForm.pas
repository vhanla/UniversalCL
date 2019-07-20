unit UCL.TUForm;

interface

uses
  UCL.Classes, UCL.TUThemeManager, UCL.TUTooltip, UCL.Utils,
  System.Classes,
  Winapi.Windows, Winapi.Messages,
  VCL.Forms, VCL.Controls, VCL.ExtCtrls, VCL.Graphics;

type
  TUForm = class(TForm, IUThemeControl)
    const
      BorderColorDefault = $707070;

    private
      FThemeManager: TUThemeManager;

      FBorderColor: TColor;

      FResizeable: Boolean;

      procedure SetThemeManager(const Value: TUThemeManager);

      procedure WM_DPIChanged(var Msg: TWMDpi); message WM_DPICHANGED;

      procedure WM_NCCalcSize(var Msg: TWMNCCalcSize); message WM_NCCALCSIZE;
      procedure WM_NCHitTest(var Msg: TWMNCHitTest); message WM_NCHITTEST;
      procedure WM_DWMColorizationColorChanged(var Msg: TMessage); message WM_DWMCOLORIZATIONCOLORCHANGED;

    protected
      procedure CreateParams(var Params: TCreateParams); override;

      procedure Paint; override;
      procedure Resize; override;

    public
      constructor Create(aOwner: TComponent); override;
      procedure UpdateTheme;

    published
      property ThemeManager: TUThemeManager read FThemeManager write SetThemeManager;

      property Resizeable: Boolean read FResizeable write FResizeable;
  end;

implementation

{ THEME }

procedure TUForm.SetThemeManager(const Value: TUThemeManager);
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

procedure TUForm.UpdateTheme;
begin
  //  Change background color
  if ThemeManager = nil then
    begin
      Self.Color := $FFFFFF;
      HintWindowClass := TUTooltip;
    end
  else if ThemeManager.Theme = utLight then
    begin
      Self.Color := $FFFFFF;
      HintWindowClass := TUTooltip;
    end
  else
    begin
      Self.Color := $000000;
      HintWindowClass := TUDarkTooltip;
    end;

  //  Change border color
  if ThemeManager = nil then
    FBorderColor := BorderColorDefault
  else if ThemeManager.ColorOnBorder = true then
    FBorderColor := ThemeManager.ActiveColor
  else
    FBorderColor := BorderColorDefault;

  Invalidate; //  To repaint form border
end;

{ MAIN CLASS }

constructor TUForm.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  HintWindowClass := TUTooltip;
  PixelsPerInch := Screen.PixelsPerInch;  //  Get PPI on create

  FResizeable := true;

  UpdateTheme;
end;

{ CUSTOM EVENTS }

procedure TUForm.Paint;
begin
  inherited;

  Canvas.Brush.Handle := CreateSolidBrushWithAlpha(Color);
  Canvas.FillRect(GetClientRect);

  if Self.WindowState <> wsMaximized then
    begin
      Canvas.Pen.Color := FBorderColor;
      Canvas.Rectangle(0, 0, ClientWidth, ClientHeight);
    end;
end;

procedure TUForm.Resize;
begin
  if WindowState = wsMaximized then
    begin
      Self.Left := Screen.WorkAreaRect.Left;
      Self.Top := Screen.WorkAreaRect.Top;
      Self.Width := Screen.WorkAreaRect.Right - Screen.WorkAreaRect.Left;
      Self.Height := Screen.WorkAreaRect.Bottom - Screen.WorkAreaRect.Top - 1;
        //  Without -1, form will over screen size

      Self.Padding.SetBounds(0, 0, 0, 0);
    end
  else
    Self.Padding.SetBounds(1, 1, 1, 1);

  inherited;
  Invalidate; //  Neccesary
end;

{ MESSAGES }

procedure TUForm.WM_DPIChanged(var Msg: TWMDpi);
begin
  PixelsPerInch := Msg.XDpi;
  inherited;
end;

procedure TUForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.Style := Params.Style or WS_OVERLAPPEDWINDOW;  //  Enabled aerosnap
end;

procedure TUForm.WM_NCCalcSize(var Msg: TWMNCCalcSize);
begin
  Msg.Result := 0;
end;

procedure TUForm.WM_NCHitTest(var Msg: TWMNCHitTest);
const
  EDGEDETECT = 5;
var
  deltaRect: TRect;
begin
  inherited;

  if (Resizeable = true) and (WindowState <> wsMaximized) then
    with Msg, deltaRect do
      begin
        Left := XPos - BoundsRect.Left;
        Right := BoundsRect.Right - XPos;
        Top := YPos - BoundsRect.Top;
        Bottom := BoundsRect.Bottom - YPos;

        if (Top < EDGEDETECT) and (Left < EDGEDETECT) then
          Result := HTTOPLEFT
        else if (Top < EDGEDETECT) and (Right < EDGEDETECT) then
          Result := HTTOPRIGHT
        else if (Bottom < EDGEDETECT) and (Left < EDGEDETECT) then
          Result := HTBOTTOMLEFT
        else if (Bottom < EDGEDETECT) and (Right < EDGEDETECT) then
          Result := HTBOTTOMRIGHT
        else if (Top < EDGEDETECT) then
          Result := HTTOP
        else if (Left < EDGEDETECT) then
          Result := HTLEFT
        else if (Bottom < EDGEDETECT) then
          Result := HTBOTTOM
        else if (Right < EDGEDETECT) then
          Result := HTRIGHT
      end;
end;

procedure TUForm.WM_DWMColorizationColorChanged(var Msg: TMessage);
begin
  if Self.ThemeManager <> nil then
    Self.ThemeManager.ReloadAutoSettings;
  inherited;
end;

end.
