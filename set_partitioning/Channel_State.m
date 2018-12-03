function C_st=Channel_State(antennas,H_ch)
    C_st=cell(size(antennas));
    for i=1:size(antennas,1)
        C_st(i,1)={antennas(i)};
        C_st(i,2)={H_ch(:,i)};
    end
end