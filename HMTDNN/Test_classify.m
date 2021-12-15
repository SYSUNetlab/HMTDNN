    function [Confu_matrix, accuracy, P, R, pro_pre, label_pre] = Test_classify(X_test, label, net0, Class_number) 
    % TEST_CLASSIFY Ouputs the result of testing.
    probit=net0(X_test');  
    [pro_pre,label_pre] = max(probit,[],1);
    index_t = find(label ==label_pre');
    accuracy =  length(index_t)/length(label'); 
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
    
