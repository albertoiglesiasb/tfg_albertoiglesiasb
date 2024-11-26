function smoothed_airfoil = smooth_airfoil(airfoil, Cfg)
    % Definir índices para los puntos de corte en 0.15 y 0.8
    idx_upper_1 = find(airfoil.x_upper <= 0.15, 1, 'last');
    idx_upper_2 = find(airfoil.x_upper <= 0.8, 1, 'last');
    idx_lower_1 = find(airfoil.x_lower <= 0.15, 1, 'last');
    idx_lower_2 = find(airfoil.x_lower <= 0.8, 1, 'last');
    
    % Tamaño de ventana para movmean
    window_size = 3;
    
    %% Suavizado en el extrados (upper)
    % Primera sección (x <= 0.15)
    z_upper_initial = movmean(airfoil.z_upper(1:idx_upper_1), window_size);
    x_upper_initial = airfoil.x_upper(1:idx_upper_1);
    
    % Segunda sección (0.15 < x <= 0.8)
    z_upper_middle = movmean(airfoil.z_upper(idx_upper_1:idx_upper_2), window_size);
    x_upper_middle = airfoil.x_upper(idx_upper_1:idx_upper_2);
    
    % Tercera sección (x > 0.8)
    z_upper_final = movmean(airfoil.z_upper(idx_upper_2:end), window_size);
    x_upper_final = airfoil.x_upper(idx_upper_2:end);
    
    % Concatenar las tres secciones del extrados
    x_upper_combined = [x_upper_initial, x_upper_middle(2:end), x_upper_final(2:end)];
    z_upper_combined = [z_upper_initial, z_upper_middle(2:end), z_upper_final(2:end)];
    
    % Aplicar un último movmean para suavizar las uniones
    smoothed_airfoil.x_upper = x_upper_combined;
    smoothed_airfoil.z_upper = movmean(z_upper_combined, window_size);
    
    % Ajustar el primer y último punto para mantener la forma original
    smoothed_airfoil.z_upper(1) = airfoil.z_upper(1);
    smoothed_airfoil.z_upper(end) = airfoil.z_upper(end);

    %% Suavizado en el intrados (lower)
    % Primera sección (x <= 0.15)
    z_lower_initial = movmean(airfoil.z_lower(1:idx_lower_1), window_size);
    x_lower_initial = airfoil.x_lower(1:idx_lower_1);
    
    % Segunda sección (0.15 < x <= 0.8)
    z_lower_middle = movmean(airfoil.z_lower(idx_lower_1:idx_lower_2), window_size);
    x_lower_middle = airfoil.x_lower(idx_lower_1:idx_lower_2);
    
    % Tercera sección (x > 0.8)
    z_lower_final = movmean(airfoil.z_lower(idx_lower_2:end), window_size);
    x_lower_final = airfoil.x_lower(idx_lower_2:end);
    
    % Concatenar las tres secciones del intrados
    x_lower_combined = [x_lower_initial, x_lower_middle(2:end), x_lower_final(2:end)];
    z_lower_combined = [z_lower_initial, z_lower_middle(2:end), z_lower_final(2:end)];
    
    % Aplicar un último movmean para suavizar las uniones
    smoothed_airfoil.x_lower = x_lower_combined;
    smoothed_airfoil.z_lower = movmean(z_lower_combined, window_size);
    
    % Ajustar el primer y último punto para mantener la forma original
    smoothed_airfoil.z_lower(1) = airfoil.z_lower(1);
    smoothed_airfoil.z_lower(end) = airfoil.z_lower(end);

    % Reconstruir el perfil aerodinámico suavizado
    smoothed_airfoil = airfoil_geometry(smoothed_airfoil.x_upper, smoothed_airfoil.z_upper, smoothed_airfoil.x_lower, smoothed_airfoil.z_lower, Cfg.NUM_POINTS);

    % Mantener otras propiedades del perfil
    smoothed_airfoil.id = airfoil.id;
end
