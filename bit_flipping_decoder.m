%Performs Single BF Algorithm for regular LDPC
%Input: Received codeword after hard decoding (rx_codeword); Parity check
%matrix (h)

function bf_rx_codeword = bit_flipping_decoder(rx_codeword, h)

%Static variable definition.
lmax = 2000000; %Maximum number of iterations.
T = 1; %Treshold for the termination condition.

%Auxiliar variables.
v = rx_codeword;

%Determines size of h.
[~, N] = size(h);

%Calculates the syndrome.
s = double(logical(v * h'));

if s == 0   
    v = rx_codeword; %Accepts the received codeword.
else 
    for l = 1:lmax
        err_counter = zeros(1, N); %Initializes error counter.
        
        S = find(s); %Determines the indexes of s whose values are different from 0.
        
        %Counts the number of errors that might be associated to each bit.
        for i = S
            for j = 1:N
                if h(i,j) == 1
                    err_counter(1, j) = err_counter(1,j) + 1;
                end
            end
        end
        
        [max_value, index] = max(err_counter); %Determines the maximum number of errors and its index.
        
        if max_value <= T %Error Treshold.
            break
        else
            v(index) = xor(v(index), 1);
        end
        
        %Updates syndrome.
        s = double(logical(v * h'));
    end
end
    
    bf_rx_codeword = v;
end 