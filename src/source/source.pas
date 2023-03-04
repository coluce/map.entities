unit source;

interface

uses
  provider;

type

  TSourceMetadata = record

    MainUnitName: string;
    MainClassName: string;

    EntityUnitName: string;
    EntityInterfaceName: string;
    EntityClassName: string;

    DaoUnitName: string;
    DaoInterfaceName: string;
    DaoClassName: string;
  end;

  ISourceBuilder = interface
    ['{8181D13B-7F99-4FA6-A2F8-888F719A18D3}']
    function MainClass: string;
    function EntityClass: string;
    function DAOClass: string;
  end;

  ISourceGenerator = interface
    ['{AC17E93D-7967-4796-8D23-DFB5EBD8381C}']
    function SetTable(const ATable: ITable): ISourceGenerator;
    function Builder: ISourceBuilder;
  end;

  TSource = class
  public
    class function Generator: ISourceGenerator;
  end;

implementation

uses
  source.generator;

{ TSource }

class function TSource.Generator: ISourceGenerator;
begin
  Result := TSourceGenerator.Create;
end;

end.
