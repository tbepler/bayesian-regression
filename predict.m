function Yh = predict( W, x )
%PREDICT Summary of this function goes here
%   Detailed explanation goes here
    if size( W, 1 ) == size( x , 2 ) + 1
        Yh = x * W(2:end) + W(1);
    else
        Yh = x * W;
    end

end

