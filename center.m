function C = center(X)
colsum = sum(X,1)./size(X,1);
C = X - repmat(colsum,size(X,1),1);
