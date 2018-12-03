function out_ary=find_char(possible_sets,char)
    dummy=strfind(possible_sets,char);
    out_ary=zeros(size(dummy));
    for i=1:length(out_ary)
        if dummy{i,1}>=1
            out_ary(i)=1;
        else
            out_ary(i)=0;
        end
    end
end