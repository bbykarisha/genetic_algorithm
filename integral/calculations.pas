{$MODE TP+}
{$F+}
uses 
    root, integral, graphics, math;
type 
    TF = function (x: real): real;
var 
    x12, x13, x23, x_otl, shape_area, shape_otl: real;

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

begin
    Root(f1, f2, der_f1, der_f2, 0.6, 4, 0.001, x12);
    Root(f1, f3, der_f1, der_f3, 0.6, 4, 0.001, x13);
    Root(f2, f3, der_f2, der_f3, 0.6, 4, 0.001, x23);
    writeln(x12:0:3);
    writeln(x13:0:3);
    writeln(x23:0:3);
    shape_area := Integral(f1, x13, x12, 0.001) - Integral(f3, x13, x23, 0.001) - Integral(f2, x23, x12, 0.001);
    writeln(shape_area:0:3);
    Graphic(f1, f2, f3, x12, x13, x23))
    {проверка отладочной функции:}
    Root(otladka, null, der_otladka, null, -1, 1, 0.001, x_otl);
    //writeln(x_otl:0:3);
    shape_otl := Integral(otladka, x_otl, 2, 0.001);
    //writeln(shape_otl:0:3);
end.