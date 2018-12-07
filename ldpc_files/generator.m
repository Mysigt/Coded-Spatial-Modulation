%Look up table.

function codeword  = generator(incoming, c)
    
    %Converts to decimal.
    incoming_decimal = bi2de(incoming);
    
    %Indexes the codeword table.
    codeword = c(incoming_decimal, :);
    
end