program task1;
uses crt;
type
    protein_sequence = array [0..499] of char;
    rnk_sequence = array [0..9999] of char;
    rnk_sequence_without_spaces = array [0..9999] of char;
    cnt_of_rnk_lines = array [0..9999] of integer;

var 
    protein: protein_sequence;
    rnk: rnk_sequence;
    rnk_new: rnk_sequence_without_spaces;
    rnk_lines: cnt_of_rnk_lines;
    num_p, num_r, cur_p, cur_r, start_ind, end_ind: integer;
    num_r_new, temp_start_ind, flag: integer;
    symb_p, symb_r: char;
    is_there_ans, is_was_start: boolean;
    cnt_in_line, num_lines, u, z, k, j: integer;
    start_x,start_y, end_x, end_y, cur_x, cur_y: integer;
     
begin
    clrscr;
    u := 0;
    cur_x := 0;
    cur_y := 1;           
    num_p := 1;
    protein[0] := 'B';
    repeat
        read(symb_p);
        if ( (symb_p = 'A') or (symb_p = 'R') or (symb_p = 'N') or (symb_p = 'D') or
            (symb_p = 'C') or (symb_p = 'E') or (symb_p = 'Q') or (symb_p = 'G') or 
            (symb_p = 'H') or (symb_p = 'I') or (symb_p = 'L') or (symb_p = 'K') or
            (symb_p = 'M') or (symb_p = 'F') or (symb_p = 'P') or (symb_p = 'S') or 
            (symb_p = 'T') or (symb_p = 'W') or (symb_p = 'Y') or (symb_p = 'V')) then 
        begin
            protein[num_p] := symb_p;
            num_p := num_p + 1;    
        end
        else if ((symb_p <> '.') and (symb_p <> '-') and (symb_p <> ' ') and 
            (ord(symb_p) <> 9) and (ord(symb_p) <> 13)) then 
        begin 
            writeln('The protein sequence contains invalid characters!');
            exit;
        end; 
    until (symb_p = '.');
    protein[num_p] := '#';
    num_p := num_p + 1;
    num_r := 0;
    read(symb_p);
    {read(symb_p);}
    num_r_new := 0;
    cnt_in_line := 0;
    num_lines := 0;
    repeat
        read(symb_r);
        if ((symb_r = 'A') or (symb_r = 'a') or (symb_r = 'U') or (symb_r = 'u') or 
            (symb_r = 'G') or (symb_r = 'g') or (symb_r = 'C') or (symb_r = 'c') or 
            (symb_r = '-') or (symb_r = ' ') or (symb_r = '-') or (symb_r = ' ') or 
            (ord(symb_r) = 9) or (ord(symb_r) = 13) ) then
        begin
            rnk[num_r] := symb_r;
            num_r := num_r + 1;
            cnt_in_line := cnt_in_line + 1;
        end;
        if ((symb_r = 'A') or (symb_r = 'a') or (symb_r = 'U') or (symb_r = 'u') or  
            (symb_r = 'G') or (symb_r = 'g') or (symb_r = 'C') or (symb_r = 'c')) then
        begin
            rnk_new[num_r_new] := symb_r;
            num_r_new := num_r_new + 1;
        end
        else if (ord(symb_r) = 10) then
        begin
            num_lines := num_lines + 1;
            rnk_lines[num_lines] := cnt_in_line;
            cnt_in_line := 0;
            rnk[num_r] := '%';
            num_r := num_r + 1;
        end
        else if ((symb_r <> '.') and (symb_r <> ' ') and (symb_r <> '-') and 
            (ord(symb_r) <> 13) and (ord(symb_r) <> 9)) then
        begin
            writeln('The rnk sequence contains invalid characters!');
            exit;
        end;       
    until (symb_r = '.');
    num_lines := num_lines + 1;
    rnk_lines[num_lines] := cnt_in_line;
     
    if (num_r_new < 9) then 
    begin
        writeln('The rnk sequence has insufficient quantity of letters!');
        exit;
    end;

    cur_p := 0;
    cur_r := 0;
    start_ind := 0;
    end_ind := 0;
    is_there_ans := false;
    while ((cur_p < num_p) and (cur_r < num_r_new - 2)) do 
    begin
        if (cur_p = 0) then start_ind := cur_r; 
        if (protein[cur_p] = 'B') then
        begin
            if ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'AUG') then  
            begin
                start_ind := cur_r + 1;
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'A') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GCU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GCC') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GCA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GCG')) then
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'R') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CGU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CGC') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CGA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CGG') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'AGA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'AGG')) then
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'N') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'AAU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'AAC')) then  
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'D') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GAU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GAC')) then  
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'C') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UGU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UGC')) then  
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'Q') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CAA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CAG')) then  
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'E') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GAA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GAG')) then  
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'G') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GGU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GGC') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GGA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GGG')) then
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'H') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CAU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CAC')) then  
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'I') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'AUU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'AUC') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'AUA')) then   
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'L') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UUA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UUG') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CUU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CUC') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CUA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CUG')) then
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'K') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'AAA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'AAG')) then  
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'M') then
        begin
            if ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'AUG') then  
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'F') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UUU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UUC')) then  
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'P') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CCU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CCC') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CCA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'CCG')) then
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'S') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UCU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UCC') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UCA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UCG') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'AGU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'AGC')) then
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'T') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'ACU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'ACC') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'ACA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'ACG')) then
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'W') then
        begin
            if ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UGG') then  
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'Y') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UAU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UAC')) then   
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = 'V') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GUU') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GUC') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GUA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'GUG')) then
            begin
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end
        else if (protein[cur_p] = '#') then
        begin
            if (((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UAA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UGA') or 
               ((rnk_new[cur_r] + rnk_new[cur_r + 1] + rnk_new[cur_r + 2]) = 'UAG')) then   
            begin
                is_there_ans := true;
                cur_p := cur_p + 1;
                cur_r := cur_r + 3;
                end_ind := cur_r;

                start_x := 0;
                start_y := 0;
                end_x := 0;
                end_y := 0;
               
                is_was_start := false;
                z := start_ind - 1;
                while (z < (end_ind - 1)) do
                begin
                    for k := u to num_r - 1 do
                    begin
                        u := k; 
                        if ((rnk[k] = ' ') or (rnk[k] = '-') or (ord(rnk[k]) = 10) or 
                            (ord(rnk[k]) = 13) or (rnk[k] = '\n') or (rnk[k] = '\r')) then 
                        begin
                            cur_x := cur_x + 1;
                            continue;
                        end;
                        if (rnk_new[z] = rnk[k]) then
                        begin
                            cur_x := cur_x + 1;
                            if ((z = (start_ind - 1)) and (is_was_start = false)) then 
                            begin
                                is_was_start := true;
                                start_x := cur_x;
                                start_y := cur_y;  
                            end
                            else if (z = (end_ind - 1)) then
                            begin
                                end_x := cur_x;
                                end_y := cur_y;
                                break;
                            end;
                            z := z + 1;
                        end
                        else if (rnk[k] = '%') then 
                        begin
                            cur_y := cur_y + 1;
                            cur_x := 0;
                        end
                        else if (is_was_start = false) then
                        begin
                            cur_x := cur_x + 1;
                        end
                        else 
                        begin
                            is_was_start := false;
                            z := start_ind - 1;
                            break;
                        end;
                    end; 
                end;
                write('(',start_y, ', ', start_x, ') ');
                write(start_ind, ' - '); 
                write('(',end_y, ', ', end_x, ') ');
                write(end_ind, ': ');
            
                temp_start_ind := start_ind;
                for j := temp_start_ind - 1 to end_ind - 1 do 
                begin
                    write(rnk_new[j]);
                end;
                writeln();
                cur_p := 0;
            end
            else begin
                cur_p := 0;
                cur_r := cur_r + 1;
            end;
        end;
    end;
    if (is_there_ans = false) then 
        writeln('The rnk sequence does not contain protein sequence!');
end.