%Function to determine codewords.

function c = codewords(h)

%Determine size of parity check matrix.
m = size(h, 1);
n = size(h, 2);

%Creates the codewords matrix.
b = zeros(2^n, n);

%Generates all 2^n possible codewords.
d = 0:1:(2^n-1);

c_all = de2bi(d, n, 'left-msb');

%Codes index
c = c_all(1,:);

for i = 2:(2^n)
    
   %Modulo-2 check
   check = mod(c_all(i, :)*h', 2);
   
   if check == 0
       
      c = [c;c_all(i,:)];
       
   end
    
end
   
end