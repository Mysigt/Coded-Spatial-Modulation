%this simulation is written according to the system diagram of "Trellis
%coded Spatial modulation (2010), fig. [1]"
%all the parameter values and block designs are according to the paper.
%rng(1)
tx=4; %transmitting antenna number
rx=4; %receiving antenna number
signal_size=2; %M-ary size in bits
spatial_size=1; %size of spatial constellation points in bits
antennas=['A'; 'B' ;'C'; 'D']; 
all_symbols=[65:65+15]';
all_symbols=char(all_symbols);

error_rate=zeros(1,9);

n=20;

k=15;

rate=k/n;

A=[1 1 1 0 1 0 0 1 0 0 0 1 0 0 0; 

   1 0 0 1 1 1 0 0 1 0 0 0 1 0 0; 

   0 1 0 0 0 0 1 1 1 0 1 0 0 1 0; 

   0 0 1 0 0 1 0 0 0 1 1 1 0 0 1;

   0 0 0 1 0 0 1 0 0 1 0 0 1 1 1];

H=cat(2,A,eye(size(A,1)));
G=cat(2,eye(size(A,2)),A');
%%
kk_value=[10 10 10 10 50 50 50 100 100];
seq_length=[1020 1020 1020 1020 1020 10020 100020 1000020 1000020];
seq_cluster={};
for i=1:length(seq_length)
seq_cluster{i}=randombisequence(seq_length(i));
end
%%
channel_cluster={};
for i=1:length(kk_value)
    for j=1:kk_value(i)
        H_dummy=channel_matrix(tx,rx,'Rician',3);
        channel_cluster(i,j)={H_dummy};
    end
end
%%
%%
%parpool(2)

parfor j=1:6
    ro=(j-1)*2;
    bit_error_count=0;
    for kk=1:kk_value(j)
%% transmitter side

seq_length1=seq_length(j);
seq=seq_cluster{j};
H_ch=channel_cluster{j,kk};
%% All possible vectors to receive
[phys_response,~,~]=ref_const(H_ch,tx,signal_size);

%set partitioning and bit mapping

opt_tree=set_partitioning_tree(phys_response,all_symbols);

b_m=bit_mapping(opt_tree);
%%
 [phys_response,encoded_seq_ref,signal_cons_ref]=ref_const_joint(H_ch,tx,signal_size,b_m);
  
[spatial_cons,signal_cons]=splitter(seq,spatial_size,1);

%for a rate 1/2 feedforward convolutional encoder
%octal representation of (5,7)
%constraint length 3
% rate=1/2;
% constraint_length=3;
% octal_rep=[5 7];
% trellis_structure=poly2trellis(constraint_length, octal_rep);
% encoded_seq=convenc(spatial_cons,trellis_structure);

encoded_spa = encode(spatial_cons,n,k,'linear/binary',G);
encoded_sig = encode(signal_cons,n,k,'linear/binary',G);
interlvr_depth=1000;
interlvd_spa=randintrlv(encoded_spa,interlvr_depth);    %random block interleaver
interlvd_sig=randintrlv(encoded_sig,interlvr_depth);    %random block interleaver

%modulated_signal=modulator_qam(interlvd_sig,signal_size); %modulator depending on signal constellation size, in this case 4- QAM

mapped=sm_mapper_joint(interlvd_spa,interlvd_sig,tx,signal_size,b_m); %creating signal matrix for transmitting antennas
%each column representing the i-th symbol to transmit and each row the
%number of antenna

SNR=sqrt(10^(ro*0.1));% sqrt of SNR
sigma=1;% std of noise
received_signal=SNR*H_ch*mapped+sigma*(randn(size(mapped))+randn(size(mapped))*1i);% introduce noise
%% Receiver Side
[re_coded_spat, re_signal_cons]=sm_decoder(received_signal,SNR,...
    phys_response,encoded_seq_ref,signal_cons_ref,signal_size,spatial_size,1/2);

deinterlvd_spa=randdeintrlv(re_coded_spat,interlvr_depth);

deinterlvd_sig=randdeintrlv(re_signal_cons,interlvr_depth);

% tblen=15; % a typical value for traceback depth is about 5 times the constraint length of the code
% decoded_seq=vitdec(deinterlvd_seq,trellis_structure, tblen,'trunc', 'hard');

%bfd=bit_flipping_decoder(deinterlvd_spa,H);

%demodulated_signal=demodulator_qam(re_signal_cons,signal_size);
decoded_spa= decode(deinterlvd_spa,n,k,'linear/binary',G);
decoded_sig= decode(deinterlvd_sig,n,k,'linear/binary',G);
recovered_seq=jointer(decoded_spa,decoded_sig,spatial_size,1);

%% bit-error check
% error_rate(j,kk)=biterr(recovered_seq,seq')/seq_length(j);
% error_rate_spatial(j,kk)=biterr(decoded_seq,spatial_cons)/length(spatial_cons);
% error_rate_signal(j,kk)=biterr(re_signal_cons,signal_cons)/length(signal_cons);
    bit_error_count=bit_error_count+biterr(recovered_seq,seq')/seq_length(j);
    end
    error_rate_ric3(j)=bit_error_count/kk_value(j);
    
end
%error_rate_avg=mean(error_rate,2);
%plot
%semilogy([0:8],error_rate_avg)
%semilogy([0:2:10], error_rate)
%% Rician 1
kk_value=[10 10 10 10 50 50 50 100 100];
seq_length=[1020 1020 1020 1020 1020 10020 100020 1000020 1000020];
seq_cluster={};
for i=1:length(seq_length)
seq_cluster{i}=randombisequence(seq_length(i));
end
%%
channel_cluster={};
for i=1:length(kk_value)
    for j=1:kk_value(i)
        H_dummy=channel_matrix(tx,rx,'Rician',1);
        channel_cluster(i,j)={H_dummy};
    end
end
%%
%%
%parpool(2)

parfor j=1:6
    ro=(j-1)*2;
    bit_error_count=0;
    for kk=1:kk_value(j)
%% transmitter side

seq_length1=seq_length(j);
seq=seq_cluster{j};
H_ch=channel_cluster{j,kk};
%% All possible vectors to receive
[phys_response,~,~]=ref_const(H_ch,tx,signal_size);

%set partitioning and bit mapping

opt_tree=set_partitioning_tree(phys_response,all_symbols);

b_m=bit_mapping(opt_tree);
%%
 [phys_response,encoded_seq_ref,signal_cons_ref]=ref_const_joint(H_ch,tx,signal_size,b_m);
  
[spatial_cons,signal_cons]=splitter(seq,spatial_size,1);

%for a rate 1/2 feedforward convolutional encoder
%octal representation of (5,7)
%constraint length 3
% rate=1/2;
% constraint_length=3;
% octal_rep=[5 7];
% trellis_structure=poly2trellis(constraint_length, octal_rep);
% encoded_seq=convenc(spatial_cons,trellis_structure);

encoded_spa = encode(spatial_cons,n,k,'linear/binary',G);
encoded_sig = encode(signal_cons,n,k,'linear/binary',G);
interlvr_depth=1000;
interlvd_spa=randintrlv(encoded_spa,interlvr_depth);    %random block interleaver
interlvd_sig=randintrlv(encoded_sig,interlvr_depth);    %random block interleaver

%modulated_signal=modulator_qam(interlvd_sig,signal_size); %modulator depending on signal constellation size, in this case 4- QAM

mapped=sm_mapper_joint(interlvd_spa,interlvd_sig,tx,signal_size,b_m); %creating signal matrix for transmitting antennas
%each column representing the i-th symbol to transmit and each row the
%number of antenna

SNR=sqrt(10^(ro*0.1));% sqrt of SNR
sigma=1;% std of noise
received_signal=SNR*H_ch*mapped+sigma*(randn(size(mapped))+randn(size(mapped))*1i);% introduce noise
%% Receiver Side
[re_coded_spat, re_signal_cons]=sm_decoder(received_signal,SNR,...
    phys_response,encoded_seq_ref,signal_cons_ref,signal_size,spatial_size,1/2);

deinterlvd_spa=randdeintrlv(re_coded_spat,interlvr_depth);

deinterlvd_sig=randdeintrlv(re_signal_cons,interlvr_depth);

% tblen=15; % a typical value for traceback depth is about 5 times the constraint length of the code
% decoded_seq=vitdec(deinterlvd_seq,trellis_structure, tblen,'trunc', 'hard');

%bfd=bit_flipping_decoder(deinterlvd_spa,H);

%demodulated_signal=demodulator_qam(re_signal_cons,signal_size);
decoded_spa= decode(deinterlvd_spa,n,k,'linear/binary',G);
decoded_sig= decode(deinterlvd_sig,n,k,'linear/binary',G);
recovered_seq=jointer(decoded_spa,decoded_sig,spatial_size,1);

%% bit-error check
% error_rate(j,kk)=biterr(recovered_seq,seq')/seq_length(j);
% error_rate_spatial(j,kk)=biterr(decoded_seq,spatial_cons)/length(spatial_cons);
% error_rate_signal(j,kk)=biterr(re_signal_cons,signal_cons)/length(signal_cons);
    bit_error_count=bit_error_count+biterr(recovered_seq,seq')/seq_length(j);
    end
    error_rate_ric1(j)=bit_error_count/kk_value(j);
    
end
%error_rate_avg=mean(error_rate,2);
%plot
%semilogy([0:8],error_rate_avg)
%semilogy([0:2:10], error_rate)
%% Rayleigh
kk_value=[10 10 10 10 50 50 50 100 100];
seq_length=[1020 1020 1020 1020 1020 10020 100020 1000020 1000020];
seq_cluster={};
for i=1:length(seq_length)
seq_cluster{i}=randombisequence(seq_length(i));
end
%%
channel_cluster={};
for i=1:length(kk_value)
    for j=1:kk_value(i)
        H_dummy=channel_matrix(tx,rx,'Rayleigh',3);
        channel_cluster(i,j)={H_dummy};
    end
end
%%
%%
%parpool(2)

parfor j=1:6
    ro=(j-1)*2;
    bit_error_count=0;
    for kk=1:kk_value(j)
%% transmitter side

seq_length1=seq_length(j);
seq=seq_cluster{j};
H_ch=channel_cluster{j,kk};
%% All possible vectors to receive
[phys_response,~,~]=ref_const(H_ch,tx,signal_size);

%set partitioning and bit mapping

opt_tree=set_partitioning_tree(phys_response,all_symbols);

b_m=bit_mapping(opt_tree);
%%
 [phys_response,encoded_seq_ref,signal_cons_ref]=ref_const_joint(H_ch,tx,signal_size,b_m);
  
[spatial_cons,signal_cons]=splitter(seq,spatial_size,1);

%for a rate 1/2 feedforward convolutional encoder
%octal representation of (5,7)
%constraint length 3
% rate=1/2;
% constraint_length=3;
% octal_rep=[5 7];
% trellis_structure=poly2trellis(constraint_length, octal_rep);
% encoded_seq=convenc(spatial_cons,trellis_structure);

encoded_spa = encode(spatial_cons,n,k,'linear/binary',G);
encoded_sig = encode(signal_cons,n,k,'linear/binary',G);
interlvr_depth=1000;
interlvd_spa=randintrlv(encoded_spa,interlvr_depth);    %random block interleaver
interlvd_sig=randintrlv(encoded_sig,interlvr_depth);    %random block interleaver

%modulated_signal=modulator_qam(interlvd_sig,signal_size); %modulator depending on signal constellation size, in this case 4- QAM

mapped=sm_mapper_joint(interlvd_spa,interlvd_sig,tx,signal_size,b_m); %creating signal matrix for transmitting antennas
%each column representing the i-th symbol to transmit and each row the
%number of antenna

SNR=sqrt(10^(ro*0.1));% sqrt of SNR
sigma=1;% std of noise
received_signal=SNR*H_ch*mapped+sigma*(randn(size(mapped))+randn(size(mapped))*1i);% introduce noise
%% Receiver Side
[re_coded_spat, re_signal_cons]=sm_decoder(received_signal,SNR,...
    phys_response,encoded_seq_ref,signal_cons_ref,signal_size,spatial_size,1/2);

deinterlvd_spa=randdeintrlv(re_coded_spat,interlvr_depth);

deinterlvd_sig=randdeintrlv(re_signal_cons,interlvr_depth);

% tblen=15; % a typical value for traceback depth is about 5 times the constraint length of the code
% decoded_seq=vitdec(deinterlvd_seq,trellis_structure, tblen,'trunc', 'hard');

%bfd=bit_flipping_decoder(deinterlvd_spa,H);

%demodulated_signal=demodulator_qam(re_signal_cons,signal_size);
decoded_spa= decode(deinterlvd_spa,n,k,'linear/binary',G);
decoded_sig= decode(deinterlvd_sig,n,k,'linear/binary',G);
recovered_seq=jointer(decoded_spa,decoded_sig,spatial_size,1);

%% bit-error check
% error_rate(j,kk)=biterr(recovered_seq,seq')/seq_length(j);
% error_rate_spatial(j,kk)=biterr(decoded_seq,spatial_cons)/length(spatial_cons);
% error_rate_signal(j,kk)=biterr(re_signal_cons,signal_cons)/length(signal_cons);
    bit_error_count=bit_error_count+biterr(recovered_seq,seq')/seq_length(j);
    end
    error_rate_ray(j)=bit_error_count/kk_value(j);
    
end
%error_rate_avg=mean(error_rate,2);
%plot
%semilogy([0:8],error_rate_avg)
%semilogy([0:2:10], error_rate)