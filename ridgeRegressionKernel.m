function [A, lambda, xvalerr, lambdas] = ridgeRegressionKernel( X, Y, lambdas, K, kernel, centered, kfold )
%RIDGEREGRESSION Tries to find weights W, W0 such that X*W + W0 = Y
%   Detailed explanation goes here

    if nargin < 7
        kfold = 5;
    end
    
    if nargin < 6
        centered = false;
    end
    
    if nargin < 5
        kernel = @linearKernel;
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
        
    N = size( X, 1 );
    if nargin < 4 || size( K, 1 ) ~= N || size( K, 2 ) ~= N
        %compute kernel matrix
        K = kernel( Xc, Xc );
    end
    
    if length( lambdas ) > 1
        %perform cross validation on lambdas
        train = @( x, y, l, k ) ridgeRegressionKernel( x, y, l, k, kernel, true );
        [ lambda, xvalerr ] = crossValidateKernel( Xc, Yc, K, kfold, lambdas, train, @predictKernel, @mse );
    else
        lambda = lambdas;
        xvalerr = [];
    end
    
    A = ( K + lambda * eye(N) ) \ Yc ;
    
    if ~centered
        A0 = mean( Y ) - kernel( mean( X, 1 ), X ) * A;
        A = [ A0 ; A ];
    end

end

