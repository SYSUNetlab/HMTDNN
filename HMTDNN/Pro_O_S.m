function [logPros,Pros] = Pro_O_S(pi, trans, trans_tree, logp_on_given_sn, ss)

    % input:
    % pi,trans, trans_tree, logp_on_given_sn均为模型的参数
    % ss_len:序列的长度
    % ss:生成的序列
    % output：
    % Pros = Pr[O,S|lamda] = Pr[S1]Pr[O1|S1]Pr[O2:T,S2:T|S1] = ...
    ss_len = size(ss,2);
    tmp=log(pi(ss(1)));
    for i=2:ss_len
        if judge_Power(i,2)==1 % 该结点为最左侧节点
            tmp = tmp + logp_on_given_sn(i,ss(i)) + log(trans(ss(i/2),ss(i)));
        else
            if mod(i,2)==0 % L(k)与k具有不同的父节点，L(k)为k的左侧节点
                tmp = tmp + logp_on_given_sn(i,ss(i)) + log(trans_tree(ss(i-1),ss(i/2),ss(i)));
            else
                tmp = tmp + logp_on_given_sn(i,ss(i)) + log(trans_tree(ss(i-1),ss((i-1)/2),ss(i)));
            end
        end
    end
    logPros = tmp;
    Pros = exp(tmp);
                
            
     
 
    