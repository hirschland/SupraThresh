function [Bmn,Bsd,Boot]=MLCM_boot(Estimate,stim,model,n)

ps = Estimate;
sig = 1;
pn = length(ps);

if strcmp(model,'add')
	ps(2:end,2:end) = ps(2:end,1) + ps(1,2:end);
elseif strcmp(model,'ind')
	ps = repmat(ps(:,1),[1,pn]);
end

del = ps(sub2ind(size(ps),stim(:,4),stim(:,2))) -...
	ps(sub2ind(size(ps),stim(:,3),stim(:,1))) +...
	normrnd(0,sig,length(stim),n);
R = del;
R(del>0) = 1; R(del<=0) = 0;

for bb = n:-1:1
	[Boot(:,:,bb),~,~]=MLCM_MLE(stim,R(:,bb),model,0);
	fprintf('\b\b\b%3.0f',bb)
end

Bmn = mean(Boot,3);
Bsd = std(Boot,[],3);


end