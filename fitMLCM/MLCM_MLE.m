function [Estimate,ExitFlag,Likelihood]=MLCM_MLE(stim,resp,model,display)
%[Estimate,ExitFlag]=MLCM_MLE(stim, resp, model, display);
%
% Find the optimal perceptual scaling of stimuli given the responses of an
% observer to a list of trials, by Maximum Likelihood Estimation.
%
% STIM - the list of trials, each encoding the physical scale levels for
%			a pair of stimuli, [LA RA LB RB]
% RESP - a binary coding that the observer selected either the left [0] or
%			right [1] pair as having the highest perceptual response
% DISPLAY - binary, decide whether to plot the current model estimate
%           during the optimisation
% ESTIMATE - the optimal perceptual scale estimate found by MLE. The last
%				value is sigma.
% LIKELIHOOD - the neg log likelihood of the model given the data.
%
% For reference, please see Chapter 8 of Knoblauch and Maloney, 2012
% ===============================================================
% Code by: Joshua Harvey, University of Oxford (UK)
% joshua.harvey@pmb.ox.ac.uk
% ===============================================================

pn = max(stim,[],'all'); % get number of levels in parameter space
if display
		disp = 'iter';
	else
		disp = 'off';
end
	
options = optimoptions(@fmincon,'Algorithm','interior-point','Display',disp,...
		'MaxFunctionEvaluations',3000,'StepTolerance',1e-4);
	
fitfun = @(ps)objMLCM(stim, resp, ps, model, display);

% specify initial parameters (these don't matter)
p0 = zeros(pn,pn);
	
[Estimate,Likelihood,ExitFlag]  = fmincon(fitfun, p0,[],[],[],[],[],[],[],options);

end