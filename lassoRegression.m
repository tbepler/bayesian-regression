function [W, lambda, xvalerr, lambdas] = lassoRegression( X, Y, lambdas, centered, kfold)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 5
    kfold = Defaults.KFOLD;
end

if nargin < 4
    centered = false;
end

if nargin < 3 || isempty( lambdas )
    lambdas = Defaults.LAMBDAS;
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
    train = @( x, y, l ) lassoRegression( x, y, l, true );
    [ lambda, xvalerr ] = crossValidate( Xc, Yc, kfold, lambdas, train, @predict, @mse );
else
    lambda = lambdas;
end

D = size( Xc, 2 );

Winit = zeros( D, 1 );

opts = optimoptions( 'fminunc', 'Algorithm', 'quasi-newton', 'Display', 'none' );
W = fminunc( @lassoObjective, Winit, opts );

if ~centered
    W0 = mean( Y ) - mean( X, 1 ) * W;
    W = [ W0 ; W ];
end     

    function v = lassoObjective( W )
        v = gather( sum( ( Xc*W - Yc ) .^ 2 ) + lambda * sum( abs( W ) ) );
    end

end

