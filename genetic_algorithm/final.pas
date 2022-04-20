{$MODE TP+}
{$H+}
uses 
    math;
const 
    m = 15;
type
    TF = function(x: real): real;
    individual_num = array [1..1000] of smallint;
    individual_arg = array [1..1000] of real;
    individual_func = array [1..1000] of real;
    individual_num_bin = array [1..1000] of int64;
var 
    population_volume, preserved_high_positions, preserved_low_positions, cnt, i, difference: integer;
    crossing_cnt, mutation_cnt, duplicates_cnt, selection_cnt, max_iters, max_valueless_iters: integer;
    a: individual_num;
    b: individual_arg;
    c: individual_func;
    bin: individual_num_bin;
    crossing_volume, variability, quality_epsilon, enough_function_value, tmp: real;
    f1, f2: text;
    exit_flag: boolean;
     
function F(x: real): real;
begin
    F := x * (x - 2) * (x - 2.75) * cos(x/10) * (2 - power(3, (x-2))) * exp(x/10);  
end;

procedure Forming_first_population(var arr: individual_num);
var 
    j: integer;
    cnt: smallint;
begin
    for j := 1 to population_volume do 
    begin
        cnt := random(32760) + 1;
        arr[j] := cnt;
    end;
end;

procedure Coding_individual(left, right: real; var a: individual_num; var b: individual_arg);
var 
    j: integer;
    val: real;
begin
    for j := 1 to population_volume do 
    begin 
        val := left + a[j] * (right - left) / power(2, m);
        b[j] := val;
    end;
end;

procedure Calculation_quality_function(func: TF; var a: individual_arg; var b: individual_func);
var 
    j: integer;
begin
    for j := 1 to population_volume do
        b[j] := func(a[j]);    
end;

procedure Coctail_sort(var a: individual_func; var b: individual_arg; var c: individual_num; var d: individual_num_bin);
var 
    j, first_ind, last_ind: integer;
    tmp_a, tmp_b: real;
    tmp_c: smallint;
    tmp_d: int64;
begin
    first_ind := 1;
    last_ind := population_volume;
    while first_ind < last_ind do 
    begin
        for j := first_ind to last_ind - 1 do
            if a[j] < a[j+1] then begin
                tmp_a := a[j];
                a[j] := a[j+1];
                a[j+1] := tmp_a;
                
                tmp_b := b[j];
                b[j] := b[j+1];
                b[j+1] := tmp_b;

                tmp_c := c[j];
                c[j] := c[j+1];
                c[j+1] := tmp_c;

                tmp_d := d[j];
                d[j] := d[j+1];
                d[j+1] := tmp_d;
            end;
        for j := last_ind downto first_ind + 1 do
            if a[j] > a[j-1] then begin
                tmp_a := a[j];
                a[j] := a[j-1];
                a[j-1] := tmp_a;
                
                tmp_b := b[j];
                b[j] := b[j-1];
                b[j-1] := tmp_b;

                tmp_c := c[j];
                c[j] := c[j-1];
                c[j-1] := tmp_c;

                tmp_d := d[j];
                d[j] := d[j-1];
                d[j-1] := tmp_d;
            end;
        first_ind := first_ind + 1;
        last_ind := last_ind - 1;   
    end; 
end;       

procedure Selection(var a: individual_num);
var 
    j, ind: integer;
begin
    for j := 1 to selection_cnt do
    begin
        ind := preserved_high_positions + random(difference); 
        a[ind] := -1; 
    end;
end;

procedure Single_crossing(var a: individual_num; cnt: integer);
var    
    i, j, ind_1, ind_2, n: integer;
    mask: smallint;
begin
    for i := 1 to cnt do
    begin
    	n := random(16);
    	mask := trunc(power(2, (n+1)) - 1);
        repeat
            ind_1 := random(population_volume);     
        until (a[ind_1] <> -1); 
        repeat
            ind_2 := random(population_volume);   
        until (a[ind_2] <> -1);
        for j := 1 to population_volume do
            if (a[j] = -1) then begin
            	a[j] := abs( (a[ind_1] and (not(mask))) or (a[ind_2] and mask) );
            	break;
            end;
    end;
end;

procedure Double_crossing(var a: individual_num; cnt: integer);
var    
    i, j, k, ind_1, ind_2, min_n, max_n, n_1, n_2: integer;
    mask: smallint;
