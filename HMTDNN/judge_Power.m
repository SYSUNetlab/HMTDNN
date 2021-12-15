function [Bin,i] = judge_Power(value, base)

% Function Judge if a number if the power of base
i=0;

while(value~=0)
   if mod(value,base)~=0 && value ~= 1
       Bin = 0;
       break;
   elseif mod(value,base)==0
       value = value/base;
       i=i+1;
   end
   if value==1
       Bin = 1;
       break;
   end
end

