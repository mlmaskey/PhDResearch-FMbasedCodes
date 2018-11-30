function [results] = pso_bypar(funobj,model,opciones,opfun)
%..........................................................................
%AIM: a particle swarm family optimizer to solve an inverse problem
%
% Input:
%   funobj	: objective function
%   model	: model parameters after formatting
%   data	: data structure
%   opciones	: inverse options structure
%   opfun	: problem-dependent parameter structure
%   prgm	: a bunch of stuff introduced by jason2
%		  gets passed to initial_swarm and fobj_fractal
% Output:
%   results	: results structure
%SINTAXIS
%..........................................................................
%   [results]=psoves(funobj,modelo,datos,opciones,opfun)
%..........................................................................
% parambar = [];
rand('state',sum(100*clock));

% PSO parameters
prgm  = opfun.prgm;
data = opfun.data;
oppso = opciones.pso;
esquema = oppso.esquema;
talla = oppso.size;
maxiter = oppso.maxiter;
proyection = oppso.proyection;
elitism = oppso.elitism;
ccontrol = oppso.ccontrol;
cdelta = oppso.cdelta;
TolPso = opfun.TolPso;
IterFile = opfun.IterFile;
psoParFile = opfun.psoParFile;
% kind of seed

    
seed = opciones.inversion.seed;
%
distmed = [];
inter = [];
nmejoras = [];
leader.inercia = [];
leader.aclocal = [];
leader.acglobal = [];
leader.deltat = [];
%..........................................................................
%					   Search space
%..........................................................................

% low and upper limits in  row format

lowlimit = model.lowlimit;
upperlimit = model.upperlimit;
nparam = length(lowlimit);
pasot1 = opciones.pso.deltat1*ones(talla,nparam);
pasot2 = opciones.pso.deltat2*ones(talla,nparam);
niter = opciones.pso.niter;

% parámetros numéricos
% PSO parameters

switch esquema
    case 'PSO'
        disp('EXECUTING PSO');
        inercia = oppso.pso.inertia;
        aclocal = oppso.pso.philocal;
        acglobal = oppso.pso.phiglobal;
    case 'CC'
        disp('EXECUTING CC');
        inercia = oppso.cc.inertia;
        aclocal = oppso.cc.philocal;
        acglobal = oppso.cc.phiglobal;
    case 'CP'
        disp('EXECUTING CP');
        inercia = oppso.cp.inertia;
        aclocal = oppso.cp.philocal;
        acglobal = oppso.cp.phiglobal;
end

% keeping a copy of the parameters

allinercia = inercia;
allaclocal = aclocal;
allacglobal = acglobal;

ninercia = length(inercia);

% adapting the constants to the size of the swarm

if ninercia==1
	inercia = inercia*ones(1,talla);
	aclocal = aclocal*ones(1,talla);
	acglobal = acglobal*ones(1,talla);
elseif talla> ninercia
	nveces = floor(talla/ninercia);
	sobrante = talla-ninercia*floor(talla/ninercia);
	iner = [];
	acl = [];
	acg = [];
	for k = 1:nveces
		prow = randperm(ninercia);
		iner = [iner inercia(prow)];
		acl = [acl aclocal(prow)];
		acg = [acg acglobal(prow)];
	end
	
	if sobrante>0
		prow = randperm(ninercia);
		iner = [iner inercia(prow(1:sobrante))];
		acl = [acl aclocal(prow(1:sobrante))];
		acg = [acg acglobal(prow(1:sobrante))];
	end
	
	inercia = iner;
	aclocal = acl;
	acglobal = acg;
	
%elseif talla < ninercia
	% we change randomly the parameters in each iteration
	% see on line 247 
end

% PLOTTING
message = sprintf('PSO: %%g/%g iterations, Iteration best fit = %%g.\n',maxiter);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inicialización de la población y de las velocidades
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isequal(seed,'given') && ~isempty(model.initial),
	swarm0 = model.initial; % has the same structure as model
	talla = size(swarm0,1);			  % initial swarm size
	% we put the prior into the first population
