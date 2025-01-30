function [result, bandsOut, col_names] = acousticParams( rir, vars )
%   By Alex Southern.
%   Calculate ISO 3382 Octave Band Acoustic Parameters.
%   OR
%   Calculate Third-Octave Band Acoustic Parameters.
%
%   rir is a n x m matrix of room impulse responses, where n is the number
%   of signals and m is the number of samples in each signal.
%   vars is a structure will the following possible fields:
%
%   Required Fields
%       vars.fs                    : Sampling Rate (Hz)
%   Optional Fields, [] indicates default
%       vars.bandwidth             : ['one-octave'] or 'third-octave' 
%       vars.bands                 : centre frequencies of the desired,
%                                       default is all bands. 
%       vars.signaltype            : ['real'] or 'modelled'
%       vars.params                : [{'T20','T30','T40','EDT','C50',...
%                                               'C80','CT','D50','D80'}]
%       vars.plot                  : 'none' or [{'T20','T30','T40','EDT','C50',...
%                                               'C80','CT','D50','D80'}]
%       vars.outputOrientation     : ['band'] or 'signal'
%
%   Do not create a field in order to use its default parameter.  
%
%   Very Basic Usage: Calculate all parameters for all octave-bands.
%   vars.fs = 48000;
%   result = acousticParams( rir,vars );   
%
%   Basic Usage: Calculate all parameters for two one-third octave bands.
%   vars.fs = 48000;
%   vars.bands = {'1000','2000'};
%   vars.bandwidth = {'one-third'};
%   result = acousticParams( rir,vars );   
%
%   If you use this function in your publication results please give 
%   appropriate reference or acknowledgment.
%
%   By Alex Southern
%   Virtual Acoustic Team
%   Department of Media Technology
%   Aalto University 
%   Otaniemi
%   Espoo, 47001
%   Finland
%
%   Thanks to Bruno S. Masiero - This script has been 
%   heavily adpated from chuparam. www.mathworks.com/matlabcentral/....
%                        fileexchange/11392-acmus-room-acoustic-parameters
%
%   Thanks to Aslak Grinsted for Subaxis
%   http://www.mathworks.com/matlabcentral/fileexchange/3696


if isfield(vars,'fs') == 0
    error('msgId:msg','There must be a sampling rate.');
end

if isfield(vars,'bandwidth') == 0
    % assume octave band is desired
    vars.bandwidth = 'one-octave'; 
    % Other options: 'third-octave'
else
    if strcmp(vars.bandwidth,'third-octave') == 0 && strcmp(vars.bandwidth,'one-octave') == 0
        error('msgId:msg','The specified bandwidth was not recognized. \n\n Options [one-octave | third-octave].');
    end
end

if isfield(vars,'bands') == 0
    % Assume all bands are desired
    if strcmp(vars.bandwidth,'one-octave') == 1
        % Compute Params for all Octave bands
        fc = 1000 * 2.^[-4 -3 -2 -1 0 1 2 3];
    else        
        % Compute Params for all One-Third Octave bands
        fc = (1000).*((2^(1/3)).^[-10:12]);
        fc = fc(fc < vars.fs/2.5);        
    end
    
    for i = 1:length(fc)
        vars.bands{i} = [num2str(fc(i))];
    end
    vars.bands{length(fc)+1} = 'A';
    vars.bands{length(fc)+2} = 'C';
    vars.bands{length(fc)+3} = 'L';    
end

bandsOut = vars.bands;

if isfield(vars,'signaltype') == 0
    % Assume signal was measured with a real microphone 
    % (and includes noise floor in last 10% of signal)
    vars.signaltype = 'real';
    % Other options: 'modelled'
else
    if strcmp(vars.signaltype,'real') == 0 && strcmp(vars.signaltype,'modelled') == 0
        error('msgId:msg','The specified signal type was not recognized. \n\n Options [real | modelled].');
    end    
end

valid_params = {'T20','T30','T40','EDT','C50','C80','CT','D50','D80'};
if isfield(vars,'params') == 0
    % Assume all params are desired
    vars.params = valid_params; 
else
    % Throw error if any params are not recognized
    for i = 1:length(vars.params)
        found = find( strcmp(vars.params{i},valid_params) ); 
        if isempty( found ) == 1
            error('msgId:msg',['The specified acoustic parameter ' vars.params{i} '  is not recognized \n\n Options [T20|T30|T40|EDT|C50|C80|CT|D50|D80]']);
        end
    end    
end

vars.doplot = true; 
if isfield(vars,'plot') == 0
    % Assume all params are desired
    vars.plot = valid_params; 
    % Other Option:  'none'
