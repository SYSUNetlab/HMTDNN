function Ps = Pro_s(series, tree)
% PRO_S  Calculate the similarity of state trees.
% Inputs：
% series: optimal state tree
% tree: detecting state tree
%
% Output:
% Ps:the similarity
    num = 0;
    for i=1:size(series,2)
        if series(i) == tree(i)
            num = num + 1;
        else
            continue;
        end
    end
    Ps = num / size(series,2);
    
    
    tabel_1 = tabulate(series');
    tabel_2 = tabulate(tree');
