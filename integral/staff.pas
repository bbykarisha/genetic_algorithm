{$MODE TP+}
{$H+}

uses 
    {$IFDEF UNIX} cthreads, {$ENDIF} ptcGraph, math;
type 
    TF = function (x : real) : real;
var 
    x12, x13, x23, shape_area, x_otl, shape_otl, eps: real;
    num: integer;

function f1(x: real): real; 
begin 
    f1 := 0.6 * x + 3; 
end;
function der_f1(x: real): real; 
begin 
    der_f1 := 0.6; 
end;

function f2(x: real): real; 
begin 
    f2:= power((x-2), 3) - 1; 
end;
function der_f2(x: real): real; 
begin 
    der_f2:= 3 * power((x-2), 2); 
end;

function f3(x: real): real; 
begin 
    f3:= 3.0 / x; 
end;
function der_f3(x: real): real; 
begin 
    der_f3:= -3.0 / sqr(x); 
end;

{отладочные функции:}
function otladka(x: real): real; 
begin 
    otladka:= power(x, 3); 
end;
function der_otladka(x: real): real; 
begin 
    der_otladka:= 3 * power(x, 2); 
end;
function null(x: real): real; 
begin 
    null:= 0; 
end;

function Char_num(n: real): integer;
var
    cnt: integer;
begin
    cnt := 0;
    while (n <> 1) do begin
        n := n * 10;
        cnt := cnt + 1;
    end;
    Char_num := cnt;
end;

procedure Root(f, g, f1, g1 : TF; a, b, eps1 : real; var x : real);

function Dif (x : real) : real;
begin
    Dif := f(x) - g(x);
end;
function Dif_der (x : real) : real;
begin
    Dif_der := f1(x) - g1(x);
end;

begin
    if (Dif(a) < 0) and ( Dif((a+b)/2) > (Dif(a) + Dif(b))/2 ) 
        or (Dif(a) > 0) and ( Dif((a+b)/2) < (Dif(a) + Dif(b))/2 )  then
    begin
        a := a - Dif(a) / Dif_der(a);  {касательные}
        b := (a*Dif(b) - b*Dif(a)) / (Dif(b) - Dif(a));  {хорды}
    end
    else begin
        a := (a*Dif(b) - b*Dif(a)) / (Dif(b) - Dif(a));  {хорды}
        b := b - Dif(b) / Dif_der(b);  {касательные}
    end;
    if (abs(a - b) > eps1) then begin 
    	writeln(a:0:num, ' ', b:0:num);
        Root(f, g, f1, g1, a, b, eps1, x);
    end
    else begin
        x := (a + b) / 2;
        writeln();
    end;
end;

function Simpson (f : TF; a, b : real; n : integer) : real;
var h, f_n, s : real;
    j : integer;
begin
    h := (b - a) / n;
    s := f(a) + f(b);
    for j := 1 to n - 1 do
    begin
        f_n := f(a + j * h);
        if (j mod 2 = 0) then
            s := s + 2 * f_n
        else
            s := s + 4 * f_n;
    end;
    Simpson := h/3 * s;
end;

function Integral (f : TF; a, b, eps2 : real) : real;
var p : real;
    n : integer;
begin
    n := 500;
    p := 1/15; {коэффициент Рунге для метода Симпсона}  
    while (p * abs(Simpson(f, a, b, n) - Simpson(f, a, b, 2*n)) > eps2) do
        n := 2 * n;
    Integral := Simpson(f, a, b, 2*n)
end;

procedure Graphic (f1, f2, f3 : TF; x12, x13, x23 : real);
var 
    d , m, i, x0, y0, onestep, n: integer;
    maxX, maxY: integer;
    x, xd: real;
    s: string;
    
