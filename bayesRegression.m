function [ M, S, b, xvalerr, a, alphagrid, betagrid ] = bayesRegression( X, Y, alpha, beta, kfold )

if nargin < 5
    kfold = 5;
end

if nargin < 4 || isempty(beta)
    beta = 1;
end

if nargin < 3 || isempty(alpha)
    alpha = beta * Defaults.LAMBDAS;
end

assert( kfold > 1 );

X = [ones(size(X,1),1),X];

xvalerr = [];

if numel( alpha ) + numel( beta ) > 2
    %perform cross validation
    [alphagrid, betagrid] = meshgrid( alpha, beta );
    xvalerr = zeros( size( alphagrid ) );
    indices = crossvalind( 'Kfold', size( X, 1 ), kfold );
    err = zeros( kfold , 1 );
    for i = 1 : numel( alphagrid )
        a = alphagrid(i);
        b = betagrid(i);
        for k = 1 : kfold
            test = ( indices == k );
            train = ~test;
            s = covariance( X(train,:), a, b );
            m = mean( X(train,:), Y(train), s, b);
            yh = bayesPredict( X(test,2:end), m, s, b );
            err(k) = mse( Y(test), yh );
            %err(k) = 1 - corr( Y(test), yh );
        end
        xvalerr(i) = sum( err ) / kfold;
    end
    [~,i] = min( xvalerr );
    a = alphagrid( i );
    b = betagrid( i );
else
    a = alpha;
    b = beta;
end

    function cov = covariance( Xp, a, b )
        D = size( Xp, 2 );
        cov = inv( a * eye( D ) + b * ( Xp' * Xp ) );
    end

    function m = mean( Xp, Yp, cov, b )
        m = b * cov * Xp' * Yp;
    end

%m0 = zeros(D,1);
S = covariance( X , a , b );
M = mean( X , Y , S , b );


end