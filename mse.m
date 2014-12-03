function err = mse( X, Y )
    err = sum( ( X - Y ) .^ 2 ) / numel( X );
end
