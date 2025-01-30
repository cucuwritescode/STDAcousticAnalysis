function plotRT60(filename)
    %plotRT60: computes and plots RT60 from an impulse response
    %IN: filename - string, the name of the IR wav file
    %OUT: RT60 vs frequency plot

    %load impulse response
    [IR, Fs] = audioread(filename);

    %define parameters for APT
    vars = struct;
    vars.fs = Fs;
    vars.bandwidth = 'one-octave'; %use octave bands
    vars.bands = {'125', '250', '500', '1000', '2000', '4000'}; %frequency bands
    vars.signaltype = 'real';
    vars.params = {'T30'}; %extract T30 for RT60
    vars.outputOrientation = 'band';
    vars.plot = 'none'; %prevents APT from auto-plotting schroeder decay curves

    %close all extra figures first
    close all;

    %run APT analysis
    [results, bands, parameters] = acousticParams(IR', vars);

    %extract T30 values from the matrix
    numBands = length(bands);
    RT60_values = zeros(numBands, 1);

    for i = 1:numBands
        bandData = results(:,:,i); %get all T30 values for this band
        RT60_values(i) = 2 * bandData(1); %take only the first valid T30 value
    end

    %cnvert bands to numeric
    freqBands = cellfun(@str2double, bands);

    %plot RT60 vs frequency
    figure;
    plot(freqBands, RT60_values, '-o', 'LineWidth', 1.5);
    set(gca, 'XScale', 'log'); %log x-axis
    xlabel('Frequency (Hz)');
    ylabel('RT60 (seconds)');
    title(['RT60 by Frequency Band for ', filename], 'Interpreter', 'none');
    grid on;
end