begin
    for i := 1 to cnt do
    begin
    	n_1 := random(16);
        n_2 := random(16);
        min_n := min(n_1, n_2);
        max_n := max(n_1, n_2);
        mask := 0;
        repeat
            ind_1 := random(population_volume);     
        until (a[ind_1] <> -1); 
        repeat
            ind_2 := random(population_volume);   
        until (a[ind_2] <> -1);
        for j := 1 to population_volume do
            if (a[j] = -1) then begin
                for k := min_n to (max_n - 1) do 
                    mask := mask + trunc(power(2, k));
                a[j] := abs(a[ind_1] and (not(mask))) or (a[ind_2] and mask);
                break;
            end;
    end;
end;

procedure Universal_crossing(var a:individual_num; cnt: integer);
var    
    i, j, k, ind_1, ind_2, num_rod, num_bit: integer; 
    mask, res, res_tmp: smallint;
begin
    for i := 1 to cnt do
    begin
    	num_bit := random(16);
        num_rod := random(2) + 1;
        mask := trunc(power(2, num_bit));
        res := 0;
        repeat
            ind_1 := random(population_volume);     
        until (a[ind_1] <> -1); 
        repeat
            ind_2 := random(population_volume);   
        until (a[ind_2] <> -1);
        for j := 1 to population_volume do
            if (a[j] = -1) then begin
                for k := 1 to 16 do
                begin
                    if (num_rod = 1) then res_tmp := a[ind_1] and mask
                    else res_tmp := a[ind_2] and mask;
                    res := res or res_tmp;
                end;
                a[j] := abs(res);
                break;
            end;
    end;
end;

procedure Uniform_crossing(var a: individual_num; cnt: integer);
var    
    i, j, ind_1, ind_2: integer;
    mask: smallint;
begin
    for i := 1 to cnt do
    begin
    	mask := random(16);
        repeat
            ind_1 := random(population_volume);     
        until (a[ind_1] <> -1);
        repeat
            ind_2 := random(population_volume);   
        until (a[ind_2] <> -1);
        for j := 1 to population_volume do
            if (a[j] = -1) then  begin
                a[j] := abs((a[ind_1] and mask) or (a[ind_2] and (not(mask))));
                break;
            end;
    end;
end;

procedure Change_bit_mutation(var a: individual_num; cnt: integer);
var 
    i, j, ind, n: integer;
    mask: smallint;
begin 
    for i := 1 to cnt do
    begin
        n := random(16);
        mask := trunc(power(2, n));
        repeat
            ind := random(population_volume);
        until (a[ind] <> -1);
        for j := 1 to population_volume do
            if (a[j] = -1) then begin 
                a[j] := abs(a[ind] xor mask); 
                break;
            end;
    end;
end;

procedure Rearrange_bits_mutation(var a:individual_num; cnt: integer);
var 
    i, j, ind, n_1, n_2: integer;
    mask_1, mask_2: smallint;
begin    
    for i := 1 to cnt do
    begin
        n_1 := random(16);
        n_2 := random(16);
        mask_1 := trunc(power(2, n_1));
        mask_2 := trunc(power(2, n_2));
        repeat
            ind := random(population_volume);
        until (a[ind] <> -1);
        for j := 1 to population_volume do
            if (a[j] = -1) then begin
                if ((a[ind] and mask_1) = 0) and  ((a[ind] and mask_2) = 0) or
                ((a[ind] and mask_1) <> 0) and ((a[ind] and mask_2) <> 0) 
                    then a[j] := a[ind] {переставляемые биты одинаковые}
                else  
                    a[j] := abs((a[ind] xor mask_1) xor mask_2); {биты разные} 
                break;   
            end;
    end;
end;

procedure Reverse_bits_mutation(var a: individual_num; cnt: integer);
var 
    i, j, ind, n: integer;
    mask_1, mask_2, bit_shift, res_1, res_2, res: smallint;
begin 
    for i := 1 to cnt do
    begin
        n := random(14) + 2;
        bit_shift := n - 1;
        mask_1 := trunc(power(2, n - 1));
        mask_2 := 1;
        repeat
            ind := random(population_volume);
        until (a[ind] <> -1);
        res := a[ind];
        while (mask_1 > mask_2) do
        begin
            res_1 := a[ind] and mask_1;
            res_2 := a[ind] and mask_2;
            res := (res and (not(mask_1 or mask_2))) or (res_1 shr bit_shift) or (res_2 shl bit_shift);        
            mask_1 := mask_1 shr 1;
            mask_2 := mask_2 shl 1;
            bit_shift := bit_shift - 2; 
        end;
        for j := 1 to population_volume do begin
            if (a[j] = -1) then begin 
                a[j] := res; 
                break;
            end;
        end;
    end;
