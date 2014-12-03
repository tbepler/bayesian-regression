function [Yh,Sm] = bayesPredict(x,M,S,beta)
x = [ones(size(x,1),1),x];
Yh = x * M;
if nargout > 1
    Sm = 1/beta + dot( x * S , x , 2 );
end
%Sm = diag( 1/beta + x * sN * x' );


end