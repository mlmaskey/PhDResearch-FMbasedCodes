function [ nparam ] = FMvariants_int( prgm )
%gives the number of paramters for each variants
%   prgm = FM variants
switch prgm
        case 1 
            nparam = 6; 
            disp('FM Model: Simple Wire through three interpolating points')
            disp(['Cutoff threshold at layer dy, ' int2str(nparam)...
                ' parameters'])
        case 2 
            nparam = 8; 
            disp('FM Model: Simple leaf with two maps')
            disp(['Cutoff threshold at layer dy, ' int2str(nparam)...
                ' parameters'])
        case 3 
            nparam = 6; 
            disp('FM Model: Simple Wire through three interpolating points')
            disp(['Cutoff threshold at layer dx, ' int2str(nparam)...
                ' parameters'])
        case 4 
            nparam = 8; 
            disp('FM Model: Simple leaf with two maps')
            disp(['Cutoff threshold at layer dx, ' int2str(nparam)...
                ' parameters'])
        case 10 
            nparam = 7; 
            disp('FM Model: Simple Wire through three interpolating points')
            disp(['Cutoff threshold at layer dy unboundy, '...
                int2str(nparam) ' parameters'])
        case 20 
            nparam = 9; 
            disp('FM Model: Simple leaf with two maps')
            disp(['Cutoff threshold at layer dy unboundy, '...
                int2str(nparam) ' parameters'])
        case 30 
            nparam = 7; 
            disp('FM Model: Simple Wire through three interpolating points')
            disp(['Cutoff threshold at layer dx unboundy, '...
                int2str(nparam) ' parameters'])
        case 40 
            nparam = 9; 
            disp('FM Model: Simple leaf with two maps')
            disp(['Cutoff threshold at layer dx unboundy, '...
                int2str(nparam) ' parameters'])
        case 13 
            nparam = 10; 
            disp('FM Model: Simple Wire through four interpolating points')
            disp(['Cutoff threshold at layer dy, ' int2str(nparam)...
                ' parameters'])
        case 23 
            nparam = 14; 
            disp('FM Model: Simple leaf with three maps')
            disp(['Cutoff threshold at layer dy, ' int2str(nparam)...
                ' parameters'])
        case 33 
            nparam = 10; 
            disp('FM Model: Simple Wire through four interpolating points')
            disp(['Cutoff threshold at layer dx, ' int2str(nparam)...
                ' parameters'])
        case 43 
            nparam = 14; 
            disp('FM Model: Simple leaf with three maps')
            disp(['Cutoff threshold at layer dx, ' int2str(nparam)...
                ' parameters']) 
        case 130 
            nparam = 11; 
            disp('FM Model: Simple Wire through four interpolating points')
            disp(['Cutoff threshold at layer dy unboundy, '...
                int2str(nparam) ' parameters'])
        case 230 
            nparam = 15; 
            disp('FM Model: Simple leaf with three maps')
            disp(['Cutoff threshold at layer dy unboundy, '...
                int2str(nparam) ' parameters'])
        case 330 
            nparam = 11; 
            disp('FM Model: Simple Wire through four interpolating points')
            disp(['Cutoff threshold at layer dx unboundy, '...
                int2str(nparam) ' parameters'])
        case 430 
            nparam = 15; 
            disp('FM Model: Simple leaf with three maps')
            disp(['Cutoff threshold at layer dx unboundy, '...
                int2str(nparam) ' parameters'])          
end

