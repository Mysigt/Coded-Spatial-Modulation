clear; clc;  %close all
%===================================================================================================
% Input Parameters
%===================================================================================================
Runs = 1;                           %Test iterationss
p.Constellation = 'MQAM';           %Constellation: MQAM or MPSK
p.M = 4;                            %Modulation levels
p.N = 10002;                        %Number of bits

p.Fade = 1;                         %Type of fading: 1 = Rayleigh, 2 = Rician
p.K = 0;                            %K factor for Rician type fading
SNR = 10;                           %SNR in dB - should be a vector to iterate over
p.var = 1;                          %Standard deviation of noise (sigma)

p.nTx = 4;                          %Number of transmit antennas
p.nRx = 4;                          %Number of receiving antennas

p.rate = 1/2;                       %Code rate 
p.constr = 3;                       %Constraint
p.octRep = [5 7];                   %
p.intlvrDepth = 1000;               %Interleaver depth
%===================================================================================================

for i = 1:length(SNR)
    p.SNR = SNR(i);
for j = 1:Runs
    in = genSeq(p);
    in = Trellis(p,in);
    in = Modulator(p,in);
    in = smMapper(p,in);
    [out,H] = genFade(p,in);
end
end

%===================================================================================================
%Tx Side Functions 
%===================================================================================================
function in = genSeq(p)
in.q = randombisequence(p.N);
i = log2(p.M); iSym = []; j = 0; 
while i ~= 0 %iSym is the index of all the symbol bits 
    iSym = [iSym, log2(p.nTx)*p.rate+1+j:(log2(p.M)+log2(p.nTx)*p.rate):p.N]; 
    j = j+1; i = i-1;
end
iSym = sort(iSym);
in.q1 = in.q;
in.q1(iSym) = []; %Remove all symbol bits to obtain antenna bits
in.q2 = in.q(iSym); %symbol bits
end

function in = Trellis(c,in)
trellisStruct = poly2trellis(c.constr, c.octRep);
in.a=convenc(in.q1,trellisStruct);
in.a=randintrlv(in.a,c.intlvrDepth);    %random block interleaver
end

function in = Modulator(p,in)
temp = reshape(in.q2, [log2(p.M) length(in.q2)/log2(p.M)]);
dSymb = bi2de(temp');
in.x = qammod(dSymb,2^p.M,'UnitAveragePower',true);
end

function in = smMapper(p,in)
    in.s=zeros(p.nTx, length(in.x)); 
    for i=1:length(in.x)
        antNum= bi2de(reshape(in.a, [log2(p.nTx), length(in.a)/log2(p.nTx)])');
        in.s(antNum(i)+1,i)=in.x(i);
    end
end

%===================================================================================================
%Channel functions
%===================================================================================================
function [out,H] = genFade(p,in)
switch p.Fade
    case 1
            H=randn([p.nRx p.nTx])+randn([p.nRx p.nTx])*1i;
    case 2
            H=randn([p.nRx p.nTx])+randn([p.nRx p.nTx])*1i;
            H=sqrt(factor/(1+factor))*ones(p.nRx,p.nTx)+sqrt(1/(1+factor))*H;
end
out.r = sqrt(p.SNR)*H*in.s+p.var*(randn(size(in.s))+randn(size(in.s))*1i);% introduce noise
end

%===================================================================================================
%Receiver Side Functions
%===================================================================================================
function [] = refSig(p)
mappedPairs = de2bi(0:p.nTx*p.M-1,)
modulated_signal_ref=modulator_qam(signal_cons_ref,signal_size);

mapped_ref=sm_mapper(encoded_seq_ref,modulated_signal_ref,rate);
transmitted_signal_ref=H*mapped_ref;
end

function [] = smDecoder()
end

function [] = viterbiDecoder()

end

function [] = 
end









