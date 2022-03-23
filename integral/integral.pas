unit integral;

interface

type TF = function (x : real) : real;
function Simpson (f : TF; a, b : real; n : integer) : real;
function Integral (f : TF; a, b, eps2 : real) : real;

implementation

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

end.