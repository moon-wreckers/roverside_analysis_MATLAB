%% Entrapment Detection

D1 = dlmread('ak2_vive_driving_normal_highbay_20171206.csv', ',');
D2 = dlmread('ak2_vive_driving_highcentered_highbay_20171206.csv', ',');
D3 = dlmread('ak2_vive_driving_stuck_jiggling_highbay_20171206.csv', ',');

t1 = D1(:,1) - D1(1,1);
%t2 = D2(:,1) - D2(1,1);
t2 = D3(:,1) - D3(1,1);
t2 = t2 + t1(size(t1,1),1);
t = [t1;t2];

D = [D1;D3];

v_wheel = D(:,2:4);
v_vive = D(:,5:7);


%% Classifier
%  Y = normpdf(X, mu, sigma);

mu_diverged = 0.284731;
sigma_diverged = 0.017305;

mu_normal = 0.050663;
sigma_normal = 0.005074;

mu = [mu_normal, mu_diverged];
sigma = [sigma_normal, sigma_diverged];


%% Bayes Process
%  P(S|X) = P(X|S) * P(S) / P(X)
%  P(S=s) = P(X|S=s) * P(S=s) / sum_v(P(X|S=v) * P(S=v))

v_err = zeros(size(D,1),1);

priors = zeros(size(t,1)+1, size(mu,2));
priors(1,:) = [ 0.99, 0.01 ]; % [ normal, diverged ]
for i_t = 1:size(t,1)
    priors_update = priors(i_t,:);
    x = abs(norm(v_vive(i_t,:)) - norm(v_wheel(i_t,:)));
    v_err(i_t) = x;
    
    wsize = 2;
    if i_t > wsize
        acc_x = 0;
        for i_err = (i_t - wsize + 1):i_t
            acc_x = acc_x + v_err(i_err);
        end
        v_err(i_t) = acc_x / wsize;
    end
    x = v_err(i_t);
    
    for i_prior = 1:size(priors,2)
        priors_update(1,i_prior) = normpdf(x, mu(1,i_prior), sigma(1,i_prior)) * priors(i_t,i_prior);
    end
    for i_prior = 1:size(priors,2)
        priors(i_t+1,i_prior) = priors_update(1,i_prior) / sum(priors_update);
    end
    rg = 0.001;
    sum_priors = sum(priors(i_t+1,:));
    hasnan = 0;
    for i_prior = 1:size(priors,2)
        priors(i_t+1,i_prior) = (priors(i_t+1,i_prior) + rg) / (sum_priors + rg * size(priors,2));
        if isnan(priors(i_t+1,i_prior))
            hasnan = 1;
        end
    end
    if hasnan
        priors(i_t+1,:) = priors(i_t,:);
    end
    
end


%% Plot

figure(1);

subplot(3,1,1);
plot(t, v_err);

subplot(3,1,2);
plot(t, priors(2:size(priors,1),1));
axis([0,max(t),-1,2]);
ylabel('P(normal)');

subplot(3,1,3);
plot(t, priors(2:size(priors,1),2));
axis([0,max(t),-1,2]);
ylabel('P(diverged)');

