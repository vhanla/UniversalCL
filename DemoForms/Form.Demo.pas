﻿unit Form.Demo;

interface

uses
  //  UCL units
  UCL.Utils, UCL.Classes, UCL.SystemSettings, UCL.IntAnimation, UCL.TUThemeManager,
  UCL.TUForm, UCL.TUSwitch, UCL.TUScrollBox, UCL.TUCheckBox, UCL.TUProgressBar, UCL.TUHyperLink,
  UCL.TUPanel, UCL.TUSymbolButton, UCL.TUButton, UCL.TUText, UCL.TUCaptionBar, UCL.TURadioButton,
  UCL.TUSlider, UCL.TUContextMenu, UCL.TUSeparator, UCL.TUEdit, UCL.TUItemButton,

  //  Winapi units
  Winapi.Windows, Winapi.Messages, DWMApi, UxTheme,

  //  System units
  System.SysUtils, System.Variants, System.Classes, System.Types, System.ImageList,
  System.Threading,

  //  VCL units
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.WinXCtrls,
  Vcl.Imaging.pngimage, Vcl.WinXPanels, Vcl.Menus, Vcl.Buttons, Vcl.Samples.Gauges, Vcl.ImgList, Vcl.VirtualImageList,
  Vcl.BaseImageCollection, Vcl.ImageCollection;

type
  TMARGINS = record
    leftWidth: integer;
    rightWidth: integer;
    topHeight: integer;
    bottomHeight: integer;
  end;

  TformDemo = class(TUForm)
    AppTheme: TUThemeManager;
    captionbarOldStyle: TUCaptionBar;
    drawerNavigation: TUPanel;
    buttonOpenMenu: TUSymbolButton;
    buttonMenuSettings: TUSymbolButton;
    buttonMenuProfile: TUSymbolButton;
    buttonMenuSave: TUSymbolButton;
    buttonMenuOpen: TUSymbolButton;
    buttonMenuRate: TUSymbolButton;
    boxSmoothScrolling: TUScrollBox;
    captionbarNewStyle: TUCaptionBar;
    headingSettings: TUText;
    entryUserProfile: TUText;
    checkAutoSync: TUCheckBox;
    checkSendEmail: TUCheckBox;
    buttonDeleteAccount: TUButton;
    entryAccountType: TUText;
    radioFreeAccount: TURadioButton;
    radioProAccount: TURadioButton;
    radioDevAccount: TURadioButton;
    desAccountHint: TUText;
    entryStorage: TUText;
    desStorageHint: TUText;
    progressStorageUsed: TUProgressBar;
    imgAvatar: TImage;
    headingAbout: TUText;
    desAppVersion: TUText;
    desFlashVersion: TUText;
    desChromiumVersion: TUText;
    buttonCheckUpdate: TUButton;
    linkEmbarcadero: TUHyperLink;
    buttonUpgradeAccount: TUButton;
    checkKeepEmailPrivate: TUCheckBox;
    entryAppTheme: TUText;
    radioDefaultTheme: TURadioButton;
    radioLightTheme: TURadioButton;
    radioDarkTheme: TURadioButton;
    dialogSelectColor: TColorDialog;
    panelSelectAccentColor: TUPanel;
    desAccentColorHint: TUText;
    checkColorBorder: TUCheckBox;
    panelRibbon: TUScrollBox;
    buttonGoBack: TUSymbolButton;
    separator1: TUSeparator;
    buttonGoHome: TUSymbolButton;
    buttonNewDoc: TUSymbolButton;
    buttonOpenDoc: TUSymbolButton;
    buttonPrintDoc: TUSymbolButton;
    buttonSaveDoc: TUSymbolButton;
    separator2: TUSeparator;
    buttonAppBack: TUButton;
    buttonAppQuit: TUButton;
    editAccountName: TUEdit;
    imgcollectionMain: TImageCollection;
    imglistMain: TVirtualImageList;
    linkConnected: TUHyperLink;
    linkCustomColor: TUHyperLink;
    linkDisabled: TUHyperLink;
    buttonNoFocus: TUButton;
    buttonCanFocus: TUButton;
    buttonCustomColor: TUButton;
    buttonReloadSettings: TUSymbolButton;
    buttonHighlight: TUButton;
    buttonDisabled: TUButton;
    buttonToggle: TUButton;
    radioA1: TURadioButton;
    radioA2: TURadioButton;
    radioA3: TURadioButton;
    radioB1: TURadioButton;
    radioB2: TURadioButton;
    check2State: TUCheckBox;
    check3State: TUCheckBox;
    UItemButton1: TUItemButton;
    UItemButton2: TUItemButton;
    symbolButtonOpenDisabled: TUSymbolButton;
    symbolbuttonSaveHorz: TUSymbolButton;
    symbolbuttonSaveVert: TUSymbolButton;
    progressVert: TUProgressBar;
    buttonRandomProgress: TUButton;
    progressCustomColor: TUProgressBar;
    progressConnected: TUProgressBar;
    textDescription: TUText;
    textNormal: TUText;
    textEntry: TUText;
    textHeading: TUText;
    textTitle: TUText;
    buttonRunning: TButton;
    buttonAniStart: TButton;
    buttonAniInverse: TButton;
    buttonWithImage: TUButton;
    buttonAppMaximized: TUButton;
    buttonAppMinimized: TUButton;
    sliderHorz: TUSlider;
    sliderDisabled: TUSlider;
    sliderVert: TUSlider;
    popupVert: TUContextMenu;
    popupHorz: TUContextMenu;
    procedure FormCreate(Sender: TObject);
    procedure buttonReloadSettingsClick(Sender: TObject);
    procedure buttonAniStartClick(Sender: TObject);
    procedure buttonRandomProgressClick(Sender: TObject);
    procedure buttonAniInverseClick(Sender: TObject);
    procedure buttonOpenMenuClick(Sender: TObject);
    procedure radioDefaultThemeClick(Sender: TObject);
    procedure radioLightThemeClick(Sender: TObject);
    procedure radioDarkThemeClick(Sender: TObject);
    procedure panelSelectAccentColorClick(Sender: TObject);
    procedure checkColorBorderClick(Sender: TObject);
    procedure buttonClosePopupClick(Sender: TObject);
    procedure buttonAppQuitClick(Sender: TObject);
    procedure buttonMenuSettingsClick(Sender: TObject);
    procedure buttonAppMaximizedClick(Sender: TObject);
    procedure buttonAppMinimizedClick(Sender: TObject);
    procedure sliderHorzChange(Sender: TObject);
  private
  public
  protected
    procedure WndProc(var Msg: TMessage); override;
  end;

