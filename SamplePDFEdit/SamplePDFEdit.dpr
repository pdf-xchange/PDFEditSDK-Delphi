program SamplePDFEdit;

uses
  Vcl.Forms,
  untMain in 'untMain.pas' {Form1},
  PDFInst in 'PDFInst.pas',
  about in 'about.pas' {AboutBox},
  matrix in 'matrix.pas',
  untImageView in 'untImageView.pas' {Form2},
  uDocAuthCallback in 'uDocAuthCallback.pas';

{$R *.res}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
