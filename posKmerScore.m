function s = posKmerScore( strA, strB )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

mtch = strA == strB;
for i = 2:length(strA)
    if mtch(i) ~= 0
        mtch(i) = mtch(i) + mtch(i-1);
    end
end
s = sum( mtch );


end

