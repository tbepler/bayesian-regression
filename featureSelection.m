function [ I, W, lambda, lambdas, err ] = featureSelection( X, Y, lambdas, kfold, centered )
%FEATURESELECTION Performs feature selection on the design matrix, X, and
%returns a logical vector, I, indicating the indices of the selected
%feature columns
%   Detailed explanation goes here

if nargin < 5
    centered = false;
end

if nargin < 4
    kfold = Defaults.KFOLD;
end

if nargin < 3 || isempty( lambdas )
    lambdas = Defaults.LAMBDAS;
end

% if ~centered
%     Xc = center( X );
%     Yc = center( Y );
% else
%     Xc = X;
%     Yc = Y;
% end

% if length( lambdas ) > 1
%     %perform cross validation
%     train = @( x, y, l ) lasso( x, y, 'Lambda', l, 'Standardize', false );
%     [ lambda, err ] = crossValidate( Xc, Yc, kfold, lambdas, train, @predict, @mse );
% else
%     lambda = lambdas;
% end

lassoParams = { 'CV', kfold, 'Lambda', lambdas, 'Standardize', ~centered ...
    };
    %, 'Options', statset( 'UseParallel', true ) };
[ W, fitinfo ] = lasso( gather(X), gather(Y), lassoParams{:} );
err = fitinfo.MSE;
[~,i] = min( err );
W = W( : , i );
lambda = fitinfo.Lambda( i );
if ~centered
    W0 = fitinfo.Intercept( i );
    W = [ W0 ; W ];
end

%[ W, lambda, err, lambdas ] = lassoRegression( X, Y, lambdas, centered, kfold );

if centered
    I = W ~= 0;
else
    I = W(2:end) ~= 0;
end

end

