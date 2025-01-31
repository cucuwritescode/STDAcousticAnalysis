function plotRoomModes(modeFrequencies, roomDimensions)
    %plotRoomModes: visualises the room mode frequencies
    %IN:
    %modeFrequencies - matrix [f, n, p, q] of mode frequencies
    %roomDimensions- str for title ('24m x 4.57m x 2.42m')

    %extract only the frequencies
    frequencies = modeFrequencies(:, 1);
    
    %assign y-values based on mode type for better spacing
    yValues = zeros(size(frequencies));
    
    for i = 1:size(modeFrequencies, 1)
        n = modeFrequencies(i, 2);
        p = modeFrequencies(i, 3);
        q = modeFrequencies(i, 4);

        %give axial, tangential, and pblique different heights
        if (n > 0 && p == 0 && q == 0) || (n == 0 && p > 0 && q == 0) || (n == 0 && p == 0 && q > 0)
            yValues(i) = 9; %axial (strongest modes)
        elseif (n > 0 && p > 0 && q == 0) || (n > 0 && q > 0 && p == 0) || (p > 0 && q > 0 && n == 0)
            yValues(i) = 6; %tangential (mid strength)
        else
            yValues(i) = 3; %oblique(weakest modes)
        end
    end

    %create stem plot
    figure;
    stem(frequencies, yValues, 'o', 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'b', 'LineWidth', 1);

    %format plot
    xlabel('Frequency (Hz)');
    ylabel('Relative Magnitude (dB)');
    title(['Underpass Tunnel of ', roomDimensions], 'FontWeight', 'bold');
    grid on;
    
    %frequency limits
    xlim([0 250]); 
    ylim([0 10]);
end