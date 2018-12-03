function mapped=sm_mapper(coded_spatial,modulated_signal,rate,spatial_size,b_m)
    tx_number=2^(1/rate); %transmitting antenna number
    column_num=length(modulated_signal);
    mapped=zeros(tx_number, column_num);
    
    for i=1:column_num
        mapped(binary_to_decimal(coded_spatial((i-1)*spatial_size/rate+1:i*spatial_size/rate))+1,i)=modulated_signal(i);
    end
end