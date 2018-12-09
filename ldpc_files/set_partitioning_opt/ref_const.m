function [phys_response,spatial_cons,signal_cons]=ref_const(H_ch,tx,signal_size)
    all_symbols=[0:tx*2^signal_size-1]';
    all_symbols=de2bi(all_symbols,log2(tx)+signal_size,'left-msb');
    spatial_cons=all_symbols(:,1:log2(tx));
    signal_cons=all_symbols(:,log2(tx)+1:end);
    
    dummy=[];
    for i=1:size(spatial_cons,1)
        dummy=cat(2,dummy,spatial_cons(i,:));
    end
    spatial_cons=dummy;
    
    dummy=[];
    for i=1:size(signal_cons,1)
        dummy=cat(2,dummy,signal_cons(i,:));
    end
    signal_cons=dummy;
    
    
    modulated_signal=modulator_qam(signal_cons,signal_size);
    

    mapped_ref=sm_mapper_def(spatial_cons,modulated_signal,tx);
    phys_response=H_ch*mapped_ref;
end