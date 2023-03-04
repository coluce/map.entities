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
  system.sysutils,
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

  FMetadata.MainUnitName := LowerCase(FTable.Name);
  FMetadata.MainClassName := 'T' + FTable.Name;

  FMetadata.EntityUnitName := LowerCase(FTable.Name + '.entity');
  FMetadata.EntityInterfaceName := 'I' + FTable.Name + 'Entity';
  FMetadata.EntityClassName := 'T' + FTable.Name + 'Entity';

  FMetadata.DaoUnitName := LowerCase(FTable.Name + '.dao');
  FMetadata.DaoInterfaceName := 'I' + FTable.Name + 'Dao';
  FMetadata.DaoClassName := 'T' + FTable.Name + 'Dao';

end;

end.
