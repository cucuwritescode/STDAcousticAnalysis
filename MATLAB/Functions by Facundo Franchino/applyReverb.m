function applyReverb(cleanFile, irFile, outputFile)
%it applies reverb using a stereo IR on a clean recording (ideally anechoic)
%written by Facundo Franchino
    %how to use?
    %applyReverb('steeltongue_anechoic.wav', 'tunnel_IR.wav', 'output.wav')
    %
    %inputs:
    %-cleanfile: path to the clean (an cx echoic) audio file (mono or stereo)
    %-IRfile: path to the stereo IR file
    %-outputfile: name of the output file (default: 'convolved_audio.wav')
    %
    %output:
    %-saves the convolved audio as a stereo .wav file.
    %default output file name if not provided
    if nargin < 3
        outputFile = 'convolved_audio.wav';
    end
    %load clean/anechoic recording
    [cleanAudio, fsClean] = audioread(cleanFile);
    %load stereo IR
    [irAudio, fsIR] = audioread(irFile);
    %check if the sampling rates match
    if fsClean ~= fsIR
        error('Sampling rates of clean audio and IR do not match!');
    end
    %perform stereo convolution
    outputLeft = conv(cleanAudio, irAudio(:, 1));%convolve with L IR channel
    outputRight = conv(cleanAudio, irAudio(:, 2));%convolve with R IR channel
    %combine into stereo
    outputStereo = [outputLeft, outputRight];
    %normalise to avoid clipping
    outputStereo = outputStereo / max(abs(outputStereo(:)));
    %save convolved audio
    audiowrite(outputFile, outputStereo, fsClean);
    %play the convolved audio
    sound(outputStereo, fsClean);
    %display success message (enhorabuena jeje)
    fprintf('convolved audio saved as: %s\n', outputFile);
end
