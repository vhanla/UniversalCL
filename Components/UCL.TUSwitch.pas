unit UCL.TUSwitch;

interface

uses
  UCL.Classes, UCL.TUThemeManager,
  System.Classes, System.SysUtils,
  Winapi.Messages,
  VCL.Controls, VCL.Graphics, VCL.WinXCtrls;

type
  TUCustomSwitch = class(TCustomToggleSwitch, IUThemeComponent)
    private
      FThemeManager: TUThemeManager;

      FHitTest: Boolean;
      FCustomColor: TColor;

      //  Setters
      procedure SetThemeManager(const Value: TUThemeManager);
      procedure SetCustomColor(const Value: TColor);

      //  Messages
      procedure WM_LButtonUp(var Msg: TMessage); message WM_LBUTTONUP;

    public
      constructor Create(aOwner: TComponent); override;
      procedure UpdateTheme;

    published
      property ThemeManager: TUThemeManager read FThemeManager write SetThemeManager;

      property HitTest: Boolean read FHitTest write FHitTest default true;
      property CustomColor: TColor read FCustomColor write SetCustomColor;
  end;

  TUSwitch = class(TUCustomSwitch)
    published
      property Action;
      property Align;
      property Alignment;
      property Anchors;
      property AutoSize;
      property BiDiMode;
      //property Color;
      property Constraints;
      property DisabledColor;
      property DoubleBuffered;
      property DragCursor;
      property DragKind;
      property DragMode;
      property Enabled;
      property Font;
      //property FrameColor;
      property Height;
      property HelpContext;
      property Hint;
      property ParentBiDiMode;
      property ParentColor;
      property ParentCtl3D;
      property ParentDoubleBuffered;
      property ParentFont;
      property ParentShowHint;
      property PopupMenu;
      property ReadOnly;
      property ShowHint;
      property ShowStateCaption;
      property State;
      property StateCaptions;
      property StyleElements;
      property SwitchHeight;
      property SwitchWidth;
      property TabOrder;
      property TabStop;
      //property ThumbColor;
      property ThumbWidth;
      property Visible;
      property Width;

      property OnClick;
      property OnContextPopup;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDock;
      property OnEndDrag;
      property OnEnter;
      property OnExit;
      property OnKeyDown;
      property OnKeyPress;
      property OnKeyUp;
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

{ TUCustomSwitch }

//  THEME

procedure TUCustomSwitch.SetThemeManager(const Value: TUThemeManager);
begin
  if Value <> FThemeManager then
    begin
      if FThemeManager <> nil then
        FThemeManager.Disconnect(Self);

      if Value <> nil then
        Value.Connect(Self);

      FThemeManager := Value;
      UpdateTheme;
    end;
end;

procedure TUCustomSwitch.UpdateTheme;
begin
  //  Dont set ThemeManager
  if ThemeManager = nil then
    begin
      if IsOn then
        begin
          ThumbColor := $FFFFFF;
          Color := CustomColor;
          FrameColor := CustomColor;
        end
      else
        begin
          ThumbColor := $000000;
          Color := $FFFFFF;
          FrameColor := $000000;
        end;
      Font.Color := $000000;
    end

  //  Light theme
  else if ThemeManager.Theme = utLight then
    begin
      if IsOn then
        begin
          ThumbColor := $FFFFFF;
          Color := ThemeManager.AccentColor;
          FrameColor := ThemeManager.AccentColor;
        end
      else
        begin
          ThumbColor := $000000;
          Color := $FFFFFF;
          FrameColor := $000000;
        end;
      Font.Color := $000000;
    end

  //  Dark theme
  else
    begin
      if IsOn then
        begin
          ThumbColor := $FFFFFF;
          Color := ThemeManager.AccentColor;
          FrameColor := ThemeManager.AccentColor;
        end
      else
        begin
          ThumbColor := $FFFFFF;
          Color := $000000;
          FrameColor := $FFFFFF;
        end;
      Font.Color := $FFFFFF;
    end;
end;

//  SETTERS

procedure TUCustomSwitch.SetCustomColor(const Value: TColor);
begin
  if Value <> FCustomColor then
    begin
      FCustomColor := Value;
      UpdateTheme;
    end;
end;

//  MAIN CLASS

constructor TUCustomSwitch.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);

  FHitTest := true;
  FCustomColor := $D77800;
  SwitchWidth := 40;

  Font.Name := 'Segoe UI';
  Font.Size := 10;

  UpdateTheme;
end;

//  MESSAGES

procedure TUCustomSwitch.WM_LButtonUp(var Msg: TMessage);
begin
  if Enabled and HitTest then
    begin
      inherited;
      UpdateTheme;
    end;
end;

end.
