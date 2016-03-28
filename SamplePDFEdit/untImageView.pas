unit untImageView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.Actions,
  Vcl.ActnList, Vcl.StdActns, Vcl.ExtActns, System.ImageList, Vcl.ImgList,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.ExtDlgs;

type
  TForm2 = class(TForm)
    Image1: TImage;
    ToolBar1: TToolBar;
    ScrollBox1: TScrollBox;
    ToolButton1: TToolButton;
    ActionList1: TActionList;
    ImageList1: TImageList;
    SavePictureDialog1: TSavePictureDialog;
    SavePicture: TAction;
    procedure SavePictureExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses
  Vcl.Imaging.jpeg, Vcl.Imaging.GIFImg, Vcl.Imaging.pngimage;

procedure TForm2.SavePictureExecute(Sender: TObject);
Var
 img: TWICImage;
begin
  if (SavePictureDialog1.Execute) then
  Begin
    //GetEncoderClsid('image/jpeg', encoderClsid);
    img := TWICImage.Create;
    img.Assign(Image1.Picture.Graphic);
    //img.ImageFormat := ;
    img.SaveToFile(SavePictureDialog1.FileName);
    //Image1.Picture.SaveToFile(SavePictureDialog1.FileName);
  End;
end;

end.
