function bnd = bandFilter(signal,vars)
% Performs filtering in octave bands, as recommended by IEC 61620 OR
% third-octave bands, depending on the specfication in vars.
% This function is intended to be called by acousticParams.m

fs = vars.fs;

% Convert centre frequencies from cell array to numerical array
k = 1;
for  i = 1:length(vars.bands)
    if strcmp(vars.bands{i},'A') == 0 && strcmp(vars.bands{i},'C') == 0 && strcmp(vars.bands{i},'L') == 0
        fc(k) = str2num(vars.bands{i});
        k = k + 1;
    end
end

% Order of butterworth filter
n = 3;  

if strcmp(vars.bandwidth,'third-octave') == 1
    % Third Octave
    for x = 1:length(fc)    
        try
            [b,a] = oct3dsgn(fc(x),fs,n);
            bnd(:,x) = filtfilt(b,a,signal);
        catch
            bnd(:,x) = 0;
        end
    end
else
    % Octave
    delta = inv(sqrt(2)*(sqrt(2)-1)^(1/2/n));   %Correcao para filtro causal
    aC = (delta+sqrt(delta^2+4))/2;
    if exist('fc') == 1
        for x = 1:length(fc)
            try
                [b,a] = butter(n,[fc(x)/(fs/2)/aC,fc(x)/(fs/2)*aC]);
                bnd(:,x) = filtfilt(b,a,signal);
            catch
                bnd(:,x) = 0;
            end
        end    
    end
end

if sum(strcmp(vars.bands,'A')) == 1
    %-------------A Weigthing-------
    f1 = 20.598997; 
    f2 = 107.65265;
    f3 = 737.86223;
    f4 = 12194.217;
    A1000 = 1.9997;
    NUMs = [ (2*pi*f4)^2*(10^(A1000/20)) 0 0 0 0 ];
    DENs = conv([1 +4*pi*f4 (2*pi*f4)^2],[1 +4*pi*f1 (2*pi*f1)^2]); 
    DENs = conv(conv(DENs,[1 2*pi*f3]),[1 2*pi*f2]);
    [B,A] = bilinear(NUMs,DENs,fs); 
    bnd(:,end+1) = filter(B,A,signal);
end

if sum(strcmp(vars.bands,'C')) == 1
    %-------------C Weigthing-------
    f1 = 20.598997; 
    f4 = 12194.217;
    C1000 = 0.0619;
    %pi = 3.14159265358979;
    NUMs = [ (2*pi*f4)^2*(10^(C1000/20)) 0 0 ];
    DENs = conv([1 +4*pi*f4 (2*pi*f4)^2],[1 +4*pi*f1 (2*pi*f1)^2]); 
    [B,A] = bilinear(NUMs,DENs,fs); 
    bnd(:,end+1) = filter(B,A,signal);
end

if sum(strcmp(vars.bands,'L')) == 1
    %-------------Linear Weigthing------------
    if exist('bnd') == 1
        bnd(:,end+1) = signal;
    else
        bnd = signal';
    end
end
