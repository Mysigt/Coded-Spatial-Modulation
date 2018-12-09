function mapped=sm_mapper_joint(coded_spatial,signal_cons,tx,signal_size,b_m)
    block_length=log2(tx);
    column_num=length(signal_cons)/signal_size;
    mapped=zeros(tx, column_num);
    org_tx_seq=b_m(:,1);
    mapped_tx_seq=b_m(:,2);
    for i=1:column_num
        dummy=cat(2,coded_spatial((i-1)*block_length+1:i*block_length),signal_cons((i-1)*signal_size+1:i*signal_size));
        symbol_name=mapped_tx_seq(binary_to_decimal(dummy)+1);
        symbol_num=strfind(org_tx_seq',symbol_name);
        bi_symbol_num=decimal_to_binary(block_length+signal_size,symbol_num);
        antenna_num=binary_to_decimal(bi_symbol_num(1:block_length))+1;
        signal_num=bi_symbol_num(block_length+1:end);
        mapped(antenna_num,i)=modulator_qam(signal_num,signal_size);
    end
end