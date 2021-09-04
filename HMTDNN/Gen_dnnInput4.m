
% 函数用于处理测试数据，生成后续用于训练分类用DNN的input
% input：
% data，state：为观测数据及状态
% net：为用于生成似然概率的网络
% num：为各种类型样本的数目
% 其他均为每种类型的HMT的参数
% 
% output：
% X_test: 后续需要输入分类DNN的数据
% X_test = [p_4, pro_4, Ps4, per_max4, per_min4, Var_4];
% 2021/01/21 修改：增加输出由参数计算出的最优状态树


function [X_test, test_tree] = Gen_dnnInput4(data, state, label, net, percent_1, pi_1, trans_1, trans_tree_1, ss1,loglik1,...
                                                    net_1,percent_2, pi_2, trans_2, trans_tree_2, ss2,loglik2,...
                                                    net_2,percent_3, pi_3, trans_3, trans_tree_3, ss3,loglik3,...
                                                    net_3,percent_4, pi_4, trans_4, trans_tree_4, ss4,loglik4,...
                                                    net_4,percent_5, pi_5, trans_5, trans_tree_5, ss5,loglik5,...
                                                    net_5,percent_6, pi_6, trans_6, trans_tree_6, ss6,loglik6,...
                                                    net_6,percent_7, pi_7, trans_7, trans_tree_7, ss7,loglik7,...
                                                    num,scale)
                                                                                      
    Q = size(trans_1,1);                                                                                     
