function MLCMtrials = MLCMmaketrials(res)

% res = 5; % resolution of paramater space

allrb = fliplr(CombVec(1:res,1:res)');

%% get all different combinations of rough and bumpy settings

allpairs = nchoosek(1:25,2);

% add in same/same condition
sames = repmat([1:25]',[1,2]);
allpairs = cat(1,allpairs,sames);

quads = [allrb(allpairs(:,1),:), allrb(allpairs(:,2),:)];

%quads = [quads;quads]; % two times
%quads = [quads;quads;quads]; % two repeats
quads = [quads;quads;quads;quads]; % three repeats
%% randomly shuffle pairs within quadruples, and shuffle trials

shuf = datasample(1:length(quads),length(quads));

shufquads = quads;
shufquads(shuf,1:2) = quads(shuf,3:4); % replace left image with right
shufquads(shuf,3:4) = quads(shuf,1:2); % replace right image with left

tshuf = datasample(1:length(quads),length(quads)); % total shuffle indices
MLCMtrials = shufquads(tshuf,:);

end