unit source;

interface

uses
  system.classes,
  provider;

type

  TSource = class
  private
    class function DatabaseTypeToPascalType(const AField: IField): string;
  public
    class function CreateEntityClass(const ATable: ITable): TStrings;
  end;

implementation

uses
  system.sysutils;

{ TSource }

class function TSource.CreateEntityClass(const ATable: ITable): TStrings;
var
  vField: IField;
begin
  Result := TStringList.Create;
  Result.Add('unit ' + Lowercase(ATable.Name) +'.entity;');
  Result.Add('');
  Result.Add('interface');
  Result.Add('');
  Result.Add('type');
  Result.Add('');
  Result.Add('  T' + ATable.Name + ' = class');
  Result.Add('  private');

  for vField in ATable.Fields.Values do
  begin
    Result.Add('    F' + vField.Name + ': ' + TSource.DatabaseTypeToPascalType(vField) + ';');
  end;

  Result.Add('  public');
  for vField in ATable.Fields.Values do
  begin
    Result.Add('    property ' + vField.Name + ': ' + TSource.DatabaseTypeToPascalType(vField) + ' read F' + vField.Name + ' write F' + vField.Name + ';');
  end;
  Result.Add('  end;');
  Result.Add('');
  Result.Add('implementation');
  Result.Add('');
  Result.Add(' { T' + ATable.Name + ' }');
  Result.Add('');
  Result.Add('end.');
end;

class function TSource.DatabaseTypeToPascalType(const AField: IField): string;
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
