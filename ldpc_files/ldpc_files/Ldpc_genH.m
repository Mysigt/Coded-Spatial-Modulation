K=200; %Source Blocks
N=100;

msg = randi([0,1],K,1); %Generate msg
H = Hldpc(K,N); %Construct Gallager parity check matrix
H_rref = g2rref(H); %Gaus jordan elim
Gpre = null2(H_rref)';%Generator equals null space

function H = Hldpc(K,N)
w_c = 10; % Column weight
w_r = 20; % Row weight
H_sub = zeros(N/w_r,N);
for i = 1:N/w_r
    for j = (i-1)*w_r+1:i*w_r
        H_sub(i,j) = H_sub(i,j) + 1;
    end
end
H_pre = H_sub;
for t = 2:w_c
    x = randperm(N);
    H_sub_perm = H_sub(:,x);
    H_pre = [H_pre H_sub_perm];
end
H = zeros(K,N);
for p = 1:w_c
    H((p-1)*(N/w_r)+1:(p)*(N/w_r),1:N) = H((p-1)*(N/w_r)+1:(p)*(N/w_r),1:N) + H_pre(:,(p-1)*N+1:p*N);
end
end

function [A] = g2rref(A)
[m,n] = size(A);

% Loop over the entire matrix.
i = 1;
j = 1;

while (i <= m) && (j <= n)
   % Find value and index of largest element in the remainder of column j.
   k = find(A(i:m,j),1) + i - 1;

   % Swap i-th and k-th rows.
   A([i k],j:n) = A([k i],j:n);
   
   % Save the right hand side of the pivot row
   aijn = A(i,j:n);
   
   % Column we're looking at
   col = A(1:m,j);
   
   % Never Xor the pivot row against itself
   col(i) = 0;
   
   % This builds an matrix of bits to flip
   flip = col*aijn;
   
   % Xor the right hand side of the pivot row with all the other rows
   A(1:m,j:n) = xor( A(1:m,j:n), flip );

   i = i + 1;
   j = j + 1;
end
end

function [NullSpace]=null2(A)
A=mod(A,2);
%number of constraints:
m=size(A,1);
%number of variables:
n=size(A,2);
%number of independent constraints:
r=gfrank(A,2);

%Take care of the trivial cases:
if (r==n)
    NullSpace=[];
elseif (r==0)
    NullSpace=eye(n,n);
end

%Add one constraint at a time.
%Maintain a matrix X whose columns obey all constraints examined so far.

%Initially there are no constraints:
X=eye(n,n);

for i=1:m
    y=mod(A(i,:)*X,2);
    % identify 'bad' columns of X which are not orthogonal to y
    % and 'good' columns of X which are orthogonal to y
    GOOD=[X(:,find(not(y)))];
    %convert bad columns to good columns by taking pairwise sums
    if (nnz(y)>1)
      BAD=[X(:,find(y))];
      BAD=mod(BAD+circshift(BAD,1,2),2);
      BAD(:,1)=[];
    else
        BAD=[];
    end
    X=[GOOD,BAD];
end%for i

NullSpace=X;
end
