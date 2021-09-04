function Ps = Pro_s(series, tree)

%%%  函数用于计算P(s|lanbuda)，即用于检测的样本得到的最优序列与训练样本收敛时最优序列的组合
% input：
% series: 训练收敛时的最优序列
% tree:检测样本得到的序列

% output:
% Ps:用于表示series与tree匹配程度的指标。\
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