function similarity = ss0_ss1_Compare( seq_old, seq_new )
% �Ա�״̬���е����Ƴ̶�
% ���룺
% seq_old/newÿһ��Ϊһ��������״̬���У�����Ϊ����������
% seq_oldΪǰһ��ѵ����״̬����
% seq_newΪ��ǰѵ����״̬����
% ======================================
% �����
% �¾�״̬����һģһ�������� / ����������
    sim_cnt = 0; % ���ڼ�¼�¾�״̬����һģһ��������
    col = size(seq_old, 2); % ���г���
    for i = 1:size(seq_old, 1)
        flag = 1;
        for j = 1:col
            if seq_old(i, j) ~= seq_new(i, j)
                flag = 0; % �¾�״̬���в�һ��
                break
            end
        end
        if flag == 1
            sim_cnt = sim_cnt + 1;
        end
    end
    similarity = sim_cnt / size(seq_old, 1);
end

