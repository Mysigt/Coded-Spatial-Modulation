function encoded = step_v2(h, sequence, enc)

    sequence = sequence';
        
    %Determine each message length.
    msg_size = size(h,2) - size(h,1);
    
    %Sequence size.
    seq_size = size(sequence, 1);
    
    %Number of iterations.
    n_iterations = ceil(seq_size / msg_size);
    
    %Initializes code.
    encoded = [];
    
    %Encodes all words.
    for i = 1:n_iterations
        
        msg_end = i * msg_size;
        msg_start = (i-1)*msg_size+1;
        
%         if msg_end > seq_size
%             
%             n_extrabits = msg_end - seq_size;
%             extrabits = zeros(n_extrabits, 1);
%             sequence = [sequence; extrabits];
%             
%         end
        
        %Determines the index.
        dummy = sequence(msg_start:msg_end);
        sequence_encoded = step(enc, dummy);
        
        %Generates the codeword.
        encoded = [encoded; sequence_encoded];
        
    end
    
    encoded = double(encoded');
end