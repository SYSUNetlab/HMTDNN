function similarity = ss0_ss1_Compare( seq_old, seq_new )
% SS0_SS1_COMPARE Calculate the similarity of state trees
    sim_cnt = 0; 
    col = size(seq_old, 2); 
    for i = 1:size(seq_old, 1)
        flag = 1;
        for j = 1:col
            if seq_old(i, j) ~= seq_new(i, j)
                flag = 0; 
                break
            end
        end
        if flag == 1
            sim_cnt = sim_cnt + 1;
        end
    end
    similarity = sim_cnt / size(seq_old, 1);
end
