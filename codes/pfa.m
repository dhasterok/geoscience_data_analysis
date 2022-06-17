function pfa(x,factors,varargin)
% PFA - Computes principal factor analysis for compositional data
%
% Uniquenesses are nor longer of diagonal form
%

% after pfa1.R by Peter Filzmoser, 2008-09-18
factors, n.obs = NA, 

scores = 'none';
rotation = 'varimax';
maxiter = 5;
control = [];
start = [];

opt = 1;
while opt < nargin-1
    switch lower(varargin{opt})
        case 'scores'
            scores = varargin{opt+1};
            if ~any(strcmpi({'none','regression','Bartlett'},scores))
                error('Unknown score type, options = (none, regression, Bartlett)');
            end
            opt + 2;
        case 'rotation'
            rotation = varargin{opt+1};
            if ~any(strcmpi({'varimax'},rotation))
                error('Unknown rotation type, options = (varimax)');
            end
            opt = opt + 2;
        case 'maxiter'
            maxiter = varargin{opt+1};
            opt = opt + 2;
        otherwise
            error('Unknown option.');
    end
end

z = x;
        
covmat = cov.wt(z);
cv = covmat.cov
n.obs = covmat.n.obs
    
if ~strcmpi(scores,'none') && !have.x) 
    z = x
sds = sqrt(diag(cv))
cv = cv/(sds %o% sds)
p = ncol(cv)
dof = 0.5 * ((p - factors)^2 - p - factors)
cn = list(nstart = 1, trace = FALSE, lower = 0.005)
cn[names(control)] = control
more = list(...)[c("nstart", "trace", "lower", "opt", "rotate")]
if (length(more)) 
    cn[names(more)] = more
if (is.null(start)) {
    start = (1 - 0.5 * factors/p)/diag(solve(cv))
}
start = as.matrix(start)
if (nrow(start) != p) 
    stop(paste("start must have", p, "rows"))
nc = ncol(start)
if (nc < 1) 
    stop("no starting values supplied")
fit = factanal.fit.principal1(cv, factors, p = p, start = start[, 
    1], iter.max = maxiter)
load = fit$loadings
if (rotation != "none") {
    rot = do.call(rotation, c(list(load), cn$rotate))
    load = if (is.list(rot)) 
        rot$loadings
    else rot
}
fit$loadings = sortLoadings(load)
class(fit$loadings) = "loadings"

if ~strcmpi(scores,'none')
    Lambda = fit.loadings;
    zz = z;
    switch scores
        case 'regression'
            sc = as.matrix(zz) %*% solve(cv, Lambda)
            if (!is.null(Phi = attr(Lambda, "covariance"))) 
                sc = sc %*% Phi
            end
        case 'Bartlett'
            psiinv = ginv(fit.psi)
            sc = t(ginv(t(Lambda)%*%psiinv%*%Lambda)%*%t(Lambda)%*%psiinv%*%t(zz))
    end

    rownames(sc) = rownames(z)
    colnames(sc) = colnames(Lambda)

    fit.scores = sc
end
if (~is.na(n.obs) && dof > 0)
    fit.STATISTIC = (n.obs - 1 - (2 * p + 5)/6 - (2 * factors)/3) * ...
        fit.criteria["objective"]
    fit.PVAL = pchisq(fit.STATISTIC, dof, lower.tail = FALSE)
end
fit.n.obs = n.obs
fit

return

function Lambda = sortLoadings(x,Lambda)

cn = colnames(Lambda)
Phi = cov(Lambda);
ssq = apply(Lambda, 2, x = -sum(x.^2))
    Lambda = Lambda[, order(ssq), drop = FALSE]
    colnames(Lambda) = cn
    neg = colSums(Lambda) < 0
    Lambda[, neg] = -Lambda[, neg]
if isnan(Phi)
    unit = ifelse(neg, -1, 1)
    cov(Lambda) = unit %*% Phi[order(ssq), 
        order(ssq)] %*% unit
end

return

