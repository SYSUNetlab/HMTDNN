    function trans = Static_state(ss, Q)

    % ��������ͳ�Ƽ��ʱ������е�״̬ת�ƾ���
    % input:
    % ss: ����״̬����
    % Q ��״̬����Ŀ

    % output��
    % trans��trans_tree��״̬ת�ƾ���
    
    trans = zeros(Q,Q);
    for i=2:size(ss,2)
        trans(ss(i-1),ss(i)) = trans(ss(i-1),ss(i)) + 1;
    end
        

