function recovered_seq=jointer(decoded_seq,demodulated_signal,spatial_size,signal_size)
length_recovered_seq=length(decoded_seq)+length(demodulated_signal);    
recovered_seq=zeros(1,length_recovered_seq);
for i=1:length_recovered_seq/(spatial_size+signal_size)
    recovered_seq((i-1)*(spatial_size+signal_size)+1:i*spatial_size+(i-1)*signal_size)=decoded_seq((i-1)*spatial_size+1:i*spatial_size);
    recovered_seq(i*spatial_size+(i-1)*signal_size+1:i*(spatial_size+signal_size))=demodulated_signal((i-1)*signal_size+1:i*signal_size);
end
end