end;

procedure Add_change_bit_mutation(var a: individual_num);
var 
    i, j, ind, n: integer;
    mask: smallint;
begin 
    for i := 1 to duplicates_cnt do
    begin
        n := random(16);
        mask := trunc(power(2, n));
        repeat
            ind := random(population_volume);
        until (a[ind] <> -2);
        for j := 1 to population_volume do
            if (a[j] = -2) then begin 
                a[j] := abs(a[ind] xor mask); 
                break;
            end;
    end;
end;

procedure Add_rearrange_bits_mutation(var a:individual_num);
var 
    i, j, ind, n_1, n_2: integer;
    mask_1, mask_2: smallint;
begin    
    for i := 1 to duplicates_cnt do
    begin
        n_1 := random(16);
        n_2 := random(16);
        mask_1 := trunc(power(2, n_1));
        mask_2 := trunc(power(2, n_2));
        repeat
            ind := random(population_volume);
        until (a[ind] <> -2);
        for j := 1 to population_volume do
            if (a[j] = -2) then begin
                if ((a[ind] and mask_1) = 0) and  ((a[ind] and mask_2) = 0) or
                ((a[ind] and mask_1) <> 0) and ((a[ind] and mask_2) <> 0) 
                    then a[j] := a[ind] {переставляемые биты одинаковые}
                else  
                    a[j] := abs((a[ind] xor mask_1) xor mask_2); {биты разные} 
                break;   
            end;
    end;
end;

procedure Add_reverse_bits_mutation(var a: individual_num);
var 
    i, j, ind, n: integer;
    mask_1, mask_2, bit_shift, res_1, res_2, res: smallint;
begin 
    for i := 1 to duplicates_cnt do
    begin
        n := random(14) + 2;
        bit_shift := n - 1;
        mask_1 := trunc(power(2, n - 1));
        mask_2 := 1;
        repeat
            ind := random(population_volume);
        until (a[ind] <> -2);
        res := a[ind];
        while (mask_1 > mask_2) do
        begin
            res_1 := a[ind] and mask_1;
            res_2 := a[ind] and mask_2;
            res := (res and (not(mask_1 or mask_2))) or (res_1 shr bit_shift) or (res_2 shl bit_shift);        
            mask_1 := mask_1 shr 1;
            mask_2 := mask_2 shl 1;
            bit_shift := bit_shift - 2; 
        end;
        for j := 1 to population_volume do begin
            if (a[j] = -2) then begin 
                a[j] := res; 
                break;
            end;
        end;
    end;
end;
 

procedure Crossing(var a: individual_num; cnt: integer);
var 
    num_cross: integer;
begin
    num_cross := random(4);
    case num_cross of
    0: Single_crossing(a, cnt);
    1: Double_crossing(a, cnt);
    2: Universal_crossing(a, cnt);
    3: Uniform_crossing(a, cnt);
    end; 
end;

procedure Mutation(var a: individual_num; cnt: integer);
var 
    num_mut: integer;
begin
    num_mut := random(3);
    case num_mut of
    0: Change_bit_mutation(a, cnt);
    1: Rearrange_bits_mutation(a, cnt);
    2: Reverse_bits_mutation(a, cnt);
    end;
end;

procedure Additional_mutation(var a: individual_num);
var 
    num_mut: integer;
begin
    num_mut := random(3);
    case num_mut of
    0: Add_change_bit_mutation(a);
    1: Add_rearrange_bits_mutation(a);
    2: Add_reverse_bits_mutation(a);
    end;
end;

procedure Destruction_duplicates(var a: individual_num);
var 
    i, j: integer;
begin
    duplicates_cnt := 0;
    for i := 1 to population_volume do
    begin
        tmp := a[i];
        for j := 1 to population_volume do  
            if ((a[j] = tmp) and (i <> j) and (a[j] <> -2)) then begin  
                a[j] := -2;
                inc(duplicates_cnt);
            end;
    end; 
    if (duplicates_cnt <> 0) then Additional_mutation(a);    
end;

procedure Convert_to_binary(a: individual_num; var b: individual_num_bin);
var 
    j: integer;
    num: int64;
