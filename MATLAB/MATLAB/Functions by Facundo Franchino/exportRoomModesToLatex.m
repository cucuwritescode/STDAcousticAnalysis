function exportRoomModesToLatex(modeFrequencies, filename)
    %exportRoomModesToLatex: exports room mode frequencies to a LaTeX table with classification
    %IN:
    %modeFrequencies-matrix [f, n, p, q] of mode frequencies
    %filename- output file name (e.g., 'room_modes.tex')

    %open file for writing
    fid = fopen(filename, 'w');

    %write latex table header
    fprintf(fid, '\\begin{table}[h]\n');
    fprintf(fid, '\\centering\n');
    fprintf(fid, '\\begin{tabular}{|c|c|c|c|}\n');
    fprintf(fid, '\\hline\n');
    fprintf(fid, 'Frequency (Hz) & Mode (n,p,q) & Type & Mode Strength \\\\\n');
    fprintf(fid, '\\hline\n');

    %loop through mode frequencies and write to file
    for i = 1:size(modeFrequencies, 1)
        %extract mode indices
        n = modeFrequencies(i, 2);
        p = modeFrequencies(i, 3);
        q = modeFrequencies(i, 4);

        %classify mode type
        modeType = classifyMode(n, p, q);

        %rstimate mode strength (lower modes are stronger)
        modeStrength = 1 / (1 + n + p + q); 

        %write row to LaTeX file
        fprintf(fid, '%0.2f & (%d,%d,%d) & %s & %0.2f \\\\\n', ...
            modeFrequencies(i, 1), n, p, q, modeType, modeStrength);
        fprintf(fid, '\\hline\n');
    end

    %write LaTeX table footer
    fprintf(fid, '\\end{tabular}\n');
    fprintf(fid, '\\caption{Computed Room Mode Frequencies with Classification and Strength}\n');
    fprintf(fid, '\\label{tab:room_modes}\n');
    fprintf(fid, '\\end{table}\n');

    %close file
    fclose(fid);

    fprintf('LaTeX table saved as %s\n', filename);
end

%function to classify modes
function modeType = classifyMode(n, p, q)
    if (n > 0 && p == 0 && q == 0) || (n == 0 && p > 0 && q == 0) || (n == 0 && p == 0 && q > 0)
        modeType = 'Axial';
    elseif (n > 0 && p > 0 && q == 0) || (n > 0 && q > 0 && p == 0) || (p > 0 && q > 0 && n == 0)
        modeType = 'Tangential';
    else
        modeType = 'Oblique';
    end
end