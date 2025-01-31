function freqspec(filename)
% plots frequency spectrum of first channel of input file
[x,fs] = audioread(filename);
x = x(:,1);
L = length(x);
NFFT = 2^nextpow2(L);

% fourier transfrom the windowed waveform. convert to db and normalise to
% max = 0dB

Y = fft(x,NFFT);
YdB = db(abs(Y(1:NFFT/2))/max(abs((Y(1:NFFT/2)))));

% create frequency axis values

f = linspace(0,fs/2,NFFT/2);

% plot spectrum with logarithmic frequnecy axis

semilogx(f,YdB,'color','k')
title(strcat(filename,{' - '},'Frequency Spectrum'), 'Interpreter', 'none');

% set -100dB amplitude limit. set frequency axis limits between 22Hz and
% 22kHz - range of frequency sweep.

axis([22 22000 -90 1])
grid on
% set frequency labels and ticks

xlabel('Frequency (Hz)')
ylabel ('Magnitude (dB)')
set(gca,'XTick',[22 100 1000  10000  20000])
set(gca,'XTickLabel',{'22','100','1k','10k','20k'})

end
