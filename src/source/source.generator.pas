unit source.generator;

interface

uses
  source,
  provider;

type

  TSourceGenerator = class(TInterfacedObject, ISourceGenerator)
  private
    FTable: ITable;
    FMetadata: TSourceMetadata;
    FBuilder: ISourceBuilder;
  public
    function SetTable(const ATable: ITable): ISourceGenerator;
    function Builder: ISourceBuilder;
  end;

implementation

uses
  source.builder;

{ TSourceGenerator }

function TSourceGenerator.Builder: ISourceBuilder;
begin
  if not Assigned(FBuilder) then
    FBuilder := TSourceBuilder.Create(FTable, FMetadata);
  Result := FBuilder;
end;

function TSourceGenerator.SetTable(const ATable: ITable): ISourceGenerator;
begin
  Result := Self;
  FTable := ATable;

  FMetadata.MainClassName := 'T' + FTable.Name;

  FMetadata.EntityInterfaceName := 'I' + FTable.Name + 'Entity';
  FMetadata.EntityClassName := 'T' + FTable.Name + 'Entity';

  FMetadata.DaoInterfaceName := 'T' + FTable.Name + 'Dao';
  FMetadata.DaoClassName := 'I' + FTable.Name + 'Dao';

end;

end.
