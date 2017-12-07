%% Velocity Divergence Analysis
%  Show the velocity divergence of a static rover.

D = dlmread('ak2_vive_driving_normal_highbay_20171206.csv', ',');
%D = dlmread('ak2_vive_driving_highcentered_highbay_20171206.csv', ',');
%D = dlmread('ak2_vive_driving_stuck_jiggling_highbay_20171206.csv', ',');
t = D(:,1) - D(1,1);
v_wheel = D(:,2:4);
v_vive = D(:,5:7);

v_wheel_mag = zeros(size(D,1), 1);
v_vive_mag = zeros(size(D,1), 1);
for i_D = 1:size(D,1)
    v_wheel_mag(i_D, 1) = norm(v_wheel(i_D,:));
    v_vive_mag(i_D, 1) = norm(v_vive(i_D,:));
end


%% Divergence Analysis

v_err = v_vive - v_wheel;
v_mag_err = abs(v_vive_mag - v_wheel_mag);

mu_v_err = mean(v_err);

v_err_centered = v_err;
v_err_centered(:,1) = v_err_centered(:,1) - mu_v_err(1,1);
v_err_centered(:,2) = v_err_centered(:,2) - mu_v_err(1,2);
v_err_centered(:,3) = v_err_centered(:,3) - mu_v_err(1,3);

Sigma_v_err = v_err_centered' * v_err_centered / size(v_err,1);
fprintf('err velocity covariance:\n');
disp(Sigma_v_err);


%% Plot

figure(1);

subplot(4, 1, 1);
plot(t, v_err(:,1));
%axis([0, 120, -0.05, 0.05]);
xlabel('t / s');
ylabel('v_x / m/s');

subplot(4, 1, 2);
plot(t, v_err(:,2));
%axis([0, 120, -0.05, 0.05]);
xlabel('t / s');
ylabel('v_y / m/s');

subplot(4, 1, 3);
plot(t, v_err(:,3));
%axis([0, 120, -0.05, 0.05]);
xlabel('t / s');
ylabel('v_z / m/s');

subplot(4, 1, 4);
plot(t, v_mag_err);
hold on;
plot(t, v_wheel_mag);
hold off;
%axis([0, 120, -0.05, 0.05]);
xlabel('t / s');
ylabel('|e_v| / m/s');

suptitle('Velocity Divergence (Rover Driving)');


%% Semi-Gaussian Model Fitting

gauss_mu = mean(v_mag_err); %0.5;
gauss_sigma = (v_mag_err - gauss_mu)' * (v_mag_err - gauss_mu) / size(v_mag_err,1);

fprintf('Gaussian_mu = %f\n', gauss_mu);
fprintf('Gaussian_sigma = %f\n', gauss_sigma);


