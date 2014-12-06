function [Model, lambda, xvalerr, lambdas] = ridgeRegressionKernel( X, Y, lambdas, kernel, K, centered, kfold )
%RIDGEREGRESSION Tries to find weights W, W0 such that X*W + W0 = Y
%   Detailed explanation goes here

    if nargin < 7
        kfold = 5;
    end
    
    if nargin < 6
        centered = false;
    end
    
    if nargin < 4
        kernel = @linearKernel;
    end
    
    if nargin < 3 || isempty( lambdas )
        lambdas = 10.^(-4:5);
    end
            
    N = size( X, 1 );
    if nargin < 5 || size( K, 1 ) ~= N || size( K, 2 ) ~= N
        %compute kernel matrix
        fprintf( 'Computing kernel...\n' );
        K = kernel( X );
        fprintf( 'Kernel computed.\n' );
    end

    if ~centered
        Kc = center ( K );
        Yc = center( Y );
    else
        Kc = K;
        Yc = Y;
    end

    
    if length( lambdas ) > 1
        %perform cross validation on lambdas
        train = @( x, y, l, k ) ridgeRegressionKernel( x, y, l, kernel, k, true );
        [ lambda, xvalerr ] = crossValidateKernel( X, Yc, Kc, kfold, lambdas, train, @predictKernel, @mse );
    else
        lambda = lambdas;
        xvalerr = [];
    end
    
    Kc(1:N+1:end) = Kc(1:N+1:end) + lambda;
    A = Kc \ Yc ;
    
    keep = A ~= 0;
    X = X( keep, : );
    A = A( keep );
    
    bias = 0;
    if ~centered
        %bias = mean( Y ) - kernel( mean( X, 1 ), X ) * A;
        bias = mean( Y ) - mean( K, 1) * A;
        %bias = mean( Y );
    end
    
    Model.alpha = A;
    Model.bias = bias;
    Model.svs = X;
    Model.kernel = kernel;

end

