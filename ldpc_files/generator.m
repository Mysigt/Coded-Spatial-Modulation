%Look up table.
%Input: incoming bit sequence(incoming), codewords table generated using
%codewords function (c).
%Output: encoded bit sequence (codeword).

function codeword  = generator(incoming, c)
    
    %Linear independent set.
    c = g2rref(c);
    
    %Removes zero rows.
    c_reduced = c(any(c,2),:);
    
    %Determines codeword size.
    codeword_size = size(c_reduced, 2);
    
    %Initializes the codeword;
    codeword = zeros(1, codeword_size);
    
    
    %Which lines to add.
    index = find(incoming);
        
    for i = index
        
        codeword = xor(c_reduced(i,:), codeword); 
        
    end
 
end