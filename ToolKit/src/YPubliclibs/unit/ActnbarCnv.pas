unit ActnbarCnv;

interface

uses
  Classes, Menus, Forms, ComCtrls, ActnList, ActnMan, ActnMenus,
  StdStyleActnCtrls, XPStyleActnCtrls;

type
  TActionbarConverter = class(TComponent)
  private
    FForm : TCustomForm;
    FMainMenu : TMainMenu;
    FMainMenuToolbar : TToolbar;
    FActionManager : TActionManager;
    FActionMainMenubar : TActionMainMenubar;
    FNewMenuActions : TList;
    procedure ActionMainMenuBar_ExitMenuLoop(Sender:TCustomActionMenuBar;
      Cancelled: Boolean);
    procedure ActionMainMenubar_Popup(Sender:TObject; Item:TCustomActionControl);
    procedure SetActionMainMenubar(Value:TActionMainMenubar);
    procedure SetActionManager(Value:TActionManager);
    procedure SetForm(Value:TCustomForm);
  protected
    procedure AnalyzeForm;
    procedure Loaded; override;
    procedure LoadMenu(ActionList: TCustomActionList; Clients: TActionClients;
      AMenu: TMenuItem; SetActionList: Boolean = True);
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure ProcessMenu;
    procedure UpdateActionMainMenuBar(Menu: TMenu);
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    procedure Update;
  published
    property Form : TCustomForm read FForm write SetForm;
    property ActionManager : TActionManager read FActionManager write SetActionManager;
    property ActionMainMenubar : TActionMainMenubar read FActionMainMenubar write SetActionMainMenubar;
  end;

//==============================================================================
                                implementation
//==============================================================================

uses
  SysUtils;

//==============================================================================

{ TABMenuAction -
  This class is a special ActionBand menu action that stores the TMenuItem
  that it is associated with so that if it is executed it can actually call the
  TMenuItem.Click method simulating an actual click on the TMenuItem itself. }
type
  TABMenuAction = class(TCustomAction)
  private
    FMenuItem: TMenuItem;
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    destructor Destroy; override;
    procedure ExecuteTarget(Target: TObject); override;
    function HandlesTarget(Target: TObject): Boolean; override;
  end;

//------------------------------------------------------------------------------

destructor TABMenuAction.Destroy;
begin
  if Assigned(FMenuItem) then FMenuItem.RemoveFreeNotification(Self);
  inherited;
end;

//------------------------------------------------------------------------------

procedure TABMenuAction.ExecuteTarget(Target: TObject);
begin
  if Assigned(FMenuItem) then FMenuItem.Click;
end;

//------------------------------------------------------------------------------

function TABMenuAction.HandlesTarget(Target: TObject): Boolean;
begin
  Result := True;
end;

//------------------------------------------------------------------------------

procedure TABMenuAction.Notification(AComponent: TComponent; Operation: TOperation);
begin
  if (Operation = opRemove) and (AComponent = FMenuItem)
    then FMenuItem := nil;
end;



//------------------------------------------------------------------------------
//   TActionbarConverter
//------------------------------------------------------------------------------

constructor TActionbarConverter.Create(AOwner:TComponent);
begin
  inherited Create(AOwner);
  FNewMenuActions := TList.Create;
  if (AOwner is TCustomForm) then SetForm(TCustomForm(AOwner));
end;

//------------------------------------------------------------------------------

destructor TActionbarConverter.Destroy;
begin
  FNewMenuActions.Free;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TActionbarConverter.ActionMainMenuBar_ExitMenuLoop(Sender:TCustomActionMenuBar;
  Cancelled: Boolean);
var
  I: Integer;
  AnAction: TObject;
begin
  // Clear the top level menu sub item and add a single dummy item which
  // will cause them to be regenerated on the next menu loop.  This is done
  // because the IDE's menus can be very dynamic and this ensures that the
  // menus will always be up-to-date.
  for I := 0 to FActionManager.ActionBars[0].Items.Count - 1 do begin
    FActionManager.ActionBars[0].Items[I].Items.Clear;
    FActionManager.ActionBars[0].Items[I].Items.Add;
  end;
  // Any menuitems not linked to an action had one dynamically created for them
  // during the menu loop so now we need to destroy them
  while FNewMenuActions.Count > 0 do begin
    AnAction := TObject(FNewMenuActions.Items[0]);
    AnAction.Free;
    FNewMenuActions.Delete(0);
  end;
end;

//------------------------------------------------------------------------------

