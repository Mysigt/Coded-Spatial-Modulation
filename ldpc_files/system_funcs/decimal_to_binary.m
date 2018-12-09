function binary=decimal_to_binary(size,dec)
binary=zeros(1,size);
for i=0:size-1
    if dec>=2^(size-1-i)
        binary(i+1)=1;
        dec=dec-2^(size-1-i);
    end
end
end