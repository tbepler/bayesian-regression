function [ P, xvalerr ] = crossValidate( X, Y, kfold, parameters, train, predict, error)
%CROSSVALIDATE Performs k-fold cross validation using the given training,
%prediction, and error methods
%   Detailed explanation goes here

xvalerr = zeros( length( parameters ) , kfold );
indices = crossvalind( 'Kfold', size( X, 1 ), kfold );

for k = 1 : kfold
    testI = ( indices == k );
    trainI = ~testI;
    Xtrain = X(trainI, :);
    Ytrain = Y(trainI);
    Xtest = X(testI, :);
    Ytest = Y(testI);
    parfor i = 1 : length( parameters )
        p = parameters( i );
        W = train( Xtrain, Ytrain, p );
        Yh = predict( W, Xtest );
        xvalerr( i, k ) = gather( error( Ytest, Yh ) );
    end
end

xvalerr = sum( xvalerr, 2 ) ./ kfold;

% for i = 1 : length( parameters )
%     p = parameters( i );
%     err = zeros( kfold, 1 );
%     for k = 1 : kfold
%         testI = ( indices == k );
%         trainI = ~testI;
%         W = train( X(trainI,:), Y(trainI), p );
%         Yh = predict( W, X(testI,:) );
%         err(k) = gather( error( Y(testI), Yh ) );
%     end
%     xvalerr(i) = sum( err ) / kfold;
% end

[~,i] = min( xvalerr );
P = parameters( i );

end

