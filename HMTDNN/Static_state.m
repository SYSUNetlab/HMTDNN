    function trans = Static_state(ss, Q)
    % STATIC_STATE calculate the state transition matrix by analyzing the state tree set
    % input:
    % ss: state tree
    % Q: number of states

    % output:
    % trans, trans_tree: state transition matrix
    
    trans = zeros(Q,Q);
    for i=2:size(ss,2)
        trans(ss(i-1),ss(i)) = trans(ss(i-1),ss(i)) + 1;
    end
        

