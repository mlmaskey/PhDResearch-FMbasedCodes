function creatgrid(gx, gy, hv)
switch hv
    case 'v' || 'V'
        nx = numel(gx);
        for i = 1:nx
            plot([gx(i) gx(i)], [gy(1) gy(end)], '--', 'color', [0.25 0.25 0.25]);
        end
    case 'h' || 'H'
        ny = numel(gy);
        for i = 1:ny
            plot([gx(1) gx(end)], [gy(i) gy(i)], '--', 'color', [0.25 0.25 0.25]);
        end
end 