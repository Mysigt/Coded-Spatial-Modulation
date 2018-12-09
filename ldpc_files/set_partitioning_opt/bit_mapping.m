function b_m=bit_mapping(opt_tree)
    antennas=opt_tree{1};
    b_m=char(opt_tree{end}');
    b_mm=[];
    for i=1:size(b_m,1)
        b_mm=cat(2,b_mm,b_m(i,:));
    end
    b_m=cat(2,antennas',b_mm');
end


% function b_m=bit_mapping(opt_set)
% msize=0;
%     for i=1:length(opt_set)
%         msize=msize+length(char(opt_set(i)));
%     end
% msize_bit=log2(msize);
% b_m={};
% bit_set=(0:msize-1);
% bit_set=de2bi(bit_set,msize_bit,'left-msb');
% 
%     for i=1:length(opt_set)
%         set=char(opt_set(i));        
%         bit=bit_set(randi([1 size(bit_set,1)],1,1),:);
%         for j=1:length(set)
%             if j==1
%                % b_m=cat(2,b_m,bit);
%             else
%                 hamming_dist=sum(xor(bit_set,bit),2);
%                 [m,index]=max(hamming_dist);
%                 bit=bit_set(index,:);
%                 
%             end
%             b_m=cat(1,b_m,{set(j),bit});
%             bit_set(all((bit_set==bit),2),:)=[];
%         end
%     end
% end