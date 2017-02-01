function F = residual(D, k_on, k_off, mobile_fraction, xc, yc, r_bleach_region, intensity_inside_bleach_region, intensity_outside_bleach_region, delta_t, image_data_post_bleach)

[number_of_pixels, ~, number_of_images_post_bleach] = size(image_data_post_bleach);

image_data_post_bleach_model = signal(D, k_on, k_off, mobile_fraction, xc, yc, r_bleach_region, intensity_inside_bleach_region, intensity_outside_bleach_region, delta_t, number_of_pixels, number_of_images_post_bleach);

F = image_data_post_bleach_model(:) - image_data_post_bleach(:);

end

