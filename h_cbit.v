function integer cbit(input time cmax);
    begin
        for (cbit = 0; cmax; cbit = cbit + 1)
            cmax = cmax >> 1;
    end
endfunction
