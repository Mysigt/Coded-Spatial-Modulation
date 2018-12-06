function seq=bit_demapper(input_seq,b_m)
    org_tx_seq=b_m(:,1);
    mapped_tx_seq=b_m(:,2);
    block_length=ceil(log2(b_m));
    loop_length=length(input_seq)/block_length;
    seq=zeros(1,length(input_seq));
    for i=1:loop_length
        antenna_name=org_tx_seq(binary_to_decimal(input_seq((i-1)*block_length+1:i*block_length))+1);
        antenna_num=strfind(mapped_tx_seq',antenna_name);
        seq((i-1)*block_length+1:i*block_length)=de2bi(mapped_tex_seq(antenna_num),block_length,'left-msb');
    end
end