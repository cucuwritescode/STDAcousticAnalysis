function plotSchroeder(ir, fs, bands, results)
%plotschroeder - visualises the schroeder decay curve and overlays key metrics
%
%inputs:
%   ir-impulse response (filtered or full-band)
%   fs- sampling frequency in hz
%   bands- array of frequency band center frequencies
%   results - matrix of acoustic parameters (e.g., rt60, edt, etc.)
%
%output:
%   plots a schroeder decay curve with annotated acoustic parameters

    %compute schroeder decay curve
    energy = flip(cumsum(flip(ir.^2))); % schroeder integration
    energy_dB = 10 * log10(energy / max(energy)); % normalise to 0 db
    t = (0:length(energy_dB)-1) / fs; % time vector in seconds

    %create decay curve plot
    figure('Name', 'Schroeder Decay Curve');
    plot(t, energy_dB, 'k', 'LineWidth', 1.5);
    hold on;

    %overlay rt60 and edt annotations
    for i = 1:length(bands)
        band = bands(i);
        rt60 = results(i, 1); % rt60 value
        edt = results(i, 2);  % edt value

        %annotate if values are valid
        if ~isnan(rt60)
            text(rt60, -60, sprintf('%.1f Hz: RT60 %.2f s', band, rt60), 'Color', 'r');
        end
        if ~isnan(edt)
            text(edt, -10, sprintf('%.1f Hz: EDT %.2f s', band, edt), 'Color', 'b');
        end
    end

    %add labels and formatting
    xlabel('time (s)');
    ylabel('energy decay (db)');
    title('schroeder decay curve');
    grid on;
    axis([0 max(t) -80 5]);
    hold off;
end