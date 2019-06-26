function [Bmn,Bsd,Boot]=MLDS_boot(Estimate,stim,n)

sigma = Estimate(end);
psis = [0 Estimate(2:end-2) 1];

del = psis(stim) * [1 -1 -1 1]' +...
	normrnd(0,sigma,length(stim),n); % calculate del function
R = del;
R(del>0) = 1; R(del<=0) = 0;

for bb = n:-1:1
	[Boot(:,:,bb),~]=MLDS_MLE(stim,R(:,bb),0);
	fprintf('\b\b\b%3.0f',bb)
end

Bmn = mean(Boot,3);
Bsd = std(Boot,[],3);

end