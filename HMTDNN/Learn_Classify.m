% ѧϰһ�����з����������
function [net0,tr] = Learn_Classify(X_test, label) 


 % ����DNN����ѵ����
    layers = [50 50 50 50 50];
    Net = patternnet(layers);
%    Net.trainParam.epochs = 50; % �����������Ĵ���
    Net.trainParam.lr = 0.005; % ����ѧϰ����
    
    label_extend = full(sparse(label',1:length(label'),1, 7, length(label')));
    [net0, tr] = train(Net,X_test',label_extend);
    net0.trainParam.showWindow = true;% ����ѵ��ʱ�����細��
    net0.trainParam.showCommandLine = true; % ����ѵ��ʱ�����細��
 
    

    
%     for j = test_num(1) + 1 :sum(test_num(1:2)) 
%         tmp = squeeze(data{j}(:,1,2:64));
%         Post_pro = net_2(tmp); %  ����۲�ֵ��ÿ��״̬�ĵ�Ԥ�����,Q*n,���������Pr(S|O),״̬��������
%         % ���������ת��Ϊ��Ȼ��Pr(O|S)
%         Pre_pro = repmat(percent_2,[1,size(Post_pro,2)]);% ��P(S)ƽ�̿����������ں�������
%         Gen_lik = Post_pro ./ Pre_pro;% ������Ȼ��Q*N,�����ɸ���
%         p = Calcu_Pro(pi_2, trans_2, trans_tree_2, Gen_lik);% ����DNN-HMT����ĸ���, ����ĸ���Ϊһ��������ȡ��������λ�ã����Ǹ����ݵ�Ԥ�����
%         [~, predict] = max(p);
%         Confu_matrix(label(j),predict) = Confu_matrix(label(j),predict) +1;
%     end

end