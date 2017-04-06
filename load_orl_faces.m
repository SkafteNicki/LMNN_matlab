close all; %clear all;
addpath('orl_faces');

%% Load data
n = 112; m = 92;
X = zeros(400, n*m);
Y = zeros(400, 1);
count = 1;
for person = 1:40
    for image = 1:10
        file = ['orl_faces/s' num2str(person) '/' num2str(image) '.pgm'];
        importfile(file);
        
        if(image == 1), X(count,:) = x1(:)'; end
        if(image == 2), X(count,:) = x2(:)'; end
        if(image == 3), X(count,:) = x3(:)'; end
        if(image == 4), X(count,:) = x4(:)'; end
        if(image == 5), X(count,:) = x5(:)'; end
        if(image == 6), X(count,:) = x6(:)'; end
        if(image == 7), X(count,:) = x7(:)'; end
        if(image == 8), X(count,:) = x8(:)'; end
        if(image == 9), X(count,:) = x9(:)'; end
        if(image == 10), X(count,:) = x10(:)'; end
        Y(count) = person;
        count = count + 1;
    end
end
clear x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 file person image count;
%% Do a pca reduction
[coeff,score,~,~,explained,mean] = pca(X);
cum_explained = cumsum(explained);
% figure;
%     plot(explained, 'LineWidth', 2);
%     hold on;
%     plot(cum_explained, 'LineWidth', 2);
minComp = find(cum_explained >= 95,1);
XPCA = score(:,1:minComp);
%% Do a splitting of the data
Xtrain = [ ];
Xtest = [ ];
Ytrain = [ ];
Ytest = [ ];
trainIdx = [ ];
testIdx = [ ];
for person = 1:40
    idx = randperm(10)';
    trainIdx = [trainIdx; 10*(person-1)+idx(1:7)];
    testIdx = [testIdx; 10*(person-1)+idx(8:10)];
    Xtrain = [Xtrain ; XPCA(10*(person-1)+idx(1:7),:)];
    Xtest = [Xtest ; XPCA(10*(person-1)+idx(8:10),:)];
    Ytrain = [Ytrain ; person*ones(7,1)];
    Ytest = [Ytest ; person*ones(3,1)];
end
save orl_data.mat X Y trainIdx testIdx Xtrain Xtest Ytrain Ytest n m;
%% Do some training and prediction
time = zeros(4,1);
tic;
[prediction0, nearest0] = kNN(Xtrain, Ytrain, Xtest, 6);
error(1) = sum(Ytest ~= prediction0) / length(Ytest);
time(1) = toc; 

tic;
M1 = LMNN_naive(Xtrain, Ytrain, 6, 0.7, 20, 1, 1e-5);
[prediction1, nearest1] = kNN(Xtrain, Ytrain, Xtest, 6, M1);
error(2) = sum(Ytest ~= prediction1) / length(Ytest);
time(3) = toc;

tic;
M2 = LMNN_active(Xtrain, Ytrain, 6, 0.7, 20, 1, 1e-5);
[prediction2, nearest2] = kNN(Xtrain, Ytrain, Xtest, 6, M2);
error(3) = sum(Ytest ~= prediction2) / length(Ytest);
time(2) = toc;

tic;
M3 = LMNN_stochastic(Xtrain, Ytrain, 6, 0.7, 50, 1, 1e-5, 40);
[prediction3, nearest3] = kNN(Xtrain, Ytrain, Xtest, 6, M3);
error(4) = sum(Ytest ~= prediction3) / length(Ytest);
time(4) = toc;

tradeoff = 100*(error(1)-error(2:end)) ./ time(2:end)';
%%
% p = 2;
% figure;
%     subplot(2,4,1);
%         imagesc(reshape(X(trainIdx(p),:),[n,m]));
%         axis off;
%         title('Original image', 'Fontsize', 15);
%         colormap gray;
%     text(-70,50,'Before training', 'Fontsize', 15);    
%     text(-70,200,'After training', 'Fontsize', 15);    
%     for near = 1:3
%         subplot(2,4,near+1);
%             imagesc(reshape(X(trainIdx(nearest0(p,near)),:),[n,m]));
%             title(['Nearest neighbour ' num2str(near)], 'Fontsize', 15);
%             axis off;
%             colormap gray;
%         subplot(2,4,near+5);
%             imagesc(reshape(X(trainIdx(nearest1(p,near)),:),[n,m]));
%             colormap gray;
%             axis off;
%     end
% figure;
%     imagesc(reshape(X(trainIdx(p),:),[n,m]));
%     axis off; axis image;
%     colormap gray;
%     set(gca,'position',[0 0 1 1],'units','normalized')
% for near = 1:3
%     figure;
%         imagesc(reshape(X(trainIdx(nearest0(p,near)),:),[n,m]));
%         axis off; axis image;
%         colormap gray;
%         set(gca,'position',[0 0 1 1],'units','normalized')
%     figure;
%         imagesc(reshape(X(trainIdx(nearest1(p,near)),:),[n,m]));
%         axis off; axis image;
%         colormap gray;
%         set(gca,'position',[0 0 1 1],'units','normalized')
% end
%         
%     