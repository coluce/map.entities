unit structure.service;

interface

uses
  provider;

type

  TStructureService = class
  public
    class function GetTables: TArray<ITable>;
  end;

implementation

uses
  system.classes;

{ TStructureService }

class function TStructureService.GetTables: TArray<ITable>;
var
  vTable: ITable;
  vStrTables: TStrings;
  vTableName: string;
begin
  SetLength(Result, 0);

  vStrTables := TStringList.Create;
  try
    TProvider.Firebird.FillTableNames(vStrTables);
    for vTableName in vStrTables do
    begin
      vTable := TStructureDomain.Table
        .Name(vTableName);

      TProvider.Firebird.FillFields(vTable);

      SetLength(Result, Length(Result) + 1);
      Result[Length(Result) - 1] := vTable;

    end;
  finally
    vStrTables.Free;
  end;

end;

end.
