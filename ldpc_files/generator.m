%Look up table.
%Input: incoming bit sequence(incoming), codewords table generated using
%codewords function (c).
%Output: encoded bit sequence (codeword).

function codeword  = generator(incoming, c)
    
    %Converts to decimal.
    incoming_decimal = bi2de(incoming);
    
    %Indexes the codeword table.
    codeword = c(incoming_decimal, :);
    
end