begin
    d := 10;
    m := 577;
    InitGraph(d, m, '');

    x0 := round(GetMaxX() / 2);
    y0 := round(GetMaxY() / 2);
    maxX := GetMaxX();
    maxY := GetMaxY();
    onestep := 50;
     
    setbkcolor(15);
    setcolor(8);
    setlinestyle(0, 4, 2);
    settextstyle(0, 0, 2);

    line(0, y0, maxX, y0); {Ox}
    line(x0, 0, x0, maxY); {Oy}

    {стрелки + 'X', 'Y'}
    line(maxX, y0, maxX - 10, y0 - 10);
    line(maxX, y0, maxX - 10, y0 + 10);
    line(x0, 0, x0 - 10, 10);
    line(x0, 0, x0 + 10, 10);

    OutTextXY(maxX - 25, y0 - 26, 'X');
    OutTextXY(x0 - 30, 7, 'Y');

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
    x := -20;
    while x < 35 do
    begin
        putpixel(x0 + round(x * onestep), y0 - round(f1(x) * onestep), lightblue);
        x := x + 0.0001
    end;
    {y = power((x-2), 3) - 1}
    x := -5;
    while x < 8 do
    begin
        putpixel(x0 + round(x * onestep), y0 - round(f2(x) * onestep), lightred);
        x := x + 0.0001
    end;
    {y = 3.0 / x}
    x := -20;
    while x < 35 do
    begin
        putpixel(x0 + round(x * onestep), y0 - round(f3(x) * onestep), magenta);
        x := x + 0.0001
    end;
    
    //if ( x > x13 and x < x12 and y < f1(x) and y > f3(x) and y > f2(x)) then setfillstyle(WideDotFill, 10);
    
    (*x := x13 + 0.1;
    xd := x23;
    while (x < x23) and (f2(xd) < f2(x12)) do
    begin
    line(x0 + round(x * onestep), y0 - round(f1(x) * onestep), x0 + round(xd * onestep), y0 - round(f2(xd) * onestep));
    x := x + 0.1;
    xd := xd + 0.1
    end;*)
    
    
    (*x := x13 + 0.1;
    xd := x23;
    while (x < x12) and (f3(xd) < f2(x12)) do
    begin
    line(x0 + round(x * onestep), y0 - round(f1(x) * onestep), x0 + round(xd * onestep), y0 - round(f2(xd) * onestep));
    x := x + 0.1;
    xd := xd + 0.1
    end;*)
    
    line(x0 + round(x12 * onestep), y0 - round(f1(x12) * onestep), x0 + round(x12 * onestep), y0);
    OutTextXY(x0 + round(x12 * onestep) + 5, y0 - 20, 'X12');
    line(x0 + round(x13 * onestep), y0 - round(f1(x13) * onestep), x0 + round(x13 * onestep), y0);
    OutTextXY(x0 + round(x13 * onestep) + 5, y0 - 20, 'X13');
    line(x0 + round(x23 * onestep), y0 - round(f2(x23) * onestep), x0 + round(x23 * onestep), y0);
    OutTextXY(x0 + round(x23 * onestep) + 5, y0 - 20, 'X23');
    readln();
    closegraph;
end;

begin
    if ((ParamCount > 1) or (ParamCount = 0)) then begin
        writeln('Неверное количество параметров');
        exit();
    end;
    val(ParamStr(1), eps);
    num := Char_num(eps); 
    writeln(0.6:0:num, ' ', 4.0:0:num);
    Root(f1, f3, der_f1, der_f3, 0.6, 4, eps, x13);
    writeln(0.6:0:num, ' ', 4.0:0:num);
    Root(f2, f3, der_f2, der_f3, 0.6, 4, eps, x23);
    writeln(0.6:0:num, ' ', 4.0:0:num);
    Root(f1, f2, der_f1, der_f2, 0.6, 4, eps, x12);
    writeln('Первый корень: ', x13:0:num);
    writeln('Второй корень: ', x23:0:num);
    writeln('Третий корень: ', x12:0:num);
    shape_area := Integral(f1, x13, x12, eps) - Integral(f3, x13, x23, eps) - Integral(f2, x23, x12, eps);
    writeln('Площадь фигуры = ', shape_area:0:num);
    Graphic(f1, f2, f3, x12, x13, x23);
    {проверка отладочной функции:}
    Root(otladka, null, der_otladka, null, -1, 1, eps, x_otl);
    //writeln(x_otl:0:num);
    shape_otl := Integral(otladka, x_otl, 2, eps);
    //writeln(shape_otl:0:num);
end.