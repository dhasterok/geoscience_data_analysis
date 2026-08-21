function [dm,F] = lgmodel(m,x);

dm = forward(m,x);
F = frechet(m,x);

return


function dm = forward(m,x);

    dm = lognormal(x,m(1),m(2));

return


function F = frechet(m,x);

    var = m(2).^2;
    u = log(x) - m(1);
    arg = exp(-0.5*u.^2./var)./(x*sqrt(2*pi));
    F = [u.*arg./(m(2)*var) ...
        (u.^2 - var).*arg./var.^2];

return
