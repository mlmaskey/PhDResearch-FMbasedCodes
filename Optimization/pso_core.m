function best = pso_core(prgm, psopar, data)


% The input-output parameters are:
%		
%		prgm -		Fractal-Multifractal model
%		nparam -	Number of parameters
%		data -		Input data set
%		best -		Set of best parameters
%
model.lowlimit =  psopar.lowlimit; % set lower and upper bounds (may be modified)
model.upperlimit = psopar.upperlimit;

% PSO options
opfun.prgm = prgm;
opfun.data = data;
opfun.prior.model = []; % to introduce the mean
opfun.prior.niter = 2; % to force the prior enters into the swarm each niter
options.inversion.modellog = 0 ; %log or no log data
opfun.IterFile = psopar.IterFile;
opfun.psoParFile = psopar.psoParFile ;

% PSO parameters
options.pso.ccontrol = 0; % delta control of coordinates 1: YES
options.pso.cdelta = 0.5; % deltat for control
options.pso.proyection = 'near';   %'far' 'rebond' kind of proyection over search space
% opcpso = pso_create_param;
% options.pso = opcpso;

%
%--------------------------------------------------------------
% CUSTOMIZE HERE size and algorithm
%--------------------------------------------------------------
%

options.pso.esquema = 'PSO';
options.pso.size    =  psopar.size ; % number of particles in each iteration 50
options.pso.elitism =    0 ; % 0: explorative; 1: exploitative
options.pso.maxiter =   psopar.maxiter ; % this may be changed...
opfun.TolPso = psopar.TolPso;
% deltat options
options.pso.deltat1 =  1.4 ;
options.pso.deltat2 =  0.8 ; % for testing CP
options.pso.niter   =  1   ;

%
%--------------------------------------------------------------
% magic stuff
%--------------------------------------------------------------
%

opfun.norm = psopar.norm;
switch options.pso.esquema
    case 'PSO'
        options.pso.cloud = 'yes';
        disp('loading cloud_PSO.mat');
        load('cloud_PSO.mat');
        npoints = size(w_al_ag,1);
        prow = randperm(npoints);
        dat_w_al_ag = zeros(npoints,3);
        for i = 1:npoints
            dat_w_al_ag(i,1) = w_al_ag(prow(i),1); %w
            dat_w_al_ag(i,2) = w_al_ag(prow(i),2); %al
            dat_w_al_ag(i,3) = w_al_ag(prow(i),3); %ag
        end
        % charging the options structure
        options.pso.pso.inertia = dat_w_al_ag(:,1)';
        options.pso.pso.philocal = dat_w_al_ag(:,2)';
        options.pso.pso.phiglobal = dat_w_al_ag(:,3)';
    case 'CC'
        options.pso.cc.inertia = 0.5;
        options.pso.cc.philocal = 2.125; 
        options.pso.cc.phiglobal = 2.125;
    case 'CP'
        options.pso.cp.inertia = [0.9607,0.8770,0.7775,0.6571,0.5209,...
            0.3848,0.2068,0.0393,-0.1335,-0.3534];
        options.pso.cp.philocal = [0.2378,0.7135,1.0331,1.3684,1.6023,...
            1.7661,1.9922,2.1325,2.3431,2.5224]; 
        options.pso.cp.phiglobal = [0.4756,1.4269,2.0663,2.7368,3.2047,...
            3.5321,3.9844,4.2651,4.6861,5.0448];
end

options.inversion.seed = 'random';
[results] = pso_bypar(@shad_obj_fun,model,options,opfun);
%--------------------------------------------------------------------------
% saving results
%--------------------------------------------------------------------------
model.initial = results.parent; % for rebooting purposes (last model)
%--------------------------------------------------------------------------
[i,j] = min(results.error_hist);
best = results.historia(j,:) % print results on the diary... for condense.php
%


return