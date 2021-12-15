clear all;
close all;
clc;

load Data
hidden_layers = [20 20 20 20]; % structure of DNN
Q = 20; % number of states
iteration = 20; 
dim = 5;
scale = 4;

confu = [];
acc = [];
p = [];
label_p = [];
label_t = [];
time_inter = [];
for epoch=1:1
    % DNN-HMT traning
    [t1, net, pi_1,trans_1,trans_tree_1, train_samples_1, train_State_1, train_labels_1,test_samples_1,test_State_1, test_labels_1, percent_1, loglik_list_1,loglik_matrix1, ss1,...
       pi_2,trans_2,trans_tree_2, train_samples_2, train_State_2, train_labels_2,test_samples_2,test_State_2, test_labels_2, percent_2, loglik_list_2,loglik_matrix2, ss2,...
       pi_3,trans_3,trans_tree_3, train_samples_3, train_State_3, train_labels_3,test_samples_3,test_State_3, test_labels_3, percent_3, loglik_list_3,loglik_matrix3, ss3,...
       pi_4,trans_4,trans_tree_4, train_samples_4, train_State_4, train_labels_4,test_samples_4,test_State_4, test_labels_4, percent_4, loglik_list_4,loglik_matrix4, ss4,...
       pi_5,trans_5,trans_tree_5, train_samples_5, train_State_5, train_labels_5,test_samples_5,test_State_5, test_labels_5,percent_5, loglik_list_5,loglik_matrix5, ss5,...
       pi_6,trans_6,trans_tree_6, train_samples_6, train_State_6, train_labels_6,test_samples_6,test_State_6, test_labels_6, percent_6, loglik_list_6,loglik_matrix6, ss6,...
       pi_7,trans_7,trans_tree_7, train_samples_7, train_State_7, train_labels_7,test_samples_7,test_State_7, test_labels_7, percent_7, loglik_list_7,loglik_matrix7, ss7...
       ] = train_DNNHMT(State_space, Q, scale, hidden_layers, x_train, y_train, iteration, train_samples, test_samples, train_lable, test_lable);
   
   % testing
    learn_samples = [train_samples_1, train_samples_2, train_samples_3, train_samples_4, train_samples_5, train_samples_6, train_samples_7];
    learn_state = [train_State_1(:,:); train_State_2(:,:); train_State_3(:,:); train_State_4(:,:); train_State_5(:,:); train_State_6(:,:); train_State_7(:,:)];
    learn_labels = [train_labels_1, train_labels_2, train_labels_3, train_labels_4, train_labels_5, train_labels_6, train_labels_7]';

    learn_num = [size(train_labels_1,2), size(train_labels_2,2), size(train_labels_3,2), size(train_labels_4,2), size(train_labels_5,2), size(train_labels_6,2), size(train_labels_7,2)];
    [x_learn, learn_tree] = Gen_dnnInput4(learn_samples(:), net, percent_1, pi_1, trans_1, trans_tree_1,...
                                                             net,percent_2, pi_2, trans_2, trans_tree_2,...
                                                             net,percent_3, pi_3, trans_3, trans_tree_3,...
                                                             net,percent_4, pi_4, trans_4, trans_tree_4,...
                                                             net,percent_5, pi_5, trans_5, trans_tree_5,...
                                                             net,percent_6, pi_6, trans_6, trans_tree_6,...
                                                             net,percent_7, pi_7, trans_7, trans_tree_7,...
                                                             learn_num);

    [Net, tr1] = Learn_Classify(x_learn, learn_labels);
    test_samples = [test_samples_1, test_samples_2, test_samples_3, test_samples_4, test_samples_5, test_samples_6, test_samples_7];
    test_state = [];
    test_labels = [test_labels_1, test_labels_2, test_labels_3, test_labels_4, test_labels_5, test_labels_6, test_labels_7]';

    Test_num = [size(test_labels_1,2), size(test_labels_2,2), size(test_labels_3,2), size(test_labels_4,2), size(test_labels_5,2), size(test_labels_6,2), size(test_labels_7,2)];
    Class_number = numel(unique(test_labels));



     [x_test, test_tree] = Gen_dnnInput4(test_samples(:), net, percent_1, pi_1, trans_1, trans_tree_1,...
                                                          net,percent_2, pi_2, trans_2, trans_tree_2,...
                                                          net,percent_3, pi_3, trans_3, trans_tree_3,...
                                                          net,percent_4, pi_4, trans_4, trans_tree_4,...
                                                          net,percent_5, pi_5, trans_5, trans_tree_5,...
                                                          net,percent_6, pi_6, trans_6, trans_tree_6,...
                                                          net,percent_7, pi_7, trans_7, trans_tree_7,...
                                                          Test_num);                                                                                           

      [Confu_matrix, accuracy, P, R, pro_pre, label_pre] = Test_classify(x_test, test_labels, Net, Class_number);
      t2 = clock;
      time_inter = [time_inter;etime(t2,t1)];
      confu = [confu; Confu_matrix];
      acc = [acc; accuracy];
end                                     
Confu_matrix
accuracy