procedure TActionbarConverter.ActionMainMenubar_Popup(Sender:TObject;
  Item: TCustomActionControl);
begin
  // If the tag is not zero then we've already populated this submenu...
  if Item.ActionClient.Items[0].Tag <> 0 then exit;
  // ...otherwise this is the first visit to this submenu and we need to
  // populate the actual ActionClients collection.
  if Assigned(TMenuItem(Item.ActionClient.Tag).OnClick) then
    TMenuItem(Item.ActionClient.Tag).OnClick(TMenuItem(Item.ActionClient.Tag));
  Item.ActionClient.Items.Clear;
  TMenuItem(Item.ActionClient.Tag).RethinkHotkeys;
  LoadMenu(FActionManager, Item.ActionClient.Items, TMenuItem(Item.ActionClient.Tag), False);
end;

//------------------------------------------------------------------------------

procedure TActionbarConverter.AnalyzeForm;
var
  i : integer;
begin
  FMainMenu := nil;
  FMainMenuToolbar := nil;
  if Assigned(FForm) then begin
    for i:=0 to FForm.ComponentCount-1 do
      if (FForm.Components[i] is TMainMenu) then begin
        FMainMenu := FForm.Components[i] as TMainMenu;
        break;
      end;
    for i:=0 to FForm.ComponentCount-1 do
      if (FForm.Components[i] is TToolbar) then begin
        FMainMenuToolbar := FForm.Components[i] as TToolbar;
        if FMainMenuToolbar.Menu = FMainMenu
          then break
          else FMainMenuToolbar := nil;
      end;
  end;
  ProcessMenu;
end;

//------------------------------------------------------------------------------

procedure TActionbarConverter.Loaded;
begin
  AnalyzeForm;
end;

//------------------------------------------------------------------------------

procedure TActionbarConverter.LoadMenu(ActionList: TCustomActionList;
  Clients: TActionClients; AMenu: TMenuItem; SetActionList: Boolean = True);
{ This method dynamically builds the ActionBand menu from an existing
  TMenuItem. }
var
  I: Integer;
  AC: TActionClientItem;
begin
  AMenu.RethinkHotkeys;
  AMenu.RethinkLines;
  // Use the existing hotkeys from the TMenuItem
  Clients.AutoHotKeys := False;
  for I := 0 to AMenu.Count - 1 do begin
    AC := Clients.Add;
    AC.Caption := AMenu.Items[I].Caption;
    // Assign the Tag property to the TMenuItem for reference
    AC.Tag := Integer(AMenu.Items[I]);
    AC.Action := TContainedAction(AMenu.Items[I].Action);
    AC.Visible := AMenu.Items[I].Visible;
    // If the TMenuItem has subitems add an ActionClient placeholder.
    // Submenus are only populated when the user selects the parent item of the
    // submenu.
    if AMenu.Items[I].Count > 0 then
      AC.Items.Add  // Add a dummy indicating this item can/should be dynamically built
    else
      if (AMenu.Items[I].Caption <> '')
        and (AMenu.Items[I].Action = nil)
        and (AMenu.Items[I].Caption <> '-')
      then begin
        // The TMenuItem is not connected to an action so dynamically create
        // an action.
        AC.Action := TABMenuAction.Create(self); //Application.MainForm);
        AMenu.Items[I].FreeNotification(AC.Action);
        TABMenuAction(AC.Action).FMenuItem := AMenu.Items[I];
        FNewMenuActions.Add(AC.Action);
        AC.Action.ActionList := FActionManager;
        AC.Action.Tag := AMenu.Items[I].Tag;
        TCustomAction(AC.Action).ImageIndex := AMenu.Items[I].ImageIndex;
        TCustomAction(AC.Action).HelpContext := AMenu.Items[I].HelpContext;
        TCustomAction(AC.Action).Visible := AMenu.Items[I].Visible;
        TCustomAction(AC.Action).Checked := AMenu.Items[I].Checked;
        TCustomAction(AC.Action).Caption := AMenu.Items[I].Caption;
        TCustomAction(AC.Action).ShortCut := AMenu.Items[I].ShortCut;
        TCustomAction(AC.Action).Enabled := AMenu.Items[I].Enabled;
        TCustomAction(AC.Action).AutoCheck := AMenu.Items[I].AutoCheck;
        TCustomAction(AC.Action).Checked := AMenu.Items[I].Checked;
        TCustomAction(AC.Action).GroupIndex := AMenu.Items[I].GroupIndex;
        AC.ImageIndex := AMenu.Items[I].ImageIndex;
        AC.ShortCut := AMenu.Items[I].ShortCut;
      end;
    AC.Caption := AMenu.Items[I].Caption;
    AC.ImageIndex := AMenu.Items[I].ImageIndex;
    AC.HelpContext := AMenu.Items[I].HelpContext;
    AC.ShortCut := AMenu.Items[I].ShortCut;
    AC.Visible := AMenu.Items[I].Visible;
  end;
