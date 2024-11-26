function [airfoil, velocity] = update_airfoil(airfoil, velocity, pBest, gBest, Cfg)

    % Actualizar todos los puntos del extrados
    [airfoil.z_upper, velocity.z_upper] = update_coord(airfoil.z_upper, velocity.z_upper, pBest.z_upper, gBest.z_upper, Cfg);
    [airfoil.x_upper, velocity.x_upper] = update_coord(airfoil.x_upper, velocity.x_upper, pBest.x_upper, gBest.x_upper, Cfg);

    % Actualizar todos los puntos del intrados
    [airfoil.z_lower, velocity.z_lower] = update_coord(airfoil.z_lower, velocity.z_lower, pBest.z_lower, gBest.z_lower, Cfg);
    [airfoil.x_lower, velocity.x_lower] = update_coord(airfoil.x_lower, velocity.x_lower, pBest.x_lower, gBest.x_lower, Cfg);

end