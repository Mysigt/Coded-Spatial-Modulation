%Look up table.
%Input: Codewords table generated using codewords function (c). Number of
%message bits (n_bits).
%Output: Look-up table.

function lu_table  = generate_lut(c, n_bits)

%Linear independent set.
c = g2rref(c);

%Removes zero rows.
c_reduced = c(any(c,2),:);

%Determines codeword size.
codeword_size = size(c_reduced, 2);

%Initializes the table.
lu_table = zeros(1, codeword_size);

%Generates all possible sequences.
for i = 0:(2^n_bits-1)
    
    bin = de2bi(i);
    
    index = find(bin);
    
    codeword = zeros(1, codeword_size);
    
    for j = index
        
        codeword = xor(c_reduced(j,:), codeword);
        
    end
    
    lu_table = [lu_table; codeword];
    
end

lu_table = lu_table(2:end, :);

end