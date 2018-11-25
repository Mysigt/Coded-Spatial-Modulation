s1=size(Gpre,1);
s2=size(Gpre,2);
l=length(seq)/s1;
for i=1:l
    enc_seq((i-1)*s2+1:i*s2)=seq((i-1)*s1+1:i*s1)'*Gpre;
end
%%

i=1;
    rx_codeword=enc_seq((i-1)*s2+1:i*s2);
decoded_seq = bit_flipping_decoder(rx_codeword, H);

%%
M=10;
N=20;
onePerCol = 3;
H = makeLdpc(M, N, 1, 1, onePerCol);