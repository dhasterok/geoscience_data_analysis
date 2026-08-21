function [Aq,Bq,Cq] = errorbar_tern(A,B,C,varargin)

q = 0.025;
plottype = 'bar';
colour = [];
if nargin > 3
    q = varargin{1};
    if nargin > 4
        plottype = varargin{2};
        
        if ~any(strcmp(plottype,{'bar','patch','none'}))
            error(['Unknown plot type ',plottype,'.']);
        end
        
        if nargin > 5
            colour = varargin{3};
        end
    end
end

q = [q 0.5 1-q];

if length(A) == length(B) & length(B) == length(C) & length(A) == 3
    Aq = A;
    Bq = B;
    Cq = C;
else
    Aq = compute_bars(A(~isnan(A)),q);
    Bq = compute_bars(B(~isnan(B)),q);
    Cq = compute_bars(C(~isnan(C)),q);
end

size(Aq)

dA = -0.5*([Aq(1) Aq(3)] - Aq(2));
dB = -0.5*([Bq(1) Bq(3)] - Bq(2));
dC = -0.5*([Cq(1) Cq(3)] - Cq(2));

switch plottype
    case 'bar'
        t(1) = ternplot([Aq(1) Aq(3)], Bq(2)+dA, Cq(2)+dA,'-');
        t(2) = ternplot(Aq(2)+dB, [Bq(1) Bq(3)], Cq(2)+dB,'-');
        t(3) = ternplot(Aq(2)+dC, Bq(2)+dC, [Cq(1) Cq(3)],'-');
        t(4) = ternplot(Aq(2),Bq(2),Cq(2),'^');
        if ~isempty(colour)
            for i = 1:3
                set(t(i),'Color',colour);
            end
            set(t(4),'MarkerEdgeColor','none','MarkerFaceColor',colour);
        end
    case 'patch'
        Av = [Aq(1) Aq(2)+dB(2) Aq(2)+dC(1) Aq(3) Aq(2)+dB(1) Aq(2)+dC(2) Aq(1)]
        Bv = [Bq(2)+dA(1) Bq(3) Bq(2)+dC(1) Bq(2)+dA(2) Bq(1) Bq(2)+dC(2) Bq(2)+dA(1)]
        Cv = [Cq(2)+dA(1) Cq(2)+dB(2) Cq(1) Cq(2)+dA(2) Cq(2)+dB(1) Cq(3) Cq(2)+dA(1)]
        t(1) = ternplot(Av,Bv,Cv,'-');
        t(2) = ternplot(Aq(2),Bq(2),Cq(2),'^');
        if ~isempty(colour)
            set(t(1),'Color',colour);
            set(t(2),'MarkerEdgeColor','none','MarkerFaceColor',colour);
        end
    case 'none'
        return
end

return


function Xq = compute_bars(X,q);

Xq = quantile(X,q)

return
