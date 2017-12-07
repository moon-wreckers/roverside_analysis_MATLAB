%% IMU Integral Analysis
%  Show the infeasiblity of using IMU integral as a mean for odometry.

D = dlmread('ak2_stopped_compositelab_20171109_imu.csv', ',');
t = D(:,1) - D(1,1);
theta = D(:,2:4);
a = D(:,5:7);
a = a - ones(size(a,1),1) * mean(a);


%% Gaussian Denosing
%  Denoising by assuming the data conform to a Gaussian distribution.

if 1
    
end


%% IMU Orientation Readings
%  Plot the orientation of the rover estimated by the IMU when it is
%  actually stopped.

figure(1);
subplot(3, 1, 1);
plot(t, theta(:,1));
axis([0, 120, -5, -1]);
xlabel('t / s');
ylabel('roll = \theta_x / rad');

subplot(3, 1, 2);
plot(t, theta(:,2));
axis([0, 120, -2, 2]);
xlabel('t / s');
ylabel('pitch = \theta_y / rad');

subplot(3, 1, 3);
plot(t, theta(:,3));
axis([0, 120, -1, 3]);
xlabel('t / s');
ylabel('yaw = \theta_z / rad');

suptitle('IMU Orientation Readings (Rover Stopped)');


%% IMU Acceleration Readings
%  Plot the acceleration of the rover estimated by the IMU when it is
%  actually stopped.

figure(2);
subplot(3, 1, 1);
plot(t, a(:,1));
axis([0, 120, -0.05, 0.05]);
xlabel('t / s');
ylabel('a_x / m/s^2');

subplot(3, 1, 2);
plot(t, a(:,2));
axis([0, 120, -0.05, 0.05]);
xlabel('t / s');
ylabel('a_y / m/s^2');

subplot(3, 1, 3);
plot(t, a(:,3));
axis([0, 120, -0.05, 0.05]);
xlabel('t / s');
ylabel('a_z / m/s^2');

suptitle('IMU Acceleration Readings (Rover Stopped)');


%% Numerical Integral over IMU Acceleration
%  Numerical integral over IMU acceleration to obtain the rover velocity.

v = zeros(size(t,1), 3);
mid_a = [a; 0,0,0] + [0,0,0; a];
mid_a = mid_a(2:size(a,1), :) / 2;
for i_mid = 1:(size(t,1) - 1)
    v(i_mid+1,:) = v(i_mid,:) + mid_a(i_mid,:) * t(i_mid+1);
end


figure(3);
subplot(3, 1, 1);
plot(t, v(:,1));
%axis([0, 120, -0.1, 0.1]);
xlabel('t / s');
ylabel('v_x / m/s');

subplot(3, 1, 2);
plot(t, v(:,2));
%axis([0, 120, -0.1, 0.1]);
xlabel('t / s');
ylabel('v_y / m/s');

subplot(3, 1, 3);
plot(t, v(:,3));
%axis([0, 120, -0.1, 0.1]);
xlabel('t / s');
ylabel('v_z / m/s');

suptitle('IMU Velocity by Integral (Rover Stopped)');

