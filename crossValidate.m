function [ P, xvalerr ] = crossValidate( X, Y, kfold, parameters, train, predict, error )
%CROSSVALIDATE Performs k-fold cross validation using the given training,
%prediction, and error methods
%   Detailed explanation goes here

    xvalerr = zeros( length( parameters ) , 1 );
    indices = crossvalind( 'Kfold', size( X, 1 ), kfold );
    for i = 1 : length( parameters )
        p = parameters( i );
        err = zeros( kfold, 1 );
        for k = 1 : kfold
            testI = ( indices == k );
            trainI = ~testI;
            W = train( X(trainI,:), Y(trainI), p );
            Yh = predict( X(testI,:), W );
            err(k) = error( Y(testI), Yh );
        end
        xvalerr(i) = sum( err ) / kfold;
    end
    [~,i] = min( xvalerr );
    P = parameters( i );
    

end

