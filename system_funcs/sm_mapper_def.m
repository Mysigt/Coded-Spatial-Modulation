function mapped=sm_mapper_def(coded_spatial,modulated_signal,tx)
    block_length=log2(tx);
    column_num=length(modulated_signal);
    mapped=zeros(tx, column_num);
   
    for i=1:column_num
        antenna_num=binary_to_decimal(coded_spatial((i-1)*block_length+1:i*block_length))+1;
        mapped(antenna_num,i)=modulated_signal(i);
    end
end