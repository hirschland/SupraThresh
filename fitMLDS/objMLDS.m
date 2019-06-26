function lL = objMLDS(stim,resp,ps,display)
%objMLDS(stim,resp,ps,plotting)
%
% The objective function, which calculates the log likelihood of a
% perceptual scale (and sigma) given the response pattern of an observer to
% a set of stimuli.
%
% STIM - the list of trials, each encoding the physical scale levels for
%			a top pair and a bottom pair of stimuli, [T1 T2 B1 B2]
% RESP - a binary coding that the observer selected either the top [0] or
%			bottom [1] pair as having the most intra-pair difference
% PS	 - the perceptual scale (which is in logit space), with sigma in
%			the last position (which is in log space)
% DISPLAY - binary, decide whether to plot the current model estimate
%
% For reference, please see pp.201-3 of Knoblauch and Maloney, 2012
% ===============================================================
% Code by: Joshua Harvey, University of Oxford (UK)
% joshua.harvey@pmb.ox.ac.uk
% ===============================================================

sigma = ps(end);
psi = ps(2:end-2);

psit = 1./(1+exp(-psi)); % sigmoid transformation of scale
psit = [0 psit 1]; % fix start and end of scale to 0 and 1
esig = exp(sigma); % exponential transformation of sigma

del = psit(stim) * [1 -1 -1 1]'/esig; % calculate del function

lL = - ( sum( log(normcdf(del(resp(:,1)==1)))) +...
	sum( log(1-normcdf(del(resp(:,1)==0)))) ); % log likelihood

if display
	figure(1)
	set(gcf,'Color','w')
	subplot(1,3,1:2)
	plot(psit,'o-','LineWidth',2);
	title('Difference scale')
	ylim([0 1])
	xlim([0.9 length(psit)+0.1])
	set(gca,'LineWidth',1)
	set(gca,'FontSize',16)
	axis square
	drawnow;
	subplot(1,3,3)
	plot(esig,'o','LineWidth',2);
	title('Sigma')
	ylim([-.5 1.5])
	set(gca,'LineWidth',1)
	set(gca,'FontSize',16)
	drawnow
end

end