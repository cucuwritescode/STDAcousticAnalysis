function analyseIR(irFile, maxfreq, loglin, dbmin)
%analyse and visualize an IR (time, spectrum, spectrogram)
%created by Facundo Franchino
    %how to use?
    %analyseIR('stereoIR_tunnel_sweep.wav', 20000, 'log', -100);
    %inputs:
    %-irFile: path to the IR file.
    %-maxfreq:maximum frequency for the spectrogram (por ejemplo, 20000 Hz).
    %-loglin: log or 'lin' for spectrogram frequency axis.
    %-dbmin:minimum dB value for the spectrogram (por ejemplo, -100).
    %waveform plot
    fprintf('generating waveform plot...\n');
    waveformplot(irFile);
    saveas(gcf, 'waveform.png'); %save waveform plot
    %frequency spectrum
    fprintf('generating frequency spectrum...\n');
    freqspec(irFile);
    saveas(gcf, 'frequencyspectrum.png'); %save frequency spectrum plot
    %spectrogram
    fprintf('generating spectrogram...\n');
    spectrogramComplete(irFile, 2048, maxfreq, loglin, dbmin);
    saveas(gcf, 'spectrogram.png'); %save spectrogram plot
    fprintf('IR analysis complete. plots saved as .png files.\n');
end
