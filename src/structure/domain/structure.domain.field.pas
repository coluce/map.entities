unit structure.domain.field;

interface

uses
  structure.domain;

type

  TField = class(TInterfacedObject, IField)
  private
    FID: integer;
    FName: string;
    FFieldType: string;
  public

    function ID: integer; overload;
    function ID(const Value: integer): IField; overload;

    function Name: string; overload;
    function Name(const Value: string): IField; overload;

    function FieldType: string; overload;
    function FieldType(const Value: string): IField; overload;

  end;

implementation

uses
  system.strutils;

{ TField }

function TField.FieldType: string;
begin
  Result := FFieldType;
end;

function TField.FieldType(const Value: string): IField;
begin
  Result := Self;
  FFieldType := Value;
end;

function TField.ID: integer;
begin
  Result := FID;
end;

function TField.ID(const Value: integer): IField;
begin
  Result := Self;
  FID := Value;
end;

function TField.Name(const Value: string): IField;
begin
  Result := Self;
  FName := ReplaceStr(Value, '"', '');
end;

function TField.Name: string;
begin
  Result := FName;
end;

end.
