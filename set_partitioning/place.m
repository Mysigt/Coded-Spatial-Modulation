function out=place(pairing_clus, dummy_ary,dim,dim_place)
    out=pairing_clus;
    switch dim
        case 1
            for i=1:size(dummy_ary,1)
                out(dim_place,end+1)={dummy_ary(i,:)};
            end
        case 2
            for i=1:size(dummy_ary,2)
                out(end+1,dim_place)={dummy_ary(i,:)};
end