else
    % Throw error if any params are not recognized
    if iscell(vars.plot) == 0
        if strcmp(vars.plot,'none') == 0
            error('msgId:msg',['The specified plot parameter ' vars.params...
                '  is not recognized. \n Note that acoustic parameters '...
                'must be specified in a cell string array. \n\n Options '...
                '[none|T20|T30|T40|EDT|C50|C80|CT|D50|D80]']);
        else
            vars.doplot = false;
        end
    else    
        for i = 1:length(vars.plot)
            found = find( strcmp(vars.plot{i},valid_params) ); 
            if isempty( found ) == 1
                error('msgId:msg',['The specified plot parameter ' ...
                    vars.params{i} '  is not recognized. Note that parameter '...
                    '"none" must be specified as vars.params = "none" \n\n '...
                    'Options [none|T20|T30|T40|EDT|C50|C80|CT|D50|D80]']);
            end
        end
    end
end

if isfield(vars,'outputOrientation') == 0
    % Assume that the output should be organized by band
    vars.outputOrientation = 'band'; %'signal'
else
    if strcmp(vars.outputOrientation,'band') == 0 && strcmp(vars.outputOrientation,'signal') == 0
       error('msgId:msg','The specified output orientation was not recognized. \n\n Options [band | signal].');
    end    
end

[numRIRs tmp] = size(rir);
if tmp < numRIRs
    warning('There appears to be more signals than there are samples, transposing rir...');
    rir = rir';
    [numRIRs tmp] = size(rir);
end

% Line Style Color
ls = {'k','k','r','g','b'};

for i = 1:numRIRs
    
    IR = rir(i,:);

    % Bandpass filter the input signal
    bnd = bandFilter( IR,vars );
    
    % Identify Noise floor in each band
    [numSamples numBands] = size( bnd );
    if strcmp( vars.signaltype,'real' ) == 1 
        % Get last 10% of signal in each band, assume this is the noise floor.
        signalNoise = bnd( round(0.9*numSamples):end,: );
        RMS = mean( signalNoise.^2 );
    else
        RMS( 1:numBands ) = 0;
    end

    if vars.doplot == true
          
        if strcmp(vars.outputOrientation,'signal') == 1 
            numFigs = numBands;
        else
            numFigs = numRIRs;
        end 

        valid_subplotsize = false;
        inc = 0;
        while valid_subplotsize == false
            fL = ceil(sqrt(numFigs)); 
            fW = floor(sqrt(numFigs)) + inc;
            if fL*fW < numFigs
                %not enough subplots
                valid_subplotsize = false;
            else
                valid_subplotsize = true;
            end
            inc = inc+1;
        end            
        
    end
    
    % Calculate Acoustic Parameters
    for n = 1:numBands
        startId = signalStart(bnd(:,n)); %find starting index of signal
        aux = (bnd(startId:end,n).^2) - RMS(n);   % substract noise floor from signal energy
        [enrg] = energyCalc(aux,vars);
        [rev] = reverberationCalc(aux,vars);
        
        % Get title of band response
        if isempty(str2num(vars.bands{n})) == 1
            titlestr = [vars.bands{n} ' Weighting']; % A C or L
        else
            titlestr = [vars.bands{n} ' Hz']; % Frequency Band
        end
        
        % Construct output table
        if strcmp(vars.outputOrientation,'signal')
            %  Sort Output by Signal 
            col_names{n} = titlestr;
            [T(:,n,i) row_names] = params2table(enrg,rev,vars);
        else
            %  Sort Output by frequency bands 
            row_names{i} = ['RIR ' num2str(i)];
            [T(:,i,n) col_names] = params2table(enrg,rev,vars);
        end
        
        
        % Plot Response
        if vars.doplot == true
            % Time scale in seconds
            x = (0:length(rev.E)-1)/vars.fs;             
            
            if strcmp(vars.outputOrientation,'signal') == 0            
                % Place multiple signals one figure window for a single
                % frequency band.
                figure(n);
                subaxis(fL,fW,i,'Spacing',0,'Margin',0.05);
            else
                % Place multiple frequency bands on one figure window for a 
                % single signal.
                figure(i);
                subaxis(fL,fW,n,'Spacing',0,'Margin',0.05);
            end
            
            % Plot Shroeder Curve
            plot(x,rev.E,'LineWidth',1.5);
            
            ylim([-70 0]);
            ylimit = ylim;
            xlabel('Time (s)'), ylabel('dB')
            if isfield(rev,'T20') == 1
                t20 = rev.T20;
            else
                t20 = 0;
            end
            if isfield(rev,'T30') == 1
                t30 = rev.T30;
            else
                t30 = 0;
            end
            if isfield(rev,'T40') == 1
                t40 = rev.T40;
            else
                t40 = 0;
            end
            
            if sum([t20 t30 t40]) > 0
                xlim([0 max([t20 t30 t40])*1.1]);
            end
            
            xlimit = xlim;
            
            hold on;
    
            % Plot Desired Acoustic Parameters
            names = vars.plot;
            legendnames = {'Shroeder Curve'};
            
            % Plot Reverberation Time based Parameters
            for k = 1:4
                switch k 
                    case 1
                        str = 'EDT';
                        if isfield(rev,str) == 1
                            res = rev.EDT;
                        end
                    otherwise
                        str = ['T' num2str(k) '0'];
                        if isfield(rev,str) == 1
                            res = eval(['rev.' str]);
                        end
                end                         
                        
                if isfield(rev,str) == 1
                    if sum(strcmp(names,str)) == 1
                        try
                            line([0,(-60-rev.A(k))/(rev.B(k))],[rev.A(k),-60],'Color',ls{k},'LineWidth',.5);
                            legendnames{end+1} = [str ' (ms) ' num2str(res*1000)]; 
                        catch
                        end
                    end
                end
            end
            
            % Plot Energy based Parameters
            energystr = ' ';
            if isempty(enrg) == 0
                              
                if sum(strcmp(vars.plot,'D50')) == 1 && isfield(enrg,'D50') == 1
                    energystr = [energystr 'D_5_0 ' num2str(enrg.D50) ' |'];
                end
                if sum(strcmp(vars.plot,'D80')) == 1 && isfield(enrg,'D80') == 1
                    energystr = [energystr 'D_8_0 ' num2str(enrg.D80) ' |'];
                end
                if sum(strcmp(vars.plot,'C50')) == 1 && isfield(enrg,'C50') == 1
                    energystr = [energystr 'C_5_0 ' num2str(enrg.C50) ' |'];
                end
                if sum(strcmp(vars.plot,'C80')) == 1 && isfield(enrg,'C80') == 1
                    energystr = [energystr 'C_8_0 ' num2str(enrg.C80) ' |'];
                end
                if sum(strcmp(vars.plot,'CT')) == 1 && isfield(enrg,'CT') == 1
                    energystr = [energystr 'CT ' num2str(enrg.CT) ' |'];
                end     
            end
            
         
            % The title is placed as text to save space, the energy based 
            % params are given after the title (if any).
            text((xlimit(2) - xlimit(1))*0.05,-55,[titlestr energystr]);  
            
            legend(legendnames);
            
            % Plot 60 dB Threshold Line
            line([xlimit(1),xlimit(2)],[-60,-60],'Color',[.4,.4,.4],'LineWidth',.5);
            
            hold off;
        end        
    end
