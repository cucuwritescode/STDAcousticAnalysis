function [ sweep, inv_filter ] = generatesweep( freq_lower, freq_upper, duration, fs, padend)
%GENERATESWEEP Generates a exponential sine sweep and a corresponding
%inverse filter for deconvolution. Also creates a wav file of the sweep.
%
% This is a mashup of code from Simon Shelley, Bertrand Delvaux, Andrew
% Chadwick, and Frank Stevens.
%
%
% Usage:
% ======
%
% freq_lower    :       Lowest frequency of interest. Sweep will start
%                       lower in order to allow a 0.1s fade in
% freq_upper    :       Highest frequency of interest. Sweep will end
%                       higher in order to allow a 0.1s fade out
% duration      :       Duration of the sweep in seconds (0.1s in/out 
%                       ramps are added to this duration)
% fs            :       Sampling rate
% padend        :       Amount of silence to add at the end of the
%                       sweep
% Example usage: 
% [ sweep, inv_filter] = generatesweep(20,20000,15,44100,5);
%
% =====================================================================
   
% Constants
ramptime = 0.1;
maxamplitude = 0.98;
    
% Calculate original angular frequencies, K and L
w1 = 2*pi*freq_lower;
w2 = 2*pi*freq_upper;
K = duration*w1/log(w2/w1);
L = duration/log(w2/w1);  

% Calculate the frequency we need to start at to hit the start
% frequency 0.1 seconds later, and the frequency we'll be at 0.1
% seconds after the target
start_freq = (K*exp(-ramptime/L))/(2*pi*L);
end_freq = (K*exp((duration+ramptime)/L))/(2*pi*L);

% Now recalculate the parameters to include the onset and offset time
% =====================================================================

% Add ramp durations on to the total duration
duration = duration + 0.2;   

% Create a Time Ramp 
timeramp = 0:1/fs:duration-(1/fs);    

% Calculate new angular frequencies, K and L
w1 = 2*pi*start_freq;
w2 = 2*pi*end_freq;
K = duration*w1/log(w2/w1);
L = duration/log(w2/w1); 

% Generate the sweep
% =====================================================================

% Calculate the sweep
sweep = sin( K *(exp(timeramp/L)-1) );

% Create an envelope with a ramp at either end
envelope = [ linspace(0,maxamplitude,ramptime*fs), ones(1,round((duration-(2*ramptime))*fs))*maxamplitude, linspace(maxamplitude,0,ramptime*fs) ];

% Apply the envelope
sweep = sweep.*envelope;

% Generate the inverse filter (and apply amp envelope of 6dB/Octave)
% =====================================================================

% Reverse the sweep
sweep_rev = fliplr(sweep);

% Generate linear range from 0 to -6*log2(number of octaves)
env_linspace=linspace(0,(-6*(log(freq_upper/freq_lower)./log(2))),length(sweep_rev));
env_log=10.^(env_linspace./20);

% Multiply by amp envelope
inv_filter = sweep_rev.*env_log;

% pad the end and start
sweep = (1/sqrt(2)).*[zeros(1,fs), sweep, zeros(1,padend*fs)];

% Export the sweep and its inverse as wavs
audiowrite(['Sweep_',num2str(freq_lower),'to',num2str(freq_upper),'_',num2str(fs),'.wav'], sweep,fs,'BitsPerSample', 24);
audiowrite(['Inverse_Sweep_',num2str(freq_lower),'to',num2str(freq_upper),'_',num2str(fs),'.wav'], inv_filter,fs,'BitsPerSample', 24);

end