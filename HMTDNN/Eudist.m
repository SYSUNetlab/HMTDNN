function Euc_dist = Eudist(A,B)

% �������ڼ��������ͬά�ȵľ���A,B��ŷʽ����

C = (A - B).^2;
Euc_dist = sqrt(sum(C(:)));