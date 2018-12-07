%Look up table.
%Input: incoming bit sequence(incoming), codewords table generated using
%codewords function (c).
%Output: encoded bit sequence (codeword).

function codeword  = generator(incoming, c)
    
    %Linear independent set.
    c = g2rref(c);
    
    %Determines codeword size.
    codeword_size = size(c, 2);
    
    %Initializes the codeword;
    codeword = zeros(1, codeword_size);
    
    
    %Which lines to add.
        index = find(incoming);
        
    for i = index
        
        codeword = xor(c(i,:), codeword); 
        
    end

    
end