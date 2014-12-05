function K = posKmerKernel( X, Xp )

if ischar( X )
    X = { X };
end

if nargin < 2 %special case, compute K(X,X)
    
    N = length( X );
    K = zeros( N, N );
    for i = 1:N
        strA = X{i};
        for j = i:N
            if i == j %entry with itself has known score
                L = length( strA );
                K( i, j ) = ( L^2 + L ) / 2;
            else
                s = posKmerScore( strA, X{j} );
                K( i, j ) = s;
                K( j, i ) = s;
            end
        end
    end
    
else %normal case
    
    if ischar( Xp )
        Xp = { Xp };
    end
    
    N = length( X );
    M = length( Xp );
    K = zeros( N, M );
    
    for i = 1:N
        for j = 1:M
            K(i,j) = posKmerScore( X{i}, Xp{j} );
        end
    end
end



end