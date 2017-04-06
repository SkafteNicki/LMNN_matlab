function MODE = weightedMode(X, W)
%% Description
% weightedMode calculates the weighted mode of the classes in X weighted by
% the distances in W
%% Function
uniq = unique(X);   % find uniqe classes
frequent = histc(X,uniq); % count each classes
modeCount = sum(max(frequent) == frequent); % count how minimum classes exist
if(modeCount == 1) % if only 1, then just do the mode
    MODE = mode(X);
else % if multiple, calculate weighted mode
    dist = zeros(modeCount,1);
    bimode = uniq(max(frequent) == frequent);
    for i = 1:modeCount
        dist(i) = sum(W(X == bimode(i)));
    end
    [~,idx] = min(dist);
    MODE = bimode(idx);
end
    

end