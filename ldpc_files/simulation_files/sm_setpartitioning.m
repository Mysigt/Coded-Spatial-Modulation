%this simulation is written according to the system diagram of "Trellis
%coded Spatial modulation (2010), fig. [1]"
%all the parameter values and block designs are according to the paper.
% %rng(1)
% kk_value=[10 10 10 10 50 50 50 100 100];
% seq_length=[1020 1020 1020 1020 1020 10020 100020 1000020 1000020];
% seq_cluster={};
% for i=1:length(seq_length)
% seq_cluster{i}=randombisequence(seq_length(i));
% end
% %%
% channel_cluster={};
% for i=1:length(kk_value)
%     for j=1:kk_value(i)
%         H_dummy=channel_matrix(tx,rx,'Rician',3);
%         channel_cluster(i,j)={H_dummy};
%     end
% end
%%
%parpool(6)
 parfor j=1:9
     ro=(j-1)*2;
     bit_error_count=0;
     for kk=1:kk_value(j)
%% transmitter side
tx=4; %transmitting antenna number
rx=4; %receiving antenna number
signal_size=2; %M-ary size in bits
spatial_size=1; %size of spatial constellation points in bits

antennas=['A'; 'B' ;'C'; 'D']; 

seq_length1=seq_length(j);
seq=seq_cluster{j};

H_ch=channel_cluster{j,kk};

[spatial_cons,signal_cons]=splitter(seq,spatial_size,signal_size);

opt_tree=set_partitioning_tree(H_ch,antennas);

b_m=bit_mapping(opt_tree);

%for a rate 1/2 feedforward convolutional encoder
%octal representation of (5,7)
%constraint length 3
rate=1/2;
constraint_length=3;
octal_rep=[5 7];
trellis_structure=poly2trellis(constraint_length, octal_rep);
encoded_seq=convenc(spatial_cons,trellis_structure);

interlvr_depth=1000;
interlvd=randintrlv(encoded_seq,interlvr_depth);    %random block interleaver

modulated_signal=modulator_qam(signal_cons,signal_size); %modulator depending on signal constellation size, in this case 4- QAM

mapped=sm_mapper(interlvd,modulated_signal,tx,b_m); %creating signal matrix for transmitting antennas
%each column representing the i-th symbol to transmit and each row the
%number of antenna


SNR=sqrt(10^(ro*0.1));% sqrt of SNR
sigma=1;% std of noise
received_signal=SNR*H_ch*mapped+sigma*(randn(size(mapped))+randn(size(mapped))*1i);% introduce noise
%% All possible vectors to receive
encoded_seq_ref=[0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 1 1 0 1 0 1 0 1 0 1 1 1 1 1 1 1 1];
signal_cons_ref=[0 0 0 1 1 0 1 1 0 0 0 1 1 0 1 1 0 0 0 1 1 0 1 1 0 0 0 1 1 0 1 1];
modulated_signal_ref=modulator_qam(signal_cons_ref,signal_size);

mapped_ref=sm_mapper(encoded_seq_ref,modulated_signal_ref,tx,b_m);
transmitted_signal_ref=H_ch*mapped_ref;
%% Receiver Side
[re_coded_spat, re_signal_cons]=sm_decoder(received_signal,SNR,...
    transmitted_signal_ref,encoded_seq_ref,signal_cons_ref,signal_size,spatial_size,rate);

deinterlvd_seq=randdeintrlv(re_coded_spat,interlvr_depth);

tblen=15; % a typical value for traceback depth is about 5 times the constraint length of the code
decoded_seq=vitdec(deinterlvd_seq,trellis_structure, tblen,'trunc', 'hard');

%demodulated_signal=demodulator_qam(re_signal_cons,signal_size);

recovered_seq=jointer(decoded_seq,re_signal_cons,spatial_size,signal_size);
 bit_error_count=bit_error_count+biterr(recovered_seq,seq')/seq_length(j);
   
% %% bit-error check
% error_rate(ro+1,kk)=biterr(recovered_seq,seq')/seq_length;
% error_rate_spatial(ro+1,kk)=biterr(decoded_seq,spatial_cons)/length(spatial_cons);
% error_rate_signal(ro+1,kk)=biterr(re_signal_cons,signal_cons)/length(signal_cons);
     end
     error_rate(j)=bit_error_count/kk_value(j);
 end
% error_rate_avg=mean(error_rate,2);
%plot
%semilogy([1:20],error_rate_avg)
%semilogy([0:2:16], error_rate)