unit root;

interface

type TF = function (x : real) : real;
procedure Root(f, g, f1, g1 : TF; a, b, eps1 : real; var x : real);

implementation

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
        b := (a*Dif(b) - b*Dif(a)) / (Dif(b) - Dif(a))  {хорды}
    end
    else begin
        a := (a*Dif(b) - b*Dif(a)) / (Dif(b) - Dif(a));  {хорды}
        b := b - Dif(b) / Dif_der(b)  {касательные}
    end;
    if (abs(a - b) > eps1) then
        Root(f, g, f1, g1, a, b, eps1, x)
    else
        x := (a + b) / 2;
end;

end.