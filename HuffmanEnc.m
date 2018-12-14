clear;
nTx = 4; nRx = 4;
R = 4; %Bits per channel user
p = [1/2, 1/4, 1/8, 1/8]; %Probabilities
antSym = 1:nTx;
N = 80; %Length of bit stream
SNRdB = 50; %SNR in dB
var = 1; %variance of noise

x = unidrnd(2,N/R,R)-1; %Generate random bit stream and shape in R length blocks
dict = huffmandict(antSym,p);
SNR = 10^(SNRdB/10);

H=randn([nRx nTx])+randn([nRx nTx])*1i; %Rayleigh channel

AntMap = zeros(1, nTx);
combVec = flip(combnk(1:nTx,2));
dist = zeros(1, size(combVec,1));
for i = 1:size(combVec,1)
    dist(i) = norm(H(:,combVec(i,1)) - H(:,combVec(i,2)));
end
[sortDist, newI] = sort(dist); %Sort distance array
sortComb = combVec(newI,:); %Modify combinations array to match sorted dist array
check = sortComb(1,:) == sortComb(end,:); %Check for common value between
unassigned = 1:nTx;
AntMap(nTx-1:nTx) = sortComb(1,:); %closest together points will be given to C and D
unassigned(unassigned == sortComb(1,1)) = [];
unassigned(unassigned == sortComb(1,2)) = [];
if check (1) == 1 %Assign greatest probability to value further from smallest points if common
    AntMap(1) = sortComb(end,2);
    unassigned(unassigned == AntMap(1)) = [];
elseif check (2) == 1
    AntMap(1) = sortComb(end,1);
    unassigned(unassigned == AntMap(1)) = [];
else
    AntMap(1:2) = sortComb(end,:);
    unassigned(unassigned == AntMap(end,1)) = [];
    unassigned(unassigned == AntMap(end,2)) = [];
end
if ~isempty(unassigned)
AntMap(2) = unassigned;
end

C = cell(1,nTx); %Keep hold of extracted binary symbols
ModSig = cell(2,nTx); %Row 1 = Modulated symbols, row 2 = symbol indices
totInd = 1:size(x,1);
for i = 1:nTx
    ind = find(x(totInd,i) == 0); %extract indices for when the ith symbol equals zero
    if i ~= nTx
        C{i} = x(totInd(ind),1+i:end); %assign the extracted symbols to the correct cell
        temp = binConv(C{i});
        if i == 1 
            ModSig{1,i} = starQAMMod(temp);
        else
            ModSig{1,i} = qammod(temp,2^(nTx-i),'UnitAveragePower',true);
        end
        ModSig{2,i} = totInd(ind);
    else
        C{i} = x(totInd(ind),end);
        temp = binConv(C{i});
        if ~isempty(temp)
        ModSig{1,i} = qammod(temp,2,'UnitAveragePower',true);
        ModSig{2,i} = totInd(ind);
        end
    end
    totInd(ind) = [];
end

s = zeros(nTx,N/R);
for k = 1:length(AntMap)
    s(AntMap(k),ModSig{2,k}) = ModSig{1,k}; %Maps symbol sequence to correct antenna position and location within send vector
end
r = sqrt(SNR)*H*s+var*(randn(size(s))+randn(size(s))*1i); %Multiply by chan resp + add noise

[sRef,refPt] = refRxSet(p,R,nTx,AntMap); %Creates the reference signal set of all unique symbol responses
rRef = sqrt(SNR)*H*sRef;
yHat = hardML(R,rRef,r);
[BitEr,BER] = biterr(x,yHat);

%===================================================================================================

function d = binConv(x) %binary to decimal conversion
[seqLength, bitLength] = size(x);
d = zeros(seqLength,1);
for j = 1:seqLength
    for i = 1:bitLength
        d(j) = d(j) + x(j,i)*2^(bitLength-i);
    end
end
end

function [sRef, refPt] = refRxSet(p,R,nTx, AntMap)
partInd = p * 2^R - 1; %array of highest symbol value for each subset of huffman tree
refPt = cell(2,R);
for i = 1:R-1 %R-1 as last two will have the same set
    if i == 1 %handles case when using 8 qam      
        refPt{1,i} = starConst();
        refPt{2,i} = 1:partInd(i)+1;
    else
        refPt{1,i} = qammod(0:partInd(i),2^(R-i),'UnitAveragePower',true);
        refPt{2,i} = 1:partInd(i)+1;
    end
end
refPt{1,R} = refPt{1,R-1};
refPt{2,R} = refPt{2,R-1};
sRef = zeros(nTx, 2^R);
for j = 1:length(AntMap)
    if j == 1
        sRef(AntMap(j), refPt{2,j}) = refPt{1,j};
        temp = refPt{2,1}(j,end);
    else
        sRef(AntMap(j), temp + refPt{2,j}) = refPt{1,j};
        refPt{2,j} = refPt{2,j} + temp;
        temp = refPt{2,j}(1,end);
    end
end
end

function yHat = hardML(R,rRef,r)
for i = 1:length(r)
    for j = 1:length(rRef)
        dist=r(:,i)-rRef(:,j);
        dist_arr(j)=(norm(dist,'fro'))^2;
    end
    [~,min_arg(i)]=min(dist_arr);
end
yHat = de2bi(min_arg-1,R, 'left-msb');
end

function sB = starConst()
s1 = qammod(0:3, 4);
s2 = [-(1+sqrt(3))+0i 0-(1+sqrt(3))*1i (1+sqrt(3))+0i 0+(1+sqrt(3))*1i];
s = [s1, s2];
%sB1 = [s(5) s(1) s(2) s(8) s(6) s(3) s(4) s(7)];
sB = [s(2) s(5) s(8) s(1) s(6) s(4) s(3) s(7)]*(1/sqrt(4.732)); %reorder points + scale for unit avg power
end

function s = starQAMMod(x)
s = zeros(1,length(x));
x = x+1;
sB = starConst();
for i = 1:length(x)
    s(i) = sB(1,x(i));
end
end

