function mapped=sm_mapper(coded_spatial,modulated_signal,tx,b_m)
    block_length=log2(tx);
    column_num=length(modulated_signal);
    mapped=zeros(tx, column_num);
    org_tx_seq=b_m(:,1);
    mapped_tx_seq=b_m(:,2);
    for i=1:column_num
        antenna_name=mapped_tx_seq(binary_to_decimal(coded_spatial((i-1)*block_length+1:i*block_length))+1);
        antenna_num=strfind(org_tx_seq',antenna_name);
        mapped(antenna_num,i)=modulated_signal(i);
    end
end