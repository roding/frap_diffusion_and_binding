function F = residual_d_px( D, ...
                            mf, ...
                            Ib, ...
                            Iu, ...
                            x_bleach, ...
                            y_bleach, ...
                            r_bleach, ...
                            delta_t, ...
                            number_of_pixels, ...
                            number_of_images, ...
                            number_of_pad_pixels, ...
                            data)

model = signal_d(   D, ...
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

F = model(:) - data(:);

end