unit structure.domain;

interface

uses
  System.Generics.Collections;

type

  IField = interface
    ['{29D1BC0C-62BA-4016-A621-6219141961FA}']

    function ID: integer; overload;
    function ID(const Value: integer): IField; overload;

    function Name: string; overload;
    function Name(const Value: string): IField; overload;

    function FieldType: string; overload;
    function FieldType(const Value: string): IField; overload;

  end;

  ITable = interface
    ['{AEF9F64E-33D2-4433-A999-C3A8C8EF3F03}']

    function Name: string; overload;
    function Name(const Value: string): ITable; overload;

    function Fields: TDictionary<string, IField>;

  end;

  TStructureDomain = class
  public
    class function Table: ITable;
    class function Field: IField;
  end;

implementation

uses
  structure.domain.field,
  structure.domain.table;

{ TStructureDomain }

class function TStructureDomain.Field: IField;
begin
  Result := TField.Create;
end;

class function TStructureDomain.Table: ITable;
begin
  Result := TTable.Create;
end;

end.