end

result = T ;

function [T row_names] = params2table(enrg,rev,vars)
id = 1;

if isempty(enrg) == 0
    names = fieldnames(enrg);
    if sum(strcmp(names,'D50')) == 1
        T(id) = enrg.D50; row_names{id} = 'D50'; id = id+1;
    end
    if sum(strcmp(names,'D80')) == 1
        T(id) = enrg.D80; row_names{id} = 'D80'; id = id+1;
    end
    if sum(strcmp(names,'C50')) == 1
        T(id) = enrg.C50; row_names{id} = 'C50'; id = id+1;
    end
    if sum(strcmp(names,'C80')) == 1
        T(id) = enrg.C80; row_names{id} = 'C80'; id = id+1;
    end
    if sum(strcmp(names,'CT')) == 1
        T(id) = enrg.CT; row_names{id} = 'CT'; id = id+1;
    end
end

if isempty(rev) == 0
    names = fieldnames(rev);
    if sum(strcmp(names,'EDT')) == 1
        T(id) = rev.EDT; row_names{id} = 'EDT'; id = id+1;
    end
    if sum(strcmp(names,'T20')) == 1
        T(id) = rev.T20; row_names{id} = 'T20'; id = id+1;
    end
    if sum(strcmp(names,'T30')) == 1
        T(id) = rev.T30; row_names{id} = 'T30'; id = id+1;
    end
    if sum(strcmp(names,'T40')) == 1
        T(id) = rev.T40; row_names{id} = 'T40';
    end
end

function [idx] = signalStart(impulse)

mx = find(abs(impulse) == max(abs(impulse))); % find peak
energy = (impulse/impulse(mx(1))).^2; % normalize and square

aux = energy(1:mx(1)-1);
idx = mx(1);
if any(aux > 0.01)   % 1 percent
    idx = min(find(aux > 0.01));
    aux = energy(1:idx-1);
end