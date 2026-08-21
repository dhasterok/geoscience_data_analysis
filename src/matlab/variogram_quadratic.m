function [dm,varargout] = variogram_quadratic(m,h)

% forward model
dm = m(1) + (m(2) - m(1))*( h.^2./(m(3)^2 + h.^2) );

% frechet matrix for newton inversion
if nargout == 2
    F = [ones(size(h)) - ( h.^2./(m(3)^2 + h.^2) ), ...
        h.^2./(m(3)^2 + h.^2), ...
        (m(2) - m(1))*( -2*m(3)*h.^2./(m(3)^2 + h.^2).^2 ) ];
    varargout{1} = F;
end

return