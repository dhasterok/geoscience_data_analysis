function [dm,varargout] = variogram_spherical(m,h)

% forward model
ind = h < m(3);
dm = zeros(size(h));
% h < range
dm(ind) = m(1) + (m(2) - m(1))*( 3*h(ind)/(2*m(3)) - h(ind).^3/(2*m(3)^3) );
% h > range
dm(~ind) = m(2);

% frechet matrix for newton inversion
if nargout == 2
    F = zeros([length(h) 3]);
    % h < range
    F(ind,:) = [ones([sum(ind) 1]) - ( 3*h(ind)/(2*m(3)) - h(ind).^3/(2*m(3)^3) ), ...
        3*h(ind)/(2*m(3)) - h(ind).^3/(2*m(3)^3), ...
        (m(2) -  m(1))*( 3*(h(ind).^3 - h(ind)*m(3)^2)/(2*m(3)^4) )];
    % h > range
    F(~ind,:) = [m(1)*ones([sum(~ind) 1]) m(1)*ones([sum(~ind) 1]) zeros([sum(~ind) 1])];
    varargout{1} = F;
end

return