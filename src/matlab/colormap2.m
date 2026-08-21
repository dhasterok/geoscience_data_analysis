function varargout = colormap2(cmap,varargin)
% COLORMAP2 - Additional colormaps
%
%   colormap2(map) will produce a color map either given as a series of
%   color triplets or by given name.  This code adds the following
%   additional colormaps.
%
%   'red', 'blue','green', 'violet', 'brown', 'rwb' (red-white-blue),
%   'ryb' (red-yellow-blue), 'plasma', 'inferno', 'klindman', 'blackbody'
%   'bivroy', 'bivroy2'
%
%   colormap2 will also accept native MatLab colormaps.
%
% Options:
%   'Direction'         'normal' or 'reverse'
%   'N'                 sets the number of color divisions, default 256.

% D. Hasterok, 2022, Univ. Adelaide

p = inputParser;
addRequired(p,'Colormap');%,@ischar);
addParameter(p,'Direction','normal',@ischar);
addParameter(p,'N',256,@isnumeric);
parse(p,cmap,varargin{:});

direction = p.Results.Direction;
N = p.Results.N;

if isnumeric(cmap)
    map = palatte(cmap(1,:),cmap(2,:),cmap(3,:),64);
else
    switch cmap
        case 'red'
            map = palatte(0.9*[1 1 1],[1 0.5 0],[0.8627 0.0784 0.2353],N);
        case 'red2'
            map = palatte([1 1 1],[1 0.5 0],[0.8627 0.0784 0.2353],N);
        case 'blue'
            map = palatte(0.9*[1 1 1],[0 0.9804 0.6039],[0 0 0.8039],N);
        case 'green'
            map = palatte(0.9*[1 1 1],[1 0.7843 0.1176],[0.1333 0.5451 0.1333],N);
        case 'violet'
            map = palatte(0.9*[1 1 1],[1 0.6275 0.4784],[0.5804 0 0.8275],N);
        case 'brown'
            map = palatte(0.9*[1 1 1],[0.8706 0.7216 0.5294],[0.5451 0.2706 0.0745],N);
        case 'rwb'
            map = palatte([0.8039 0 0],[1 1 1],[0 0 0.8039],N);
        case 'rwb2'
            map = palatte([0.8039 0.3608 0.3608],[1 1 1],[0.3922 0.5843 0.9294],N);
        case 'ryb'
            map = palatte([0.8039 0 0],[1 0.7843 0.1176],[0 0 0.8039],N);
        case 'ryb2'
            map = palatte([0.8039 0.3608 0.3608],[0.9412 0.9020 0.5490],[0.3922 0.5843 0.9294],N);
        case 'plasma'
            m = [0.0, 13, 8, 135
                0.14285714285714285, 84, 2, 163
                0.2857142857142857, 139, 10, 165
                0.42857142857142855, 185, 50, 137
                0.5714285714285714, 219, 92, 104
                0.7142857142857142, 244, 136, 73
                0.8571428571428571, 254, 188, 43
                1.0, 240, 249, 33];
            map = interp1(m(:,1),m(:,2:end),linspace(m(1,1),m(end,1),N))/255;
        case 'inferno'
            m = [0.0,0,0,4
                0.14285714285714285, 40, 11 ,84
                0.2857142857142857, 101, 21, 110
                0.42857142857142855, 159, 42, 99
                0.5714285714285714, 212, 72, 66
                0.7142857142857142, 245, 125, 21
                0.8571428571428571, 250, 193, 39
                1.0, 252, 255, 164];
            map = interp1(m(:,1),m(:,2:end),linspace(m(1,1),m(end,1),N))/255;
            %map = palatte([0,0,4]/255,[185.5,57,82.5]/255,[252,255,164]/255,64);
        case 'klindman'
            m = [0.0, 0, 0, 0
                0.14285714285714285, 36, 6, 117
                0.2857142857142857, 7, 62, 150
                0.42857142857142855, 5, 115, 97
                0.5714285714285714, 8, 159, 21
                0.7142857142857142, 112, 196, 9
                0.8571428571428571, 250, 208, 146
                1.0, 255, 255, 255];
            map = interp1(m(:,1),m(:,2:end),linspace(m(1,1),m(end,1),N))/255;
        case 'blackbody'
            m = [0.0, 0, 0, 0
                0.14285714285714285, 65, 23, 18
                0.2857142857142857, 128, 31, 27
                0.42857142857142855, 188, 51, 32
                0.5714285714285714, 224, 101, 10
                0.7142857142857142, 232, 161, 26
                0.8571428571428571, 231, 218, 48
                1.0, 255, 255, 255];
            map = interp1(m(:,1),m(:,2:end),linspace(m(1,1),m(end,1),N))/255;
        case 'bivroy'
            m = [0, 0, 17, 58
                0.1850, 10, 189, 248
                0.4083, 87, 45, 69
                0.5683, 194, 24, 30
                0.6483, 239, 44, 25
                1, 255, 255, 10];
            map = interp1(m(:,1),m(:,2:end),linspace(m(1,1),m(end,1),N))/255;
        case 'bivroy2'
            m = [0, 0, 27, 48
                0.1850, 10, 189, 248
                0.4083, 98, 0, 151 %87, 45, 69
                0.5683, 194, 24, 30
                0.6483, 239, 44, 25
                1, 255, 255, 10];
            map = interp1(m(:,1),m(:,2:end),linspace(m(1,1),m(end,1),N))/255;   
        otherwise
            % check if it is a default matlab colormap
            try
                map = feval(cmap,N);
            catch
                error('Unknown colormap.');
            end
    end
end

switch direction
    case 'normal'
        % do nothing
    case 'reverse'
        map = flipud(map);
    otherwise
        error('Direction must be normal or reverse')
end

% apply colormap or return map
if nargout == 0
    colormap(map);
else
    varargout{1} = map;
end

return