function h = create_matrix(filename)

fileid = fopen(filename);

A = fscanf(fileid, '%d');

%Create zeros matrix.
M = A(1);
N = A(2);

h = zeros(M,N);

%Number of 1's in a row.
wr = A(3);

%Numbber of 1's in a column.
wc = A(4);

%Fills the table.

begin = M + N + 5; %Begining of reading the file vector A.

finish = begin + wr * M - 1; %Point to stop readinng file vector A.

row = 1;
j = 0;

for i = begin:finish
    
   column = A(i);
   
   h(row, column) = 1;
    
   j = j + 1;
   
   if j == wr
       
       row = row + 1;
       j = 0;
       
   end
   
end

end

