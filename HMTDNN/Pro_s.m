function Ps = Pro_s(series, tree)

%%%  �������ڼ���P(s|lanbuda)�������ڼ��������õ�������������ѵ����������ʱ�������е����
% input��
% series: ѵ������ʱ����������
% tree:��������õ�������

% output:
% Ps:���ڱ�ʾseries��treeƥ��̶ȵ�ָ�ꡣ\
    num = 0;
    for i=1:size(series,2)
        if series(i) == tree(i)
            num = num + 1;
        else
            continue;
        end
    end
    Ps = num / size(series,2);
    
    
    tabel_1 = tabulate(series');
    tabel_2 = tabulate(tree');