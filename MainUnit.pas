unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Math, ComCtrls;
  
const
  N = 120; { total number of atoms }
  cellsize_x = 2;
  cellsize_y = 2;
  { potential is a/r^12-b/r^6 = e((d/r)^12-2(d/r)^6) }
  { it's minimum is at (2*a/b)^(1/6) = d }
  { the minimal value is -b^2/(4*a) = -e }
  potential_d = 0.1;
  potential_e = 120;
  potential_a = potential_e*potential_d*potential_d*potential_d*potential_d*potential_d*potential_d*potential_d*potential_d*potential_d*potential_d*potential_d*potential_d;
  potential_b = 2*potential_e*potential_d*potential_d*potential_d*potential_d*potential_d*potential_d;
  { for g(r) calculations }
  GR_max_R = potential_d * 8;
  GR_N = 300;
  GR_step = GR_max_R/(GR_N-1);
  GR_shift = 0;
  GR_strip_width = potential_d/4.0;
  { for n(e) calculations }
  E_points = 300;
  E_slices = 30;

const
  { potential modes }
  Mode_Fixed = 1;
  Mode_Periodic = 2;

type
  TMainForm = class(TForm)
    ImagePanel: TPanel;
    AtomView: TImage;
    StartButton: TButton;
    ResetButton: TButton;
    QuitButton: TButton;
    OneFrameButton: TButton;
    AdditionalPages: TPageControl;
    ParametersTab: TTabSheet;
    StatisticsTab: TTabSheet;
    GRTab: TTabSheet;
    Potential_ELabel: TPanel;
    Potential_DLabel: TPanel;
    Potential_EEdit: TPanel;
    Potential_DEdit: TPanel;
    CellSize_2ndLabel: TPanel;
    CellsizeYEdit: TPanel;
    CellsizeXEdit: TPanel;
    CellSizeLabel: TPanel;
    SPFLabel: TPanel;
    SPFEdit: TEdit;
    SPFApplyButton: TButton;
    ApplyShiftButton: TButton;
    ShiftEdit: TEdit;
    ShiftLabel: TPanel;
    TemperatureLabel: TPanel;
    TemperatureEdit: TEdit;
    ApplyTemperatureButton: TButton;
    PeriodicBorderSwitch: TSpeedButton;
    FixedBorderSwitch: TSpeedButton;
    BoundaryLabel: TPanel;
    ParametersLabel: TPanel;
    GRPanel: TPanel;
    GRView: TImage;
    StepsLabel: TPanel;
    StepsView: TPanel;
    EnergyLabel: TPanel;
    MeanEnergyView: TPanel;
    MinEnergyLabel: TPanel;
    MinEnergyView: TPanel;
    MaxEnergyLabel: TPanel;
    MaxEnergyView: TPanel;
    TabSheet1: TTabSheet;
    EnergyPanel: TPanel;
    EnergyView: TImage;
    Edit1: TEdit;
    procedure StartButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure QuitButtonClick(Sender: TObject);
    procedure TemperatureEditChange(Sender: TObject);
    procedure TemperatureEditKeyPress(Sender: TObject; var Key: Char);
    procedure FixedBorderSwitchClick(Sender: TObject);
    procedure PeriodicBorderSwitchClick(Sender: TObject);
    procedure ApplyShiftButtonClick(Sender: TObject);
    procedure SPFApplyButtonClick(Sender: TObject);
    procedure OneFrameButtonClick(Sender: TObject);
    procedure AdditionalPagesChange(Sender: TObject);
  private
  { Private declarations }
    Running, StopFlag: boolean;
    Runner: TThread;
    One_kT, ShiftDistance: double;
    SPF: integer;
    Steps: Int64;
    procedure StopRunning;
    procedure StartRunning;
    procedure RedrawImage;
    procedure DrawAtoms(Canvas: TCanvas);
    procedure DrawGR(Canvas: TCanvas);
    procedure DrawEnergy(Canvas: TCanvas);
    procedure DrawGrid(Canvas: TCanvas; xtitle, ytitle: string;
                       xmin, ymin, xmax, ymax: integer;
                       xvalmin, yvalmin, xvalmax, yvalmax: double);
    procedure UpdateStatistics;
  public
    { Public declarations }
  end;

  TRunner = class(TThread)
  public
    Form: TMainForm;
  protected
    procedure Execute; override;
  end;

  Coord = record
    x, y: double;
  end;

  AtomArray = array [1..N] of Coord;
  GRArray = array [0..GR_N-1] of double;
  E_Array = array [1..N] of double;

var
  MainForm: TMainForm;
  atoms: AtomArray;
  GR: GRArray;
  E: E_Array;
  mode: integer;

implementation

{$R *.dfm}

function rand_double(min, max: double): double;
const granularity = 30000;
begin
  rand_double := min+((max-min)*random(granularity))/(granularity-1);
end;

{ ----------------------- Model Calculations code ----------------------- }

procedure reset_positions(x1, x2, y1, y2: double);
var i: integer;
begin
  for i := 1 to N do
  begin
    atoms[i].x := rand_double(x1, x2);
    atoms[i].y := rand_double(y1, y2);
  end;
end;

{ a/r^12-b/r^6 }
function potential(dx, dy: double): double;
var d2,d6: double;
begin
  d2 := 1.0/(sqr(dx)+sqr(dy));
  d6 := d2*d2*d2;
  potential := (potential_a*d6 - potential_b)*d6;
end;

{ potential energy with periodic boundary conditions }
{ the cutoff distance is concidered to be less than half of cell size }
function potential_periodic(dx, dy: double): double;
begin
   dx := abs(dx);
   dy := abs(dy);
   if cellsize_x - dx < dx then dx := cellsize_x - dx;
   if cellsize_y - dy < dy then dy := cellsize_y - dy;
   potential_periodic := potential(dx, dy);
end;

function atom_energy(k: integer; x, y: double): double;
var
  i: integer;
  E: double;
begin
  E := 0;
  if mode = Mode_Fixed then
  begin
    for i := 1 to N do
      if i <> k then
        E := E + potential(x-atoms[i].x, y-atoms[i].y);
  end else begin
    for i := 1 to N do
      if i <> k then
        E := E + potential_periodic(x-atoms[i].x, y-atoms[i].y);
  end;
  atom_energy := E;
end;

procedure step(count: integer; max_shift, one_kT: double);
var
  c, i: integer;
  R, phi, x, y, dE: double;
  val: double;
begin
  for c := 1 to count do
  begin
    i := random(N)+1;
    R := rand_double(0, max_shift);
    phi := rand_double(0, 2*Pi);
    x := atoms[i].x + R * cos(phi);
    y := atoms[i].y + R * sin(phi);
    if mode = Mode_Fixed then
    begin
      if x > cellsize_x then x := cellsize_x
      else if x < 0 then x := 0;
      if y > cellsize_y then y := cellsize_y
      else if y < 0 then y := 0;
      dE := atom_energy(i, x, y) - atom_energy(i, atoms[i].x, atoms[i].y);
    end else begin
      if x > cellsize_x then x := x-cellsize_x
      else if x < 0 then x := x+cellsize_x;
      if y > cellsize_y then y := y-cellsize_y
      else if y < 0 then y := y+cellsize_y;
      dE := atom_energy(i, x, y) - atom_energy(i, atoms[i].x, atoms[i].y);
    end;
    val := dE*one_kT;
    if (dE < 0) or ((val < 10) and (rand_double(0, 1) < exp(-val))) then
    begin
      atoms[i].x := x;
      atoms[i].y := y;
    end;
  end;
end;

procedure calc_GR_x(var GR: GRArray; var gmin, gmax: double);
var
  i, j, k: integer;
  c: integer;
  rmin, rmax, rmin2, rmax2: double;
  s, d2: double;
begin
  gmin := +1e20;
  gmax := -1e20;

  for k := 0 to GR_N-1 do
  begin
    c := 0;
    rmin := GR_shift + k*GR_step - GR_strip_width*0.5;
    rmax := rmin + GR_strip_width;
    if rmin < 0 then rmin := 0;
    rmin2 := sqr(rmin);
    rmax2 := sqr(rmax);
    s := Pi*(rmax2-rmin2);
    for i := 1 to N-1 do
    for j := i+1 to N do
    begin
      d2 := sqr(atoms[i].x-atoms[j].x) + sqr(atoms[i].y-atoms[j].y);
      if (d2 <= rmax2) and (d2 >= rmin2) then c := c + 2;

      { you can add mirrored atoms in a case of periodic boundaries like this: }
      {if mode = Mode_Periodic then
      begin
        d2 := sqr(atoms[i].x-atoms[j].x-cellsize_x) + sqr(atoms[i].y-atoms[j].y);
        if (d2 <= rmax2) and (d2 >= rmin2) then c := c + 2;
        d2 := sqr(atoms[i].x-atoms[j].x+cellsize_x) + sqr(atoms[i].y-atoms[j].y);
        if (d2 <= rmax2) and (d2 >= rmin2) then c := c + 2;
        d2 := sqr(atoms[i].x-atoms[j].x) + sqr(atoms[i].y-atoms[j].y-cellsize_y);
        if (d2 <= rmax2) and (d2 >= rmin2) then c := c + 2;
        d2 := sqr(atoms[i].x-atoms[j].x) + sqr(atoms[i].y-atoms[j].y+cellsize_y);
        if (d2 <= rmax2) and (d2 >= rmin2) then c := c + 2;
        // and so on
      end;}
    end;
    GR[k] := c/(N*s);
    if GR[k] < gmin then gmin := GR[k];
    if GR[k] > gmax then gmax := GR[k];
  end;
end;

procedure calc_GR(var GR: GRArray; var gmin, gmax: double);
var
  i, j, k, kmin, kmax: integer;
  c: array [0.. GR_N-1] of integer;
  rmin, rmax, rmin2, rmax2: double;
  s, d, d2: double;
begin
  for k := 0 to GR_N-1 do c[k] := 0;

  for i := 1 to N-1 do
  for j := i+1 to N do
  begin
    d2 := sqr(atoms[i].x-atoms[j].x) + sqr(atoms[i].y-atoms[j].y);
    d := sqrt(d2);
    kmin := floor((d - GR_shift - GR_strip_width*0.5)/GR_step)-1;
    kmax := ceil((d - GR_shift + GR_strip_width*0.5)/GR_step)+1;
    if kmin < 0 then kmin := 0;
    if kmax > GR_N-1 then kmax := GR_N-1;
    for k := kmin to kmax do
    begin
      rmin := GR_shift + k*GR_step - GR_strip_width*0.5;
      rmax := rmin + GR_strip_width;
      if rmin < 0 then rmin := 0;
      rmin2 := sqr(rmin);
      rmax2 := sqr(rmax);
      if (d2 <= rmax2) and (d2 >= rmin2) then c[k] := c[k] + 2;
    end;
  end;

  gmin := +1e20;
  gmax := -1e20;

  for k := 0 to GR_N-1 do
  begin
    rmin := GR_shift + k*GR_step - GR_strip_width*0.5;
    rmax := rmin + GR_strip_width;
    if rmin < 0 then rmin := 0;
    rmin2 := sqr(rmin);
    rmax2 := sqr(rmax);
    s := Pi*(rmax2-rmin2);
    GR[k] := c[k]/(N*s);
    if GR[k] < gmin then gmin := GR[k];
    if GR[k] > gmax then gmax := GR[k];
  end;
end;

procedure energy_stat(var EA: E_Array; var min, max, ave: double);
var
  i: integer;
  e: double;
begin
  min := +1e20;
  max := -1e20;
  ave := 0;

  for i := 1 to N do
  begin
    e := atom_energy(i, atoms[i].x, atoms[i].y);
    if e > max then max := e;
    if e < min then min := e;
    EA[i] := e;
    ave := ave + e;
  end;
  ave := ave / N;
end;

{ ----------------------- User Interface code ----------------------- }

procedure TRunner.Execute;
var SPF: integer;
begin
  while not Form.StopFlag do
  begin
    SPF := Form.SPF;
    step(SPF, Form.ShiftDistance, Form.One_kT);
    Form.Steps := Form.Steps+SPF;
    Synchronize(Form.RedrawImage);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //randomize;
  DecimalSeparator := '.';
  mode := Mode_Fixed;
  reset_positions(0, cellsize_x, 0, cellsize_y);
  Running := False;
  One_kT := 4.0/potential_e;
  TemperatureEdit.Text := FloatToStr(1.0/One_kT);
  ShiftDistance := potential_d/10;
  ShiftEdit.Text := FloatToStr(ShiftDistance);
  SPF := 1000;
  Steps := 0;
  SPFEdit.Text := IntToStr(SPF);
  Potential_EEdit.Caption := FloatToStr(potential_e);
  Potential_DEdit.Caption := FloatToStr(potential_d);
  CellsizeXEdit.Caption := FloatToStr(cellsize_x);
  CellsizeYEdit.Caption := FloatToStr(cellsize_y);
  self.RedrawImage;
end;

procedure TMainForm.RedrawImage;
begin
  DrawAtoms(AtomView.Canvas);
  case AdditionalPages.ActivePageIndex of
    1: UpdateStatistics;
    2: DrawGR(GRView.Canvas);
    3: DrawEnergy(EnergyView.Canvas);
  end;
  //AtomView.Repaint;
end;

procedure guess_grid(min, max: double; var shift, step: double; var count: integer);
var base: double;
begin
  base := power(10, floor(log10(abs(max-min))));
  shift := floor(1.5+min/base)*base;
  count := ceil((max-shift)/base-0.5);
  if count <= 2 then
  begin
    base := base / 4;
    shift := floor(1.5+min/base)*base;
    count := ceil((max-shift)/base-0.5);
  end;
  step := base;
end;

procedure TMainForm.DrawGrid(Canvas: TCanvas; xtitle, ytitle: string;
                             xmin, ymin, xmax, ymax: integer;
                             xvalmin, yvalmin, xvalmax, yvalmax: double);
var
  v, shift, step: double;
  c, i, count: integer;
  s: string;
begin
  with Canvas do
  begin
    FillRect(ClipRect);
    MoveTo(xmin, ymax); LineTo(xmin-4, ymax+10);
    MoveTo(xmin, ymax); LineTo(xmin+4, ymax+10);
    MoveTo(xmin, ymin); LineTo(xmin, ymax+9);

    MoveTo(xmax, ymin); LineTo(xmax-10, ymin+4);
    MoveTo(xmax, ymin); LineTo(xmax-10, ymin-4);
    MoveTo(xmin, ymin); LineTo(xmax-9, ymin);

    guess_grid(xvalmin, xvalmax, shift, step, count);
    for i := 0 to count-1 do
    begin
      v := shift + i * step;
      c := round(xmin + (v-xvalmin)*(xmax-xmin)/(xvalmax-xvalmin));
      s := Format('%.4g', [v]);
      TextOut(c-3*Length(s), ymin+Font.Height-8, s);
      MoveTo(c, ymin-3); LineTo(c, ymin+3);
    end;

    guess_grid(yvalmin, yvalmax, shift, step, count);
    for i := 0 to count-1 do
    begin
      v := shift + i * step;
      c := round(ymin + v*(ymax-ymin)/(yvalmax-yvalmin));
      s := Format('%.4g', [v]);
      TextOut(xmin+8, c-5, s);
      MoveTo(xmin-3, c); LineTo(xmin+3, c);
    end;

    Canvas.TextOut(xmin+8, ymax, ytitle);
    Canvas.TextOut(xmax-5*Length(xtitle)-3, ymin+Font.Height-8, xtitle);
  end;
end;

procedure TMainForm.DrawGR(Canvas: TCanvas);
var
  i, x, y: integer;
  xscale, xshift, yscale, yshift: double;
  gmin, gmax: double;
begin
  calc_GR(GR, gmin, gmax);
  with Canvas do
  begin
    xscale := (ClipRect.Right-ClipRect.Left-20)/(GR_N-0.5);
    yscale := -(ClipRect.Bottom-ClipRect.Top-20)/gmax;
    xshift := ClipRect.Left+10;
    yshift := ClipRect.Bottom-10;
    Brush.Color := RGB(255,255,255);
    Pen.Color := RGB(140,140,140);
    DrawGrid(Canvas, 'r/d', 'g(r)*d^2',
             ClipRect.Left+10, ClipRect.Bottom-10,
             ClipRect.Right-10, ClipRect.Top+10,
             0, 0, GR_max_R/potential_d, gmax*potential_d*potential_d);
    Brush.Color := RGB(0,0,0);
    Pen.Color := RGB(180,0,0);
    y := round(GR[0] * yscale + yshift);
    x := round(0.5 * xscale + xshift);
    MoveTo(round(xshift), y);
    LineTo(x, y);
    for i:= 1 to GR_N-1 do
    begin
      x := round((i-0.5) * xscale + xshift);
      y := round(GR[i] * yscale + yshift);
      LineTo(x, y);
      x := round((i+0.5) * xscale + xshift);
      LineTo(x, y);
    end;
  end;
end;

procedure TMainForm.DrawAtoms(Canvas: TCanvas);
var
  i, x, y: integer;
  xscale, xshift, yscale, yshift: double;
begin
  with Canvas do
  begin
    xscale := (ClipRect.Right-ClipRect.Left-20)/cellsize_x;
    yscale := (ClipRect.Bottom-ClipRect.Top-20)/cellsize_y;
    xshift := ClipRect.Left+10;
    yshift := ClipRect.Top+10;
    Brush.Color := RGB(255,255,255);
    Pen.Color := RGB(140,140,140);
    FillRect(ClipRect);
    MoveTo(ClipRect.Left+10, ClipRect.Top+10);
    LineTo(ClipRect.Right-10, ClipRect.Top+10);
    LineTo(ClipRect.Right-10, ClipRect.Bottom-10);
    LineTo(ClipRect.Left+10, ClipRect.Bottom-10);
    LineTo(ClipRect.Left+10, ClipRect.Top+10);
    Brush.Color := RGB(255,255,255);
    Pen.Color := RGB(155,155,155);
    for i:= 1 to N do
    begin
      x := round(atoms[i].x * xscale + xshift);
      y := round(atoms[i].y * yscale + yshift);
      RoundRect(x-2, y-2, x+3, y+3, 2, 2);
    end;
  end;
end;

procedure TMainForm.DrawEnergy(Canvas: TCanvas);
var
  i, k, kmin, kmax, x, y, max_n: integer;
  n_e: array [0..E_points-1] of integer;
  max, min, ave: double;
  xscale, xshift, yscale, yshift: double;
begin
  { calculate }
  energy_stat(E, min, max, ave);
  for i := 0 to E_points-1 do n_e[i] := 0;
  max_n := 0;

  { comment this out to unfix P(e) graph }
  min := -potential_e*7;
  max := 0;

  for i := 1 to N do
  begin
    kmin := floor(E_Points*((E[i]-min)/(max-min) - 0.5/E_Slices));
    kmax := ceil(E_Points*((E[i]-min)/(max-min) + 0.5/E_Slices));
    if kmin < 0 then kmin := 0;
    if kmax < 0 then kmax := 0;
    if kmin > E_points-1 then kmin := E_points-1;
    if kmax > E_points-1 then kmax := E_points-1;
    for k := kmin to kmax do
    begin
      n_e[k] := n_e[k] + 1;
      if n_e[k] > max_n then max_n := n_e[k];
    end;
  end;
  if max_n < N div 4 then max_n := N div 4
  else if max_n < N div 2 then max_n := N div 2
  else if max_n < 3*N div 4 then  max_n := 3*N div 4
  else max_n := N;
  //max_n := N;
  { draw }
  with Canvas do
  begin
    xscale := (ClipRect.Right-ClipRect.Left-20)/(E_points);
    yscale := -(ClipRect.Bottom-ClipRect.Top-20)/max_n;
    xshift := ClipRect.Left+10;
    yshift := ClipRect.Bottom-10;
    Brush.Color := RGB(255,255,255);
    Pen.Color := RGB(140,140,140);
    DrawGrid(Canvas, 'E, K', 'P, %',
             ClipRect.Left+10, ClipRect.Bottom-10,
             ClipRect.Right-10, ClipRect.Top+10,
             min, 0, max, 100*max_n/N);
    Brush.Color := RGB(0,0,0);
    Pen.Color := RGB(180,0,0);
    y := round(n_e[0] * yscale + yshift);
    x := round(xshift);
    MoveTo(round(xshift), y);
    LineTo(x, y);
    for i:= 0 to E_points-1 do
    begin
      x := round((i) * xscale + xshift);
      y := round(n_e[i] * yscale + yshift);
      LineTo(x, y);
      x := round((i+1) * xscale + xshift);
      LineTo(x, y);
    end;
  end;
end;

procedure TMainForm.UpdateStatistics;
var min, max, ave: double;
begin
  StepsView.Caption := IntToStr(Steps);
  energy_stat(E, min, max, ave);
  MeanEnergyView.Caption := FloatToStrF(ave, ffGeneral, 10, 4);
  MinEnergyView.Caption := FloatToStrF(min, ffGeneral, 10, 4);
  MaxEnergyView.Caption := FloatToStrF(max, ffGeneral, 10, 4);
end;

procedure TMainForm.StopRunning;
begin
  if Running then
  begin
    StopFlag := True;
    Runner.Priority := tpNormal;
    Runner.WaitFor;
    Runner.Destroy;
    Runner := nil;
    Running := False;
    StartButton.Caption := 'Go';
  end;
end;

procedure TMainForm.StartRunning;
begin
  if not Running then
  begin
    StopFlag := False;
    Runner := TRunner.Create(true);
    (Runner as TRunner).Form := self;
    Runner.Priority := tpLower;
    Running := True;
    Runner.Resume;
    StartButton.Caption := 'Stop';
  end;
end;

procedure TMainForm.StartButtonClick(Sender: TObject);
begin
  if not Running then
  begin
    StartButton.Enabled := False;
    StartRunning;
    StartButton.Enabled := True;
  end else begin
    StartButton.Enabled := False;
    StopRunning;
    StartButton.Enabled := True;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  StopRunning;
end;

procedure TMainForm.ResetButtonClick(Sender: TObject);
begin
  if Running then
  begin
    StopRunning;
    reset_positions(0, cellsize_x, 0, cellsize_y);
    Steps := 0;
    self.RedrawImage;
    StartRunning;
  end else begin
    reset_positions(0, cellsize_x, 0, cellsize_y);
    Steps := 0;
    self.RedrawImage;
  end;
end;

procedure TMainForm.QuitButtonClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.TemperatureEditChange(Sender: TObject);
var T: double;
begin
  try
    T := StrToFloat(self.TemperatureEdit.Text);
    One_kT := 1.0/T;
  except
    on EConvertError do
    begin
      Application.MessageBox('That is not a number', 'Validation error');
    end;
    on EZeroDivide do
    begin
      Application.MessageBox('Zero is not an acceptable temperature', 'Validation error');
    end;
  end;
end;

procedure TMainForm.TemperatureEditKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    TemperatureEditChange(Sender);
  end;
end;

procedure TMainForm.FixedBorderSwitchClick(Sender: TObject);
begin
  if Running then
  begin
    StopRunning;
    mode := Mode_Fixed;
    StartRunning;
  end else mode := Mode_Fixed;
end;

procedure TMainForm.PeriodicBorderSwitchClick(Sender: TObject);
begin
  if Running then
  begin
    StopRunning;
    mode := Mode_Periodic;
    StartRunning;
  end else mode := Mode_Periodic;
end;

procedure TMainForm.ApplyShiftButtonClick(Sender: TObject);
var shift: double;
begin
  try
    shift := StrToFloat(ShiftEdit.Text);
    ShiftDistance := shift;
  except
    on EConvertError do
    begin
      Application.MessageBox('That is not a number', 'Validation error');
    end;
  end;
end;

procedure TMainForm.SPFApplyButtonClick(Sender: TObject);
var steps: integer;
begin
  try
    steps := StrToInt(SPFEdit.Text);
    SPF := steps;
  except
    on EConvertError do
    begin
      Application.MessageBox('That is not a number', 'Validation error');
    end;
  end;
end;

procedure TMainForm.OneFrameButtonClick(Sender: TObject);
begin
  if not Running then
  begin
    step(SPF, ShiftDistance, One_kT);
    RedrawImage;
  end else begin
    StopRunning;
    OneFrameButtonClick(Sender);
  end;
end;

procedure TMainForm.AdditionalPagesChange(Sender: TObject);
begin
  case AdditionalPages.ActivePageIndex of
    1: UpdateStatistics;
    2: DrawGR(GRView.Canvas);
    3: DrawEnergy(EnergyView.Canvas);
  end;
end;

end.
