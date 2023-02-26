program ProjectMapEntity;

uses
  Vcl.Forms,
  main.view in 'src\main\main.view.pas' {MainView},
  structure.service in 'src\structure\service\structure.service.pas',
  source in 'src\source\source.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
