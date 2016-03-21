unit PDFInst;

interface
uses
  System.SysUtils, PDFXEdit_TLB;

type
  TInst = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    FInst: PDFXEdit_TLB.IPXV_Inst;
    FInstCore: PDFXEdit_TLB.IPXC_Inst;
    FInstAUX: IAUX_Inst;

    constructor Create;
    destructor Destroy; override;

    procedure Init(inst: PDFXEdit_TLB.IPXV_Inst);
    procedure InsertEmptyPage(doc: PDFXEdit_TLB.IPXV_Document; nPage: integer; nCount: integer);
    procedure DeletePages(doc: PDFXEdit_TLB.IPXV_Document; nPageStart, nPageStop: integer);

    procedure InsertPagesTest();
  published
    { published declarations }
  end;

var
  gInst: TInst;

implementation

{ TInst }

constructor TInst.Create;
begin
  inherited;
  FInst := nil;
end;

destructor TInst.Destroy;
begin
  FInst := nil;
  inherited;
end;

procedure TInst.Init(inst: PDFXEdit_TLB.IPXV_Inst);
begin
  FInst := inst;
  FInstCore := FInst.GetExtension('PXC') as PDFXEdit_TLB.IPXC_Inst;
  FInstAUX := FInstCore.GetExtension('AUX') as IAUX_Inst;

end;

procedure TInst.DeletePages(doc: PDFXEdit_TLB.IPXV_Document; nPageStart,
  nPageStop: integer);
var
  nID: integer;
  pOp: PDFXEdit_TLB.IOperation;
  input: PDFXEdit_TLB.ICabNode;
  options: PDFXEdit_TLB.ICabNode;
begin
	nID := FInst.Str2ID('op.document.deletePages', false);
	pOp := FInst.CreateOp(nID);
	input := pOp.Params.Root['Input'];
	input.v := Doc;
	options := pOp.Params.Root['Options'];
	options['PagesRange.Type'].v := 'Exact';
	options['PagesRange.Text'].v := Format('%d-%d', [nPageStart, nPageStop]) ; //Select pages range that will be deleted from the document
	pOp.Do_(0);
end;

procedure TInst.InsertEmptyPage(doc: PDFXEdit_TLB.IPXV_Document; nPage,
  nCount: integer);
var
  nID: integer;
  pOp: PDFXEdit_TLB.IOperation;
  input: PDFXEdit_TLB.ICabNode;
  options: PDFXEdit_TLB.ICabNode;
begin
	nID := FInst.Str2ID('op.document.insertEmptyPages', False);
  pOp := FInst.CreateOp(nID);
  input := pOp.Params.Root['Input'];
	input.v := Doc;
  options := pOp.Params.Root['Options'];
	options['PaperType'].v := 2; //Apply custom paper type
	options['Count'].v := nCount; //Create nCount new pages
	options['Width'].v := 800; //Width of new pages
	options['Height'].v := 1200; //Height of new pages
	options['Location'].v := 1; //New pages will be inserted after first page
	options['Position'].v := nPage; //Page number
	pOp.Do_(0);
end;

procedure TInst.InsertPagesTest;
var
  AFile1, AFile2: String;
  ADoc1, ADoc2: IPXC_Document;
  BS: IBitSet;
  APageCount1, APageCount2: Cardinal;
begin
  AFile1 := 'F:\TEMP\Numbers.pdf';
  AFile2 := 'F:\TEMP\Letters.pdf';
  try
    ADoc1 := FInstCore.OpenDocumentFromFile(PChar(AFile1), nil, nil, 0, 0);
    ADoc2 := FInstCore.OpenDocumentFromFile(PChar(AFile2), nil, nil, 0, 0);

    ADoc1.Pages.Get_Count(APageCount1);
    ADoc2.Pages.Get_Count(APageCount2);

    BS := FInstAUX.CreateBitSet(APageCount2);
    BS.SetSize(APageCount2);
    BS.Item[0] := True;
    BS.Item[1] := True;
    ADoc1.Pages.InsertPagesFromDocEx(ADoc2, APageCount1, BS, IPF_Annots_Copy + IPF_Bookmarks_CopyAll, nil);
    ADoc1.WriteToFile(PChar(AFile1), nil, 0);
  finally
  end;
end;

begin
  gInst := TInst.Create;
end.
