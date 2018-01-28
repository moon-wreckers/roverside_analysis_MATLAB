%% Build Gaussian Parameters
%  Build the parameters for the Gaussian distributions in different
%  scenarios.

D1 = dlmread('entrapment_data_normal_flat.csv', ',');
D2 = dlmread('entrapment_data_normal_rocky.csv', ',');
D3 = dlmread('entrapment_data_entrapped_highcentered.csv', ',');
D4 = dlmread('entrapment_data_entrapped_jiggling.csv', ',');

%D = vertcat(D1, D2);
%D = D2;
%D = vertcat(D3, D4);
D = D4;

X = D(:,1:2); % linear velocity magnitude, angular velocity magnitude
Y = D(:,3:4); % linear velocity magnitude, angular velocity magnitude
L = D(:,5);   % weighted loss


%% Semi-Gaussian Model Fitting

%L_augmented = vertcat(L, -L);
L_augmented = L;

gauss_mu = mean(L_augmented);
gauss_sigma = (L_augmented - gauss_mu)' * (L_augmented - gauss_mu) / size(L_augmented,1);
gauss_sigma = gauss_sigma * 2;

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
plot(normpdf(lowerbound:0.001:upperbound, gauss_mu, gauss_sigma), lowerbound:0.001:upperbound);
hold on;
scatter(zeros(size(L,1),1) + 0.01, L, '.');
hold off;
ylim([lowerbound, upperbound])

figure(2);
histogram(L);