begin
    for j := 1 to population_volume do
    begin
        num := 1;
        b[j] := 0;
        repeat
            b[j] := (a[j] mod 2) * num + b[j];
            a[j] := a[j] div 2;
            num := num * 10;   
        until (a[j] = 0);
    end;  
end;

procedure Data_input(var f1: text);
var 
    s, str: string;
    ind1, ind2, ind3, cnt: integer;
begin
    cnt := 0;
    assign(f1, 'config.txt');
    reset(f1);
    while not eof(f1) do
    begin 
        readln(f1, s);
        ind1 := pos('=', s);
        str := copy(s, 1, ind1 - 2);      
        if (str = 'population_volume') then begin
            delete(s, 1, ind1 + 1);
            ind2 := pos(' ', s);
            delete(s, ind2, length(s));  
            ind3 := pos('#', s);
            delete(s, ind3, length(s));
            val(s, population_volume);
            if (population_volume <= 0) then begin
                writeln('Неверный ввод параметра population_volume');
                exit_flag := true;   
            end
            else inc(cnt);
        end
        else if (str = 'preserved_high_positions') then begin
            delete(s, 1, ind1 + 1);
            ind2 := pos(' ', s);
            delete(s, ind2, length(s));  
            ind3 := pos('#', s);
            delete(s, ind3, length(s)); 
            val(s, preserved_high_positions);
            if (preserved_high_positions <= 0) then begin
                writeln('Неверный ввод параметра preserved_high_positions');
                exit_flag := true;
            end
            else inc(cnt);
        end
        else if (str = 'preserved_low_positions') then begin
            delete(s, 1, ind1 + 1);
            ind2 := pos(' ', s);
            delete(s, ind2, length(s));  
            ind3 := pos('#', s);
            delete(s, ind3, length(s)); 
            val(s, preserved_low_positions);
            if (preserved_low_positions <= 0) then begin
                writeln('Неверный ввод параметра preserved_low_positions');
                exit_flag := true;
            end
            else inc(cnt);
        end
        else if (str = 'crossing_volume') then begin
            delete(s, 1, ind1 + 1);
            ind2 := pos(' ', s);
            delete(s, ind2, length(s));  
            ind3 := pos('#', s);
            delete(s, ind3, length(s)); 
            val(s, crossing_volume);
            if (crossing_volume = 0) then begin
                writeln('Неверный ввод параметра crossing_volume');
                exit_flag := true;
            end
            else inc(cnt);
        end
        else if (str = 'variability') then begin
            delete(s, 1, ind1 + 1);
            ind2 := pos(' ', s);
            delete(s, ind2, length(s));  
            ind3 := pos('#', s);
            delete(s, ind3, length(s)); 
            val(s, variability);
            if (variability = 0) then begin
                writeln('Неверный ввод параметра variability');
                exit_flag := true;
            end
            else inc(cnt);
        end
        else if (str = 'max_iters') then begin
            delete(s, 1, ind1 + 1);
            ind2 := pos(' ', s);
            delete(s, ind2, length(s));  
            ind3 := pos('#', s);
            delete(s, ind3, length(s)); 
            val(s, max_iters);
            if (max_iters <= 0) then begin
                writeln('Неверный ввод параметра max_iters');
                exit_flag := true;
            end
            else inc(cnt);
        end
        else if (str = 'quality_epsilon') then begin
            delete(s, 1, ind1 + 1);
            ind2 := pos(' ', s);
            delete(s, ind2, length(s));  
            ind3 := pos('#', s);
            delete(s, ind3, length(s)); 
            val(s, quality_epsilon);
            if (quality_epsilon = 0) then begin
                writeln('Неверный ввод параметра quality_epsilon');
                exit_flag := true;
            end
            else inc(cnt);
        end
        else if (str = 'max_valueless_iters') then begin
            delete(s, 1, ind1 + 1);
            ind2 := pos(' ', s);
            delete(s, ind2, length(s));  
            ind3 := pos('#', s);
            delete(s, ind3, length(s)); 
            val(s, max_valueless_iters);
            if (max_valueless_iters <= 0) then begin
                writeln('Неверный ввод параметра max_valueless_iters');
                exit_flag := true;
            end
            else inc(cnt);
        end
        else if (str = 'enough_function_value') then begin
            delete(s, 1, ind1 + 1);
            ind2 := pos(' ', s);
            delete(s, ind2, length(s));  
            ind3 := pos('#', s);
            delete(s, ind3, length(s)); 
            val(s, enough_function_value);
            if (enough_function_value = 0) then begin
                writeln('Неверный ввод параметра enough_function_value');
                exit_flag := true;
            end
            else inc(cnt);
        end
    end;
    if (cnt < 9) then begin
        writeln('Недостаточное количество параметров или название параметра введено неверно или встречены недопустимые символы');
        exit_flag := true;
    end;
    if (cnt > 9) then begin
        writeln('Параметр встречается более одного раза');
        exit_flag := true;
    end;
    close(f1);