% 【计算各种内容的概率】
    for n=1:size(ss1,2) % 统一同一内容类型的典型状态树
        table=tabulate(ss1(:,n));
        [~,Max_sta] = max(table(:,3));
        y_tra(1,n) = Max_sta;
    end
    ss1 = [ss1; y_tra];
    
    for n=1:size(ss2,2) % 统一同一内容类型的典型状态树
        table=tabulate(ss2(:,n));
        [~,Max_sta] = max(table(:,3));
        y_tra(1,n) = Max_sta;
    end
    ss2 = [ss2; y_tra];
    
    for n=1:size(ss3,2) % 统一同一内容类型的典型状态树
        table=tabulate(ss3(:,n));
        [~,Max_sta] = max(table(:,3));
        y_tra(1,n) = Max_sta;
    end
    ss3 = [ss3; y_tra];
    
    for n=1:size(ss4,2) % 统一同一内容类型的典型状态树
        table=tabulate(ss4(:,n));
        [~,Max_sta] = max(table(:,3));
        y_tra(1,n) = Max_sta;
    end
    ss4 = [ss4; y_tra];
    
    for n=1:size(ss5,2) % 统一同一内容类型的典型状态树
        table=tabulate(ss5(:,n));
        [~,Max_sta] = max(table(:,3));
        y_tra(1,n) = Max_sta;
    end
    ss5 = [ss5; y_tra];
    
    for n=1:size(ss6,2) % 统一同一内容类型的典型状态树
        table=tabulate(ss6(:,n));
        [~,Max_sta] = max(table(:,3));
        y_tra(1,n) = Max_sta;
    end
    ss6 = [ss6; y_tra];
    
    for n=1:size(ss7,2) % 统一同一内容类型的典型状态树
        table=tabulate(ss7(:,n));
        [~,Max_sta] = max(table(:,3));
        y_tra(1,n) = Max_sta;
    end
    ss7 = [ss7; y_tra];
    
    [s1,~] = find(percent_1==0);
    [s2,~] = find(percent_2==0);
    [s3,~] = find(percent_3==0);
    [s4,~] = find(percent_4==0);
    [s5,~] = find(percent_5==0);
    [s6,~] = find(percent_6==0);
    [s7,~] = find(percent_7==0);
    if length(s1)~=0
        percent_1(s1,:) = [];
        pi_1(:,s1) = [];
        trans_1(s1,:) = [];
        trans_1(:,s1) = [];
        trans_tree_1(:,:,s1) = [];
        trans_tree_1(:,s1,:) = [];
        trans_tree_1(s1,:,:) = [];
    end

    if length(s2)~=0
        percent_2(s2,:) = [];
        pi_2(:,s2) = [];
        trans_2(s2,:) = [];
        trans_2(:,s2) = [];
        trans_tree_2(:,:,s2) = [];
        trans_tree_2(:,s2,:) = [];
        trans_tree_2(s2,:,:) = [];
    end

    if length(s3)~=0
        percent_3(s3,:) = [];
        pi_3(:,s3) = [];
        trans_3(s3,:) = [];
        trans_3(:,s3) = [];
        trans_tree_3(:,:,s3) = [];
        trans_tree_3(:,s3,:) = [];
        trans_tree_3(s3,:,:) = [];
    end

    if length(s4)~=0
        percent_4(s4,:) = [];
        pi_4(:,s4) = [];
        trans_4(s4,:) = [];
        trans_4(:,s4) = [];
        trans_tree_4(:,:,s4) = [];
        trans_tree_4(:,s4,:) = [];
        trans_tree_4(s4,:,:) = [];
    end

    if length(s5)~=0
        percent_5(s5,:) = [];
        pi_5(:,s5) = [];
        trans_5(s5,:) = [];
        trans_5(:,s5) = [];
        trans_tree_5(:,:,s5) = [];
        trans_tree_5(:,s5,:) = [];
        trans_tree_5(s5,:,:) = [];
    end

    if length(s6)~=0
        percent_6(s6,:) = [];
        pi_6(:,s6) = [];
        trans_6(s6,:) = [];
        trans_6(:,s6) = [];
        trans_tree_6(:,:,s6) = [];
        trans_tree_6(:,s6,:) = [];
        trans_tree_6(s6,:,:) = [];
    end
    if length(s7)~=0
        percent_7(s7,:) = [];
        pi_7(:,s7) = [];
        trans_7(s7,:) = [];
        trans_7(:,s7) = [];
        trans_tree_7(:,:,s7) = [];
        trans_tree_7(:,s7,:) = [];
        trans_tree_7(s7,:,:) = [];
    end
 %% 【生成最终输入DNN分类的输入】  
    % 对每个样本数据按照行进行归一化
    tmp = [];
    for k=1:length(data)
        for j = 1:size(data{k},1)
            tmp = data{k}(j,:);
            data{k}(j,:) = mapminmax(tmp,0,1);
        end
    end
    X_test=[];
    test_tree = []; % 保存每个检测样本的状态树
    for j = 1:sum(num)
        tmp = squeeze(data{j}(:,1,:));
        Post_pro_1 = net(tmp); %  输出观测值在每个状态的的预测概率,Q*n,即后验概率Pr(S|O),状态矩阵序列
        Post_pro_2 = net_1(tmp);
        Post_pro_3 = net_2(tmp);
        Post_pro_4 = net_3(tmp);
        Post_pro_5 = net_4(tmp);
        Post_pro_6 = net_5(tmp);
        Post_pro_7 = net_6(tmp);
        
        % 将后验概率转换为似然度Pr(O|S)
        Post_pro1 = Post_pro_1;
        Post_pro2 = Post_pro_2;
        Post_pro3 = Post_pro_3;
        Post_pro4 = Post_pro_4;
        Post_pro5 = Post_pro_5;
        Post_pro6 = Post_pro_6;
        Post_pro7 = Post_pro_7;
        if length(s1)~=0
            Post_pro1(s1,:) = [];
        end
        
        if length(s2)~=0
            Post_pro2(s2,:) = [];
        end
        
        if length(s3)~=0
            Post_pro3(s3,:) = [];
        end
        
        if length(s4)~=0
            Post_pro4(s4,:) = [];
        end
        
        if length(s5)~=0
            Post_pro5(s5,:) = [];
        end
        
        if length(s6)~=0
            Post_pro6(s6,:) = [];
        end
        
        if length(s7)~=0
            Post_pro7(s7,:) = [];
        end
        Post_pro1(Post_pro1<0.00001)=0.00001;% 值太小的话设置一下
        percent_1(percent_1<0.00001)=0.00001;
        Post_pro2(Post_pro2<0.00001)=0.00001;% 值太小的话设置一下
        percent_2(percent_2<0.00001)=0.00001;
        Post_pro3(Post_pro3<0.00001)=0.00001;% 值太小的话设置一下
        percent_3(percent_3<0.00001)=0.00001;
        Post_pro4(Post_pro4<0.00001)=0.00001;% 值太小的话设置一下
        percent_4(percent_4<0.00001)=0.00001;
        Post_pro5(Post_pro5<0.00001)=0.00001;% 值太小的话设置一下
        percent_5(percent_5<0.00001)=0.00001;
        Post_pro6(Post_pro6<0.00001)=0.00001;% 值太小的话设置一下
        percent_6(percent_6<0.00001)=0.00001;
        Post_pro7(Post_pro7<0.00001)=0.00001;% 值太小的话设置一下
        percent_7(percent_7<0.00001)=0.00001;
        
        Pre_pro_1 = repmat(percent_1,[1,size(Post_pro1,2)]);% 将P(S)平铺开来，有利于后续处理
        Pre_pro_2 = repmat(percent_2,[1,size(Post_pro2,2)]);
        Pre_pro_3 = repmat(percent_3,[1,size(Post_pro3,2)]);
        Pre_pro_4 = repmat(percent_4,[1,size(Post_pro4,2)]);
        Pre_pro_5 = repmat(percent_5,[1,size(Post_pro5,2)]);
        Pre_pro_6 = repmat(percent_6,[1,size(Post_pro6,2)]);
        Pre_pro_7 = repmat(percent_7,[1,size(Post_pro7,2)]);
        Gen_lik_1 = Post_pro1 ./ Pre_pro_1;% 计算似然度Q*N,即生成概率,引入了观测概率
        Gen_lik_1 = Gen_lik_1(:,:) ./ sum(Gen_lik_1);% 标准化数据
        Gen_lik_2 = Post_pro2 ./ Pre_pro_2;
        Gen_lik_2 = Gen_lik_2(:,:) ./ sum(Gen_lik_2);% 标准化数据
        Gen_lik_3 = Post_pro3 ./ Pre_pro_3;
        Gen_lik_3 = Gen_lik_3(:,:) ./ sum(Gen_lik_3);% 标准化数据
        Gen_lik_4 = Post_pro4 ./ Pre_pro_4;
        Gen_lik_4 = Gen_lik_4(:,:) ./ sum(Gen_lik_4);% 标准化数据
        Gen_lik_5 = Post_pro5 ./ Pre_pro_5;
        Gen_lik_5 = Gen_lik_5(:,:) ./ sum(Gen_lik_5);% 标准化数据
        Gen_lik_6 = Post_pro6 ./ Pre_pro_6;
        Gen_lik_6 = Gen_lik_6(:,:) ./ sum(Gen_lik_6);% 标准化数据
        Gen_lik_7 = Post_pro7 ./ Pre_pro_7;
        Gen_lik_7 = Gen_lik_7(:,:) ./ sum(Gen_lik_7);% 标准化数据
        % 只共享生成矩阵
        [p_1, pro_1, state_1, Pros_1] = Calcu_Pro(pi_1, trans_1, trans_tree_1, Gen_lik_1, s1);% 计算DNN-HMT输出的概率, 输出的概率为一个向量，取概率最大的位置，便是该数据的预测类别
        [p_2, pro_2, state_2, Pros_2] = Calcu_Pro(pi_2, trans_2, trans_tree_2, Gen_lik_2, s2);% 第一个值：似然概率；第二个值：最优状态序列对应的概率；第三个值：Pr_O_S
        [p_3, pro_3, state_3, Pros_3] = Calcu_Pro(pi_3, trans_3, trans_tree_3, Gen_lik_3, s3);
        [p_4, pro_4, state_4, Pros_4] = Calcu_Pro(pi_4, trans_4, trans_tree_4, Gen_lik_4, s4);
        [p_5, pro_5, state_5, Pros_5] = Calcu_Pro(pi_5, trans_5, trans_tree_5, Gen_lik_5, s5);
        [p_6, pro_6, state_6, Pros_6] = Calcu_Pro(pi_6, trans_6, trans_tree_6, Gen_lik_6, s6);
        [p_7, pro_7, state_7, Pros_7] = Calcu_Pro(pi_7, trans_7, trans_tree_7, Gen_lik_7, s7);
        % 保存每个检测样本对应的状态树
        if j>=1 & j<=num(1)
            test_tree = [test_tree;state_1];
        elseif j>num(1) & j<=sum(num(1:2))
            test_tree = [test_tree;state_2];
        elseif j>sum(num(1:2)) & j<=sum(num(1:3))
            test_tree = [test_tree;state_3];
        elseif j>sum(num(1:3)) & j<=sum(num(1:4))
            test_tree = [test_tree;state_4];
        elseif j>sum(num(1:4)) & j<=sum(num(1:5))
            test_tree = [test_tree;state_5];
        elseif j>sum(num(1:5)) & j<=sum(num(1:6))
            test_tree = [test_tree;state_6];
        elseif j>sum(num(1:6)) & j<=sum(num(1:7))
            test_tree = [test_tree;state_7];
        end
        
        
        % 最优树的pos
        ss_1 = ss1(end,:);
        ss_2 = ss2(end,:);
        ss_3 = ss3(end,:);
        ss_4 = ss4(end,:);
        ss_5 = ss5(end,:);
        ss_6 = ss6(end,:);
        ss_7 = ss7(end,:);
        
        % 生成状态匹配程度指标
        Ps1 = Pro_s(ss_1, state_1);
        Ps2 = Pro_s(ss_2, state_2);
        Ps3 = Pro_s(ss_3, state_3);
        Ps4 = Pro_s(ss_4, state_4);
        Ps5 = Pro_s(ss_5, state_5);
        Ps6 = Pro_s(ss_6, state_6);
        Ps7 = Pro_s(ss_7, state_7);
        
        ss1_1 = ss1(end,:);
        ss2_2 = ss2(end,:);
        ss3_3 = ss3(end,:);
        ss4_4 = ss4(end,:);
        ss5_5 = ss5(end,:);
        ss6_6 = ss6(end,:);
        ss7_7 = ss7(end,:);
        for i=1:Q
            if find(s1==i)
                for k=1:size(ss1_1,2)
                    if ss_1(k) < i
                    else
                        ss1_1(k) = ss1_1(k)-1;
                    end
                end
            end
        end

        for i=1:Q
            if find(s2==i)
                for k=1:size(ss2_2,2)
                    if ss_2(k) < i
                    else
                        ss2_2(k) = ss2_2(k)-1;
                    end
                end
            end
        end

        for i=1:Q
            if find(s3==i)
                for k=1:size(ss3_3,2)
                    if ss_3(k) < i
                    else
                        ss3_3(k) = ss3_3(k)-1;
                    end
                end
            end
        end

        for i=1:Q
            if find(s4==i)
                for k=1:size(ss4_4,2)
                    if ss_4(k) < i
                    else
                        ss4_4(k) = ss4_4(k)-1;
                    end
                end
            end
        end

        for i=1:Q
            if find(s5==i)
                for k=1:size(ss5_5,2)
                    if ss_5(k) < i
                    else
                        ss5_5(k) = ss5_5(k)-1;
                    end
                end
            end
        end

        for i=1:Q
            if find(s6==i)
                for k=1:size(ss6_6,2)
                    if ss_6(k) < i
                    else
                        ss6_6(k) = ss6_6(k)-1;
                    end
                end
            end
        end
        
        for i=1:Q
            if find(s7==i)
                for k=1:size(ss7_7,2)
                    if ss_7(k) < i
                    else
                        ss7_7(k) = ss7_7(k)-1;
                    end
                end
            end
        end
        [Pros1,~] = Pro_O_S(pi_1, trans_1, trans_tree_1, log(Gen_lik_1'), ss1_1);
        [Pros2,~] = Pro_O_S(pi_2, trans_2, trans_tree_2, log(Gen_lik_2'), ss2_2);
        [Pros3,~] = Pro_O_S(pi_3, trans_3, trans_tree_3, log(Gen_lik_3'), ss3_3);
        [Pros4,~] = Pro_O_S(pi_4, trans_4, trans_tree_4, log(Gen_lik_4'), ss4_4);
        [Pros5,~] = Pro_O_S(pi_5, trans_5, trans_tree_5, log(Gen_lik_5'), ss5_5);
        [Pros6,~] = Pro_O_S(pi_6, trans_6, trans_tree_6, log(Gen_lik_6'), ss6_6);
        [Pros7,~] = Pro_O_S(pi_7, trans_7, trans_tree_7, log(Gen_lik_7'), ss7_7);
        
        % 状态序列占比方差
        table_1 = tabulate(state_1(:));
        percent1_1 = table_1(:,3)./100;
        if size(percent1_1,1)==1
            percent1_1 = percent1_1';
        end
        if length(percent1_1) < Q
            for i=length(percent1_1)+1:Q
                percent1_1(i) = 0;
            end
        end
        if size(percent1_1,1)==1
            percent1_1 = percent1_1';
        end
        
        Q11 = prctile(percent1_1',25);
        Q31 = prctile(percent1_1',75);
        Var_1 = var(percent1_1);
        
        table_2 = tabulate(state_2(:));
        percent1_2 = table_2(:,3)./100;
        if size(percent1_2,1)==1
            percent1_2 = percent1_2';
        end
        if length(percent1_2) < Q
            for i=length(percent1_2)+1:Q
                percent1_2(i) = 0;
            end
        end
        if size(percent1_2,1)==1
            percent1_2 = percent1_2';
        end
        
        Q12 = prctile(percent1_2',25);
        Q32 = prctile(percent1_2',75);
        Var_2 = var(percent1_2);
        
        table_3 = tabulate(state_3(:));
        percent1_3 = table_3(:,3)./100;
        if size(percent1_3,1)==1
            percent1_3 = percent1_3';
        end
        if length(percent1_3) < Q
            for i=length(percent1_3)+1:Q
                percent1_3(i) = 0;
            end
        end
        if size(percent1_3,1)==1
            percent1_3 = percent1_3';
        end
        
        Q13 = prctile(percent1_3',25);
        Q33 = prctile(percent1_3',75);
        Var_3 = var(percent1_3);
        
        table_4 = tabulate(state_4(:));
        percent1_4 = table_4(:,3)./100;
        if size(percent1_4,1)==1
            percent1_4 = percent1_4';
        end
        if length(percent1_4) < Q
            for i=length(percent1_4)+1:Q
                percent1_4(i) = 0;
            end
        end
        if size(percent1_4,1)==1
            percent1_4 = percent1_4';
        end
        
        Q14 = prctile(percent1_4',25);
        Q34 = prctile(percent1_4',75);
        Var_4 = var(percent1_4);
        
        table_5 = tabulate(state_5(:));
        percent1_5 = table_5(:,3)./100;
        if size(percent1_5,1)==1
            percent1_5 = percent1_5';
        end
        if length(percent1_5) < Q
            for i=length(percent1_5)+1:Q
                percent1_5(i) = 0;
            end
        end
        if size(percent1_5,1)==1
            percent1_5 = percent1_5';
        end
        Q15 = prctile(percent1_5',25);
        Q35 = prctile(percent1_5',75);
        Var_5 = var(percent1_5);
        
        table_6 = tabulate(state_6(:));
        percent1_6 = table_6(:,3)./100;
        if size(percent1_6,1)==1
            percent1_6 = percent1_6';
        end
        if length(percent1_6) < Q
            for i=length(percent1_6)+1:Q
                percent1_6(i) = 0;
            end
        end
        if size(percent1_6,1)==1
            percent1_6 = percent1_6';
        end
        
        Q16 = prctile(percent1_6',25);
        Q36 = prctile(percent1_6',75);
        Var_6 = var(percent1_6);
        
        table_7 = tabulate(state_7(:));
        percent1_7 = table_7(:,3)./100;
        if size(percent1_7,1)==1
            percent1_7 = percent1_7';
        end
        if length(percent1_7) < Q
            for i=length(percent1_7)+1:Q
                percent1_7(i) = 0;
            end
        end
        if size(percent1_7,1)==1
            percent1_7 = percent1_7';
        end
        
        Q17 = prctile(percent1_7',25);
        Q37 = prctile(percent1_7',75);
        Var_7 = var(percent1_7);
        
        
        % 计算两个序列生成的转移矩阵的欧式距离
        sample_tran1 = Static_state(ss1_1,size(pi_1,2)+length(s1));
        test_tran1 = Static_state(state_1,size(pi_1,2)+length(s1));
        distance_1 = Eudist(sample_tran1,test_tran1);
        
        sample_tran2 = Static_state(ss2_2,size(pi_2,2)+length(s2));
        test_tran2 = Static_state(state_2,size(pi_2,2)+length(s2));
        distance_2 = Eudist(sample_tran2,test_tran2);
        
        sample_tran3 = Static_state(ss3_3,size(pi_3,2)+length(s3));
        test_tran3 = Static_state(state_3,size(pi_3,2)+length(s3));
        distance_3 = Eudist(sample_tran3,test_tran3);
        
        sample_tran4 = Static_state(ss4_4,size(pi_4,2)+length(s4));
        test_tran4 = Static_state(state_4,size(pi_4,2)+length(s4));
        distance_4 = Eudist(sample_tran4,test_tran4);
        
        sample_tran5 = Static_state(ss5_5,size(pi_5,2)+length(s5));
        test_tran5 = Static_state(state_5,size(pi_5,2)+length(s5));
        distance_5 = Eudist(sample_tran5,test_tran5);
        
        sample_tran6 = Static_state(ss6_6,size(pi_6,2)+length(s6));
        test_tran6 = Static_state(state_6,size(pi_6,2)+length(s6));
        distance_6 = Eudist(sample_tran6,test_tran6);
        
        sample_tran7 = Static_state(ss7_7,size(pi_7,2)+length(s7));
        test_tran7 = Static_state(state_7,size(pi_7,2)+length(s7));
        distance_7 = Eudist(sample_tran7,test_tran7);
        
        % 统计每种类型的状态分布
%         [~,per_max1] = find(percent_1'==max(percent_1'));
%         [~,per_min1] = find(percent_1'==min(percent_1'));
%         [~,per_max2] = find(percent_2'==max(percent_2'));
%         [~,per_min2] = find(percent_2'==min(percent_2'));
%         [~,per_max3] = find(percent_3'==max(percent_3'));
%         [~,per_min3] = find(percent_3'==min(percent_3'));
%         [~,per_max4] = find(percent_4'==max(percent_4'));
%         [~,per_min4] = find(percent_4'==min(percent_4'));
%         [~,per_max5] = find(percent_5'==max(percent_5'));
%         [~,per_min5] = find(percent_5'==min(percent_5'));
%         [~,per_max6] = find(percent_6'==max(percent_6'));
%         [~,per_min6] = find(percent_6'==min(percent_6'));
        % 状态比例的方差
%         Var_1 = var(percent_1);
%         Var_2 = var(percent_2);
%         Var_3 = var(percent_3);
%         Var_4 = var(percent_4);
%         Var_5 = var(percent_5);
%         Var_6 = var(percent_6);

%         p = [abs(log(p_1)-loglik1*7/size(label,1)),abs(log(p_2)-loglik2*7/size(label,1)),abs(log(p_3)-loglik3*7/size(label,1)),abs(log(p_4)-loglik4*7/size(label,1)),abs(log(p_5)-loglik5*7/size(label,1)),abs(log(p_6)-loglik6*7/size(label,1)),abs(log(p_7)-loglik7*7/size(label,1))];
        p = [log(p_1),log(p_2),log(p_3),log(p_4),log(p_5),log(p_6),log(p_7)];
%         Pros = [abs(Pros_1-Pros1),abs(Pros_2-Pros2),abs(Pros_3-Pros3),abs(Pros_4-Pros4),abs(Pros_5-Pros5),abs(Pros_6-Pros6),abs(Pros_7-Pros7)];
        Pros = [Pros_1,Pros_2,Pros_3,Pros_4,Pros_5,Pros_6,Pros_7];
%         Pros = [Pros_1,Pros_2,Pros_3,Pros_4,Pros_5,Pros_6];
        Ps = [Ps1,Ps2,Ps3,Ps4,Ps5,Ps6,Ps7];
        Var = [Var_1,Var_2,Var_3,Var_4,Var_5,Var_6,Var_7];
        distance = [distance_1,distance_2,distance_3,distance_4,distance_5,distance_6,distance_7];
        Q1 = [Q11,Q12,Q13,Q14,Q15,Q16,Q17];
        Q3 = [Q31,Q32,Q33,Q34,Q35,Q36,Q37];
%         x_test = [mapminmax(p,0,1),mapminmax(Pros,0,1),Ps,mapminmax(distance,0,1)]; % 0.9098
%         x_test = [mapminmax(p,0,1),mapminmax(Pros,0,1),mapminmax(distance,0,1)];% 0.8855
        x_test = [mapminmax(p,0,1),mapminmax(Pros,0,1)];% 0.9093
%         x_test = [mapminmax(p,0,1),mapminmax(Pros,0,1)];% 0.8878
%         x_test = [mapminmax(p,0,1)];% 0.8594
%         x_test = [mapminmax(Pros,0,1)];% 0.7839
%         x_test = [p,Pros,Ps,distance];
            %percent1_1', percent1_2', percent1_3', percent1_4', percent1_5', percent1_6'];
%             ,mapminmax(Pros,0,1),Ps,Var];
%         x_test = [percent1_1', percent1_2', percent1_3', percent1_4', percent1_5', percent1_6'];
%         x_test = mapminmax(x_test,0,1);
        X_test = [X_test;x_test];
            %,percent1_1', percent1_2', percent1_3', percent1_4', percent1_5', percent1_6']];
        %,Pros_1, Pros_2, Pros_3, Pros_4, Pros_5, Pros_6,Ps1, Ps2, Ps3, Ps4, Ps5, Ps6, Var_1,Var_2,Var_3,Var_4,Var_5,Var_6]];
        %,distance_1,distance_2,distance_3,distance_4,distance_5,distance_6]]; % 所有特征都选，效果较好
        

    end