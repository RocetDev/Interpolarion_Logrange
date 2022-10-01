unit graphCode;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Grids, ComCtrls, Math;

type

  { TmainForm }

  TmainForm = class(TForm)
    BuildButton: TButton;
    Canva: TImage;
    ClearButton: TButton;
    PointGrid: TStringGrid;
    pointsText: TLabel;
    MethodLagranje: TRadioButton;
    SplainInterpolation: TRadioButton;
    procedure CreateMatrix();
    procedure drawGraph();
    procedure DecisionMatrix();
    procedure BuildButtonClick(Sender: TObject);
    procedure drawLines();
    procedure drawPoint();
    procedure drawSystem();
    procedure addPointsGrid();
    procedure ClearButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CanvaMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

  private

  public

  end;

var
  mainForm: TmainForm;

  i,j,k:integer;
  edit:boolean;
  points:array[1..7] of TPoint;
  posArray:integer;
  m:array[1..7, 1..8] of real;
  x:array[1..7] of real;

implementation

{$R *.lfm}

{ TmainForm }
///////////////////////////////// method Lagranja
procedure TmainForm.CreateMatrix();
begin
  for i:=1 to posArray-1 do begin
    for j:=1 to posArray-1 do begin
      m[i,j]:= Power(points[i].X, (-1)+j);
    end;
    m[i,posArray]:=points[i].Y;
  end;
end;

procedure TmainForm.drawGraph();
var
  p:integer;
  y:real;
  firstY:integer;
  firstX:integer;
begin
  firstX:=points[1].x;
  firstY:=points[1].y;
  Canva.Canvas.Pen.Color:=clBlack;
  Canva.Canvas.Pen.Width:=2;
  for p:=points[1].x to points[posArray-1].x do
    begin
      for j:=1 to posArray-1 do y := y + (x[j] * Power(p, (-1)+j));
      Canva.Canvas.Line(firstX, firstY, p, round(y));
      firstX:=p;
      firstY:=round(y);
      y:=0;
    end;
end;

procedure TmainForm.DecisionMatrix();
var r:real;
begin
  for i:= 1 to posArray-1 do
    for j:=i+1 to posArray-1 do
      begin
        r := m[j, i] / m[i, i];
        for k:=1 to posArray do
          m[j, k] := m[j, k] - r * m[i, k];
      end;

  for i:=posArray-1 downto 1 do
    for j:=i-1 downto 1 do
      begin
        r := m[j, i] / m[i, i];
        for k:=1 to posArray do
          m[j, k] := m[j, k] - r * m[i, k];
      end;

  for i:=1 to posArray-1 do
    begin
      x[i] := m[i, posArray] / m[i, i];
    end;
end;

/////////////////////////////////////////// splain interpolation

procedure TmainForm.drawSplain();
begin

end;

////////////////////////////////////////////////////////

procedure TmainForm.drawSystem();
var
  xs:integer;
begin
  Canva.Canvas.Pen.Color:=clBlack;
  Canva.Canvas.Pen.Width:=2;
  Canva.Canvas.Line(30, 552,30,0); // y
  Canva.Canvas.Line(30, 276, 746, 276); // x

  for i:=1 to 35 do
    begin
      Canva.Canvas.Line(50+xs, 272, 50+xs, 280);
      xs := xs+20;
    end;

  xs := 0;
  for i:=1 to 20 do
    begin
      Canva.Canvas.Line(20, 276-xs, 40, 276-xs);
      Canva.Canvas.Line(20, 276+xs, 40, 276+xs);
      xs := xs+20;
    end;
end;

procedure TmainForm.addPointsGrid();
begin
  for i:=1 to posArray-1 do
    begin
      PointGrid.Cells[0,i]:=FloatToStr(i);
      PointGrid.Cells[1,i]:=FloatToStr((points[i].X-30));
      PointGrid.Cells[2,i]:=FloatToStr((points[i].Y-276)*(-1));
    end;
end;

procedure TmainForm.ClearButtonClick(Sender: TObject);
begin
  posArray := 1;
  edit:=true;
  Canva.Canvas.Brush.Color:=clWhite;
  Canva.Canvas.FillRect(0,0,776,552);
  drawSystem();

  for i:=1 to 7 do
    begin
      PointGrid.Cells[0,i] := ' ';
      PointGrid.Cells[1,i] := ' ';
      PointGrid.Cells[2,i] := ' ';
    end;

  for i:=1 to 7 do
    begin
      x[i] := 0;
      for j:=1 to 7 do
        m[i,j] := 0;
    end;

  for i:=1 to 7 do
    begin
      points[i].X := 0;
      points[i].Y := 0;
    end;
end;

procedure TmainForm.FormCreate(Sender: TObject);
begin

  posArray:=1;
  PointGrid.RowCount:= 8;
  edit:=true;
  PointGrid.Cells[1,0]:='X';
  PointGrid.Cells[2,0]:='Y';
  with Canva.Canvas do
    begin
      brush.Color:=clWhite;
      FillRect(0,0,776,552);
    end;
    drawSystem();
end;

procedure TmainForm.drawPoint();
var
  Rect:TRect;
begin
  with Canva.Canvas do
    begin
      Pen.Width := 1;
      Line(points[posArray].X-2, points[posArray].Y-2,points[posArray].X+2, points[posArray].Y-2);
      Line(points[posArray].X+2, points[posArray].Y-2,points[posArray].X+2, points[posArray].Y+2);
      Line(points[posArray].X+2, points[posArray].Y+2,points[posArray].X-2, points[posArray].Y+2);
      Line(points[posArray].X-2, points[posArray].Y+2,points[posArray].X-2, points[posArray].Y-2);
    end;
end;

procedure TmainForm.drawLines();
begin
     if posArray >= 2 then
        for i:=1 to posArray-1 do
          with Canva.Canvas do
            begin
              Pen.Color := clGreen;
              Pen.Width := 1;
              if i <> posArray-1 then
                 begin
                   MoveTo(points[i]);
                   LineTo(points[i+1]);
                 end;
            end;
     Canva.Canvas.MoveTo(0,0);
end;

procedure TmainForm.BuildButtonClick(Sender: TObject);
begin
  edit := false;
  CreateMatrix();
  DecisionMatrix();
  drawGraph();
end;

procedure TmainForm.CanvaMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
   if (posArray <> 8) and (edit = true) then
      begin
        if posArray = 1 then
           begin
             points[posArray].X := X;
             points[posArray].Y := Y;
             drawPoint();
             posArray := posArray + 1;
           end;
        if X > points[posArray-1].X then
           begin
             points[posArray].X := X;
             points[posArray].Y := Y;
             drawPoint();
             posArray := posArray + 1;
           end;
      end;
   addPointsGrid();
end;


end.

