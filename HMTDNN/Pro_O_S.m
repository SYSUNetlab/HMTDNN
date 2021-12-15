    function [logPros,Pros] = Pro_O_S(pi, trans, trans_tree, logp_on_given_sn, ss)
    % PRO_O_S Generate the joint probability Pr[O,S]
    % Inputs:
    % pi,trans, trans_tree, logp_on_given_sn: the parameter of HMT
    % ss:state tree
    % output£º
    % Pros = Pr[O,S|lamda] = Pr[S1]Pr[O1|S1]Pr[O2:T,S2:T|S1] = ...
    ss_len = size(ss,2);
    tmp=log(pi(ss(1)));
    for i=2:ss_len
        if judge_Power(i,2)==1 % the leftmost node
            tmp = tmp + logp_on_given_sn(i,ss(i)) + log(trans(ss(i/2),ss(i)));
        else
            if mod(i,2)==0 
                tmp = tmp + logp_on_given_sn(i,ss(i)) + log(trans_tree(ss(i-1),ss(i/2),ss(i)));
            else
                tmp = tmp + logp_on_given_sn(i,ss(i)) + log(trans_tree(ss(i-1),ss((i-1)/2),ss(i)));
            end
        end
    end
    logPros = tmp;
    Pros = exp(tmp);
                
            
     
 
    