%% Initialization.
clear
clc
close all hidden

%% Parameters.
D_SI = 5e-11; % m^2/s
pixel_size = 7.5e-07; % m
D = D_SI / pixel_size^2; % pixels^2 / s
k_on = 0.5; % 1/s
k_off = 5; % 1/s
mf = 1.0; % dimensionless

delta_t = 0.2; % s
number_of_pixels = 256;
number_of_images = 100;
number_of_pad_pixels = 128;
Ib = 0.6; % a.u.
Iu = 1.0;%0.9; % a.u.
x_bleach = 128; % pixels
y_bleach = 128; % pixels
r_bleach = 15e-6 / pixel_size; % pixels corresponding to 15 �m radius (30 �m diameter)

%% Simulate.
tic
data = signal_db( D, ...
                    k_on, ...
                    k_off, ...
                    mf, ...
                    Ib, ...
                    Iu, ...
                    x_bleach, ...
                    y_bleach, ...
                    r_bleach, ...
                    delta_t, ...
                    number_of_pixels, ...
                    number_of_images, ...
                    number_of_pad_pixels);
toc

sigma_noise = 0.5;
data = data + sigma_noise * randn(size(data));

%% Plot solution.
figure
hold on
imagesc(reshape(data, [number_of_pixels, number_of_pixels * number_of_images]))
% axis 'equal'
axis([0 number_of_images*number_of_pixels 0 number_of_pixels])
axis off
hold off

%% Plot recovery curve.
[X, Y] = meshgrid(1:number_of_pixels, 1:number_of_pixels);
X = X - 0.5;
Y = Y - 0.5;
ind = find( (X - x_bleach).^2 + (Y - y_bleach).^2 <= r_bleach^2 );
ind = ind(:);
recovery_curve = zeros(1, number_of_images);
for current_image = 1:number_of_images
    slice = data(:, :, current_image);
    recovery_curve(current_image) = mean(slice(ind));
end
figure
plot(delta_t:delta_t:number_of_images*delta_t, recovery_curve)

%% Save data.
% clear current_image X Y ind recovery_curve slice
% save('simulated_signal_db.mat')