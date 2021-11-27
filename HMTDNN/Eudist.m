% Calculate the Euclidean distance between A and B
function Euc_dist = Eudist(A,B)

C = (A - B).^2;
Euc_dist = sqrt(sum(C(:)));
