% script to demonstrate the functionality of the APT
% close all figures and clear workspace
close all
clear 

% choose IR filename 
filename = 'minsterMono.wav';

% read in chosen IR audio file
[data,fs] = audioread(filename);

% create vars struct for APT input. populate required fields
vars = struct;
vars.fs = fs;
%vars.plot = 'none';

% run the APT for the chosen IR
[results, bands, parameters] = acousticParams(data',vars);

% rearrange data output
results = permute(results,[1,3,2]);

% change some of the paramter names for plotting
bands(5:8) = {'1k','2k','4k','8k'};

% make a cell array of y labels
ylabelcell = {'%','%','dB','dB','Time (s)', 'Time (s)',...
    'Time (s)','Time (s)','Time (s)'}';
parameters = parameters';

% make some new plots 
figure('Name',filename)
for j = 1:length(parameters)
    subplot(3,3,j)
    plot(results(j,2:11),'k*')
    xlabel('Frequency Band')
    ylabel(ylabelcell{j})
    title(parameters{j})
    xticks(1:length(bands)-1);
    xticklabels(bands(2:11));
    grid(gca,'minor')
end

