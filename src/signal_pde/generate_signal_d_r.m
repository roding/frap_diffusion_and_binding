%% Initialization.
clear
clc
close all hidden

%% Parameters.
D_SI = 2.5e-11; % m^2/s
pixel_size = 7.598e-07; % m
D = D_SI / pixel_size^2; % pixels^2 / s
mf = 1.0; % dimensionless

delta_t = 0.2650; % s
number_of_pixels = 256;
number_of_images = 10;
number_of_pad_pixels = 128;
Ib = 0.6; % a.u.
Iu = 0.9; % a.u.
x_bleach = 128; % pixels
y_bleach = 128; % pixels
lx_bleach = 64; % pixels
ly_bleach = 64; % pixels

%% Simulate.
tic
signal = signal_d_r(D, ...
                    mf, ...
                    Ib, ...
                    Iu, ...
                    x_bleach, ...
                    y_bleach, ...
                    lx_bleach, ...
                    ly_bleach, ...
                    delta_t, ...
                    number_of_pixels, ...
                    number_of_images, ...
                    number_of_pad_pixels);
toc

%% Plot solution.
figure
hold on
imagesc(reshape(signal, [number_of_pixels, number_of_pixels * number_of_images]))
axis 'equal'
axis([0 number_of_images*number_of_pixels 0 number_of_pixels])
axis off
hold off

%% Plot recovery curve.
[X, Y] = meshgrid(1:number_of_pixels, 1:number_of_pixels);
X = X - 0.5;
Y = Y - 0.5;
ind = find(  X >= x_bleach - 0.5 * lx_bleach & X <= x_bleach + 0.5 * lx_bleach & Y >= y_bleach - 0.5 * ly_bleach & Y <= y_bleach + 0.5 * ly_bleach );
ind = ind(:);
recovery_curve = zeros(1, number_of_images);
for current_image = 1:number_of_images
    slice = signal(:, :, current_image);
    recovery_curve(current_image) = mean(slice(ind));
end
figure
plot(delta_t:delta_t:number_of_images*delta_t, recovery_curve)

%% Save data.
% clear current_image X Y ind recovery_curve slice
% save('simulated_signal_d.mat')
