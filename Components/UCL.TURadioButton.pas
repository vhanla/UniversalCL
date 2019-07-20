﻿unit UCL.TURadioButton;

interface

uses
  UCL.Classes, UCL.TUThemeManager, UCL.Utils,
  System.Classes, System.SysUtils, System.Types,
  Winapi.Messages, Winapi.Windows, GdiPAPI, GdipObj,
  VCL.Controls, VCL.Graphics;

type
  TUCustomRadioButton = class(TCustomControl, IUThemeControl)
    private var
      ICON_LEFT: Integer;
      TEXT_LEFT: Integer;

    private
      FThemeManager: TUThemeManager;

      FHitTest: Boolean;
      FIsChecked: Boolean;
      FGroup: string;
      FCustomActiveColor: TColor;
      FText: string;

      FIconFont: TFont;

      procedure SetThemeManager(const Value: TUThemeManager);
      procedure SetText(const Value: string);
      procedure SetIsChecked(const Value: Boolean);

      procedure WM_LButtonDown(var Msg: TWMLButtonDown); message WM_LBUTTONDOWN;
      procedure WM_LButtonUp(var Msg: TWMLButtonUp); message WM_LBUTTONUP;

    protected
      procedure ChangeScale(M, D: Integer; isDpiChange: Boolean); override;
      procedure Paint; override;

    public
      constructor Create(aOwner: TComponent); override;
      procedure UpdateTheme;

    published
      property ThemeManager: TUThemeManager read FThemeManager write SetThemeManager;

      property HitTest: Boolean read FHitTest write FHitTest default true;
      property IsChecked: Boolean read FIsChecked write SetIsChecked default false;
      property Group: string read FGroup write FGroup;
      property CustomActiveColor: TColor read FCustomActiveColor write FCustomActiveColor;
      property Text: string read FText write SetText;

      property IconFont: TFont read FIconFont write FIconFont;
  end;

  TURadioButton = class(TUCustomRadioButton)
    published
      //  Common properties
      property Align;
      property Anchors;
      property Color;
      property Constraints;
      property DragCursor;
      property DragKind;
      property DragMode;
      property Enabled;
      property Font;
      property ParentFont;
      property ParentColor;
      property ParentShowHint;
      property PopupMenu;
      property ShowHint;
      property Touch;
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

procedure TUCustomRadioButton.SetThemeManager(const Value: TUThemeManager);
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

procedure TUCustomRadioButton.UpdateTheme;
begin
  Paint;
end;

{ SETTERS }

procedure TUCustomRadioButton.SetIsChecked(const Value: Boolean);
begin
  if Value <> FIsChecked then
    begin
      FIsChecked := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomRadioButton.SetText(const Value: string);
begin
  if Value <> FText then
    begin
      FText := Value;
      UpdateTheme;
    end;
end;

{ MAIN CLASS }

constructor TUCustomRadioButton.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  ICON_LEFT := 5;
  TEXT_LEFT := 35;

  FHitTest := true;
  FIsChecked := false;
  FCustomActiveColor := $D77800;
  FText := 'URadioButton';

  FIconFont := TFont.Create;
  FIconFont.Name := 'Segoe MDL2 Assets';
  FIconFont.Size := 15;

  Font.Name := 'Segoe UI';
  Font.Size := 10;

  Height := 30;
  Width := 200;
  ParentColor := true;

  Font.Name := 'Segoe UI';
  Font.Size := 10;

  //UpdateTheme;
  //  Dont UpdateTheme if it call Paint method
end;

{ CUSTOM METHODS }

procedure TUCustomRadioButton.ChangeScale(M: Integer; D: Integer; isDpiChange: Boolean);
begin
  inherited;

  ICON_LEFT := MulDiv(ICON_LEFT, M, D);
  TEXT_LEFT := MulDiv(TEXT_LEFT, M, D);

  //Font.Height := MulDiv(Font.Height, M, D);   //  Not neccesary
  IconFont.Height := MulDiv(IconFont.Height, M, D);
end;

