function hh = errorbar2d(x, y, ex,ey,varargin)
%ERRORBAR Error bar plot.
%   ERRORBAR(X,Y,EX,EY) plots the graph of vector X vs. vector Y with
%   error bars specified by the vectors EX and EY.  EX and EY contain the
%   error ranges for each point in X and Y respecively.  Each error bar
%   is symmetric 2*EX(i) and 2*EY(i) long and is drawn a distance of EX(i)
%   above and below and EY(i) left and right of the points in (X,Y).
%   The vectors X,Y,EX and EY must all be the same length.  If X,Y,EX and
%   EY are matrices then each column produces a separate line.
%
%   ERRORBAR(X,Y,LX,RX,LY,UY) plots asymmetric error bars [X-LX X+RX]
%   and [Y-LY Y+UY].
%
%   ERRORBAR(...,'LineSpec') uses the color and linestyle specified by
%   the string 'LineSpec'.  See PLOT for possibilities.
%
%   H = ERRORBAR(...) returns a vector of line handles.
%
%   For example,
%      x = 1:10;
%      y = sin(x);
%      e = std(y)*ones(size(x));
%      errorbar(x,y,e)
%   draws symmetric error bars of unit standard deviation.

%   ERRORBAR.M
%   L. Shure 5-17-88, 10-1-91 B.A. Jones 4-5-93
%   Copyright 1984-2000 The MathWorks, Inc. 
%   $Revision: 5.17 $  $Date: 2000/06/02 04:30:46 $
%
%   ERRORBAR2D.M
%   Modified for X and Y error bars
%   D. Hasterok - dhasterok@mines.utah.edu
%   University of of Utah
%   Date 2002/11/15

if min(size(x))==1
  npt = length(x);
  x = x(:);
  y = y(:);
    if nargin > 2,
        if ~isstr(ex)
            lx = ex(:);
        end
        if nargin > 3
            if ~isstr(ey)
                rx = ey(:);
            end
            if nargin > 4 & nargin ~= 5
                if ~isstr(varargin{1})
                    ly = varargin{1};
                    ly = ly(:);
                end
                if nargin > 5
                    if ~isstr(varargin{2})
                        uy = varargin{2};
                        uy = uy(:);
                    end
                end
            end
        end
    end
else
  [npt,n] = size(x);
end

if nargin == 4
    if ~isstr(ex)
        lx = ex;
        rx = ex;
        if ~isstr(ey)
            ly = ey;
            uy = ey;
        end
    else
        symbol = l;
        ly = y;
        uy = y;
        y = x;
        [m,n] = size(y);
        x(:) = (1:npt)'*ones(1,n);;
    end
end

if nargin == 5
    symbol = varargin{1};
    if ~isstr(ex)
        lx = ex;
        rx = ex;
        if ~isstr(ey)
            ly = ey;
            uy = ey;
        end
    end
elseif nargin == 7
    symbol = varargin{3};
else
    symbol = 'o';
end

uy = abs(uy);
ly = abs(ly);
rx = abs(rx);
lx = abs(lx);
    
if isstr(x) | isstr(y) | isstr(uy) | isstr(ly) | isstr(rx) | isstr(lx)
    error('Arguments must be numeric.')
end

if ~isequal(size(x),size(y)) | ~isequal(size(x),size(ly)) | ~isequal(size(x),size(uy)) | ~isequal(size(x),size(lx)) | ~isequal(size(x),size(rx))
  error('The sizes of X, Y, L and U must be the same.');
end

ytop = y + uy;
ybot = y - ly;

n = size(y,2);

% Plot graph and bars
hold_state = ishold;
cax = newplot;
next = lower(get(cax,'NextPlot'));

% build up nan-separated vector for bars
xby = zeros(npt*3,n);
xby(1:3:end,:) = x;
xby(2:3:end,:) = x;
xby(3:3:end,:) = NaN;

yby = zeros(npt*3,n);
yby(1:3:end,:) = ytop;
yby(2:3:end,:) = ybot;
yby(3:3:end,:) = NaN;

xlft = x - lx;
xrht = x + rx;

xbx = zeros(npt*3,n);
xbx(1:3:end,:) = xlft;
xbx(2:3:end,:) = xrht;
xbx(3:3:end,:) = NaN;

ybx = zeros(npt*3,n);
ybx(1:3:end,:) = y;
ybx(2:3:end,:) = y;
ybx(3:3:end,:) = NaN;

[ls,col,mark,msg] = colstyle(symbol); if ~isempty(msg), error(msg); end
symbol = [ls mark col]; % Use marker only on data part
esymbol = ['-' col]; % Make sure bars are solid

h = [];
if ~isempty(ls) & ~isempty(mark)
    disp('Here');
    h = plot(x,y,symbol);
end
hold on;
h = [h; plot(xby,yby,esymbol)];
h = [h; plot(xbx,ybx,esymbol)];

if ~hold_state, hold off; end

if nargout>0, hh = h; end
