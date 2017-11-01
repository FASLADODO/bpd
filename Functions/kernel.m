function D = kernel(X,Y)
    D = zeros(size(X,1),size(Y,1));
    for i=1:size(Y,1)
        d = bsxfun(@minus, X, Y(i,:));
        s = bsxfun(@plus, X, Y(i,:));
        D(:,i) = sum(d.^2 ./ (s/2+eps), 2);
    end
    D = exp(-D);
end
% 
% function G = kernel(x,y)
%   G = 1 - sum((x - y).^2 ./ (x + y) / 2);
% end