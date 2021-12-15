function StateProinData( data )
% show the proportion of each state
    display(sprintf('****************************'));
    display(sprintf('The proportion of states'));
    tabulate(data)
    display(sprintf('****************************'));
end
