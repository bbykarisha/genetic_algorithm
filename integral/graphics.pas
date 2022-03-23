{$mode TP}
unit graphics;

interface

{$H+}
uses 
    {$IFDEF UNIX} cthreads, {$ENDIF} ptcGraph;
type 
    TF = function (x : real) : real;
procedure Graphic (f1, f2, f3 : TF; x12, x13, x23 : real);

implementation

procedure Graphic (f1, f2, f3 : TF; x12, x13, x23 : real);
var 
    d , m, i, x0, y0, onestep, n: integer;
    maxX, maxY: integer;
    x: real;
    s: string;
begin
    d := 10;
    m := 577;
    InitGraph(d, m, '');

    x0 := 198;
    y0 := 584;
    maxX := 1920;
    maxY := 1440;
    onestep := 50;

    setcolor(15);
    setlinestyle(0, 4, 1);
    settextstyle(0, 0, 2);

    line(0, y0, maxX, y0); {Ox}
    line(x0, 0, x0, maxY); {Oy}

    {рисуем стрелки + 'X', 'Y'}
    line(maxX, y0, maxX - 10, y0 - 10);
    line(maxX, y0, maxX - 10, y0 + 10);
    line(x0, 0, x0 - 10, 10);
    line(x0, 0, x0 + 10, 10);

    OutTextXY(maxX - 25, y0 - 26, 'X');
    OutTextXY(x0 + 26, 10, 'Y');

    {разметка:}
    settextstyle(0, 0, 1);
    str(0, s);
    OutTextXY(x0 - 10, y0 + 20, s);
    i := x0;
    n := 1;
    while i < maxX do
    begin
        line(i, y0 - 5, i, y0 + 5);
        str(n, s);
        OutTextXY(i + onestep, y0 + 20, s);
        n := n + 1;
        i := i + onestep
    end;
    n := -1;
    i := x0;
    while i > 0 do
    begin
        line(i, y0 - 5, i, y0 + 5);
        str(n, s);
        OutTextXY(i - onestep, y0 + 20, s);
        n := n - 1;
        i := i - onestep
    end;
    i := y0;
    n := 1;
    while i > 0 do
    begin
        line(x0 -5, i, x0 + 5, i);
        str(n, s);
        OutTextXY(x0 + 20, i - onestep, s);
        n := n + 1;
        i := i - onestep
    end;
    i := y0;
    n := -1;
    while i < maxY do
    begin
        line(x0 - 5, i, x0 + 5, i);
        str(n, s);
        OutTextXY(x0 + 20, i + onestep, s);
        n := n - 1;
        i := i + onestep
    end;

    {y = 0.6 * x + 3}
    x := -10;
    while x < 35 do
    begin
        putpixel(x0 + round(x * onestep), y0 - round(f1(x) * onestep), 11);
        x := x + 0.0001
    end;
    {y = power((x-2), 3) - 14}
    x := -10;
    while x < 35 do
    begin
        putpixel(x0 + round(x * onestep), y0 - round(f2(x) * onestep), 10);
        x := x + 0.0001
    end;
    {y = 3.0 / x}
    x := -10;
    while x < 35 do
    begin
        putpixel(x0 + round(x * onestep), y0 - round(f3(x) * onestep), 12);
        x := x + 0.0001
    end;

    line(x0 + round(x12 * onestep), y0 - round(f1(x12) * onestep), x0 + round(x12 * onestep), y0);
    OutTextXY(x0 + round(x12 * onestep) + 5, y0 - 10, 'X12');
    line(x0 + round(x13 * onestep), y0 - round(f1(x13) * onestep), x0 + round(x13 * onestep), y0);
    OutTextXY(x0 + round(x13 * onestep) + 5, y0 - 10, 'X13');
    line(x0 + round(x23 * onestep), y0 - round(f2(x23) * onestep), x0 + round(x23 * onestep), y0);
    OutTextXY(x0 + round(x23 * onestep) + 5, y0 - 10, 'X23');
    readln();
    closegraph;
end;

end.