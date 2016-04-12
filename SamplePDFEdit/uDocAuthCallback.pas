unit uDocAuthCallback;

interface
uses
  System.SysUtils, Winapi.Windows, System.Win.ComObj, PDFXEdit_TLB, Vcl.Graphics, math, matrix;

type
  TDocAuthCallback = class(TAutoIntfObject, IPXC_DocAuthCallback)
  private
    FPXS: IPXS_Inst;
  public

    constructor Create(inst: IPXV_Inst);

    procedure AuthDoc(const pDoc: IPXC_Document; nFlags: ULONG_T); safecall;
  end;

implementation

{ TDocAuthCallback }

procedure TDocAuthCallback.AuthDoc(const pDoc: IPXC_Document; nFlags: ULONG_T);
var
  pHandler: IPXC_SecurityHandler;
  status: PXC_PermStatus;
  atmStandard, nName: ULONG;
  sPass: String;
begin
	status := Perm_ReqDenied;
  pHandler :=	pDoc.GetSecurityHandler(False);
	if (pHandler = nil) then
  begin
    exit;
  end;
	atmStandard := FPXS.StrToAtom('Standard');
	pHandler.get_Name(&nName);
	if (nName = atmStandard) then
  begin
		sPass := 'UserPassword';
		status := pDoc.AuthorizeWithPassword(PWideChar(sPass));
  end;
end;

constructor TDocAuthCallback.Create(inst: IPXV_Inst);
begin
  FPXS := inst.GetExtension('PXS') as IPXS_Inst;
end;

end.
