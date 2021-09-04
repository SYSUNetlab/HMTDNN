function Euc_dist = Eudist(A,B)

% 函数用于计算具有相同维度的矩阵A,B的欧式距离

C = (A - B).^2;
Euc_dist = sqrt(sum(C(:)));