end;

//------------------------------------------------------------------------------

procedure TActionbarConverter.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if (Operation = opRemove) then
    if (AComponent=FForm) then SetForm(nil);
end;

//------------------------------------------------------------------------------

procedure TActionbarConverter.ProcessMenu;
begin
  if FMainMenu <> nil then begin
    if FMainMenutoolbar <> nil then begin
      FMainMenutoolbar.Menu := nil;
      FMainMenutoolbar.Visible := false;
    end;
    FForm.Menu := nil;

    if FActionManager=nil then begin
      FActionManager := TActionManager.Create(self);
//      FActionManager.Style := XPStyle;
    end else
      FActionManager.Actionbars.Clear;

    FActionManager.Images := FMainMenu.Images;
    FActionManager.Actionbars.Add;

    if FActionMainMenubar=nil then begin
      FActionMainMenubar := TActionMainMenubar.Create(self);
      if (FMainMenuToolbar <> nil)
        then FActionMainMenubar.Parent := FMainMenuToolbar.Parent
        else FActionMainMenubar.Parent := FForm;
    end;
    FActionMainMenubar.ActionManager := FActionManager;
    FActionMainMenubar.OnPopup := ActionMainMenubar_Popup;
    FActionMainMenubar.OnExitMenuLoop := ActionMainMenubar_ExitMenuLoop;

    UpdateActionMainMenubar(FMainMenu);
  end;
end;

//------------------------------------------------------------------------------

procedure TActionbarConverter.SetActionMainmenubar(Value:TActionMainMenubar);
begin
  if Value=nil then begin
    FActionMainMenubar := TActionMainMenubar.Create(self);
    if FMainmenuToolbar <> nil
      then FActionMainMenubar.Parent := FMainMenuToolbar.Parent
      else FActionMainMenubar.Parent := FForm;
  end else begin
    FActionMainMenubar.Free;
    FActionMainMenubar := value;
  end;
  Update;
end;

//------------------------------------------------------------------------------

procedure TActionbarConverter.SetActionManager(value:TActionManager);
begin
  if Value = nil then begin
    FActionManager := TActionManager.Create(self);
    FActionManager.Style := XPStyle;
  end else begin
    FActionManager := value;
//    if FMainMenu <> nil then FActionManager.Images := FMainMenu.Images;
  end;
  Update;
end;

//------------------------------------------------------------------------------

procedure TActionbarConverter.SetForm(value:TCustomForm);
begin
  if FForm <> Value then begin
    FForm := Value;
    AnalyzeForm;
  end;
end;

//------------------------------------------------------------------------------

procedure TActionbarConverter.Update;
begin
  AnalyzeForm;
end;

//------------------------------------------------------------------------------

procedure TActionbarConverter.UpdateActionMainMenuBar(Menu: TMenu);
{ This routine should probably also check for Enabled state although it would
  be very wierd to have a top level menu disabled. }

  function RefreshItems: Boolean;
  var
    I: Integer;
  begin
    Result := FMainMenu.Items.Count <> FActionManager.ActionBars[0].Items.Count;
    if not Result then
      for I := 0 to FMainMenu.Items.Count - 1 do
        if AnsiCompareText(
          FMainMenu.Items[I].Caption,
          FActionManager.ActionBars[0].Items[I].Caption ) <> 0
        then  begin
          Result := True;
          break;
        end;
  end;

begin
  if not (csLoading in FActionManager.ComponentState) and RefreshItems
  then begin
    // Clear any existing items and repopulate the TActionMainMenuBar
    FActionManager.ActionBars[0].Items.Clear;
    FActionManager.ActionBars[0].ActionBar := nil;
    LoadMenu(FActionManager, FActionManager.ActionBars[0].Items, FMainMenu.Items);
    FActionManager.ActionBars[0].ActionBar := FActionMainMenuBar;
    // Update the size of the main menu
    with FActionMainMenuBar do
      SetBounds(
        0,
        0,
        Controls[ControlCount-1].BoundsRect.Right + 2 + FActionMainMenuBar.HorzMargin,
        Height
      );
  end;
end;

end.