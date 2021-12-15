function [pi,trans,trans_tree,train_samples, train_State, train_labels, test_samples,test_State, test_labels,test_num, percent, logLik_list,loglik_matrix, ss_1, x_train, y_train] = F_W_DR_DH_shareState0120(pi0,A0,A0_tree,State, T_2, T_2_test, Label,Label_test, net, Q, scale, iteration)
% F_W_DR_DH_SHARESTATE0120 Update the parameters of HMT
% [pi,trans,trans_tree,train_samples, train_State, train_labels, test_samples,test_State, test_labels,test_num, percent, logLik_list,loglik_matrix, ss_1, x_train, y_train] = F_W_DR_DH_shareState0120(pi0,A0,A0_tree,State, T_2, T_2_test, Label,Label_test, net, Q, scale, iteration)
%
% Inputs:
% pi0, A0, A0_tree: the parameters of HMT in epoch(iteration-1)
% State: state trees of all samples
% T_2, T_2_test: training samples and testing samples
% net:nerual network in epoch(iteration-1)
% Q: the number of states
% scale: the maximum scale of the wavelet transform
% iteration: the number of iterations
%
% Output:
% pi, trans, trans_tree:the parameters of HMT in epoch(iteration)
% State: state trees of all samples after updating
% percent:the proportion of each state in state trees
% logLik_list:the likelihood of iterations
% x_train: o_r
% y_train: S_r


train_samples = {};
train_State = [];
train_labels = [];
test_samples = {};
test_State = [];
test_labels = [];
test_num = size(Label_test);
rng('default');
rng('shuffle');

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
Train_State=reshape(Y_train0',size(train_State,1),size(train_State,2));
Train_State=train_State;

table = tabulate(Y_train0); 
percent = table(:,3)./100; 
if size(percent,1) < size(A0,1)
    for i=size(percent,1)+1:size(A0,1)
        percent(i)=0;
    end
end


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
    [pi_update, trans_update, trans_tree_update, Percent_update, logLik_list,loglik_matrix, ~, ss_1,x_train, y_train] = ...
    DNN_HMT_shareState0118(train_samples, Train_State(:,:), percent_update, pi0_update, A0_update, A0_tree_update, net, scale, iteration, s);

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
    [pi, trans, trans_tree, percent, logLik_list,loglik_matrix, ~, ss_1,x_train, y_train] = ...
    DNN_HMT_shareState0118(train_samples, Train_State(:,:), percent, pi0, A0, A0_tree, net, scale, iteration,s);
end

% show the proportion of each state in state trees
table = tabulate(y_train); 
percent = table(:,3)./100; 
if size(percent,1) < size(A0,1)
    for i=size(percent,1)+1:size(A0,1)
        percent(i)=0;
    end
end
StateProinData(y_train);


