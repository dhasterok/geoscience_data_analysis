function varargout = variogram_model(nugget0,sill0,range0,model,varargin)

invert = 0;
if nargin == 6
    invert = 1;
elseif nargin < 4 | 6 < nargin
    error('Unknown number of inputs.');
end

if ~invert
    if nargin == 5
        h = varargin{1}(:);
    else
        h = linspace(0,5*range0,100);
    end
else
    h = varargin{1}(:);
    gamma = varargin{2}(:);
end

switch model
    case 'spherical'
        method = 'variogram_spherical';
    case 'circular'
        method = 'variogram_circular';
    case 'exponential'
        method = 'variogram_exponential';
    case 'gaussian'
        method = 'variogram_gaussian';
    case 'wave'
        method = 'variogram_wave';
    case 'quadratic'
        method = 'variogram_quadratic';
    otherwise
        error('Variogram model type unknown');
end

if invert
    [m,rms] = invnewton(method,h,gamma,[nugget0,sill0,range0]');
else
    gamma = feval(method,[nugget0,sill0,range0]',h);
end

if invert
    nugget = m(1);
    sill = m(2);
    range = m(3);
    varargout = {nugget,sill,range,rms};
    fprintf('\n  Variogram Model: %s\n  Nugget: %f\n  Sill: %f\n  Range: %f\n', ...
        model,nugget,sill,range);
else
    varargout = {h,gamma};
end

return