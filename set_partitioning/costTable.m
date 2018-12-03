function Cost_Table=costTable(C_tp,C_st)
    Cost_Table=zeros(size(C_tp));
    for i=1:size(C_tp,1)
        set=cell2mat(C_tp(i));
        Cost_Table(i)=euclideandistsum(set,C_st);
    end
end