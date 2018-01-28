%% Build Gaussian Parameters
%  Build the parameters for the Gaussian distributions in different
%  scenarios.

D1 = dlmread('entrapment_data_normal_flat.csv', ',');
D2 = dlmread('entrapment_data_normal_rocky.csv', ',');
D3 = dlmread('ak1_vive_stopped_highbay_20171130_vive.csv', ',');
D3 = horzcat(zeros(size(D3,1), 2), sqrt(D3(:,5).*D3(:,5) + D3(:,6).*D3(:,6)), D3(:,7), zeros(size(D3,1),1));

D = vertcat(D1, D2);
%D = D3;

X = D(:,1:2); % linear velocity magnitude, angular velocity magnitude
Y = D(:,3:4); % linear velocity magnitude, angular velocity magnitude
L = Y(:,1);   % measurement matrices

%L = vertcat(L, -L);

%% Semi-Gaussian Model Fitting

gauss_mu = mean(L);
gauss_sigma = (L - gauss_mu)' * (L - gauss_mu) / size(L,1);
gauss_sigma = gauss_sigma * 2;
%gauss_sigma = gauss_sigma * 200;

fprintf('Gaussian_mu = %f\n', gauss_mu);
fprintf('Gaussian_sigma = %f\n', gauss_sigma);


%% Plot

figure(1);

lowerbound = max(0, min(L) - 0.05 * (max(L) - min(L)));
upperbound = max(L) + 0.05 * (max(L) - min(L));

subplot(1,2,1);
plot(1:size(L,1), L);
axis([1, size(L,1), lowerbound, upperbound])

subplot(1,2,2);
plot(normpdf(lowerbound:0.0001:upperbound, gauss_mu, gauss_sigma), lowerbound:0.0001:upperbound);
hold on;
scatter(zeros(size(L,1),1) + 0.01, L, '.');
hold off;
ylim([lowerbound, upperbound])

figure(2);
histogram(L);

