function [ pi, trans, trans_tree, State_samples, State_path_samples ] = initialPIandA0203( data, Q, scale)
% INITIALPIANDA0203 Initialize the parameters of HMT, i.e., pi, tran, trans
%
% Inputs:
% data: State set
% Q: the number of states
%
% Outputs：
% pi, trans, trans_tree: the parameters of HMT
% 
% ============================================
    State_tree = {};
    State_samples = {};
    State_path = [];
    State_path_samples = {};
    
    for i=1:size(data,1)
        for j=1:scale
            if j==1
                State_tree{1} = data(i,1);
            else
                for h=1:2^(j-1)
                    State_tree{j}(1,h) = data(i,2^(j-1)+h-1);
                end
            end
        end
        State_samples{i} = State_tree;
        State_tree = {};
    end

    
    
    
    pi = zeros(1, Q);
    trans = zeros(Q, Q);
    trans_tree = zeros(Q,Q,Q);
    
    for i=1:length(State_samples)
        pi(1,State_samples{i}{1,1}) = pi(1,State_samples{i}{1,1}) + 1;
        for j=1:scale
            for h=1:2^(j-1)
                if judge_Power(h+2^(j-1)-1,2)~=1 && j~=1 % root
                    if mod(h+2^(j-1),2)==0 
                        p_index = (h+2^(j-1))/2 - 2^(j-2);
                        trans_tree(State_samples{i}{j}(1,h-1), State_samples{i}{j-1}(1,p_index), State_samples{i}{j}(1,h)) = ... % a(mnq)
                        trans_tree(State_samples{i}{j}(1,h-1), State_samples{i}{j-1}(1,p_index), State_samples{i}{j}(1,h)) + 1;
                    else
                        p_index = (h+2^(j-1)+1)/2 - 2^(j-2);
                        trans_tree(State_samples{i}{j}(1,h-1), State_samples{i}{j-1}(1,p_index), State_samples{i}{j}(1,h)) = ...
                        trans_tree(State_samples{i}{j}(1,h-1), State_samples{i}{j-1}(1,p_index), State_samples{i}{j}(1,h)) + 1;
                    end
                else
                    if j~=scale
                        trans(State_samples{i}{j}(1,h),State_samples{i}{j+1}(1,1)) = ... 
                        trans(State_samples{i}{j}(1,h),State_samples{i}{j+1}(1,1)) + 1;
                    end
                end
            end
        end 
    end
    for i=1:length(State_samples)
        for j=1:size(State_samples{i},2)
            State_path(j) = State_samples{i}{j}(1,1);
        end
        State_path_samples{i} = State_path; 
        State_path = [];
    end
    % pi
    piSum = sum(pi);
    pi = pi ./ piSum;
    % a(mn)
    transSum = sum(trans, 2);
    for i = 1:length(transSum)
        trans(i, :) = trans(i, :) ./ transSum(i);
    end
    
    
    % a(mnq)
    trans_treeSum = sum(trans_tree,3);
    for j=1:size(trans_tree,2)
        trans_tree(:,:,j) = trans_tree(:,:,j) ./ trans_treeSum;
    end

    [~,col_p] = find(pi==0);
    if length(col_p)~=0
        for k=1:length(col_p)
            pi(col_p(k)) = 0.0001;
        end
    end
    
    trans(isnan(trans)) = 0;
    trans_tree(isnan(trans_tree)) = 0;
    
    [row, col] = find(trans==0);
    if length(row)~=0
        for i=1:length(row)
            trans(row(i),col(i)) = 0.0001;
        end
    end
    trans(isnan(trans)) = 0;
    [row_tree,col_tree,high_tree] = ind2sub([Q,Q,Q],find(trans_tree==0));
    if length(row_tree)~=0
        for j=1:length(row_tree)
            trans_tree(row_tree(j),col_tree(j),high_tree(j)) = 0.0001;
        end
    end
end

