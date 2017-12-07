%% Static Velocity Divergence Analysis
%  Show the velocity divergence of a static rover.

D = dlmread('ak1_vive_stopped_highbay_20171130_vive.csv', ',');
t = D(:,1) - D(1,1);
v_wheel = D(:,2:4);
v_vive = D(:,5:7);


%% Noise Analysis

mu_v_vive = mean(v_vive);

v_vive_centered = v_vive;
v_vive_centered(:,1) = v_vive_centered(:,1) - mu_v_vive(1,1);
v_vive_centered(:,2) = v_vive_centered(:,2) - mu_v_vive(1,2);
v_vive_centered(:,3) = v_vive_centered(:,3) - mu_v_vive(1,3);

Sigma_v_vive = v_vive_centered' * v_vive_centered / size(v_vive,1);
fprintf('VIVE odometry velocity covariance:\n');
disp(Sigma_v_vive);

fprintf('VIVE odometry accuracy:\n');
fprintf('  - v_x error: %f mm\n', sqrt(Sigma_v_vive(1,1)) * 1000);
fprintf('  - v_y error: %f mm\n', sqrt(Sigma_v_vive(2,2)) * 1000);
fprintf('  - v_z error: %f mm\n', sqrt(Sigma_v_vive(3,3)) * 1000);
%% Plot

figure(1);

subplot(3, 1, 1);
plot(t, v_wheel(:,1));
hold on;
plot(t, v_vive(:,1));
hold off;
axis([0, 120, -0.05, 0.05]);
xlabel('t / s');
ylabel('v_x / m/s');
legend('wheel\_odom', 'vive\_odom');

subplot(3, 1, 2);
plot(t, v_wheel(:,2));
hold on;
plot(t, v_vive(:,2));
hold off;
axis([0, 120, -0.05, 0.05]);
xlabel('t / s');
ylabel('v_y / m/s');

subplot(3, 1, 3);
plot(t, v_wheel(:,3));
hold on;
plot(t, v_vive(:,3));
hold off;
axis([0, 120, -0.05, 0.05]);
xlabel('t / s');
ylabel('v_z / m/s');

suptitle('Wheel/Vive Odometry Velocities (Rover Stopped)');
