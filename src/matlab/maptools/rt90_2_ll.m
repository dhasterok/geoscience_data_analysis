function [lon,lat] = rt90_2_ll(E,N);

R = 6378137.0; % GRS 80.
flattening = 1.0 / 298.257222101; % GRS 80.
central_meridian = 15.0 + 48.0/60.0 + 22.624306/3600.0;
scale = 1.00000561024;
false_northing = -667.711;
false_easting = 1500064.274;

%if (central_meridian.nil?);
%    return
%end
% Prepare ellipsoid-based stuff.
e2 = flattening * (2.0 - flattening);
n = flattening / (2.0 - flattening);
a_roof = R / (1.0 + n) * (1.0 + n^2/4.0 + n^4/64.0);
delta1 = n/2.0 - 2.0*n^2/3.0 + 37.0*n^3/96.0 - n^4/360.0;
delta2 = n*n/48.0 + n^3/15.0 - 437.0*n^4/1440.0;
delta3 = 17.0*n^3/480.0 - 37*n^4/840.0;
delta4 = 4397.0*n^4/161280.0;

astar = e2 + e2^2 + e2^3 + e2^4;
bstar = -(7.0*e2^2 + 17.0*e2^3 + 30.0*e2^4) / 6.0;
cstar = (224.0*e2^3 + 889.0*e2^4) / 120.0;
dstar = -(4279.0*e2^4) / 1260.0;

% Convert.
deg_to_rad = pi / 180;
lambda_zero = central_meridian * deg_to_rad;
Ei = (E - false_northing) / (scale * a_roof);
eta = (N - false_easting) / (scale * a_roof);
Ei_prim = Ei - ...
    delta1*sin(2.0*Ei) .* cosh(2.0*eta) - ...
    delta2*sin(4.0*Ei) .* cosh(4.0*eta) - ...
    delta3*sin(6.0*Ei) .* cosh(6.0*eta) - ...
    delta4*sin(8.0*Ei) .* cosh(8.0*eta);
eta_prim = eta - ...
    delta1*cos(2.0*Ei) .* sinh(2.0*eta) - ...
    delta2*cos(4.0*Ei) .* sinh(4.0*eta) - ...
    delta3*cos(6.0*Ei) .* sinh(6.0*eta) - ...
    delta4*cos(8.0*Ei) .* sinh(8.0*eta);
phi_star = asin(sin(Ei_prim) ./ cosh(eta_prim));
delta_lambda = atan(sinh(eta_prim) ./ cos(Ei_prim));
lon_radian = lambda_zero + delta_lambda;
lat_radian = phi_star + sin(phi_star) .* cos(phi_star) .* ...
    (astar + ...
    bstar*(sin(phi_star) * 2) + ...
    cstar*(sin(phi_star) * 4) + ...
    dstar*(sin(phi_star) * 6));
lat = (lat_radian * 180.0 / pi);
lon = (lon_radian * 180.0 / pi);

return