function [ pi, trans, trans_tree, State_samples, State_path_samples ] = initialPIandA0203( data, Q, scale)
% 通过间的计数的方法初始化 HMM 的参数
% 这里主要对【初始状态矩阵】和【状态转移矩阵】进行初始化
% 即初始化 π 和 A矩阵
%
% 输入：
% data：数据,若data为手工标记的状态，则需要根据所有的特征的状态标记设置样本的状态；若data为使用kmedoisd标记的状态，则直接使用即可
% Q：状态个数，即聚类的类别数目
%
% 输出：
% pi：初始状态矩阵
% trans：每层第一个节点状态转移矩阵A(m,n)
% trans_tree：每一层除第一个节点的状态转移矩阵A(m,n,q)
% 2020\08\23 修改：添加尺度变化条件下的情形
% 2021/02/03 修改：只考虑高尺度
% 
% ============================================

%%% === 若为kmedoisd生成，只需要存取为树

%     [~,level] = judge_Power(size(data,2),2);% 判断小波系数的频带数，树的深度
    State_tree = {};
    State_samples = {};
    State_path = [];
    State_path_samples = {};
    
    for i=1:size(data,1)
        for j=1:scale
            if j==1
                State_tree{1} = data(i,1);
            else
                for h=1:2^(j-1)
                    State_tree{j}(1,h) = data(i,2^(j-1)+h-1);
                end
            end
        end
        State_samples{i} = State_tree;
        State_tree = {};
    end

    
    
    
    pi = zeros(1, Q);
    trans = zeros(Q, Q);
    trans_tree = zeros(Q,Q,Q);
    
    for i=1:length(State_samples)
        pi(1,State_samples{i}{1,1}) = pi(1,State_samples{i}{1,1}) + 1;
        for j=1:scale
            for h=1:2^(j-1)
                if judge_Power(h+2^(j-1)-1,2)~=1 && j~=1 % 小波树每一层的第一个节点只有来自父节点的转移概率,再考虑两个方向的转移概率时可以不用考虑
                    if mod(h+2^(j-1),2)==0 % 确定父节点位置
                        p_index = (h+2^(j-1))/2 - 2^(j-2);
                        trans_tree(State_samples{i}{j}(1,h-1), State_samples{i}{j-1}(1,p_index), State_samples{i}{j}(1,h)) = ... % a(mnq)
                        trans_tree(State_samples{i}{j}(1,h-1), State_samples{i}{j-1}(1,p_index), State_samples{i}{j}(1,h)) + 1;
                    else
                        p_index = (h+2^(j-1)+1)/2 - 2^(j-2);
                        trans_tree(State_samples{i}{j}(1,h-1), State_samples{i}{j-1}(1,p_index), State_samples{i}{j}(1,h)) = ...
                        trans_tree(State_samples{i}{j}(1,h-1), State_samples{i}{j-1}(1,p_index), State_samples{i}{j}(1,h)) + 1;
                    end
                else
                    if j~=scale
                        trans(State_samples{i}{j}(1,h),State_samples{i}{j+1}(1,1)) = ... % 除了第七层其他层最左边节点均可成为子节点
                        trans(State_samples{i}{j}(1,h),State_samples{i}{j+1}(1,1)) + 1;
                    end
                end
            end
        end 
    end
    for i=1:length(State_samples)% 提取最左侧马尔可夫链的状态集
        for j=1:size(State_samples{i},2)
            State_path(j) = State_samples{i}{j}(1,1);
        end
        State_path_samples{i} = State_path; % 存储所有的最左侧马尔可夫链
        State_path = [];
    end
    % 初始化pi
    piSum = sum(pi);
    pi = pi ./ piSum;
    % 初始化a(mn)
    transSum = sum(trans, 2);
    for i = 1:length(transSum)
        trans(i, :) = trans(i, :) ./ transSum(i);
    end
    
    
    % 初始化a(mnq)
    trans_treeSum = sum(trans_tree,3);
    for j=1:size(trans_tree,2)
        trans_tree(:,:,j) = trans_tree(:,:,j) ./ trans_treeSum;
    end

    [~,col_p] = find(pi==0);
    if length(col_p)~=0
        for k=1:length(col_p)
            pi(col_p(k)) = 0.0001;
        end
    end
    
    trans(isnan(trans)) = 0;
    trans_tree(isnan(trans_tree)) = 0;
    % 【保证初始化的转移矩阵中没有0】
    [row, col] = find(trans==0);
    if length(row)~=0
        for i=1:length(row)
            trans(row(i),col(i)) = 0.0001;
        end
    end
    trans(isnan(trans)) = 0;
    [row_tree,col_tree,high_tree] = ind2sub([Q,Q,Q],find(trans_tree==0));
    if length(row_tree)~=0
        for j=1:length(row_tree)
            trans_tree(row_tree(j),col_tree(j),high_tree(j)) = 0.0001;
        end
    end
end

