function bd=binary_to_decimal(s)
bd=0;
for i=1:length(s)
    bd=bd+2^(length(s)-i)*s(i);
end
end
