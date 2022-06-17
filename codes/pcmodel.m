function mod = pcmodel(age,ref);
% PCMODEL - Computes the best-fitting plate cooling model.

data = load('bath.out');

tz = data(:,1);
zobs = data(:,2);
zsd  = data(:,3);
usez = logical(data(:,4));

tq = ref.age;
qobs = ref.qc;
qsd  = ref.qc_sd;
N = ref.N;
useq = ref.use;

t = [0.5 1:182]';

% test parameter steps
dz = 5;
dT = 25;
dalpha = 5e-7;
dlambda = 0.1;

% parameters
v = 30*1e-3/(pi*1e7);                   % Half-spreading rate           [m/s]
za = [75:dz:150]*1e3;                   % Plate thickness               [m]
Tm = [1100:dT:1600];                    % Basal Temperature             [degC]
alpha = [2.75e-5:dalpha:4.25e-5];       % Thermal expansivity           [K^-1]
%lambda = [2.8:dlambda:3.3];             % Thermal conductivity          [W/m/K]
lambda = 3.183;                         % Thermal conductivity          [W/m/K]
Cp = 1171;                              % Specific heat capacity        [J/kg/K]
rhom = 3330;                            % Mantle density                [kg/m^3]

N = length(usez);
M = length(useq);

m = zeros([length(za) length(Tm) length(alpha) length(lambda)]);
dr = zeros([length(za) length(Tm) length(alpha) length(lambda)]);
for i = 1:length(za)
    disp([num2str(i),' of ',num2str(length(za))]);
    for j = 1:length(Tm)
        for k = 1:length(alpha)
            for ii = 1:length(lambda)
                [s,q] = platecooling(t,v,lambda(ii),Cp,rhom,za(i),Tm(j),alpha(k));
                q = q*1e3;

                S = interp1(t,s,tz(usez));
                Q = interp1(t,q,tq(useq));

                dr(i,j,k,ii) = mean(zobs(usez)) - mean(S);
                
                m(i,j,k,ii) = 1/N*sum((zobs(usez) - (S + dr(i,j,k,ii))).^2./zsd(usez).^2) ...
                    + 1/M*sum((qobs(useq) - Q).^2./qsd(useq).^2);
                m(i,j,k,ii);
                if i == 1 & j == 1 & k == 1 & ii == 1
                    misfit = m(1,1,1,1);
                    ind = [1 1 1 1];
                    dbest = s + dr(1,1,1,1);
                    qbest = q;
                end
        
                if m(i,j,k,ii) < misfit
                    misfit = m(i,j,k,ii);
                    ind = [i j k ii];
                    dbest = s + dr(i,j,k,ii);
                    qbest = q;
                end
            end
        end
    end
end

%out = [t dbest qbest];
%save best.tzq out -ASCII

qs = 1e3*lambda(ind(4))*Tm(ind(2))/za(ind(1));
fprintf('\nPlate Velocity:       %7.1f mm/yr\n',v*pi*1e10);
fprintf('Ridge Depth:           %7.0f m\n',dr(ind(1),ind(2),ind(3),ind(4)));
fprintf('Plate Thickness:       %7.0f km\n',za(ind(1))/1000);
fprintf('Basal Temperature:     %7.0f K\n',Tm(ind(2)));
fprintf('Thermal Expansion:     %7.2e K^-1\n',alpha(ind(3)));
fprintf('Thermal Conductivity:  %7.2f W/m/K\n',lambda(ind(4)));
fprintf('Aysmptotic Heat Flow:  %7.0f mW/m^2\n',qs);
fprintf('Minimum Misfit:        %7.4f\n\n',misfit);

mod.age = age;
[s,q] = platecooling(mod.age,v,lambda(ind(4)),Cp,rhom,za(ind(1)),Tm(ind(2)),alpha(ind(3)));
mod.q = q*1e3;
mod.s = s*1e-3;
mod.dr = dr(ind(1),ind(2),ind(3),ind(4))*1e-3;
mod.za = za(ind(1))*1e-3;
mod.Tm = Tm(ind(2));
mod.alpha = alpha(ind(3));
mod.lambda = lambda(ind(4));
mod.rms = misfit;

return

