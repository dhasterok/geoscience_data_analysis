function [varargout] = tcmodel(m,x)

dm = forward(m,x);
varargout{1} = dm;

if nargout == 2
    F = frechet(m,x);
    varargout{2} = F;
end

return


function dm = forward(m,x)

dm = (m(1) + m(2)*x(:,1) + m(3)*x(:,1).^2).*(298./x(:,2)).^m(4);

return


function F = frechet(m,x)

F = [(298./x(:,2)).^m(4) ...
    x(:,1).*(298./x(:,2)).^m(4) ...
    x(:,1).^2.*(298./x(:,2)).^m(4) ...
    (m(1) + m(2)*x(:,1) + m(3)*x(:,1).^2).*(298./x(:,2)).^m(4).*log(298./x(:,2))];

return