end;  

procedure Data_output(var f2: text);
var     
    j: integer;
begin
    for j := 1 to population_volume do
        writeln(f2, bin[j]:20, '   ', a[j]:8, '   ', b[j]:10:5, '   ', c[j]:10:5);
end;

begin
    randomize;
    exit_flag := false;
    Data_input(f1);
    if (exit_flag = true) then exit;
    
    crossing_cnt := round(crossing_volume * population_volume);
    mutation_cnt := round(variability * population_volume);

    assign(f2, 'output.txt');
    rewrite(f2);
    writeln(f2, 'битовое представление ', ' номер особи ', ' значение X ', ' значение Y ');
    writeln(f2, 'Начальная популяция:');
    
    Forming_first_population(a);
    Coding_individual(0.0, 4.0, a, b);
    Convert_to_binary(a, bin);

    cnt := 1;
    tmp := c[1];
    for i := 1 to max_iters do
    begin
        writeln(f2, i, '-ая итерация:');
        duplicates_cnt := 0;
        Calculation_quality_function(F, b, c); 
        Data_output(f2);
        writeln(f2, 'Отсортированная популяция:');
        Coctail_sort(c, b, a, bin);
        Data_output(f2);
        if (c[1] >= enough_function_value) then begin
            writeln(b[1]:0:5, ' ', c[1]:0:5, '  ', i, '-ая итерация');
            writeln('Достигнуто заданное значение функции качества');
            exit;
        end;
        if (abs(c[1] - tmp) <= quality_epsilon) then inc(cnt)
        else begin
            cnt := 1;
            tmp := c[1]
        end;
        if (cnt = max_valueless_iters) then begin
            writeln(b[1]:0:5, ' ', c[1]:0:5);
            writeln('Выполнено заданное количество итераций без улучшения качества популяции');
            exit;
        end;
        writeln(f2, 'Популяция после селекции:');
        difference := population_volume - preserved_high_positions - preserved_low_positions;
        selection_cnt := random(difference) + 1;
        Selection(a);
        Data_output(f2);

        if (selection_cnt >= crossing_cnt + mutation_cnt) then begin
            writeln(f2, 'Популяция после скрещивания:');
            Crossing(a, crossing_cnt);
            Coding_individual(0.0, 4.0, a, b);
            Convert_to_binary(a, bin);
            Calculation_quality_function(F, b, c);
            Data_output(f2);

            writeln(f2, 'Популяция после мутации:');
            Mutation(a, mutation_cnt);
            Mutation(a, selection_cnt - crossing_cnt - mutation_cnt);
            Coding_individual(0.0, 4.0, a, b);
            Convert_to_binary(a, bin);
            Calculation_quality_function(F, b, c);
            Data_output(f2);   
        end
        else begin
            writeln(f2, 'Популяция после скрещивания:');
            Crossing(a, crossing_cnt);
            Coding_individual(0.0, 4.0, a, b);
            Convert_to_binary(a, bin);
            Calculation_quality_function(F, b, c);
            Data_output(f2);

            writeln(f2, 'Популяция после мутации:');
            Mutation(a, selection_cnt - crossing_cnt);
            Coding_individual(0.0, 4.0, a, b);
            Convert_to_binary(a, bin);
            Calculation_quality_function(F, b, c);
            Data_output(f2);      
        end;
        
        writeln(f2, 'Популяция после удаления дубликатов:');
        Destruction_duplicates(a); 
        Coding_individual(0.0, 4.0, a, b);
        Convert_to_binary(a, bin);
        Calculation_quality_function(F, b, c);
        Data_output(f2);
    end;
    writeln(b[1]:0:5, ' ', c[1]:0:5);
    writeln('Выполнено максимальное количество итераций');
    exit;  
    
    close(f2);
end.