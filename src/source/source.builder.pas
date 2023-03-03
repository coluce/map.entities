unit source.builder;

interface

uses
  system.classes,
  source,
  provider;

type

  TSourceBuilder = class(TInterfacedObject, ISourceBuilder)
  private
    FTable: ITable;
    FMetadata: TSourceMetadata;
    function DatabaseTypeToPascalType(const AField: IField): string;
  public
    constructor Create(const ATable: ITable; AMetadata: TSourceMetadata);

    function MainClass: string;
    function EntityClass: string;
    function DAOClass: string;
  end;

implementation

uses
  system.sysutils;

{ TSourceBuilder }

constructor TSourceBuilder.Create(const ATable: ITable; AMetadata: TSourceMetadata);
begin
  FTable := ATable;
  FMetadata := AMetadata;
end;

function TSourceBuilder.DAOClass: string;
var
  vSource: TStrings;
  vField: IField;
begin

  vSource := TStringList.Create;
  try
    vSource.Add('unit ' + Lowercase(FTable.Name) +'.dao;');
    vSource.Add('');
    vSource.Add('interface');
    vSource.Add('');
    vSource.Add('type');
    vSource.Add('');
    vSource.Add('  ' + FMetadata.DaoClassName + ' = class');
    vSource.Add('  private');
    vSource.Add('    { private declarations }');
    vSource.Add('  public');
    vSource.Add('    { public declarations }');

    vSource.Add('    procedure Save(const Value: IMyEntity);');
    vSource.Add('    procedure Delete(const Value: IMyEntity);');
    vSource.Add('    function Get(const Value: IFilter): TArray<IMyEntity>;');

    vSource.Add('  end;');
    vSource.Add('');
    vSource.Add('implementation');
    vSource.Add('');
    vSource.Add(' { ' + FMetadata.DaoClassName + ' }');
    vSource.Add('');
    vSource.Add('procedure ' + FMetadata.DaoClassName + '.Save(const Value: IMyEntity);');
    vSource.Add('begin');
    vSource.Add('  //');
    vSource.Add('end;');
    vSource.Add('');
    vSource.Add('procedure ' + FMetadata.DaoClassName + '.Delete(const Value: IMyEntity);');
    vSource.Add('begin');
    vSource.Add('  //');
    vSource.Add('end;');
    vSource.Add('');
    vSource.Add('function ' + FMetadata.DaoClassName + '.Get(const Value: IFilter): TArray<IMyEntity>;');
    vSource.Add('begin');
    vSource.Add('  SetLength(Result, 0);');
    vSource.Add('end;');
    vSource.Add('');
    vSource.Add('end.');

    Result := vSource.Text;

  finally
    vSource.Free;
  end;
end;

function TSourceBuilder.EntityClass: string;
var
  vSource: TStrings;
  vField: IField;
begin

  vSource := TStringList.Create;
  try
    vSource.Add('unit ' + Lowercase(FTable.Name) +'.entity;');
    vSource.Add('');
    vSource.Add('interface');
    vSource.Add('');
    vSource.Add('type');
    vSource.Add('');
    vSource.Add('  ' + FMetadata.EntityClassName + ' = class');
    vSource.Add('  private');
    vSource.Add('    { private declarations }');

    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    F' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ';');
    end;

    vSource.Add('  public');
    vSource.Add('    { public declarations }');
    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    property ' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ' read F' + vField.Name + ' write F' + vField.Name + ';');
    end;
    vSource.Add('  end;');
    vSource.Add('');
    vSource.Add('implementation');
    vSource.Add('');
    vSource.Add(' { ' + FMetadata.EntityClassName + ' }');
    vSource.Add('');
    vSource.Add('end.');

    Result := vSource.Text;

  finally
    vSource.Free;
  end;
end;

function TSourceBuilder.MainClass: string;
var
  vSource: TStrings;
  vField: IField;
begin

  vSource := TStringList.Create;
  try
    vSource.Add('unit ' + Lowercase(FTable.Name) +'.main;');
    vSource.Add('');
    vSource.Add('interface');
    vSource.Add('');
    vSource.Add('type');
    vSource.Add('');
    vSource.Add('  ' + FMetadata.MainClassName + ' = class');
    vSource.Add('  private');
    vSource.Add('    { private declarations }');
    vSource.Add('  public');
    vSource.Add('    { public declarations }');
    vSource.Add('    class function Entity: ' + FMetadata.EntityInterfaceName + ';');
    vSource.Add('    class function Dao: ' + FMetadata.DaoInterfaceName + ';');
    vSource.Add('  end;');
    vSource.Add('');
    vSource.Add('implementation');
    vSource.Add('');
    vSource.Add('uses');
    vSource.Add('');
    vSource.Add('');
    vSource.Add(' { ' + FMetadata.MainClassName + ' }');
    vSource.Add('');
    vSource.Add('class function Entity: ' + FMetadata.EntityInterfaceName + ';');
    vSource.Add('begin');
    vSource.Add('  Result := nil');
    vSource.Add('end;');
    vSource.Add('');
    vSource.Add('class function Dao: ' + FMetadata.DaoInterfaceName + ';');
    vSource.Add('begin');
    vSource.Add('  Result := nil');
    vSource.Add('end;');
    vSource.Add('');
    vSource.Add('end.');

    Result := vSource.Text;

  finally
    vSource.Free;
  end;
end;

function TSourceBuilder.DatabaseTypeToPascalType(const AField: IField): string;
begin
  Result := AField.FieldType;

  if AField.FieldType.Equals('CHAR') then
    Result := 'string';

  if AField.FieldType.Equals('VARCHAR') then
    Result := 'string';

  if AField.FieldType.Equals('INTEGER') then
    Result := 'integer';

  if AField.FieldType.Equals('SMALLINT') then
    Result := 'integer';

  if AField.FieldType.Equals('TIMESTAMP') then
    Result := 'TDateTime';

  if AField.FieldType.Equals('DATE') then
    Result := 'TDate';

  if AField.FieldType.Equals('TIME') then
    Result := 'TTime';

  if AField.FieldType.Equals('NUMERIC') then
    Result := 'double';

  if AField.FieldType.Equals('DECIMAL') then
    Result := 'double';

  if AField.FieldType.Equals('DOUBLE PRECISION') then
    Result := 'double';

  if AField.FieldType.Equals('BLOB SUB_TYPE 0') then
    Result := 'TMemoryStream';

  if AField.FieldType.Equals('BLOB SUB_TYPE 1') then
    Result := 'string';

end;

end.