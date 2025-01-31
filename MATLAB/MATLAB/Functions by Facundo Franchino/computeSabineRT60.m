function RT60 = computeSabineRT60(volume, surfaceAreas, absorptionCoeffs)
%computeSabineRT60 - Estimates reverberation time (RT60) using the Sabine equation.
%written by Facundo Franchino
%
%IN:
%   -volume:room volume in cubic meters (m^3).
%   -surfaceAreas:vector of surface areas for different materials (m^2).
%   -absorptionCoeffs:corresponding absorption coefficients for each surface.
%
%OUT:
%   -rt60:estimated reverberation time in seconds.

%validate input sizes
if length(surfaceAreas) ~= length(absorptionCoeffs)
    error('Mismatch: Surface areas and absorption coefficients must have the same length.');
end

%compute total absorption area
totalAbsorption = sum(surfaceAreas .* absorptionCoeffs);

%apply Sabine's formula
RT60 = 0.161 * volume / totalAbsorption;

end