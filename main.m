%this simulation is written according to the system diagram of "Trellis
%coded Spatial modulation (2010), fig. [1]"
%all the parameter values and block designs are according to the paper.
%% transmitter side
signal_size=2; %M-ary size in bits
spatial_size=1; %size of spatial constellation points in bits

seq_length=10002;
seq=randombisequence(seq_length);

[spatial_cons,signal_cons]=splitter(seq,spatial_size,signal_size);

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

mapped=sm_mapper(interlvd,modulated_signal,rate); %creating signal matrix for transmitting antennas
%each column representing the i-th symbol to transmit and each row the
%number of antenna

%% Channel
% mimo_channel.NumTransmitAntennas=4;
% mimo_channel.NumReceiveAntennas=1;
mimo_channel=comm.MIMOChannel ;
mimo_channel.TransmitCorrelationMatrix=eye(4);
mimo_channel.ReceiveCorrelationMatrix=1;    %assuming uncorrelated antennas
mimo_channel.FadingDistribution='Rician';%fading constant K=3 (default)

%channel model fading technique is filtered gaussian noise(default)
%Average path gain is 0 (default)
%Normalize path gain (default)

transmitted_signal=mimo_channel(mapped');

sigma=1/10;% SNR=1/sigma in this case
received_signal=transmitted_signal+sigma*randn(length(transmitted_signal),1);% introduce noise
%% All possible vectors to receive
encoded_seq_ref=[0 0 0 0 0 0 0 0 0 1 0 1 0 1 0 1 1 0 1 0 1 0 1 0 1 1 1 1 1 1 1 1];
signal_cons_ref=[0 0 0 1 1 0 1 1 0 0 0 1 1 0 1 1 0 0 0 1 1 0 1 1 0 0 0 1 1 0 1 1];
modulated_signal_ref=modulator_qam(signal_cons_ref,signal_size);

mapped_ref=sm_mapper(encoded_seq_ref,modulated_signal_ref,rate);
transmitted_signal_ref=mimo_channel(mapped_ref');

%% Receiver Side
[re_coded_spat, re_signal_cons]=sm_decoder(received_signal,sigma,...
    transmitted_signal_ref,encoded_seq_ref,signal_cons_ref,signal_size,spatial_size,rate);

deinterlvd_seq=randdeintrlv(re_coded_spat,interlvr_depth);

tblen=15; % a typical value for traceback depth is about 5 times the constraint length of the code
decoded_seq=vitdec(deinterlvd_seq,trellis_structure, tblen,'trunc', 'hard');

%demodulated_signal=demodulator_qam(re_signal_cons,signal_size);

recovered_seq=jointer(decoded_seq,re_signal_cons,spatial_size,signal_size);

%% bit-error check
error_rate=biterr(recovered_seq,seq')/seq_length;