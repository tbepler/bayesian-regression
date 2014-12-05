function s = posKmerScore( strA, strB )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

N = min( length( strA ), length( strB ) );
mtch = bsxfun( @eq, strA(1:N), strB(1:N) );
for i = 2:N
    if mtch(i) ~= 0
        mtch(i) = mtch(i) + mtch(i-1);
    end
end
s = sum( mtch );


end

