function [outparams] = reverbertionCalc(varargin)
 
ir  = varargin{1};  % Signal
vars = varargin{2}; % Calculation Parameters Struct (see acousticParams.m)

Fs = vars.fs;

% Normalized schroeder
E(length(ir):-1:1) = (cumsum(ir(length(ir):-1:1))/sum(ir));

% Remove Negative Values
if find(E < 0)
    E(min(find(E < 0)):end) = [];
    E=10*log10(E);
else
    E=10*log10(E);
end

% Save Shroeder Curve to output structure
outparams.E = E;

% Time scale in seconds
x = (0:length(E)-1)/Fs; 

if sum(strcmp(vars.params,'EDT')) == 1
    % Calculate Early Decay Time (EDT) of signal. Obtained from the intial part 
    % of the Schroeder curve.
    t10   = min(find(E < -10)); 
    [A10,B10] = intlinear(x(1:t10),E(1:t10));
    outparams.A(1) = A10;
    outparams.B(1) = B10;
    outparams.EDT = (-60)/(B10);
end

% Calculate T20, T30 and T40 from the Schroeder curve (in dB).
begin = min(find(E < -5));      % 5dB Index
t25   = min(find(E < -25));     % 25dB Index
t35   = min(find(E < -35));     % 35dB Index
t45   = min(find(E < -45));     % 45dB Index

if sum(strcmp(vars.params,'T20')) == 1
    % 20dB Reverb Time
    if ~isempty(t25)
        [A20,B20] = intlinear(x(begin:t25),E(begin:t25));
        outparams.A(2) = A20;
        outparams.B(2) = B20;
        outparams.T20 = (-60)/(B20);
    else
        outparams.T20 = NaN; % Shroeder Curve does not drop below 25dB                 
    end
end

if sum(strcmp(vars.params,'T30')) == 1
    % 30dB Reverb Time
    if ~isempty(t35)
        [A30,B30] = intlinear(x(begin:t35),E(begin:t35));
        outparams.A(3) = A30;
        outparams.B(3) = B30;
        outparams.T30 = (-60)/(B30);
    else
        outparams.T30 = NaN; % Shroeder Curve does not drop below 30dB                
    end
end

if sum(strcmp(vars.params,'T40')) == 1
    % 40dB Reverb Time
    if ~isempty(t45)
        [A40,B40] = intlinear(x(begin:t45),E(begin:t45));
        outparams.A(4) = A40;
        outparams.B(4) = B40;
        outparams.T40 = (-60)/(B40);
    else
        outparams.T40 = NaN; % Shroeder Curve does not drop below 40dB
    end
end