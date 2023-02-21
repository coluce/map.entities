program ProjectMapEntity;

uses
  Vcl.Forms,
  main.view in 'src\main\main.view.pas' {MainView},
  structure.domain in 'src\structure\domain\structure.domain.pas',
  structure.domain.field in 'src\structure\domain\structure.domain.field.pas',
  structure.domain.table in 'src\structure\domain\structure.domain.table.pas',
  structure.service in 'src\structure\service\structure.service.pas',
  structure.dao in 'src\structure\dao\structure.dao.pas',
  source in 'src\source\source.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
