function Yh = predictKernel( A, K, x, X, kernel )
%PREDICT Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 5
        kernel = @linearKernel;
    end
    
    if isempty(K)
        K = kernel( x, X );
    end
    
    if size( A, 1 ) == size( K , 2 ) + 1
        Yh = K * A(2:end) + A(1);
    else
        Yh = K * A;
    end

end

