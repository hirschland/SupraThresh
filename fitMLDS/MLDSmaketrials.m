function MLDStrials = MLDSmaketrials(res)

% res = 5; % resolution of paramater space

orderedtrials = nchoosek([1:res],4); % all non-overlapping quads

l = length(orderedtrials);

% swap top and bottom pair for half of trials
swapindxfull = randperm(l);
swapindxhalf = swapindxfull(1:floor(l/2));

swappedtrials = orderedtrials;
swappedtrials(swapindxhalf,:) = orderedtrials(swapindxhalf,[3 4 1 2]);

% randomise trial order
shuffindx = randperm(l);
MLDStrials = swappedtrials(shuffindx,:);

end