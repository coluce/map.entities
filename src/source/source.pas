unit source;

interface

uses
  system.classes,
  structure.domain;

type

  TSource = class
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
    Result.Add('    F' + vField.Name + ': ' + vField.FieldType + ';');
  end;

  Result.Add('  public');
  for vField in ATable.Fields.Values do
  begin
    Result.Add('    property ' + vField.Name + ': ' + vField.FieldType + ' read F' + vField.Name + ' write F' + vField.Name + ';');
  end;
  Result.Add('  end;');
  Result.Add('');
  Result.Add('implementation');
  Result.Add('');
  Result.Add(' { T' + ATable.Name + ' }');
  Result.Add('');
  Result.Add('end.');
end;

end.
