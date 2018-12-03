function out=remove(remaining_ant,keep)
    out=remaining_ant;
    for i=1:length(keep)
        out=out(out~=keep(i));
    end
end
