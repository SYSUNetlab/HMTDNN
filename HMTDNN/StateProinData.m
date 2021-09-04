function StateProinData( data )
% 展示数据集中状态的比例
    display(sprintf('****************************'));
    display(sprintf('数据集中状态的比例：'));
    tabulate(data)
    display(sprintf('****************************'));
end