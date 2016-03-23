unit matrix;

interface
uses
  System.SysUtils, PDFXEdit_TLB, math;

procedure UpdateMinMax(v: Double; var vMin, vMax: Double);
procedure Transform(m1: PXC_Matrix; var x, y: Double);
procedure TransformRect(m1: PXC_Matrix; var rcPageBox: PXC_Rect);
function RectToRectMatrix(from: PXC_Rect; to_: tagRECT): PXC_Matrix; Overload;
function RectToRectMatrix(from: PXC_Rect; to_: PXC_Rect): PXC_Matrix; Overload;
function Multiply(m1: PXC_Matrix; m2: PXC_Matrix): PXC_Matrix;
implementation

procedure UpdateMinMax(v: Double; var vMin, vMax: Double);
Begin
  if (vMin > v) then
    vMin := v;
  if (vMax < v) then
    vMax := v;
End;

procedure Transform(m1: PXC_Matrix; var x, y: Double);
var
  tx: double;
Begin
  tx := x;
  x := (tx * m1.a + y * m1.c + m1.e);
  y := (tx * m1.b + y * m1.d + m1.f);
End;

procedure TransformRect(m1: PXC_Matrix; var rcPageBox: PXC_Rect);
var
  x, y, x1, x2, y1, y2: Double;
Begin
  x := rcPageBox.left;
  y := rcPageBox.bottom;
  Transform(m1, x, y);
  x1 := x;
  x2 := x;
  y1 := y;
  y2 := y;
  x := rcPageBox.left;
  y := rcPageBox.top;
  Transform(m1, x, y);
  UpdateMinMax(x, x1, x2);
  UpdateMinMax(y, y1, y2);
  x := rcPageBox.right;
  y := rcPageBox.top;
  Transform(m1, x, y);
  UpdateMinMax(x, x1, x2);
  UpdateMinMax(y, y1, y2);
  x := rcPageBox.right;
  y := rcPageBox.bottom;
  Transform(m1, x, y);
  UpdateMinMax(x, x1, x2);
  UpdateMinMax(y, y1, y2);
  rcPageBox.left := x1;
  rcPageBox.right := x2;
  rcPageBox.bottom := y1;
  rcPageBox.top := y2;
End;

function RectToRectMatrix(from: PXC_Rect; to_: tagRECT): PXC_Matrix;
var
  m: PXC_Matrix;
Begin
  if ((to_.right = to_.left) or (to_.top = to_.bottom) or
  (from.left = from.right) or (from.top = from.bottom)) then
  Begin
    m.d := 1.0;
    m.a := m.d;
  End
  else
  Begin
    m.a := ((to_.right - to_.left) / (from.right - from.left));
    m.d := ((to_.top - to_.bottom) / (from.top - from.bottom));
  End;
  m.b := 0;
  m.c := 0;
  m.e := (to_.left - from.left * m.a);
  m.f := (to_.bottom - from.bottom * m.d);
  Result := m;
End;

function RectToRectMatrix(from: PXC_Rect; to_: PXC_Rect): PXC_Matrix;
var
  m: PXC_Matrix;
Begin
  if ((to_.right = to_.left) or (to_.top = to_.bottom) or
    (from.left = from.right) or (from.top = from.bottom)) then
  begin
    m.d := 1.0;
    m.a := m.d;
  end
  else
  Begin
    m.a := ((to_.right - to_.left) / (from.right - from.left));
    m.d := ((to_.top - to_.bottom) / (from.top - from.bottom));
  End;
  m.b := 0;
  m.c := 0;
  m.e := (to_.left - from.left * m.a);
  m.f := (to_.bottom - from.bottom * m.d);
  Result := m;
End;

function Multiply(m1: PXC_Matrix; m2: PXC_Matrix): PXC_Matrix;
var
  t0, t2, t4: Double;
begin
   t0 := (m1.a * m2.a + m1.b * m2.c);
   t2 := (m1.c * m2.a + m1.d * m2.c);
   t4 := (m1.e * m2.a + m1.f * m2.c + m2.e);
   m1.b := (m1.a * m2.b + m1.b * m2.d);
   m1.d := (m1.c * m2.b + m1.d * m2.d);
   m1.f := (m1.e * m2.b + m1.f * m2.d + m2.f);
   m1.a := t0;
   m1.c := t2;
   m1.e := t4;
   Result := m1;
end;

end.
