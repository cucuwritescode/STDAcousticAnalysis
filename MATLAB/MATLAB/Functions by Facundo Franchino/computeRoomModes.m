function modeFrequencies = computeRoomModes(c, L, W, H, maxOrder)
    %computeRoomModes: calculates room mode frequencies for a rectangular space
    %written by Facundo Franchino
    %IN:
    %   c-speed of sound (m/s)
    %   L, W, H- room dimensions (mts)
    %   maxOrder-max order of modes to calculate
    %OUT:
    %modeFrequencies-sorted matrix of modal frequencies and mode indices [f,n,p,q]

    %init arrays modes and frequency storage
    modeList = [];
    
    %loop through mode indices up to maxOrder
    for n = 0:maxOrder
        for p = 0:maxOrder
            for q = 0:maxOrder
                %calculate mode freq using standing wave equation
                f = (c / 2) * sqrt((n / L)^2 + (p / W)^2 + (q / H)^2);
                
                %avoid 0,0,0 which has freq 0
                if f > 0
                    modeList = [modeList; f, n, p, q];
                end
            end
        end
    end

    %sort frequencies in ascending order
    modeFrequencies = sortrows(modeList, 1);
end