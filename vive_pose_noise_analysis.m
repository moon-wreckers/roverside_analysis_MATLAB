%% VIVE Pose Noise Analysis

D = dlmread('ak1_vive_stopped_highbay_20171130_rpyXYZ.csv', ',');
D = D(5:size(D,1)-5,:);
t = D(:,1) - D(1,1);
X = D(:,2:7);

X_centered = X;
for i_d = 1:size(X,2)
    X_centered(:,i_d) = X(:,i_d) - mean(X(:,i_d));
end

Sigma = X_centered' * X_centered / size(X_centered,1);
fprintf('cov(rpyXYZ) = \n');
format long;
disp(Sigma);

figure(1);
for i_d = 1:size(X_centered,2)
    subplot(size(X_centered,2),1,i_d);
    plot(t,X_centered(:,i_d));
end

