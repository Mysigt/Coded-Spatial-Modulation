n=10;
k=5;

H=[0 1 0 0 1 1 0 0 0 1 ; ...
   1 0 0 1 0 1 1 0 0 0 ; ...
   0 1 1 0 0 0 1 1 0 0 ; ...
   0 0 0 1 1 0 0 1 1 0 ; ...
   1 0 1 0 0 0 0 0 1 1 ];


G=[1 0 0 0 0 1 0 0 0 1; ...
   0 1 0 0 0 1 1 0 0 0; ...
   0 0 1 0 0 0 0 1 1 0; ...
   0 0 0 1 0 0 1 1 0 0; ...
   0 0 0 0 1 0 0 0 1 1];


u=randombisequence(5);
%c=mod(u'*G,2);
c = encode(u',n,k,'linear/binary',G);
bfd=bit_flipping_decoder(c,H);
u_rx= decode(bfd,n,k,'linear/binary',G);