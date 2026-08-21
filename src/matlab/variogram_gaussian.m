function [dm,varargout] = variogram_gaussian(m,h)

% forward model
dm = m(1) + (m(2) - m(1))*( 1 - exp(-(h/m(3)).^2) );

% frechet matrix for newton inversion
if nargout == 2
    F = [ones(size(h)) - ( 1 - exp(-(h/m(3)).^2) ), ...
        1 - exp(-(h/m(3)).^2), ...
        -(m(2) - m(1))*2*h.^2.*exp(-(h/m(3)).^2)/m(3)^3 ];
    varargout{1} = F;
end

return