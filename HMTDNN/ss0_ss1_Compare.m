function similarity = ss0_ss1_Compare( seq_old, seq_new )
% 对比状态序列的相似程度
% 输入：
% seq_old/new每一行为一个样本的状态序列，行数为样本的数量
% seq_old为前一次训练的状态序列
% seq_new为当前训练的状态序列
% ======================================
% 输出：
% 新旧状态序列一模一样的数量 / 样本总数量
    sim_cnt = 0; % 用于记录新旧状态序列一模一样的数量
    col = size(seq_old, 2); % 序列长度
    for i = 1:size(seq_old, 1)
        flag = 1;
        for j = 1:col
            if seq_old(i, j) ~= seq_new(i, j)
                flag = 0; % 新旧状态序列不一样
                break
            end
        end
        if flag == 1
            sim_cnt = sim_cnt + 1;
        end
    end
    similarity = sim_cnt / size(seq_old, 1);
end

