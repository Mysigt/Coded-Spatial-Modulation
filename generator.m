filename='PEGirReg252x504.txt';
H=create_matrix(filename);
H=H';
[r,c]=size(H);
G=cat(2,eye(r),zeros([r,c-r]));
keep=[];

dummy=0;
zero_ary=zeros(r,1);
for j=1:2^c
    syndrome=mod((H*de2bi(dummy,c,'left-msb')'),2);
    if syndrome==zero_ary
        keep=cat(1,keep,de2bi(dummy,c,'left-msb'));
    end
    dummy=dummy+1;
end


%%
