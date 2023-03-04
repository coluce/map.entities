unit main.view;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, provider, system.generics.collections, SynEditHighlighter,
  SynHighlighterPas, Vcl.WinXCtrls, System.Actions, Vcl.ActnList;

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
    pnlTables: TPanel;
    srchTable: TSearchBox;
    pnlSource: TPanel;
    pnlSourceToolbar: TPanel;
    btnSourceGenerator: TButton;
    aclSource: TActionList;
    acnSourceGenerate: TAction;
    cbbClassType: TComboBox;
    procedure btnFillTablesClick(Sender: TObject);
    procedure lstTablesDblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure srchTableInvokeSearch(Sender: TObject);
    procedure acnSourceGenerateExecute(Sender: TObject);
  private
    { Private declarations }
    FTables: TDictionary<string, ITable>;
    FTableSelected: ITable;
    procedure DoLoadTables;
    procedure DrawTables;
    procedure DoSourceGenerate;
    procedure DoDrawFields;
  public
    { Public declarations }
  end;

var
  MainView: TMainView;

implementation

uses
  System.Generics.Defaults,
  structure.service,
  source;

{$R *.dfm}


procedure TMainView.acnSourceGenerateExecute(Sender: TObject);
begin
  DoSourceGenerate;
end;

procedure TMainView.btnFillTablesClick(Sender: TObject);
begin
  lstTables.Clear;
  lstFields.Clear;

  DoLoadTables;
  DrawTables;

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

procedure TMainView.DoLoadTables;
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

procedure TMainView.DoSourceGenerate;
begin
  case cbbClassType.ItemIndex of
    0: edtSource.Lines.Text := TSource.Generator.SetTable(FTableSelected).Builder.MainClass;
    1: edtSource.Lines.Text := TSource.Generator.SetTable(FTableSelected).Builder.EntityClass;
    2: edtSource.Lines.Text := TSource.Generator.SetTable(FTableSelected).Builder.DAOClass;
  end;
end;

procedure TMainView.DoDrawFields;
var
  vField: IField;
  vItem: string;
  vList: TList<IField>;
begin
  vList := TList<IField>.Create;
  try

    vList.AddRange(FTableSelected.Fields.Values);

    vList.Sort(TComparer<IField>.Construct(
      function (const L, R: IField): integer
      begin
        if L.ID = R.ID then
        begin
          Result := 0;
        end
        else
        begin
          if L.ID < R.ID then
          begin
            Result := -1;
          end
          else
          begin
            Result := 1;
          end;
        end;
      end
    ));

    for vField in vList do
    begin
      vItem := FormatFloat('00', vField.ID);

      if vField.PrimaryKey then
        vItem := vItem + ' 🔑 '
      else
        vItem := vItem + ' 🗄 ';

      vItem := vItem + vField.Name + ' | ' + LowerCase(vField.FieldType);

      lstFields.Items.Add(vItem);

    end;

  finally
    vList.Free;
  end;
end;

procedure TMainView.DrawTables;
var
  vItem: ITable;
  vFilter:  string;
begin
  lstTables.Clear;

  vFilter := Trim(srchTable.Text);
  for vItem in FTables.Values do
  begin
    if
      vFilter.IsEmpty or
      vItem.Name.Contains(vFilter)
    then
      lstTables.Items.Add(vItem.Name);
  end;

end;

procedure TMainView.lstTablesDblClick(Sender: TObject);
begin
  lstFields.Clear;
  edtSource.Lines.Clear;
  FTableSelected :=  nil;
  if FTables.TryGetValue(lstTables.Items[lstTables.ItemIndex], FTableSelected) then
  begin
    DoSourceGenerate;
    DoDrawFields;
  end;
end;

procedure TMainView.srchTableInvokeSearch(Sender: TObject);
begin
  DrawTables;
end;

end.
