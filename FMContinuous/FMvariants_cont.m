function [ nparam ] = FMvariants_cont( prgm )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
switch prgm
        case 1 % wire
            nparam = 5; 
            disp(['FM Model: Simple Wire, ' int2str(nparam) ' parameters'])
        case 2 % leaf overlap
            nparam = 7;
            disp(['FM Model: Simple Leaf, ' int2str(nparam) ' parameters'])
        case 3 % general affine maps
            nparam = 9;
            disp(['FM Model: Two Affine Maps, ' int2str(nparam) ' parameters'])
        case 4 % wire loop nice
            nparam = 9;
            disp(['FM Model: Nice Loop Wires, ' int2str(nparam) ' parameters'])	
        case 5 % leaf loop nice
            nparam = 12; 
            disp(['FM Model: Nice Loop Leaves, ' int2str(nparam) ' parameters'])
        case 6 % wire loop general
            nparam = 11;
            disp(['FM Model: General Loop Wires, ' int2str(nparam) ' parameters'])	
        case 7 % leaf loop general
            nparam = 15; 
            disp(['FM Model: General Loop Leaves, ' int2str(nparam) ' parameters'])
        case 8 % two wires together
            nparam = 13; 
            disp(['FM Model: Two Wires Together, ' int2str(nparam) ' parameters'])	
        case 9 % two leaves together
            nparam = 15; 
            disp(['FM Model: Two Leaves Together, ' int2str(nparam) ' parameters'])	
        case 10 % semi-loop of two wires
            nparam = 11; 
            disp(['FM Model: Semi-Loop Wires, ' int2str(nparam) ' parameters'])
        case 11 % semi-loop of two leaves
            nparam = 15; 
            disp(['FM Model: Semi-Loop Leaves, ' int2str(nparam) ' parameters'])
        case 12 % pivoting wire 
            nparam = 6; 
            disp(['FM Model: Pivoting Wire, ' int2str(nparam) ' parameters'])
        case 13 % Pivoting Leaves
            nparam = 8; 
            disp(['FM Model: Pivoting Leaves, ' int2str(nparam) ' parameters'])
        case 14 % Pivoting Affine
            nparam = 10; 
            disp(['FM Model: Pivoting Affine, ' int2str(nparam) ' parameters'])
        case 21 % 3 Interpolating points with Simple wire
            nparam = 6; 
            disp(['FM Model: 3 Interpolating points with Simple wire ' int2str(nparam) ' parameters'])
        case 22 % 4 Interpolating points with Simple wire
            nparam = 9; 
            disp(['FM Model: 4 Interpolating points with Simple wire, ' int2str(nparam) ' parameters'])
        case 23 % 5 Interpolating points with Simple wire
            nparam = 12; 
            disp(['FM Model: 3 Interpolating points with Simple wire, ' int2str(nparam) ' parameters'])
        case 31 % wire
            nparam = 9; 
            disp(['FM Model: Simple Wire, ' int2str(nparam) ' parameters'])
        case 32 % leaf overlap
            nparam = 13;
            disp(['FM Model: Simple Leaf, ' int2str(nparam) ' parameters'])
        case 41 % Wire Loop constrained
            nparam = 7;
            disp(['FM Model: Leaf after Leaf constrained, ' int2str(nparam) ' parameters'])
        case 51 % Wire Loop constrained
            nparam = 10;
            disp(['FM Model: Leaf after Leaf constrained, ' int2str(nparam) ' parameters'])
        case 91 % Leaf after Leaf constrained
            nparam = 12;
            disp(['FM Model: Leaf after Leaf constrained, ' int2str(nparam) ' parameters'])
        case 100 % wire with two maps y unbound
            nparam = 6; 
            disp(['FM Model: Simple Wire with y unbound, ' int2str(nparam) ' parameters'])            
        case 101 % wire with fixed probability 
            nparam = 4;
            disp(['FM Model: Simple Wire with fixed probability, ' int2str(nparam) ' parameters'])
        case 102 % leaf overlap with reduced parameter 
            nparam = 3;
            disp(['FM Model: Simple Wire with reduced parameter, ' int2str(nparam) ' parameters'])
        case 103
            nparam = 3;
            disp(['FM Model: Simple Wire with reduced parameter, ' int2str(nparam) ' parameters'])
        case 105
            nparam = 4;
            disp(['FM Model: Simple Wire with reduced parameter, ' int2str(nparam) ' parameters']) 
        case 111
            nparam = 6;
            disp(['FM Model: Simple Wire with Tukey, ' int2str(nparam) ' parameters']) 
        case 112
            nparam = 7;
            disp(['FM Model: Simple Wire with Tukey and angle, ' int2str(nparam) ' parameters'])             
        case 131%nobj = (7+length(p))/4;[X:\Matlab_Mahesh\Jason_II\Dropbox\etc]
            nparam = 9;
            disp(['FM Model: Simple Wire with 3 maps, ' int2str(nparam) ' parameters'])         
        case  201 % wire with fixed probability 
            nparam = 4;
            disp(['FM Model: Simple Wire with fixed probability, ' int2str(nparam) ' parameters'])
        case 202 % leaf overlap with reduced parameter 
            nparam = 4;
            disp(['FM Model: Simple Leaf with reduced parameter, ' int2str(nparam) ' parameters'])
        case 203 % leaf overlap with reduced parameter 
            nparam = 4;
            disp(['FM Model: Simple Leaf with reduced parameter, ' int2str(nparam) ' parameters'])
        case 204 % leaf overlap with reduced parameter 
            nparam = 3;
            disp(['FM Model: Simple Leaf with reduced parameter, ' int2str(nparam) ' parameters'])
        case 205 % leaf overlap with reduced parameter 
            nparam = 4;
            disp(['FM Model: Simple Leaf with reduced parameter, ' int2str(nparam) ' parameters'])   
        case 211
            nparam = 8;
            disp(['FM Model: Simple Leaf with Tukey, ' int2str(nparam) ' parameters']) 
        case 212
            nparam = 9;
            disp(['FM Model: Simple Leaf with Tukey and angle, ' int2str(nparam) ' parameters'])                
        case 231
            nparam = 13;%nobj = (5+length(p))/6 [X:\Matlab_Mahesh\Jason_II\Dropbox\holes]
            disp(['FM Model: Simple Leaf with 3maps, ' int2str(nparam) ' parameters'])         
        case 1001 % wire
            nparam = 5; 
            disp(['FM Model: Simple Wire in parabolic coordinate, '...
                int2str(nparam) ' parameters'])   
        case 1310 % wire three maps y unbound
            nparam = 10; 
            disp(['FM Model: Simple Wire with three maps y unbound, ' int2str(nparam) ' parameters'])                       
        case 2310 % wire three maps y unbound
            nparam = 14; 
            disp(['FM Model: Simple Leaf with three maps y unbound, ' int2str(nparam) ' parameters'])     
end 

end

