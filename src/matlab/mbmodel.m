function [dm,F] = mbmodel(m,x);

dm = forward(m,x);
F = frechet(m,x);

return


function dm = forward(m,x);

    dm = maxbolt(x,m);

return


function F = frechet(m,x);

    F = sqrt(2/pi)*m^-6*x.^2.*(x.^2 - 3*m^2).*exp(-0.5*x.^2*m^-2);

return
