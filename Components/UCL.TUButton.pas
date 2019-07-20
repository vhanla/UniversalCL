unit UCL.TUButton;

interface

uses
  UCL.Classes, UCL.TUThemeManager, UCL.Utils,
  Winapi.Messages, Winapi.Windows, GdiPAPI, GdipObj,
  System.Classes, System.Types,
  VCL.Controls, VCL.Graphics, VCL.ExtCtrls, VCL.StdCtrls, VCL.ImgList;

type
  TUCustomButton = class(TCustomControl, IUThemeControl)
    const
      DefBackColor: TDefColor = (
        ($CCCCCC, $CCCCCC, $999999, $CCCCCC, $CCCCCC),
        ($333333, $333333, $666666, $333333, $333333));
      DefBorderColor: TDefColor = (
        ($CCCCCC, $7A7A7A, $999999, $CCCCCC, $7A7A7A),
        ($333333, $858585, $666666, $333333, $858585));
      DefTextColor: TDefColor = (
        ($000000, $000000, $000000, $666666, $000000),
        ($FFFFFF, $FFFFFF, $FFFFFF, $666666, $FFFFFF));

    private
      //  Theme
      FThemeManager: TUThemeManager;
      FCustomBorderColors: TControlStateColors;
      FCustomBackColors: TControlStateColors;
      FCustomTextColors: TControlStateColors;

      //  Fields
      FButtonState: TUControlState;
      FText: string;
      FImageIndex: Integer;
      FImages: TCustomImageList;
      FHitTest: Boolean;
      FAllowFocus: Boolean;
      FHighlight: Boolean;
      FIsToggleButton: Boolean;
      FIsToggled: Boolean;
      FTransparent: Boolean;

      //  Object setters
      procedure SetThemeManager(const Value: TUThemeManager);

      //  Value setters
      procedure SetButtonState(const Value: TUControlState);
      procedure SetText(const Value: string);
      procedure SetImageIndex(const Value: Integer);
      procedure SetHighlight(const Value: Boolean);
      procedure SetTransparent(const Value: Boolean);

      //  Messages
      procedure WM_LButtonDblClk(var Msg: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
      procedure WM_LButtonDown(var Msg: TWMLButtonDown); message WM_LBUTTONDOWN;
      procedure WM_LButtonUp(var Msg: TWMLButtonUp); message WM_LBUTTONUP;
      procedure WM_SetFocus(var Msg: TWMSetFocus); message WM_SETFOCUS;
      procedure WM_KillFocus(var Msg: TWMKillFocus); message WM_KILLFOCUS;

      procedure CM_MouseEnter(var Msg: TMessage); message CM_MOUSEENTER;
      procedure CM_MouseLeave(var Msg: TMessage); message CM_MOUSELEAVE;
      procedure CM_EnabledChanged(var Msg: TMessage); message CM_ENABLEDCHANGED;

      //  Group property change
      procedure DoCustomBorderColorsChange(Sender: TObject);
      procedure DoCustomBackColorsChange(Sender: TObject);
      procedure DoCustomTextColorsChange(Sender: TObject);

    protected
      procedure Paint; override;

    public
      constructor Create(aOwner: TComponent); override;
      destructor Destroy; reintroduce;
      procedure UpdateTheme;  //  IThemeControl

    published
      property ThemeManager: TUThemeManager read FThemeManager write SetThemeManager;
      property CustomBorderColors: TControlStateColors read FCustomBorderColors write FCustomBorderColors;
      property CustomBackColors: TControlStateColors read FCustomBackColors write FCustomBackColors;
      property CustomTextColors: TControlStateColors read FCustomTextColors write FCustomTextColors;

      property ButtonState: TUControlState read FButtonState write SetButtonState default csNone;
      property Text: string read FText write SetText;
      property ImageIndex: Integer read FImageIndex write SetImageIndex default -1;
      property Images: TCustomImageList read FImages write FImages;
      property HitTest: Boolean read FHitTest write FHitTest default true;
      property AllowFocus: Boolean read FAllowFocus write FAllowFocus default true;
      property Highlight: Boolean read FHighlight write SetHighlight default false;
      property IsToggleButton: Boolean read FIsToggleButton write FIsToggleButton default false;
      property IsToggled: Boolean read FIsToggled write FIsToggled default false;
      property Transparent: Boolean read FTransparent write SetTransparent default false;
  end;

  TUButton = class(TUCustomButton)
    published
      //  Common properties
      property Align;
      property Anchors;
      property Constraints;
      property DragCursor;
      property DragKind;
      property DragMode;
      property Enabled;
      property Font;
      property ParentFont;
      property ParentShowHint;
      property PopupMenu;
      property ShowHint;
      property Touch;
      property TabOrder;
      property TabStop;
      property Visible;

      //  Common events
      property OnClick;
      property OnContextPopup;
      property OnDblClick;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDock;
      property OnEndDrag;
      property OnGesture;
      property OnMouseActivate;
      property OnMouseDown;
      property OnMouseEnter;
      property OnMouseLeave;
      property OnMouseMove;
      property OnMouseUp;
      property OnStartDock;
      property OnStartDrag;
  end;

implementation

{ THEME }

procedure TUCustomButton.SetThemeManager(const Value: TUThemeManager);
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

procedure TUCustomButton.UpdateTheme;
begin
  Paint;
end;

{ VALUE SETTER }

procedure TUCustomButton.SetButtonState(const Value: TUControlState);
begin
  if Value <> FButtonState then
    begin
      FButtonState := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomButton.SetText(const Value: string);
begin
  if Value <> FText then
    begin
      FText := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomButton.SetImageIndex(const Value: Integer);
begin
  if Value <> FImageIndex then
    begin
      FImageIndex := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomButton.SetHighlight(const Value: Boolean);
begin
  if Value <> FHighlight then
    begin
      FHighlight := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomButton.SetTransparent(const Value: Boolean);
begin
  if Value <> FTransparent then
    begin
      FTransparent := Value;
      UpdateTheme;
    end;
end;

{ MAIN CLASS }

constructor TUCustomButton.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  //  New properties
  FCustomBorderColors := TControlStateColors.Create($F2F2F2, $E6E6E6, $CCCCCC, $F2F2F2, $F2F2F2);
  FCustomBackColors := TControlStateColors.Create($F2F2F2, $E6E6E6, $CCCCCC, $F2F2F2, $F2F2F2);
  FCustomTextColors := TControlStateColors.Create(clBlack, clBlack, clBlack, clGray, clBlack);

  FCustomBorderColors.OnChange := DoCustomBorderColorsChange;
  FCustomBackColors.OnChange := DoCustomBackColorsChange;
  FCustomTextColors.OnChange := DoCustomTextColorsChange;

  FButtonState := csNone;
  FText := ClassName;
  FImageIndex := -1;
  FHitTest := true;
  FAllowFocus := true;
  FHighlight := false;
  FIsToggleButton := false;
  FIsToggled := false;
  FTransparent := false;

  //  Property
  Height := 30;
  Width := 135;
  Font.Name := 'Segoe UI';
  Font.Size := 10;
  TabStop := true;

  //UpdateTheme;
  //  Dont update theme in constructor when UpdateTheme call Paint method
end;

destructor TUCustomButton.Destroy;
begin
  FCustomBorderColors.Free;
  FCustomBackColors.Free;
  FCustomTextColors.Free;

  inherited Destroy;
end;

{ CUSTOM METHODS }

procedure TUCustomButton.Paint;
const
  IMG_SPACE = 10;
var
  TextX, TextY, TextW, TextH: Integer;
  ImgX, ImgY, ImgW, ImgH: Integer;
  BorderThickness, ThicknessPos: Integer;
  BorderColor, BackColor, TextColor: TColor;

  bmp: TBitmap;
  gfont: TGPFont;
  ggraph: TGPGraphics;
  gpen: TGPPen;
  gbrush: TGPSolidBrush;
  gstring: TGPStringFormat;
  gtxt: WideString;
begin
  inherited;

  //  Not connect ThemeManager, use custom colors
  if ThemeManager = nil then
    begin
      BorderColor := CustomBorderColors.GetStateColor(ButtonState);
      BackColor := CustomBackColors.GetStateColor(ButtonState);
      TextColor := CustomTextColors.GetStateColor(ButtonState);
    end

  //  Highlight button
  else if
    ((Highlight = true) or ((IsToggleButton = true) and (IsToggled = true)))  //  Is highlight button, or toggle on
    and (ButtonState in [csNone, csHover, csFocused]) //  Highlight only when mouse normal, hover and focused
  then
    begin
      BackColor := ThemeManager.ActiveColor;
      if ButtonState = csNone then
        BorderColor := BackColor
      else
        BorderColor := ChangeColor(BackColor, 0.6);
      TextColor := GetTextColorFromBackground(BackColor);
    end

  //  Default colors
  else
    begin
      BorderColor := DefBorderColor[ThemeManager.Theme, ButtonState];
      BackColor := DefBackColor[ThemeManager.Theme, ButtonState];
      TextColor := DefTextColor[ThemeManager.Theme, ButtonState];
    end;

  //  Transparent
  if (ButtonState = csNone) and (Transparent = true) then
    begin
      ParentColor := true;
      BackColor := Color;
      BorderColor := Color; //  The same background, because of button state
      TextColor := GetTextColorFromBackground(Color);
    end;

  // Draw using GdiPlus
  bmp := TBitmap.Create;
  try
    bmp.PixelFormat := pf32bit;
    bmp.SetSize(Width, Height);

    //  Paint background
    //Canvas.Brush.Color := BackColor;
    Canvas.Brush.Handle := CreateSolidBrushWithAlpha(BackColor);
    Canvas.FillRect(Rect(0, 0, Width, Height));
    bmp.Canvas.Brush.Handle := CreateSolidBrushWithAlpha(BackColor);
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
              //  Paint border
              BorderThickness := 2; //  Default for 100% scale
              BorderThickness := Round(BorderThickness * CurrentPPI / 96);
              if BorderThickness mod 2 = 0 then
                ThicknessPos := BorderThickness div 2 - 1
              else
                ThicknessPos := BorderThickness div 2;

              Canvas.Pen.Handle := CreateSolidBrushWithAlpha(BorderColor);
              gpen.SetColor(MakeGDIPColor(BorderColor));
              Canvas.Pen.Width := BorderThickness;
              gpen.SetWidth(BorderThickness);
              Canvas.Rectangle(Rect(
                BorderThickness div 2,
                BorderThickness div 2,
                Width - ThicknessPos,
                Height - ThicknessPos));
              ggraph.DrawRectangle(gpen,
                BorderThickness div 2,
                BorderThickness div 2,
                Width - ThicknessPos - BorderThickness,
                Height - ThicknessPos - BorderThickness);

              Font.Color := TextColor;
              gbrush.SetColor(MakeGDIPColor(TextColor));
              SetTextColor(Canvas.Handle, CreateSolidBrushWithAlpha(Font.Color));
              Canvas.Font := Font;

              TextW := Canvas.TextWidth(Text);
              TextH := Canvas.TextHeight(Text);

              if (Images <> nil) and (ImageIndex >= 0) then
                begin
                  ImgW := Images.Width;
                  ImgH := Images.Height;
                  ImgX := (Width - ImgW - IMG_SPACE - TextW) div 2;
                  ImgY := (Height - ImgH) div 2;
                  Images.Draw(Canvas, ImgX, ImgY, ImageIndex, Enabled);
                  Images.Draw(bmp.Canvas, ImgX, ImgY, ImageIndex, Enabled);

                  TextX := ImgX + ImgW + IMG_SPACE;
                  TextY := (Height - TextH) div 2;
                end
              else
                begin
                  TextX := (Width - TextW) div 2;
                  TextY := (Height - TextH) div 2;
                end;

              //  Paint text
              Canvas.TextOut(TextX, TextY, Text);
              ggraph.DrawString(Text, Length(Text), gfont, MakePoint(TextX,(1.0*TextY)), nil, gbrush);
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

  Exit;

  //  Paint background
  //Canvas.Brush.Color := BackColor;
  Canvas.Brush.Handle := CreateSolidBrushWithAlpha(BackColor);
  Canvas.FillRect(Rect(0, 0, Width, Height));

  //  Paint border
  BorderThickness := 2; //  Default for 100% scale
  BorderThickness := Round(BorderThickness * CurrentPPI / 96);
  if BorderThickness mod 2 = 0 then
    ThicknessPos := BorderThickness div 2 - 1
  else
    ThicknessPos := BorderThickness div 2;

  Canvas.Pen.Handle := CreateSolidBrushWithAlpha(BorderColor);
  Canvas.Pen.Width := BorderThickness;
  Canvas.Rectangle(Rect(
    BorderThickness div 2,
    BorderThickness div 2,
    Width - ThicknessPos,
    Height - ThicknessPos));

  Font.Color := TextColor;
  SetTextColor(Canvas.Handle, CreateSolidBrushWithAlpha(Font.Color));
  Canvas.Font := Font;

  TextW := Canvas.TextWidth(Text);
  TextH := Canvas.TextHeight(Text);

  if (Images <> nil) and (ImageIndex >= 0) then
    begin
      ImgW := Images.Width;
      ImgH := Images.Height;
      ImgX := (Width - ImgW - IMG_SPACE - TextW) div 2;
      ImgY := (Height - ImgH) div 2;
      Images.Draw(Canvas, ImgX, ImgY, ImageIndex, Enabled);

      TextX := ImgX + ImgW + IMG_SPACE;
      TextY := (Height - TextH) div 2;
    end
  else
    begin
      TextX := (Width - TextW) div 2;
      TextY := (Height - TextH) div 2;
    end;

  //  Paint text
  Canvas.TextOut(TextX, TextY, Text);
end;

{ MESSAGES }

procedure TUCustomButton.WM_LButtonDblClk(var Msg: TWMLButtonDblClk);
begin
  if (Enabled = true) and (HitTest = true) then
    begin
      ButtonState := csPress;
      inherited;
    end;
end;

procedure TUCustomButton.WM_LButtonDown(var Msg: TWMLButtonDown);
begin
  if (Enabled = true) and (HitTest = true) then
    begin
      if AllowFocus = true then
        SetFocus;
      ButtonState := csPress;
      inherited;
    end;
end;

procedure TUCustomButton.WM_LButtonUp(var Msg: TWMLButtonUp);
begin
  if (Enabled = true) and (HitTest = true) then
    begin
      if IsToggleButton = true then
        FIsToggled := not FIsToggled;
      ButtonState := csHover;
      inherited;
    end;
end;

procedure TUCustomButton.WM_SetFocus(var Msg: TWMSetFocus);
begin
  if (Enabled = true) and (HitTest = true) then
    if AllowFocus = true then
      begin
        ButtonState := csFocused;
        inherited;
      end
    else
      Msg.Msg := WM_NULL;
end;

procedure TUCustomButton.WM_KillFocus(var Msg: TWMKillFocus);
begin
  if (Enabled = true) and (HitTest = true) then
    begin
      ButtonState := csNone;
      inherited;
    end;
end;

procedure TUCustomButton.CM_MouseEnter(var Msg: TMessage);
begin
  if (Enabled = true) and (HitTest = true) then
    begin
      ButtonState := csHover;
      inherited;
    end;
end;

procedure TUCustomButton.CM_MouseLeave(var Msg: TMessage);
begin
  if (Enabled = true) and (HitTest = true) then
    begin
      //  Dont allow focus
      if AllowFocus = false then
        ButtonState := csNone //  No keep border

      //  Allow focus
      else if Focused = false then
        ButtonState := csNone //  No focus, no border
      else
        ButtonState := csFocused; //  Keep focus border

      inherited;
    end;
end;

procedure TUCustomButton.CM_EnabledChanged(var Msg: TMessage);
begin
  inherited;
  if Enabled = false then
    FButtonState := csDisabled
  else
    FButtonState := csNone;
  UpdateTheme;
end;

{ GROUP PROPERTY CHANGE }

procedure TUCustomButton.DoCustomBorderColorsChange(Sender: TObject);
begin
  UpdateTheme;
end;

procedure TUCustomButton.DoCustomBackColorsChange(Sender: TObject);
begin
  UpdateTheme;
end;

procedure TUCustomButton.DoCustomTextColorsChange(Sender: TObject);
begin
  UpdateTheme;
end;

end.
