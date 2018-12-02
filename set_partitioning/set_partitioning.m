tx=4;
rx=4;
fadingtype='Rician';
factor=3;

H_ch=channel_matrix(tx,rx,fadingtype,factor);

antennas=['A'; 'B' ;'C'; 'D'];
max_sets=4;
min_sets=2;
max_set_size=4;
min_set_size=1;

C_tp=allPossibleCombinations(antennas, max_set_size,min_set_size);

C_st=Channel_State(antennas,H_ch);

Cost_Table=costTable(C_tp,C_st);

function set=pairing(antennas,Cost_Table,max_sets,min_sets)
    pairing_clus={};
    n_ant=length(antennas);
    for set_n=max_sets:-1:min_sets
        comb_n=n_ant-set_n+1;
        
        for i=comb_n:-1:1
            remaining_ant=antennas;
            dummy_ary=nchoosek(remaining_ant,i);
            remaining_set_n=set_n;
            j=1;
            while j<set_n
                keep=dummy_ary(ii);
                remaining_ant=remove(remaining_ant,keep);
                remaining_set_n=remaining_set_n-1;
                remaining_comb_n=length(remaining_ant)-remaining_set_n+1;
                dummy_set=nchoosek(remaining_ant,remaining_comb_n);
                pairing_clus(ii:ii+length(dummy_set)-1,1)={keep};
                pairing_clus(:,1+j)=place(pairing_clus,dummy_set);
                j=j+1;   
                end
            
                pairing_clus=place(pairing_clus,dummy_ary);
            end
        end
    end
end


            

       
    




