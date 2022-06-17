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
%dm = x(:,1).*(298./x(:,2)).^m(1);
%dm = m(1)*(298./x).^m(2);
%dm = m(1)*(298./x).^m(2) + m(3)*x.^3 + m(4)*x.^2 + m(5)*x + m(6);

return


function F = frechet(m,x)

F = [(298./x(:,2)).^m(4) ...
    x(:,1).*(298./x(:,2)).^m(4) ...
    x(:,1).^2.*(298./x(:,2)).^m(4) ...
    (m(1) + m(2)*x(:,1) + m(3)*x(:,1).^2).*(298./x(:,2)).^m(4).*log(298./x(:,2))];
%F = [x(:,1).*(298./x(:,2)).^m(1).*log(298./x(:,2))];
%F = [(298./x).^m(2) m(1)*(298./x).^m(2).*log(298./x)];
%F = [(298./x).^m(2) m(1)*(298./x).^m(2).*log(298./x) x.^3 x.^2 x ones(size(x))];

return
