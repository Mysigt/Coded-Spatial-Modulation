%Look up table.
%Input: incoming bit sequence(incoming), look-up table (lu_table).
%Output: encoded bit sequence (codeword).

function codeword  = generator(incoming, lu_table)
  
    %Determines the index.
    index = bi2de(incoming);
    index = index + 1;
    
    %Generates the codeword.
    codeword = lu_table(index, :);
    
end