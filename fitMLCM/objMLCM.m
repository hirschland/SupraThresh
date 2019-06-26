function lL = objMLCM(stim,resp,ps,model,display)
%objMLCM(stim,resp,ps,model,plotting)
%
% The objective function, which calculates the log likelihood of a
% perceptual scale (and sigma) given the response pattern of an observer to
% a set of stimuli.
%
% STIM - the list of trials, each encoding the physical scale levels for
%			a pair of stimuli, [LA RA LB RB]
% RESP - a binary coding that the observer selected either the left [0] or
%			right [1] pair as having the highest perceptual response
% PS	 - the perceptual scale (which is in logit space), with sigma in
%			the last position (which is in log space)
% MODEL - fit to the independent ('ind'), additive ('add'), or saturated
%           ('sat') models of conjoint measurement
% DISPLAY - binary, decide whether to plot the current model estimate
%           during the optimisation
%
% For reference, please see pp.237-238 of Knoblauch and Maloney, 2012
% ===============================================================
% Code by: Joshua Harvey, University of Oxford (UK)
% joshua.harvey@pmb.ox.ac.uk
% ===============================================================
pn = max(stim,[],'all'); % get number of levels in parameter space
ps(1) = 0; % fix to 0

if strcmp(model,'add') % for additive model
	ps(2:end,2:end) = ps(2:end,1) + ps(1,2:end);
elseif strcmp(model,'ind') % for independent model
	ps = repmat(ps(:,1),[1,pn]);
end % otherwise assume saturated model

del = ps(sub2ind([pn pn],stim(:,4),stim(:,2))) -... % calculate del function
	ps(sub2ind([pn pn],stim(:,3),stim(:,1)));

lL = - ( sum( log(normcdf(del(resp==1)))) +...
	sum( log(1-normcdf(del(resp==0))) ) ); % log likelihood

if display
	if strcmp(model,'sat')
		figure(1);
		plot(ps(1:length(ps)/2),'o-'), hold on,
		plot(ps(1+length(ps)/2:end),'o-'), hold off,
	end
end

end
