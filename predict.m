function Yh = predict( W, x )
%PREDICT Summary of this function goes here
%   Detailed explanation goes here
    if size( W, 1 ) == size( x , 2 ) + 1
        x = [ ones( size( x, 1 ), 1 ), x ];
    end
    
    Yh = x * W;


end

