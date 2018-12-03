function [re_coded_spat, re_signal_cons]=sm_decoder(received_signal,SNR,transmitted_signal_ref,encoded_seq_ref,signal_cons_ref,signal_size,spatial_size,rate)
%assuming signal constellation 4-qam and structure of coded spatial
%constellation is known.
    coded_spatial_size=spatial_size/rate;
    re_coded_spat=zeros(1,coded_spatial_size*size(received_signal,2));
    re_signal_cons=zeros(1,signal_size*size(received_signal,2));

    for i=1:size(received_signal,2)
        dist_arr=zeros(1,size(transmitted_signal_ref,2));
       for j=1:size(transmitted_signal_ref,2)
           dist=received_signal(:,i)-SNR*transmitted_signal_ref(:,j);
           dist_arr(j)=(norm(dist,'fro'))^2;
       end
       [min_value,min_arg]=min(dist_arr);
       re_coded_spat((i-1)*coded_spatial_size+1:i*coded_spatial_size)=encoded_seq_ref((min_arg-1)*coded_spatial_size+1:min_arg*coded_spatial_size);
        re_signal_cons((i-1)*signal_size+1:i*signal_size)= signal_cons_ref((min_arg-1)*signal_size+1:min_arg*signal_size);
    end
end
