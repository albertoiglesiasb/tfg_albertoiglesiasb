function Cl_opt = calculate_optimal(Cl, Cd, alpha)
    % Fit the data to the equation Cd = Cd0 + k * Cl^2
    Cl_squared = Cl.^2;
    p = polyfit(Cl_squared, Cd, 1); % Linear fit to Cd vs Cl^2
    Cd0 = p(2); % Intercept of the fit, corresponding to Cd0
    k = p(1); % Slope of the fit, corresponding to k

    if k <= 0
        Cl_opt = [];
        %alpha_opt = NaN;
        return;
    end
    
    % Calculate Cl_opt
    Cl_opt = sqrt(Cd0 / k);
    
    % Interpolate to find the alpha corresponding to Cl_opt
    %alpha_opt = interp1(Cl, alpha, Cl_opt, 'linear', 'extrap');
end
