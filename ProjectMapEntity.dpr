program ProjectMapEntity;

uses
  Vcl.Forms,
  main.view in 'src\main\main.view.pas' {MainView},
  structure.service in 'src\structure\service\structure.service.pas',
  source.builder in 'src\source\source.builder.pas',
  source in 'src\source\source.pas',
  source.generator in 'src\source\source.generator.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainView, MainView);
  Application.Run;
end.
