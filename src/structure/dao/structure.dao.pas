unit structure.dao;

interface

uses
  system.classes,
  structure.domain;

type

  TStructureDAO = class
  public
    class function GetTables: TStrings;
    class function GetFields(const ATableName: string): TStrings;
  end;

implementation

uses
  provider;

{ TStructureDAO }

class function TStructureDAO.GetFields(const ATableName: string): TStrings;
begin
  Result := TStringList.Create;
  TProvider.Firebird.FillFieldNames(ATableName, Result);
end;

class function TStructureDAO.GetTables: TStrings;
begin
  Result := TStringList.Create;
  TProvider.Firebird.FillTableNames(Result);
end;

end.
