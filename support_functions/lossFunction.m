function loss = lossFunction(X, y, tN, mu, M)
loss = 0;
C = @(i,j) ((X(i,:) - X(j,:))'*(X(i,:) - X(j,:)));
for i = 1:size(X,1)
    for j = 1:size(tN,2)
        if(tN(i,j) ~= 0)
            diff = X(i,:) - X(tN(i,j),:);
            loss = loss + (1-mu)*trace(M*(diff'*diff));
            for l = 1:size(X,1)
                if(y(i) ~= y(l))
                    diff2 = X(i,:) - X(l,:);
                    loss = loss + mu*max([0, 1+trace(M*(diff'*diff))-trace(M*(diff2'*diff2))]);
                end
            end
        end
    end
end
end