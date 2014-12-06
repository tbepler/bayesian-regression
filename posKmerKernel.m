function K = posKmerKernel( X, Xp )

if nargin < 2
    Xp = X;
end

N = size( X, 1 );
M = size( Xp, 1 );
K = zeros( N, M );
[jgrid,igrid] = meshgrid( 1:M, 1:N );
mtch = X(igrid,:) == Xp(jgrid,:);
parfor k = 1:size(mtch,1)
    vec = double(mtch( k, : ));
    for i = 2 : length( vec )
        if vec(i) ~= 0
            vec(i) = vec(i) + vec(i - 1);
            %if vec(i) > 1
            %    vec(i) = 3;
            %end
        end
    end
    K(k) = sum( vec );
end

% if nargin < 2 %special case, compute K(X,X)
%     
%     N = size( X, 1 );
%     L = size( X, 2 );
%     K = zeros( N, N );
%     [igrid,jgrid] = meshgrid( 1:N, 1:N );
%     mtch = X(igrid,:) == X(jgrid,:);
%     parfor k = 1:size(mtch,1)
%         vec = mtch( k, : );
%         for i = 2 : length( vec )
%             if vec(i) ~= 0
%                 vec(i) = vec(i) + vec(i - 1);
%             end
%         end
%         K(k) = sum( vec );
%     end
%     
%     for i = 1:N
%         strA = X(i,:);
%         parfor j = i:N
%             if i == j %entry with itself has known score
%                 K( i, j ) = ( L^2 + L ) / 2;
%             else
%                 s = posKmerScore( strA, X(j,:) );
%                 K( i, j ) = s;
%             end
%         end
%     end
%     
%     for i = 1:N
%         for j = i+1:N
%             K( j, i ) = K( i, j );
%         end
%     end
%     
% else %normal case
%     
%     N = size( X, 1 );
%     M = size( Xp, 1 );
%     K = zeros( N, M );
%     
%     for i = 1:N
%         strA = X(i,:);
%         parfor j = 1:M
%             K(i,j) = posKmerScore( strA, Xp(j,:) );
%         end
%     end
% end



end