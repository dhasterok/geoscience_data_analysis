function ca_thol_line(varargin)

if nargin == 1
    c = varargin{1};
else
    c = [0 0 0];
end

MgO = [5:56];
FeO = 1.5559e-12 * MgO.^8 - 7.7142e-10 * MgO.^7 ...
    + 1.5664e-7 * MgO.^6 - 1.6738e-5 * MgO.^5 ...
    + 1.0017e-3 * MgO.^4 - 3.2552e-2 * MgO.^3 ...
    + 4.7776e-1 * MgO.^2 - 1.1085 * MgO + 30;
A = 100 - MgO - FeO;

t = ternplot(FeO,A,MgO,'-');
set(t,'Color',c);

return