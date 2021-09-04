function [Confu_matrix, accuracy, P, R, pro_pre, label_pre] = Test_classify(X_test, label, net0, Class_number)
                                                                                      

        
    probit=net0(X_test');   %输出观测值在每个状态的的预测概率,Q*T
    [pro_pre,label_pre] = max(probit,[],1);
    index_t = find(label ==label_pre');
    accuracy =  length(index_t)/length(label'); % 计算预测精度
    Confu_matrix = confusionmat(label',label_pre);
    
    for i= 1:Class_number
        TP(i) = Confu_matrix(i,i);
        FN(i) = sum(Confu_matrix(i,:)) - Confu_matrix(i,i);
        FP(i) = sum(Confu_matrix(:,i)) - Confu_matrix(i,i);
        TN(i) = sum(sum(Confu_matrix)) - TP(i) - FN(i) - FP(i);
    end
    
    P = TP ./ (TP + FP);
    R = TP ./ (TP + FN);
end
    
    