function [dm,varargout] = variogram_circular(m,h)

% forward model
ind = h < m(3);
dm = zeros(size(h));
% h < range
dm(ind) = m(1) + (m(2) - m(1))*( 1 - 2/pi*acos(h(ind)/m(3)) + ...
    2*h(ind).*sqrt(m(3)^2 - h(ind).^2)/(pi*m(3)^2) );
% h > range
dm(~ind) = m(2);

% frechet matrix for newton inversion
if nargout == 2
    F = zeros([length(h) 3]);
    % h < range
    F(ind,:) = [ones([sum(ind) 1]) - (1 - 2/pi*acos(h(ind)/m(3)) + ...
        2*h(ind)/(pi*m(3)).*sqrt(1 - (h(ind)/m(3)).^2)), ...
        (1 - 2/pi*acos(h(ind)/m(3)) + ...
        2*h(ind)/(pi*m(3)).*sqrt(1 - (h(ind)/m(3)).^2)), ...
        -(m(2) -  m(1))*(4*h(ind).*sqrt(m(3)^2 - h(ind).^2)/(pi*m(3)^3))];
    % h > range
    F(~ind,:) = [m(1)*ones([sum(~ind) 1]) m(1)*ones([sum(~ind) 1]) zeros([sum(~ind) 1])];
    varargout{1} = F;
end

return