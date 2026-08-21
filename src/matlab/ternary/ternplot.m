function t = ternplot(varargin)
% TERNPLOT - plot data on a ternary axes
%
%    t = ternplot(a,b,c) or
%    t = ternplot(a,b,c, sym) where sym is the line specification, see
%    PLOT.
%
%    To use ternplot like scatter (points colored using a fourth vector):
%    t = ternplot(a,b,c, sym, {S,P}) where S is the size and P is the 
%    vector of values to be scaled as the color.  S and P can be a single
%    value or of length equal to the number of points.  S and P lengths
%    need not be the same.
%
%    The order of the axes are as follows:
%
%                    A
%                   / \
%                  /   \
%                 B --- C
%
%    See also ternary, ternscatter

% Last Modified: 8 May 2023
% D. Hasterok, University of Adelaide

% parse inputs
% ------------------------
p = inputParser;

% data axes
addRequired(p,'A',@isnumeric);
addRequired(p,'B',@isnumeric);
addRequired(p,'C',@isnumeric);
addOptional(p,'D',@isnumeric);

addParameter(p,'Axes',[],@isgraphics);          % handle to axes

addParameter(p,'Symbol','o',@ischar);           % symbol
addParameter(p,'Attributes',{},@iscell);        % line pattern

parse(p,varargin{:});

a = p.Results.A;
b = p.Results.B;
c = p.Results.C;
d = p.Results.D;

sym = p.Results.Symbol;
lspec = p.Results.Attributes;

ax = p.Results.Axes;
if isempty(ax)
    ax = gca;
end
% ------------------------

if isempty(d)
    [x,y] = tern2xy(a,b,c);
else
    x = zeros(size(a));
    y = zeros(size(a));
    
    ind = d > 0;
    [x(~ind),y(~ind)] = tern2xy(a(~ind),b(~ind),c(~ind));
    [x(ind),y(ind)] = tern2xy(d(ind),b(ind),c(ind));
    y(ind) = -y(ind);
end  

if ~isempty(lspec)
    t = scatter(ax,x,y,lspec{1},lspec{2},sym,'filled');
elseif ~isempty(sym)
    t = plot(ax,x,y,sym);
else
    t = plot(ax,x,y);
end

return
