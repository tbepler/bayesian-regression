function [beta, centered] = empiricalBeta( X, Y, plotHist )

    if nargin < 3
        plotHist = false;
    end
    
%     [S,iS] = sortrows( X );
%     markers = [0; find(sum(diff(S),2)); size( X, 1 ) ];
%     
%     I = cell( numel( markers ) - 1 , 1 );
%     for i = 1:numel(markers)-1
%         I{i} = iS(markers(i)+1:markers(i+1));
%         I{i}
%     end
    
    map = containers.Map();
    
    for i = 1:size( X, 1 );
        k = hash( X(i,:) );
        if isKey( map, k )
            v = map(k);
            v = [ v i ];
            map(k) = v;
        else
            map(k) = i;
        end
    end
    
    function h = hash( row )
        h = sprintf( '%d', row );
    end

    I = values( map );

    centered = Y;
    
    for i = 1:length( I )
        idx = I{i};
        ys = Y( idx );
        centered( idx ) = ys - mean( ys );
    end
    
%     [ U, ix, iu ] = unique( X, 'rows' );
%     centered = Y;
%     for i = 1:size( U, 1 )
%         ys = Y( iu == i );
%         centered( iu == i ) = ys - mean( ys );
%     end

    if ~kstest(centered)
        disp( 'Warning: Y|X does not appear to be normally distributed' );
    end

    if plotHist
        hist( centered );
    end

    beta = 1 / var( centered );


end
