unit structure.service;

interface

uses
  structure.domain;

type

  TStructureService = class
  public
    class function GetTables: TArray<ITable>;
  end;

implementation

uses
  system.classes,
  structure.dao;

{ TStructureService }

class function TStructureService.GetTables: TArray<ITable>;

  procedure FillTableFields(const ATable: ITable);
  var
    vField: IField;
    vStrFields: TStrings;
    vFieldName: string;
  begin
    ATable.Fields.Clear;
    vStrFields := TStructureDAO.GetFields(ATable.Name);
    try
      for vFieldName in vStrFields do
      begin
        vField := TStructureDomain.Field
          .Name(vFieldName)
          .FieldType('string');
        ATable.Fields.AddOrSetValue(vField.Name, vField);
      end;
    finally
      vStrFields.Free;
    end;
  end;

var
  vTable: ITable;
  vStrTables: TStrings;
  vTableName: string;
begin
  SetLength(Result, 0);

  vStrTables := TStructureDAO.GetTables;
  try
    for vTableName in vStrTables do
    begin
      vTable := TStructureDomain.Table
        .Name(vTableName);

      FillTableFields(vTable);

      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := vTable;

    end;
  finally
    vStrTables.Free;
  end;

end;

end.
