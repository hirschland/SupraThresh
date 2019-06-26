function example_MLCM
%example_MLCM
%
% Solves the MLCM scales for the example dataset, BumpyGlossy.csv
%
% For reference, please see Chapter 8 of Knoblauch and Maloney, 2012
% ===============================================================
% Code by: Joshua Harvey, University of Oxford (UK)
% joshua.harvey@pmb.ox.ac.uk
% ===============================================================

% read in data
bg = csvread('BumpyGlossy.csv',1,1);
StimList = bg(:,2:5);
StimList = StimList(:,[2 1 4 3]); % seems to be incorrect order in the original data
R = bg(:,1);

%%
[EstimateS,~,LikelihoodS]=MLCM_MLE(StimList,R,'sat',0);
[EstimateA,~,LikelihoodA]=MLCM_MLE(StimList,R,'add',0);
[EstimateI,~,LikelihoodI]=MLCM_MLE(StimList,R,'ind',0);

% get neg log likelihood of estimate again
objMLCM(StimList,R,EstimateS,'sat',0)
objMLCM(StimList,R,EstimateA,'add',0)
objMLCM(StimList,R,EstimateI,'ind',0)

% test for nested hypothesis rejection (DoF = 24, 8, 4)
[h1,pValue1,stat1] = lratiotest(-LikelihoodS,-LikelihoodA,24-8);
[h2,pValue2,stat2] = lratiotest(-LikelihoodA,-LikelihoodI,8-4);

% plot Estimate for add
figure,
plot(EstimateA(:,1),'o-'), hold on,
plot(EstimateA(1,:),'o-')

% plot Estimate for sat
figure,
for ll = 1:5
	plot(EstimateS(ll,:),'o-'), hold on,
end

%% bootstraping

[BmnS,BsdS,BootS]=MLCM_boot(EstimateS,StimList,'sat',10);
[BmnA,BsdA,BootA]=MLCM_boot(EstimateA,StimList,'add',10);
[BmnI,BsdI,BootI]=MLCM_boot(EstimateI,StimList,'ind',10);

figure,
subplot(1,3,1)
for ll = 1:5
	errorbar(BmnS(ll,:),BsdS(ll,:)), hold on
end

subplot(1,3,2)
errorbar(BmnA(1:end,1),BsdA(1:end,1)), hold on
errorbar(BmnA(1,1:end),BsdA(1,1:end)), hold on

subplot(1,3,3)
errorbar(BmnI(1:end,1),BsdI(1:end,1)), hold on

end