var
  formDemo: TformDemo;

implementation

{$R *.dfm}

procedure TformDemo.buttonAniStartClick(Sender: TObject);
var
  Ani: TIntAni;
begin
  Ani := TIntAni.Create(akOut, afkQuartic, buttonRunning.Left, buttonRunning.Left + 210, procedure (Value: Integer)
    begin
      buttonRunning.Left := Value;
    end, false);

  Ani.OnDone := procedure begin buttonRunning.Caption := 'Animated' end;
  Ani.Start;
end;

procedure TformDemo.buttonAniInverseClick(Sender: TObject);
var
  Ani: TIntAni;
begin
  Ani := TIntAni.Create(akOut, afkQuartic, buttonRunning.Left, buttonRunning.Left - 210, procedure (Value: Integer)
    begin
      buttonRunning.Left := Value;
    end, true);
  Ani.Start;
end;

procedure TformDemo.FormCreate(Sender: TObject);
begin
  Self.ThemeManager := AppTheme;
  panelSelectAccentColor.CustomBackColor := AppTheme.ActiveColor;
  if AppTheme.ColorOnBorder = true then
    checkColorBorder.State := cbsChecked
  else
    checkColorBorder.State := cbsUnchecked;
end;

procedure TformDemo.sliderHorzChange(Sender: TObject);
begin
  //  Change progress bar value
  progressConnected.Value := sliderHorz.Value;
end;

procedure TformDemo.WndProc(var Msg: TMessage);
var
  margins: _MARGINS;
  v: Integer;
