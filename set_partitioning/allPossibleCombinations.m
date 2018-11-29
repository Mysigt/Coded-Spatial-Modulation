function C_tp=allPossibleCombinations(antennas, max_set_size)
    C_tp={};
    
    for i=1:max_set_size
        C=nchoosek(antennas,i);
        
        for j=1:size(C,1)
            C_tp=cat(1,C_tp,C(j,:));
        end
    end
end