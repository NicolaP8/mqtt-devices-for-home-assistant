Program HADemo;

{$MODE Delphi}

Uses
  Forms, Interfaces,
  Unit1 in 'Unit1.pas';

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
