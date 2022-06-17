function [dm,varargout] = variogram_wave(m,h)

% forward model
dm = m(1) + (m(2) - m(1))*( 1 - sin(h/m(3))./(h/m(3)) );

% frechet matrix for newton inversion
if nargout == 2
    F = [ones(size(h)) - ( 1 - m(3)*sin(h/m(3))./h ), ...
        1 - m(3)*sin(h/m(3))./h, ...
        (m(2) - m(1))*(cos(h/m(3))/m(3) - sin(h/m(3))./h) ];
    varargout{1} = F;
end

return