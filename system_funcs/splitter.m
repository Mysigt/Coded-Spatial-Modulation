function [spatial_cons,signal_cons]=splitter(seq,spatial_size,signal_size)

for i=1:length(seq)/(spatial_size+signal_size)
    spatial_cons((i-1)*spatial_size+1:i*spatial_size)=seq((i-1)*(spatial_size+signal_size)+1:i*spatial_size+(i-1)*signal_size);
    signal_cons((i-1)*signal_size+1:i*signal_size)=seq(i*spatial_size+(i-1)*signal_size+1:i*(spatial_size+signal_size));
end
end

