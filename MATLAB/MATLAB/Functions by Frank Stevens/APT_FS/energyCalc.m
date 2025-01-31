function [enrg] = energyCalc(energy,vars);

Fs = vars.fs;

t50 = round(0.05*Fs);
t80 = round(0.08*Fs);

enrg = [];

%Clarity
if sum(strcmp(vars.params,'C50')) == 1
    try
        enrg.C50 = 10*log10(abs(sum(energy(1:t50))/sum(energy(t50:end))));
    catch
        enrg.C50 = NaN;
    end
end

if sum(strcmp(vars.params,'C80')) == 1
    try
        enrg.C80 = 10*log10(abs(sum(energy(1:t80))/sum(energy(t80:end))));
    catch
        enrg.C80 = NaN;
    end
end

% Definition
if sum(strcmp(vars.params,'D50')) == 1
    try
        enrg.D50 = sum(energy(1:t50))/sum(energy)*100;
    catch
        enrg.D50 = NaN;
    end;
end
    
if sum(strcmp(vars.params,'D80')) == 1
    try
        enrg.D80 = sum(energy(1:t80))/sum(energy)*100;
    catch
        enrg.D80 = NaN;
    end
end

if sum(strcmp(vars.params,'CT')) == 1
    % Centre Time
    x=(0:length(energy)-1)/Fs;
    enrg.CT = sum(energy(:).*x(:))/sum(energy);
end