elseif isequal(seed,'random') || isempty(model.initial),
	 % Random generation on the search space: each model is written in a row of matrix swarm0
	 rango = upperlimit - lowlimit;
	 swarm0 = (ones(talla,1)*rango).*(rand(talla,nparam))+(ones(talla,1)*lowlimit);
	 disp('Initial random population generated');
else
end

% the prior model is cast into the swarm in a random position
if ~isempty(opfun.prior.model)
	index = floor(talla*rand(1));
	swarm0(index,:) = opfun.prior.model;
end
%
swarm = swarm0;
varmin = repmat(lowlimit,talla,1); %lowlimit matrix
varmax= repmat(upperlimit,talla,1); % upperlimit matrix

% Initial velocities
vel(1:talla,1:nparam) = zeros(talla,nparam);

% forwardproblem
rutina_directo = func2str(funobj);
problema_directo = ['[misfit]=' rutina_directo '(swarm,data,opciones,opfun,prgm);'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algoritmo iterativo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mejores_globales = [];
% the number of parameters for mejores_locales is nparam+1
% to keep the function value

mejores_locales = ones(talla,nparam+1)*NaN;
%

historia = [];
error_hist = [];
models_outmin = [];
models_outmax = [];
error_iter = [];
fittest = [];

% iteration
sinmejora = 0; %number of iterations without improving
itercheck = 1;
if exist(IterFile) == 2
    bestobj = load(IterFile);
else
    bestobj = [];
end
for iter = 1:maxiter
	historia = [historia;swarm];
	%%%%%%%%%%%% forward solution
	eval(problema_directo);
	% we keep the predicted data for further statistics
	% realmisfit is the prediction misfit
	realmisfit = misfit;
	error_hist = [error_hist realmisfit];
	%
	% local best initialisation
	%
	if isequal (iter,1)
		local_bestval = misfit;
		valorf0 = misfit;
		columnas = size(valorf0, 2);
		if columnas==1
			valorf0 = valorf0';
		end
		mejores_locales = [swarm0 valorf0'];
		mod_sinmejora = [1:talla];
		mejoras_iter = [];
		[gbest_val,mejor] = min(misfit);
		gbest = swarm0(mejor,:);
		error_iter(1) = realmisfit(mejor);
	else
		[mejoras_iter] = find(local_bestval>misfit);
		nmejoras = [nmejoras length(mejoras_iter)];
		% gbest search (minimum problem: minimize the error)
		[iter_bestval,mejor] = min(misfit);
	   % changing the gbest
		if (iter_bestval-gbest_val) < 0
			% improving: we change the global optimum
			gbest_val = iter_bestval;
			gbest = swarm(mejor,:)
            if exist (psoParFile) == 2
                dlmwrite(psoParFile, gbest, 'delimiter', ',', '-append');
            else
                dlmwrite(psoParFile, gbest, 'delimiter', ',');
            end
			mejores_globales = [mejores_globales; [gbest,iter_bestval]];
			% we keep the history fittest
			fittest = [fittest; gbest]; % best individual
			sinmejora = 0;
		else %local
			sinmejora = sinmejora+1;
			mejores_globales = [mejores_globales; [gbest,gbest_val]];
		end
		error_iter(iter) = realmisfit(mejor);
		% those which are improved are automatically actualize
		local_bestval(mejoras_iter) = misfit(mejoras_iter);
		
		gbest % print best value at the end
	end
    
	% median distance of the swarm to the center of gravity
	dismk = median(norm(swarm-repmat(gbest,talla,1)))/norm(gbest);
	distmed = [distmed;dismk];
	if iter >1
		leader.inercia = [leader.inercia, inercia(mejor)];
		leader.aclocal = [leader.aclocal, aclocal(mejor)];
		leader.acglobal = [leader.acglobal, acglobal(mejor)];
	end
	
	% we change the paremeters at each iteration if talla< ninercia (200 in
	% this case)
	if talla < ninercia
		prow = randperm(ninercia);
		inercia = allinercia(prow(1:talla));
		aclocal = allaclocal(prow(1:talla));
		acglobal = allacglobal(prow(1:talla));
	end
	%
	mejores_locales(mejoras_iter,1:end-1) = swarm(mejoras_iter,:); %
	mejores_locales(mejoras_iter,end) = local_bestval(mejoras_iter); %their misfit
	[iter_bestval,mejor] = min(misfit);
	%
	if isequal(elitism,0) %non elitist (more exploration)
		gbest = swarm(mejor,:);  % mejor global en la iteración iter
	end
	%
	gbest_val = iter_bestval;
% 	bestpos(iter,1:nparam+1) = [gbest,iter_bestval];
	
	% random coefficients for acceleration (different for each parameter of
	% each individual)
	rannum1 = rand(talla,nparam);
	rannum2 = rand(talla,nparam);
	
	% local and global accelerations
	aclocal1 = rannum1.*repmat(aclocal(:),1,nparam);
	acglobal2 = rannum2.*repmat(acglobal(:),1,nparam);
	
	% putting these variables on row format
	relajacion = repmat(inercia(:),1,nparam);
	localbest = mejores_locales(:,1:end-1); %the last column is the misfit
	
	% lime and sand algorithm
	if rem(iter,niter)==0
		pasot = pasot2; %change to pasot2
	else
		pasot=pasot1;
	end
	
	% CC uses two different leader iterations
	if isequal(esquema, 'CC') & iter>1
		% second part on velnew that is calculated on the 
		% next iteration with new acloal1,aclocal2,etc
		ter2 = coef2.*aclocal1.*(localbest-swarm);
		ter3 = coef2.*acglobal2.*(repmat(gbest,talla,1)-swarm);
		newpart = newpart + ter2 + ter3;
		vel = newpart;
	elseif isequal(esquema, 'CC') & iter==1
		newpart = zeros(talla,nparam); %initialised to zero
	end
	
	% algorithm
	if isequal(esquema, 'PSO')
		termino1 = vel.*(1+(relajacion - 1).*pasot);
		termino2 = aclocal1.*(localbest - swarm).*pasot;
		termino3 = acglobal2.*(repmat(gbest,talla,1) - swarm).*pasot;
		velnew = termino1 + termino2 + termino3;
		vel = velnew;
	elseif isequal(esquema, 'CC')
		% first part of newpart which is going to be use in the next
		% iteration. This has to be calculated first to update vel!!
		coef1 = (2+(relajacion-1).*pasot)./(2+(1-relajacion).*pasot);
		termino1 = vel.*coef1;
		%
		coef2 = pasot./(2+(1-relajacion).*pasot);
		termino2 = coef2.*aclocal1.*(localbest-swarm);
		%
		termino3 = coef2.*acglobal2.*(repmat(gbest,talla,1)-swarm);
		newpart = termino1+termino2+termino3;	 
		% calculate new swarm 
		t1 = vel.*(1+0.5*(relajacion-1).*pasot);
		t2 = 0.5*acglobal2.*(repmat(gbest,talla,1)-swarm).*pasot;
		t3 = 0.5*aclocal1.*(localbest-swarm).*pasot;
		vel = t1+t2+t3; %actualizacion de swarm	  
	elseif isequal(esquema, 'CP')
		if iter >1
			vel = velnew;
		else
			% initial vels are set to zero
		end
		coef1 = 1-(aclocal1+acglobal2).*pasot.^2;
		coef2 = (1+(1-relajacion).*pasot);
		termino1 = (coef1./coef2).*vel;
		coef1 = aclocal1.*(localbest-swarm).*pasot;
		termino2 = coef1./coef2;
		coef1 = acglobal2.*(repmat(gbest,talla,1)-swarm).*pasot;
		termino3 = coef1./coef2;
		velnew = termino1 + termino2 + termino3;
	end
	
	%
	% new population
	%
	
	swarm = swarm + vel.*pasot;
	if ~isempty(opfun.prior.model)& rem(iter,opfun.prior.niter)==0
		% I substitute one model random chosen
		index = ceil(talla*rand(1));
		if index > talla
			index = talla;
		end
		swarm(index,:) = opfun.prior.model;
	end
	% Proyection over search space
	vmin_away = swarm <= varmin;
	vmin_keep	  = swarm >  varmin;
	vmax_away = swarm >= varmax;
	vmax_keep	  = swarm <  varmax;
	
	% counting interior models
	parinterior = (swarm >= varmin) & (swarm <= varmax);
	aux = sum(parinterior');
	nvarin = length(find(aux==nparam));
	interior = nvarin/talla*100;
	fprintf('Percentage of interior models %f \n',interior);
	inter(iter) = interior;
	
	%
	% exterior particles: deltat damping
	%
	
	parexterior = (swarm <= varmin) | (swarm >= varmax);
	if isequal(ccontrol,1)
		pasot = parexterior*cdelta+(1-parexterior).*pasot;
	end
	%   Proyection method
	if	 isequal(proyection, 'near')
		swarm = (vmin_away.*varmin ) + (vmin_keep.*swarm );
		swarm = (vmax_away.*varmax ) + (vmax_keep.*swarm );
	elseif isequal(proyection, 'far')
		swarm = (vmin_away.*varmax ) + (vmin_keep.*swarm );
		swarm = (vmax_away.*varmin ) + (vmax_keep.*swarm );
	elseif isequal(proyection, 'bounce')
		swarm = (vmin_away.*varmin ) + (vmin_keep.*swarm );
		swarm = (vmax_away.*varmax ) + (vmax_keep.*swarm );
		vel = (vel.*vmin_keep) + (-vel.*vmin_away);
		vel = (vel.* vmax_keep) + (-vel.* vmax_away);
	else
		% no proyection
	end
	
	outmin = length(vmin_away);
	outmax = length(vmax_away);
	models_outmin = [models_outmin,outmin];
	models_outmax = [models_outmax,outmax];
	
	% The global best
	% Print result to screen
	fprintf(message,iter,iter_bestval);
	% updating results structure iteratively in case of divergence of 
	% the reservoir simulator
	results.historia = historia;
	results.fittest = fittest;
	results.localbest = localbest;
	
	% important: parent and parent0 are written in the format they had been
	% generated (for rebooting purposes)
	
	results.parent = swarm;
	results.parent0 = swarm0;
	%
	% first and last swarm are stored in the format they had been geneerated as
	% opciones.inversion.modellog indicates
	
	results.misfit = misfit;
	results.error_hist = error_hist;
	results.error_iter = error_iter;
	results.stat.nmejoras = nmejoras;
	results.stat.models_outmin = models_outmin;
	results.stat.models_outmax = models_outmax;
	results.stat.models_interior = inter;
	results.stat.distmed = distmed;
	results.stat.leader = leader;
    bestobj = [bestobj; iter iter_bestval];
    csvwrite(IterFile, bestobj);

    bestvalue(itercheck)= iter_bestval;
    if itercheck > 3
        ch(1) =  abs(bestvalue(itercheck-1) - bestvalue(itercheck));
        ch(2) =  abs(bestvalue(itercheck-1) - bestvalue(itercheck-2));
        ch(3) =  abs(bestvalue(itercheck-1) - bestvalue(itercheck-3));
        ch(4) =  abs(bestvalue(itercheck-2) - bestvalue(itercheck));
        ch(5) =  abs(bestvalue(itercheck-2) - bestvalue(itercheck));
        ch(6) =  abs(bestvalue(itercheck-2) - bestvalue(itercheck-3));
        ch(7) =  abs(bestvalue(itercheck-1) - bestvalue(itercheck-3));
        if ch <=  TolPso 
            disp(['Error converges at '  int2str(itercheck) 'th iteration'])
            return
        else 
        itercheck = itercheck + 1;
        end 
    else 
        itercheck = itercheck +1;
    end
end
return