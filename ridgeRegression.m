function [W, lambda, xvalerr, lambdas] = ridgeRegression( X, Y, lambdas, centered, kfold )
%RIDGEREGRESSION Tries to find weights W, W0 such that X*W + W0 = Y
%   Detailed explanation goes here

    if nargin < 5
        kfold = 5;
    end
    
    if nargin < 4
        centered = false;
    end
    
    if nargin < 3 || isempty( lambdas )
        lambdas = 10.^(-4:5);
    end
    
    if ~centered
        Xc = center( X );
        Yc = center( Y );
    else
        Xc = X;
        Yc = Y;
    end
    
    if length( lambdas ) > 1
        %perform cross validation on lambdas
        train = @( x, y, l ) ridgeRegression( x, y, l, true );
        [ lambda, xvalerr ] = crossValidate( Xc, Yc, kfold, lambdas, train, @predict, @mse );
    else
        lambda = lambdas;
    end
    
    D = size( Xc, 2 );
    W = ( Xc' * Xc + lambda * eye(D) ) \ Xc' * Yc ;
    
    if ~centered
        W0 = mean( Y ) - mean( X, 1 ) * W;
        W = [ W0 ; W ];
    end

end

