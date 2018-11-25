function modulated_signal=modulator_qam(signal_cons,M)
    decimal_sym=zeros(1,length(signal_cons)/M);
    for i=1:length(signal_cons)/M
       decimal_sym(i)=binary_to_decimal(signal_cons((i-1)*M+1:i*M));
    end
        
    modulated_signal = qammod(decimal_sym,2^M,'UnitAveragePower',true);
end
