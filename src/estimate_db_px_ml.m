function [param_hat, loglik] = estimate_db_px_ml(   data, ...
                                                    x_bleach, ...
                                                    y_bleach, ...
                                                    r_bleach, ...
                                                    delta_t, ...
                                                    number_of_pixels, ...
                                                    number_of_images, ...
                                                    number_of_pad_pixels, ...
                                                    lb, ...
                                                    ub, ...
                                                    param_guess, ...
                                                    number_of_fits)

% Optimization options.
options = optimoptions(@fmincon);
options.Algorithm = 'sqp';
options.Display = 'iter';
options.ConstraintTolerance = 1e-7;
options.OptimalityTolerance = 1e-7;
options.StepTolerance = 1e-7;

% Residual function handle.
% tic
log_gamma_term = data;
log_gamma_term(log_gamma_term == 0) = 1; % Just in case...
log_gamma_sequence = cumsum( log( 1:max(data(:)) ) );
log_gamma_term = log_gamma_sequence(log_gamma_term);
% for current_pixel = 1:numel(log_gamma_term)
%     log_gamma_term(current_pixel) = sum( log( 1:data(current_pixel) ) );
% end
% toc

fun = @(param)negloglik_db_px(  param(1), ...
                                param(2), ...
                                param(3), ...
                                param(4), ...
                                param(5), ...
                                param(6), ...
                                x_bleach, ...
                                y_bleach, ...
                                r_bleach, ...
                                delta_t, ...
                                number_of_pixels, ...
                                number_of_images, ...
                                number_of_pad_pixels, ...
                                data, ...
                                log_gamma_term);

% One fit with user-provided parameter guess or arbitrary many fits using
% random parameter guesses.
if ~isempty(param_guess)
    [param_hat, nll] = fmincon(fun, param_guess, [], [], [], [], lb, ub, [], options);
else
    param_hat = zeros(1, 6);
    nll = inf;
    
    for current_fit = 1:number_of_fits
        param_guess = lb + (ub - lb) .* rand(size(lb));
        [param_hat_, nll_] = fmincon(fun, param_guess, [], [], [], [], lb, ub, [], options);
        if nll_ < nll
            param_hat = param_hat_;
            nll = nll_;
        end
    end
end

loglik = - nll;

end
