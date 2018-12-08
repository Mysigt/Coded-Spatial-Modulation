%De-look-up table.
%Input: received codeword (codeword), look-up table (lu_table).
%Output: Closest message (msg).

function msg = de_lut(codeword, lu_table)
    
    %Hamminng distance between codeword and lu_table.
    dist = pdist2(codeword, lu_table, 'hamming');
    
    %Which codeword is closest.
    [~, index] = min(dist);
    index = index - 1;
    
    %Converts to binary.
    msg = de2bi(index);

end