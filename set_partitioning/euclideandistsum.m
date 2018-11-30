function Cost=euclideandistsum(set,C_st)
    Cost=0;
    sum_size=size(set,2);
    
    if sum_size==1
        return
    else
        v_stack=[];
        for i=1:sum_size
            index = strcmp(C_st(:,1), set(i));
            v_stack=cat(2,v_stack,cell2mat(C_st(index,2)));
        end
    
        for i=1:sum_size-1
            for k=i:sum_size-1
            V=v_stack(:,i)-v_stack(:,k+1);
            Cost=Cost+norm(V);
            end
        end
        Cost=Cost/(i*k);
    end
end