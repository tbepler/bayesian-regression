function Yh = predictKernel( x, A, bias, X, kernel, K )
%PREDICT Summary of this function goes here
%   Detailed explanation goes here

    if nargin < 4
        kernel = @linearKernel;
    end
    
    if isstruct( A )
        kernel = A.kernel;
        X = A.svs;
        bias = A.bias;
        A = A.alpha;
    end
    
    if nargin < 5 || isempty(K)
        K = kernel( x, X );
    end
    
    Yh = K * A + bias;

end

