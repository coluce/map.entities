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
begin

  vSource := TStringList.Create;
  try
    vSource.Add('unit ' + FMetadata.DaoUnitName +';');
    vSource.Add('');
    vSource.Add('interface');
    vSource.Add('');
    vSource.Add('uses');
    vSource.Add('  ' + FMetadata.MainUnitName + ';');
    vSource.Add('');
    vSource.Add('type');
    vSource.Add('');
    vSource.Add('  ' + FMetadata.DaoClassName + ' = class(TInterfacedObject, ' + FMetadata.DaoInterfaceName + ')');
    vSource.Add('  private');
    vSource.Add('    { private declarations }');
    vSource.Add('  public');
    vSource.Add('    { public declarations }');
    vSource.Add('    procedure Save(const Value: ' + FMetadata.EntityInterfaceName + ');');
    vSource.Add('    procedure Delete(const Value: ' + FMetadata.EntityInterfaceName + ');');
    vSource.Add('    function Get(const Value: IFilter): TArray<' + FMetadata.EntityInterfaceName + '>;');
    vSource.Add('  end;');
    vSource.Add('');
    vSource.Add('implementation');
    vSource.Add('');
    vSource.Add('uses');
    vSource.Add('  provider;');
    vSource.Add('');
    vSource.Add(' { ' + FMetadata.DaoClassName + ' }');
    vSource.Add('');
    vSource.Add('procedure ' + FMetadata.DaoClassName + '.Save(const Value: ' + FMetadata.EntityInterfaceName + ');');
    vSource.Add('begin');
    vSource.Add('  //');
    vSource.Add('end;');
    vSource.Add('');
    vSource.Add('procedure ' + FMetadata.DaoClassName + '.Delete(const Value: ' + FMetadata.EntityInterfaceName + ');');
    vSource.Add('begin');
    vSource.Add('  //');
    vSource.Add('end;');
    vSource.Add('');
    vSource.Add('function ' + FMetadata.DaoClassName + '.Get(const Value: IFilter): TArray<' + FMetadata.EntityInterfaceName + '>;');
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
    vSource.Add('unit ' + FMetadata.EntityUnitName +';');
    vSource.Add('');
    vSource.Add('interface');
    vSource.Add('');
    vSource.Add('uses');
    vSource.Add('  ' + FMetadata.MainUnitName + ';');
    vSource.Add('');
    vSource.Add('type');
    vSource.Add('');
    vSource.Add('  ' + FMetadata.EntityClassName + ' = class(TInterfacedObject, ' + FMetadata.EntityInterfaceName + ')');
    vSource.Add('  private');
    vSource.Add('    { private declarations }');

    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    F' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ';');
    end;

    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    procedure Set' + vField.Name + '(const Value: ' + DatabaseTypeToPascalType(vField) + ');');
      vSource.Add('    function Get' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ';');
    end;

    vSource.Add('  public');
    vSource.Add('    { public declarations }');
    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    property ' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ' read Get' + vField.Name + ' write Set' + vField.Name + ';');
    end;
    vSource.Add('  end;');
    vSource.Add('');
    vSource.Add('implementation');
    vSource.Add('');
    vSource.Add(' { ' + FMetadata.EntityClassName + ' }');
    vSource.Add('');

    for vField in FTable.Fields.Values do
    begin
      vSource.Add('procedure ' + FMetadata.EntityClassName + '.Set' + vField.Name + '(const Value: ' + DatabaseTypeToPascalType(vField) + ');');
      vSource.Add('begin');
      vSource.Add('  F' + vField.Name + ' := Value;');
      vSource.Add('end;');
      vSource.Add('function ' + FMetadata.EntityClassName + '.Get' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ';');
      vSource.Add('begin');
      vSource.Add('  Result := F' + vField.Name + ';');
      vSource.Add('end;');
    end;

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
    vSource.Add('unit ' + FMetadata.MainUnitName +';');
    vSource.Add('');
    vSource.Add('interface');
    vSource.Add('');
    vSource.Add('type');
    vSource.Add('');
    vSource.Add('  ' + FMetadata.EntityInterfaceName + ' = interface');
    vSource.Add('    [' + QuotedStr(TGuid.NewGuid.ToString) + ']');

    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    F' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ';');
    end;

    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    procedure Set' + vField.Name + '(const Value: ' + DatabaseTypeToPascalType(vField) + ');');
      vSource.Add('    function Get' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ';');
    end;

    for vField in FTable.Fields.Values do
    begin
      vSource.Add('    property ' + vField.Name + ': ' + DatabaseTypeToPascalType(vField) + ' read Get' + vField.Name + ' write Set' + vField.Name + ';');
    end;
    vSource.Add('  end;');
    vSource.Add('');

    vSource.Add('  ' + FMetadata.DaoInterfaceName + ' = interface');
    vSource.Add('    [' + QuotedStr(TGuid.NewGuid.ToString) + ']');
    vSource.Add('    procedure Save(const Value: ' + FMetadata.EntityInterfaceName + ');');
    vSource.Add('    procedure Delete(const Value: ' + FMetadata.EntityInterfaceName + ');');
    vSource.Add('    function Get(const Value: IFilter): TArray<' + FMetadata.EntityInterfaceName + '>;');
    vSource.Add('  end;');
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
    vSource.Add('  ' + FMetadata.EntityUnitName + ',');
    vSource.Add('  ' + FMetadata.DaoUnitName + ',');
    vSource.Add('');
    vSource.Add(' { ' + FMetadata.MainClassName + ' }');
    vSource.Add('');
    vSource.Add('class function Entity: ' + FMetadata.EntityInterfaceName + ';');
    vSource.Add('begin');
    vSource.Add('  Result := ' + FMetadata.EntityClassName + '.Create;');
    vSource.Add('end;');
    vSource.Add('');
    vSource.Add('class function Dao: ' + FMetadata.DaoInterfaceName + ';');
    vSource.Add('begin');
    vSource.Add('  Result := ' + FMetadata.DaoClassName + '.Create;');
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
