% 学习一个进行分类的神经网络
function [net0,tr] = Learn_Classify(X_test, label) 


 % 【对DNN进行训练】
    layers = [50 50 50 50 50];
    Net = patternnet(layers);
%    Net.trainParam.epochs = 50; % 设置最大迭代的次数
    Net.trainParam.lr = 0.005; % 设置学习速率
    
    label_extend = full(sparse(label',1:length(label'),1, 7, length(label')));
    [net0, tr] = train(Net,X_test',label_extend);
    net0.trainParam.showWindow = true;% 隐藏训练时神经网络窗口
    net0.trainParam.showCommandLine = true; % 隐藏训练时神经网络窗口
 
    

    
%     for j = test_num(1) + 1 :sum(test_num(1:2)) 
%         tmp = squeeze(data{j}(:,1,2:64));
%         Post_pro = net_2(tmp); %  输出观测值在每个状态的的预测概率,Q*n,即后验概率Pr(S|O),状态矩阵序列
%         % 将后验概率转换为似然度Pr(O|S)
%         Pre_pro = repmat(percent_2,[1,size(Post_pro,2)]);% 将P(S)平铺开来，有利于后续处理
%         Gen_lik = Post_pro ./ Pre_pro;% 计算似然度Q*N,即生成概率
%         p = Calcu_Pro(pi_2, trans_2, trans_tree_2, Gen_lik);% 计算DNN-HMT输出的概率, 输出的概率为一个向量，取概率最大的位置，便是该数据的预测类别
%         [~, predict] = max(p);
%         Confu_matrix(label(j),predict) = Confu_matrix(label(j),predict) +1;
%     end

end