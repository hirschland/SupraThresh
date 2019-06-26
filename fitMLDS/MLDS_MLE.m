function [Estimate,Likelihood] = MLDS_MLE(stim,resp,display)
%[Estimate,Likelihood] = MLDS_MLE(stim,resp,display)
%
% Find the optimal perceptual scaling of stimuli given the responses of an
% observer to a list of trials, by Maximum Likelihood Estimation.
%
% STIM - the list of trials, each encoding the physical scale levels for
%			a top pair and a bottom pair of stimuli, [T1 T2 B1 B2]
% RESP - a binary coding that the observer selected either the top [0] or
%			bottom [1] pair as having the most intra-pair difference
% DISPLAY - binary, decide whether to plot the current model estimate
%           during the optimisation
% ESTIMATE - the optimal perceptual scale estimate found by MLE. The last
%				value is sigma.
% LIKELIHOOD - the neg log likelihood of the model given the data.
%
% For reference, please see Chapter 7 of Knoblauch and Maloney, 2012
% ===============================================================
% Code by: Joshua Harvey, University of Oxford (UK)
% joshua.harvey@pmb.ox.ac.uk
% ===============================================================

pn = max(stim,[],'all'); % get number of levels

if display
	disp = 'iter';
else
	disp = 'off';
end

% options for optimisation, these may need to be changed (eg smaller steps)
options = optimoptions(@fmincon,'Algorithm','interior-point',...
	'Display',disp,'MaxFunctionEvaluations',3000,'StepTolerance',1e-4);

fitfun = @(ps)objMLDS(stim, resp, ps, display);

%define initial paramters for the optimisation (these don't matter)
p0 = linspace(0.1,.9,pn); % 'flat' prior
p0 = log(p0./(1-p0)); % convert to logit space, so estimates are -Inf<p<+Inf
sigma = log(2); % initial guess, doesn't matter, has to be +ve

ps0 = [p0 sigma];

[Estimate,Likelihood,~]  = fmincon(fitfun, ps0,...
							[],[],[],[],[],[],[],options);
						
Likelihood = -Likelihood;

% get estimate out of logit/ln space
Estimate = [0 1./(1+exp(-Estimate(2:end-2))) 1 exp(Estimate(end))];