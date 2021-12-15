function [net0,tr] = Learn_Classify(X_test, label) 
% Learn_Classify Train a classifier
    layers = [50 50 50 50 50];
    Net = patternnet(layers);
    Net.trainParam.lr = 0.005; 
    
    label_extend = full(sparse(label',1:length(label'),1, 7, length(label')));
    [net0, tr] = train(Net,X_test',label_extend);
    net0.trainParam.showWindow = true;
    net0.trainParam.showCommandLine = true; 
end