begin
  case (Msg.Msg) of
  WM_NCPAINT:
    begin
      v := 2;
      DwmSetWindowAttribute(Self.Handle, 2, @v, 4);
      DwmExtendFrameIntoClientArea(Self.Handle, margins);
    end;
  end;

  inherited WndProc(Msg);
end;

procedure TformDemo.buttonAppMaximizedClick(Sender: TObject);
begin
  if WindowState <> wsMaximized then
    WindowState := wsMaximized
  else
    WindowState := wsNormal;
end;

procedure TformDemo.buttonAppMinimizedClick(Sender: TObject);
begin
  WindowState := wsMinimized;
end;

procedure TformDemo.buttonAppQuitClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TformDemo.checkColorBorderClick(Sender: TObject);
begin
  if checkColorBorder.State = cbsChecked then
    AppTheme.ColorOnBorderKind := cobkTrue
  else
    AppTheme.ColorOnBorderKind := cobkFalse;
end;

procedure TformDemo.panelSelectAccentColorClick(Sender: TObject);
var
  NewColor: TColor;
begin
  //  Open dialog
  if dialogSelectColor.Execute = true then
    begin
      NewColor := dialogSelectColor.Color;

      //  Change accent color
      AppTheme.CustomColor := NewColor;
      AppTheme.UseAccentColor := false;

      panelSelectAccentColor.CustomBackColor := NewColor;
    end;
end;

procedure TformDemo.radioDefaultThemeClick(Sender: TObject);
begin
  AppTheme.ThemeKind := tkAuto;
end;

procedure TformDemo.radioLightThemeClick(Sender: TObject);
begin
  AppTheme.ThemeKind := tkLight;
end;

procedure TformDemo.radioDarkThemeClick(Sender: TObject);
begin
  AppTheme.ThemeKind := tkDark;
end;

procedure TformDemo.buttonClosePopupClick(Sender: TObject);
begin
  Self.SetFocus;  //  Set focus to main form to close popup
end;

procedure TformDemo.buttonMenuSettingsClick(Sender: TObject);
var
  NewWidth: Integer;
  Ani: TIntAni;
  DPI: Single;
begin
  DPI := Self.PixelsPerInch / 96;

  boxSmoothScrolling.DisableAlign;
  boxSmoothScrolling.HideOldScrollBar;

  if boxSmoothScrolling.Width <> 0 then
    NewWidth := 0 //  Go to 40 (close menu)
  else
    NewWidth := Round(250 * DPI); //  Go to 220 (open menu)

  Ani := TIntAni.Create(akOut, afkQuartic, boxSmoothScrolling.Width, NewWidth,
    procedure (Value: Integer)
    begin
      boxSmoothScrolling.Width := Value;
    end, true);

  Ani.OnDone := procedure begin boxSmoothScrolling.EnableAlign end;

  Ani.Step := 20;
  Ani.Duration := 200;

  Ani.Start;
end;

procedure TformDemo.buttonRandomProgressClick(Sender: TObject);
begin
  Randomize;
  progressCustomColor.GoToValue(Random(101));
  progressConnected.GoToValue(Random(101));
  progressVert.GoToValue(Random(101));
end;

procedure TformDemo.buttonOpenMenuClick(Sender: TObject);
var
  NewPos: Integer;
  Ani: TIntAni;
  DPI: Single;
begin
  DPI := Self.PixelsPerInch / 96;
  if drawerNavigation.Width <> Round(45 * DPI) then
    NewPos := Round(45 * DPI) // Go to 45 (close menu)
  else
    NewPos := Round(220 * DPI); // 220:45 and DPI change

  Ani := TIntAni.Create(akOut, afkQuartic, drawerNavigation.Width, NewPos,
    procedure (Value: Integer)
    begin
      drawerNavigation.Width := Value;
    end, true);
  Ani.Step := 20;
  Ani.Duration := 200;

  Ani.Start;
end;

procedure TformDemo.buttonReloadSettingsClick(Sender: TObject);
begin
  AppTheme.ReloadAutoSettings;
end;

end.
