function mapped=sm_mapper(coded_spatial,modulated_signal,rate)
    tx_number=2^(1/rate); %transmitting antenna number
    column_num=length(modulated_signal);
    mapped=zeros(tx_number, column_num);
    
    for i=1:column_num
        mapped(bi2de(coded_spatial((i-1)/rate+1:i/rate),'left-msb')+1,i)=modulated_signal(i);
    end
end