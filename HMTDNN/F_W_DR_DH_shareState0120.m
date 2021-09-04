%%  【DNN-HMT融合训练】
function [pi,trans,trans_tree,train_samples, train_State, train_labels, test_samples,test_State, test_labels,test_num, percent, logLik_list,loglik_matrix, ss_1, x_train, y_train] = F_W_DR_DH_shareState0120(pi0,A0,A0_tree,State, T_2, T_2_test, Label,Label_test, net, Q, S, scale, iteration)
%建立DNN-HMT训练模型

% % 程序参数
% O = 16; % 观测值特征维度
% Q = 6; % 状态个数
% S = 64;% 小波系数总个数
% iteration = 10; % 迭代次数
% 2021/1/12 修改：在计算信息量之前对数据集进行分割。
% 2021/1/12 修改：统一了状态空间。

%加载训练用-测试用数据
train_samples = {};
train_State = [];
train_labels = [];
test_samples = {};
test_State = [];
test_labels = [];
test_num = size(Label_test);% 用于测试样本的数目
% L = size(State,1);
% test_num = fix(L/3);% 用于测试样本的数目
rng('default');
rng('shuffle');

% DNN参数初始化
for i=1:size(T_2,2)
    train_samples{i} = T_2(:,i,:);
    train_State(i,:) = State(i,:);
    train_labels(i) = Label(i);
end
for i=1:size(T_2_test,2)
    test_samples{i} = T_2_test(:,i,:);
    test_labels(i) = Label_test(i);
end

Y_train0 = [];
for i =1:size(train_State,1)
    Y_train0 = [Y_train0,train_State(i,:)];
end
Train_State=reshape(Y_train0',size(train_State,1),size(train_State,2));% 错误reshape为列优先
Train_State=train_State;

table = tabulate(Y_train0); % 统计各个状态出现的比例
percent = table(:,3)./100; % 可以用作Pr(s),各状态的概率
if size(percent,1) < size(A0,1)
    for i=size(percent,1)+1:size(A0,1)
        percent(i)=0;
    end
end

%% 只共享生成矩阵
[s,~] = find(percent==0);
if length(s)~=0
    percent_update = percent;
    pi0_update= pi0;
    A0_update = A0;
    A0_tree_update = A0_tree;
    pi0_update(:,s) = [];
    percent_update(s,:)=[];
    A0_update(:,s)=[];
    A0_update(s,:)=[];
    A0_tree_update(:,:,s)=[];
    A0_tree_update(:,s,:)=[];
    A0_tree_update(s,:,:)=[];
    % 【DNN-HMT共同迭代训练模型】
    [pi_update, trans_update, trans_tree_update, Percent_update, logLik_list,loglik_matrix, ~, ss_1,x_train, y_train] = ...
    DNN_HMT_shareState0118(train_samples, Train_State(:,:), percent_update, pi0_update, A0_update, A0_tree_update, net, scale, iteration, s);
    % 替换掉原有的pi，trans等
    pi = zeros(1,Q);
    trans = zeros(Q,Q);
    trans_tree = zeros(Q,Q,Q);

    for j=size(trans_update,1)+1:Q
        Percent_update(j) = 0.0001;
        pi_update(j) = 0.0001;
        trans_update(j,:) = 0.0001;
        trans_update(:,j) = 0.0001;
        trans_tree_update(:,:,j) = 0.0001;
        trans_tree_update(:,j,:) = 0.0001;
        trans_tree_update(j,:,:) = 0.0001;
    end
    for i=1:Q
        if find(s==i)
            for k=Q:-1:i+1
                Percent_update(k) = Percent_update(k-1);
                pi_update(k) = pi_update(k-1);
                trans_update(k,:) = trans_update(k-1,:);
                trans_update(:,k) = trans_update(:,k-1);
                trans_tree_update(:,:,k) = trans_tree_update(:,:,k-1);
                trans_tree_update(:,k,:) = trans_tree_update(:,k-1,:);
                trans_tree_update(k,:,:) = trans_tree_update(k-1,:,:);
            end
            Percent_update(i) = 0.0001;
            pi_update(i) = 0.0001;
            trans_update(i,:) = 0.0001;
            trans_update(:,i) = 0.0001;
            trans_tree_update(:,:,i) = 0.0001;
            trans_tree_update(:,i,:) = 0.0001;
            trans_tree_update(i,:,:) = 0.0001;
        else
            continue;
        end
    end
    for j=1:Q
        if find(s==j)
            pi(j) = pi0(j);
            percent(i) = percent(j);
            trans(j,:) = A0(j,:);
            trans(:,j) = A0(:,j);
            trans_tree(:,:,j) = A0_tree(:,:,j);
            trans_tree(:,j,:) = A0_tree(:,j,:);
            trans_tree(j,:,:) = A0_tree(j,:,:);  
        else
            pi(j) = pi_update(j);
            percent(i) = Percent_update(j);
            trans(j,:) = trans_update(j,:);
            trans(:,j) = trans_update(:,j);
            trans_tree(:,:,j) = trans_tree_update(:,:,j);
            trans_tree(:,j,:) = trans_tree_update(:,j,:);
            trans_tree(j,:,:) = trans_tree_update(j,:,:);
            
        end
    end
            
else
    % 【DNN-HMT共同迭代训练模型】
    [pi, trans, trans_tree, percent, logLik_list,loglik_matrix, ~, ss_1,x_train, y_train] = ...
    DNN_HMT_shareState0118(train_samples, Train_State(:,:), percent, pi0, A0, A0_tree, net, scale, iteration,s);
end

%% 展示输出的状态比例
table = tabulate(y_train); % 统计各个状态出现的比例
percent = table(:,3)./100; % 可以用作Pr(s),各状态的概率
if size(percent,1) < size(A0,1)
    for i=size(percent,1)+1:size(A0,1)
        percent(i)=0;
    end
end
StateProinData(y_train);% 统计一下数据集中各个状态出现的比例

%% 【展示模块】
% PlotLoglik(logLik_list);% 绘制收敛性曲线
% Show_O_Dis_of_S(train_samples, ss_1, Q); % 绘制出给定状态下观测值对应的分布

