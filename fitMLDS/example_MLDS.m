function example_MLDS
%example_MLDS
%
% Solves the MLDS scale for the example dataset, kk.csv
%
% For reference, please see Chapter 7 of Knoblauch and Maloney, 2012
% ===============================================================
% Code by: Joshua Harvey, University of Oxford (UK)
% joshua.harvey@pmb.ox.ac.uk
% ===============================================================

% read in data
kk = csvread('kk.csv',1,1);

stim = kk(:,2:5);
resp = kk(:,1);

display = 1; % for visualization, will be considerably slower

% fit scale by MLE
[Estimate,Likelihood]=MLDS_MLE(stim,resp,display);

% check likelihood
pL = log(Estimate(1:end-1)./(1-Estimate(1:end-1))); % convert to logit space, so estimates are 0<p<1
sigma = log(Estimate(end));

nlL = objMLDS(stim,resp,[pL sigma],display);

if ~display
	figure(1)
	set(gcf,'Color','w')
	subplot(1,3,1:2)
	plot(Estimate(1:end-1),'o-','LineWidth',2);
	title('Difference scale')
	ylim([0 1])
	xlim([0.9 length(Estimate)-0.9])
	set(gca,'LineWidth',1)
	set(gca,'FontSize',16)
	axis square
	drawnow;
	subplot(1,3,3)
	plot(Estimate(end),'o','LineWidth',2);
	title('Sigma')
	ylim([-.5 1.5])
	set(gca,'LineWidth',1)
	set(gca,'FontSize',16)
	drawnow
end

%% obtain errors by bootstrapping

[Bmn,Bsd,Boot]=MLDS_boot(Estimate,stim,100);
Bcf = norminv(0.975)*Bsd; % 95% confidence intervals

% plot results
figure('Color','w')
subplot(1,3,1:2)
errorbar(Bmn(1:end-1),Bcf(1:end-1),'o','LineWidth',2);
title('Difference scale')
set(gca,'LineWidth',1)
set(gca,'FontSize',16)
ylim([0 1])
xlim([0.9 length(Estimate)-0.9])
axis square
drawnow;
subplot(1,3,3)
errorbar(Bmn(end),Bcf(end),'o','LineWidth',2);
title('Sigma')
ylim([-.5 1.5])
set(gca,'LineWidth',1)
set(gca,'FontSize',16)

end
