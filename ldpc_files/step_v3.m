function decoded = step_v3(h, sequence, dec)

    sequence = sequence';
    
    %Determine each message length.
    msg_size = size(h,2) - size(h,1);
    
    %Determine codeword length.
    code_size = size(h,2);
    
    %Sequence size.
    seq_size = size(sequence, 1);
    
    %Number of iterations.
    n_iterations = ceil(seq_size / code_size);
    
    %Initializes code.
    decoded = [];
    
    %Encodes all words.
    for i = 1:n_iterations
        
        code_end = i * code_size;
        code_start = code_end - code_size + 1;
        
%         if code_end > seq_size
%             
%             n_extrabits = code_end - seq_size;
%             extrabits = zeros(n_extrabits, 1);
%             sequence = [sequence; extrabits];
%             
%         end
        
        %Determines the index.
        dummy = sequence(code_start:code_end);
        sequence_decoded = step(dec, dummy);
        
        %Generates the codeword.
        decoded = [decoded; sequence_decoded];
        
    end
    
    decoded = decoded';

end