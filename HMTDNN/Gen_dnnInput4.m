function [X_test, test_tree] = Gen_dnnInput4(data,net, percent_1, pi_1, trans_1, trans_tree_1,...
                                                    net_1,percent_2, pi_2, trans_2, trans_tree_2,...
                                                    net_2,percent_3, pi_3, trans_3, trans_tree_3,...
                                                    net_3,percent_4, pi_4, trans_4, trans_tree_4,...
                                                    net_4,percent_5, pi_5, trans_5, trans_tree_5,...
                                                    net_5,percent_6, pi_6, trans_6, trans_tree_6,...
                                                    net_6,percent_7, pi_7, trans_7, trans_tree_7,...
                                                    num)                                          
                                                
% Gen_dnnInput4 Generate the probability metrics
% Input£º
% data£ºall o_r
% net_*£ºnerual network
% num£ºthe number of class
% pi_*,tran_*,trans_tree_*: the parameters of HMT
% 
% Output£º
% X_test: the probability metrics
% test_tree; the optimal tree                                                                                                                                                                   
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
    tmp = [];
    for k=1:length(data)
        for j = 1:size(data{k},1)
            tmp = data{k}(j,:);
            data{k}(j,:) = mapminmax(tmp,0,1);
        end
    end
    X_test=[];
    test_tree = [];
    for j = 1:sum(num)
        tmp = squeeze(data{j}(:,1,:));
        Post_pro_1 = net(tmp); %  the posterior probability
        Post_pro_2 = net_1(tmp);
        Post_pro_3 = net_2(tmp);
        Post_pro_4 = net_3(tmp);
        Post_pro_5 = net_4(tmp);
        Post_pro_6 = net_5(tmp);
        Post_pro_7 = net_6(tmp);
        
        % Pr(O|S)
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
        Post_pro1(Post_pro1<0.00001)=0.00001;
        percent_1(percent_1<0.00001)=0.00001;
        Post_pro2(Post_pro2<0.00001)=0.00001;
        percent_2(percent_2<0.00001)=0.00001;
        Post_pro3(Post_pro3<0.00001)=0.00001;
        percent_3(percent_3<0.00001)=0.00001;
        Post_pro4(Post_pro4<0.00001)=0.00001;
        percent_4(percent_4<0.00001)=0.00001;
        Post_pro5(Post_pro5<0.00001)=0.00001;
        percent_5(percent_5<0.00001)=0.00001;
        Post_pro6(Post_pro6<0.00001)=0.00001;
        percent_6(percent_6<0.00001)=0.00001;
        Post_pro7(Post_pro7<0.00001)=0.00001;
        percent_7(percent_7<0.00001)=0.00001;
        
        Pre_pro_1 = repmat(percent_1,[1,size(Post_pro1,2)]);% P(S)
        Pre_pro_2 = repmat(percent_2,[1,size(Post_pro2,2)]);
        Pre_pro_3 = repmat(percent_3,[1,size(Post_pro3,2)]);
        Pre_pro_4 = repmat(percent_4,[1,size(Post_pro4,2)]);
        Pre_pro_5 = repmat(percent_5,[1,size(Post_pro5,2)]);
        Pre_pro_6 = repmat(percent_6,[1,size(Post_pro6,2)]);
        Pre_pro_7 = repmat(percent_7,[1,size(Post_pro7,2)]);
        Gen_lik_1 = Post_pro1 ./ Pre_pro_1;
        Gen_lik_1 = Gen_lik_1(:,:) ./ sum(Gen_lik_1);
        Gen_lik_2 = Post_pro2 ./ Pre_pro_2;
        Gen_lik_2 = Gen_lik_2(:,:) ./ sum(Gen_lik_2);
        Gen_lik_3 = Post_pro3 ./ Pre_pro_3;
        Gen_lik_3 = Gen_lik_3(:,:) ./ sum(Gen_lik_3);
        Gen_lik_4 = Post_pro4 ./ Pre_pro_4;
        Gen_lik_4 = Gen_lik_4(:,:) ./ sum(Gen_lik_4);
        Gen_lik_5 = Post_pro5 ./ Pre_pro_5;
        Gen_lik_5 = Gen_lik_5(:,:) ./ sum(Gen_lik_5);
        Gen_lik_6 = Post_pro6 ./ Pre_pro_6;
        Gen_lik_6 = Gen_lik_6(:,:) ./ sum(Gen_lik_6);
        Gen_lik_7 = Post_pro7 ./ Pre_pro_7;
        Gen_lik_7 = Gen_lik_7(:,:) ./ sum(Gen_lik_7);

        [p_1, pro_1, state_1, Pros_1] = Calcu_Pro(pi_1, trans_1, trans_tree_1, Gen_lik_1, s1);
        [p_2, pro_2, state_2, Pros_2] = Calcu_Pro(pi_2, trans_2, trans_tree_2, Gen_lik_2, s2);
        [p_3, pro_3, state_3, Pros_3] = Calcu_Pro(pi_3, trans_3, trans_tree_3, Gen_lik_3, s3);
        [p_4, pro_4, state_4, Pros_4] = Calcu_Pro(pi_4, trans_4, trans_tree_4, Gen_lik_4, s4);
        [p_5, pro_5, state_5, Pros_5] = Calcu_Pro(pi_5, trans_5, trans_tree_5, Gen_lik_5, s5);
        [p_6, pro_6, state_6, Pros_6] = Calcu_Pro(pi_6, trans_6, trans_tree_6, Gen_lik_6, s6);
        [p_7, pro_7, state_7, Pros_7] = Calcu_Pro(pi_7, trans_7, trans_tree_7, Gen_lik_7, s7);

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
        % probability metrics
        p = [log(p_1),log(p_2),log(p_3),log(p_4),log(p_5),log(p_6),log(p_7)];
        Pros = [Pros_1,Pros_2,Pros_3,Pros_4,Pros_5,Pros_6,Pros_7];
        x_test = [mapminmax(p,0,1),mapminmax(Pros,0,1)];
        X_test = [X_test;x_test];     
    end