unit CollapsiblePanel;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Graphics, Winapi.Windows,
  Vcl.Imaging.pngimage;

type
  TCollapsiblePanel = class(TPanel)
  private
    { Private declarations }
    FImage: TImage;
    FLabel: TLabel;
    FPanel: TPanel;
    FImageArrowUp   : TPngImage;
    FImageArrowDown : TPngImage;
    FOriginalPanelHeight : Integer;
    function GetLabelText: string;
    procedure SetLabelText(const Value: string);
    function GetLabelFont: TFont;
    procedure SetLabelFont(const Value: TFont);

    procedure CreateLabel;
    procedure CreateImage;
    procedure CreatePanel;
    procedure LoadImages;
    procedure SetImage;
    procedure ImageClick(Sender : TObject);
//    procedure ImageClick(Sender : TObject);
  protected
    { Protected declarations }
    procedure Resize; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property LabelText: string read GetLabelText write SetLabelText;
    property LabelFont: TFont read GetLabelFont write SetLabelFont;
  end;

procedure Register;

implementation

  {$R MyComponentResources.res}
procedure Register;
begin
  RegisterComponents('CollapsiblePanel Components', [TCollapsiblePanel]);
end;

{ TCollapsiblePanel }

constructor TCollapsiblePanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  LoadImages;

  CreatePanel; // Initialize the TPanel
  CreateLabel; // Initialize the TLabel
  CreateImage; // Initialize the TImage

  SetImage; // Set initial image to FImage

end;

procedure TCollapsiblePanel.CreateImage;
begin
  FImage := TImage.Create(Self);
  FImage.Parent := FPanel;
  FImage.Width := 16; // Example width, adjust as needed
  FImage.Height := 16; // Example height, adjust as needed
  FImage.Stretch := True;
  FImage.Proportional := True;
  FImage.Cursor := crHandPoint;
  FImage.OnClick := ImageClick; // Assign the OnClick event
  FImage.Top := 5; // 5 pixel margin from the top
  FImage.Left := Self.Width - FImage.Width - 5; // 5 pixel margin from the right
end;

procedure TCollapsiblePanel.CreateLabel;
begin
  // Initialize the TLabel
  FLabel := TLabel.Create(Self);
  FLabel.Parent := FPanel;
  FLabel.AutoSize := True;
  FLabel.Caption := 'Label1';
  FLabel.Top := 5; // 5 pixel margin from the top
  FLabel.Left := 5; // 5 pixel margin from the left
end;

procedure TCollapsiblePanel.CreatePanel;
begin
  FPanel := TPanel.Create(Self);
  FPanel.Parent := Self;
  FPanel.Align := alTop;
  FPanel.Height := 25;
  FPanel.BevelOuter := bvNone;
end;

destructor TCollapsiblePanel.Destroy;
begin
  FImageArrowDown.Free;
  FImageArrowUp.Free;
  FImage.Free;
  FLabel.Free;
  FPanel.Free;
  inherited Destroy;
end;

function TCollapsiblePanel.GetLabelFont: TFont;
begin
  Result := FLabel.Font;
end;

function TCollapsiblePanel.GetLabelText: string;
begin
  Result := FLabel.Caption;
end;

procedure TCollapsiblePanel.ImageClick(Sender: TObject);
begin
  if Height <> 25 then begin
    FOriginalPanelHeight := Height;
    Height := 25;
    FImage.Picture.Assign(FImageArrowDown);
  end
  else begin
    Height := FOriginalPanelHeight;
    FImage.Picture.Assign(FImageArrowUp);
  end;

end;

procedure TCollapsiblePanel.LoadImages;
begin
  FImageArrowUp   := TPngImage.Create;
  FImageArrowDown := TPngImage.Create;

  FImageArrowUp.LoadFromResourceName(HInstance, 'UP_ARROW');
  FImageArrowDown.LoadFromResourceName(HInstance, 'DOWN_ARROW');

end;

procedure TCollapsiblePanel.SetImage;
begin
  FImage.Picture.Assign(FImageArrowUp);
end;

procedure TCollapsiblePanel.SetLabelFont(const Value: TFont);
begin
  FLabel.Font.Assign(Value);
end;

procedure TCollapsiblePanel.SetLabelText(const Value: string);
begin
  FLabel.Caption := Value;
  Resize; // Adjust positions after changing the label text
end;

procedure TCollapsiblePanel.Resize;
begin
  inherited Resize;

  // Adjust the TImage position when the panel is resized
  FImage.Left := Self.Width - FImage.Width - 5; // 5 pixel margin from the right

//  FOriginalPanelHeight := Height;

  // Ensure the TLabel remains at its position
  FLabel.Left := 5; // 5 pixel margin from the left
end;

end.