procedure TUCustomRadioButton.Paint;
var
  TextH: Integer;
  IconH: Integer;

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

    Canvas.Brush.Style := bsSolid;
    //Canvas.Brush.Color := Color;  //  Paint empty background
    Canvas.Brush.Handle := CreateSolidBrushWithAlpha(Color);
    Canvas.FillRect(Rect(0, 0, Width, Height));
    Canvas.Brush.Style := bsClear;

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
              //  Paint text
              Canvas.Font := Self.Font;
              if ThemeManager = nil then
                Canvas.Font.Color := $000000
              else if ThemeManager.Theme = utLight then
                Canvas.Font.Color := $000000
              else
                Canvas.Font.Color := $FFFFFF;
              gbrush.SetColor(MakeGDIPColor(Canvas.Font.Color));

              TextH := Canvas.TextHeight(Text);
              Canvas.TextOut(TEXT_LEFT, (Height - TextH) div 2, Text);
              ggraph.DrawString(Text, Length(Text), gfont, MakePoint(TEXT_LEFT,(Height - TextH) / 2), nil, gbrush);

              //  Paint radio
              Canvas.Font := IconFont;
              gfont.Free;
              gfont := TGPFont.Create(IconFont.Name, IconFont.Size, FontStyleRegular, UnitPoint);
              if IsChecked = false then
                begin
                  //  Paint circle border (black in light, white in dark)
                  if ThemeManager = nil then
                    Canvas.Font.Color := $000000
                  else if ThemeManager.Theme = utLight then
                    Canvas.Font.Color := $000000
                  else
                    Canvas.Font.Color := $FFFFFF;
                  gbrush.SetColor(MakeGDIPColor(Canvas.Font.Color));

                  IconH := Canvas.TextHeight('');
                  Canvas.TextOut(ICON_LEFT, (Height - IconH) div 2, '');
                  ggraph.DrawString('', Length(''), gfont, MakePoint(ICON_LEFT,(Height - IconH) / 2), nil, gbrush);
                end
              else
                begin
                  //  Paint circle border (active color)
                  if ThemeManager = nil then
                    Canvas.Font.Color := CustomActiveColor
                  else
                    Canvas.Font.Color := ThemeManager.ActiveColor;
                  gbrush.SetColor(MakeGDIPColor(Canvas.Font.Color));

                  IconH := Canvas.TextHeight('');
                  Canvas.TextOut(ICON_LEFT, (Height - IconH) div 2, '');
                  ggraph.DrawString('', Length(''), gfont, MakePoint(ICON_LEFT,(Height - IconH) / 2), nil, gbrush);

                  //  Paint small circle inside (black in light, white in dark)
                  if ThemeManager = nil then
                    Canvas.Font.Color := $000000
                  else if ThemeManager.Theme = utLight then
                    Canvas.Font.Color := $000000
                  else
                    Canvas.Font.Color := $FFFFFF;
                  gbrush.SetColor(MakeGDIPColor(Canvas.Font.Color));

                  IconH := Canvas.TextHeight('');
                  Canvas.TextOut(ICON_LEFT, (Height - IconH) div 2, '');
                  ggraph.DrawString('', Length(''), gfont, MakePoint(ICON_LEFT,(Height - IconH) / 2), nil, gbrush);
                end;
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

  Canvas.Brush.Style := bsSolid;
  //Canvas.Brush.Color := Color;  //  Paint empty background
  Canvas.Brush.Handle := CreateSolidBrushWithAlpha(Color);
  Canvas.FillRect(Rect(0, 0, Width, Height));
  Canvas.Brush.Style := bsClear;

  //  Paint text
  Canvas.Font := Self.Font;
  if ThemeManager = nil then
    Canvas.Font.Color := $000000
  else if ThemeManager.Theme = utLight then
    Canvas.Font.Color := $000000
  else
    Canvas.Font.Color := $FFFFFF;
  SetTextColor(Canvas.Handle, CreateSolidBrushWithAlpha(Canvas.Font.Color));

  TextH := Canvas.TextHeight(Text);
  Canvas.TextOut(TEXT_LEFT, (Height - TextH) div 2, Text);

  //  Paint radio
  Canvas.Font := IconFont;
  if IsChecked = false then
    begin
      //  Paint circle border (black in light, white in dark)
      if ThemeManager = nil then
        Canvas.Font.Color := $000000
      else if ThemeManager.Theme = utLight then
        Canvas.Font.Color := $000000
      else
        Canvas.Font.Color := $FFFFFF;

      IconH := Canvas.TextHeight('');
      Canvas.TextOut(ICON_LEFT, (Height - IconH) div 2, '');
    end
  else
    begin
      //  Paint circle border (active color)
      if ThemeManager = nil then
        Canvas.Font.Color := CustomActiveColor
      else
        Canvas.Font.Color := ThemeManager.ActiveColor;

      IconH := Canvas.TextHeight('');
      Canvas.TextOut(ICON_LEFT, (Height - IconH) div 2, '');

      //  Paint small circle inside (black in light, white in dark)
      if ThemeManager = nil then
        Canvas.Font.Color := $000000
      else if ThemeManager.Theme = utLight then
        Canvas.Font.Color := $000000
      else
        Canvas.Font.Color := $FFFFFF;

      IconH := Canvas.TextHeight('');
      Canvas.TextOut(ICON_LEFT, (Height - IconH) div 2, '');
    end;
end;

{ MESSAGES }

procedure TUCustomRadioButton.WM_LButtonDown(var Msg: TWMLButtonDown);
begin
  SetFocus;
  inherited;
end;

procedure TUCustomRadioButton.WM_LButtonUp(var Msg: TWMLButtonUp);
var
  i: Integer;
begin
  //  Only unchecked can change
  if (Enabled = true) and (HitTest = true) then
    begin
      if IsChecked = false then
        begin
          IsChecked := true;  //  Check it

          //  Uncheck other TUCustomRadioButton with the same parent and group name
          for i := 0 to Parent.ControlCount - 1 do
            if Parent.Controls[i] is TUCustomRadioButton then
              if
                ((Parent.Controls[i] as TUCustomRadioButton).Group = Group)
                and (Parent.Controls[i] <> Self)
              then
                (Parent.Controls[i] as TUCustomRadioButton).IsChecked := false;
        end;

      inherited;
    end;
end;

end.
