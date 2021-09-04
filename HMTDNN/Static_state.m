    function trans = Static_state(ss, Q)

    % 函数用于统计检测时输出序列的状态转移矩阵
    % input:
    % ss: 最优状态序列
    % Q ：状态的数目

    % output：
    % trans，trans_tree：状态转移矩阵
    
    trans = zeros(Q,Q);
    for i=2:size(ss,2)
        trans(ss(i-1),ss(i)) = trans(ss(i-1),ss(i)) + 1;
    end
        

