function RT60 = estimateRT60(ir, fs)
%estimateRT60 - computes rt60 (reverberation time) using schroeder integration
%written by Facundo Franchino
%IN:
%   -ir:impulse response (single channel)
%   -fs:sampling frequency (hz)
%
%OUT:
%   -rt60:reverberation time (seconds)
%here we calculate the energy decay curve using schroeder integration
%schroeder integration involves flipping the ir energy and performing a cumulative sum
    energy = flip(cumsum(flip(ir.^2))); % cumulative sum in reverse order
    
 %convert the energy decay curve to decibels and normalise it
 %normalisation ensures the maximum energy corresponds to 0 db
    energy_db = 10 * log10(energy / max(energy));

    %create a time vector corresponding to the length of the ir
    t = (0:length(energy_db)-1) / fs; % here we initialise the time vector
    
    %find the time index where the decay reaches -5 db
    idx_5dB = find(energy_db <= -5, 1);

    %find the time index where the decay reaches -35 db
    idx_35dB = find(energy_db <= -35, 1);

    %make sure valid indices are found for both -5 db and -35 db
    %if either index is not found, throw an error
    if isempty(idx_5dB) || isempty(idx_35dB)
        error('energy decay curve does not reach -5 db or -35 db.');
    end

    %fit a straight line to the energy decay curve between -5 db and -35 db
    %the slope of this line will be used to calculate the rt60
    p = polyfit(t(idx_5dB:idx_35dB), energy_db(idx_5dB:idx_35dB), 1);

    %calculate rt60, which corresponds to the time for a 60 db decay
    %this is derived from the slope of the fitted line
    RT60 = -60 / p(1);
end
