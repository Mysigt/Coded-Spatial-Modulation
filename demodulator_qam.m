function  demodulated_signal=demodulator_qam(re_signal_cons,M)
    symbol_number=qamdemod(re_signal_cons,2^M,'UnitAveragePower',true);
    
    demodulated_signal=zeros(1,length(re_signal_cons)*M);
    for i=1:length(re_signal_cons)
       demodulated_signal((i-1)*M+1:i*M)=de2bi(symbol_number(i),M);
    end
end