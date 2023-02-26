unit main.view;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, provider, system.generics.collections, SynEditHighlighter,
  SynHighlighterPas;

type
  TMainView = class(TForm)
    lstTables: TListBox;
    pnlHeader: TPanel;
    stat1: TStatusBar;
    spl1: TSplitter;
    lstFields: TListBox;
    spl2: TSplitter;
    edtSource: TSynEdit;
    btnFillTables: TButton;
    SynPasSyn1: TSynPasSyn;
    procedure btnFillTablesClick(Sender: TObject);
    procedure lstTablesDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FTables: TDictionary<string, ITable>;
    procedure GetTables;
  public
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

uses
  structure.service,
  source;

{$R *.dfm}


procedure TMainView.btnFillTablesClick(Sender: TObject);
var
  vItem: ITable;
begin
  lstTables.Clear;
  lstFields.Clear;

  GetTables;
  for vItem in FTables.Values do
  begin
    lstTables.Items.Add(vItem.Name);
  end;

end;

procedure TMainView.FormCreate(Sender: TObject);
begin
  FTables := TDictionary<string, ITable>.Create;
end;

procedure TMainView.FormDestroy(Sender: TObject);
begin
  FTables.Clear;
  FTables.Free;
end;

procedure TMainView.GetTables;
var
  vTable: ITable;
  vTables: TArray<ITable>;
begin
  FTables.Clear;
  FTables.TrimExcess;

  vTables := TStructureService.GetTables;
  for vTable in vTables do
  begin
    FTables.AddOrSetValue(vTable.Name, vTable);
  end;
end;

procedure TMainView.lstTablesDblClick(Sender: TObject);
var
  vTable: ITable;
  vField: IField;
  vSource: TStrings;
begin
  lstFields.Clear;
  edtSource.Lines.Clear;
  if FTables.TryGetValue(lstTables.Items[lstTables.ItemIndex], vTable) then
  begin
    for vField in vTable.Fields.Values do
    begin
      lstFields.Items.Add(vField.Name + ' | ' + LowerCase(vField.FieldType));
    end;

    vSource := TSource.CreateEntityClass(vTable);
    try
      edtSource.Lines.Text := vSource.Text;
    finally
      vSource.Free;
    end;
  end;
end;

end.
