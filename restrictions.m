function airfoil = restrictions(airfoil, Cfg)
    % Aplicar función para asegurar que z_upper esté siempre por encima de z_lower
    airfoil = ensure_no_inversion(airfoil, Cfg);
    % Aplicación de restricciones al intrados y extrados para evitar formar
    % picos y valles en el perfil
    for j = 1:6
        for i = 2:Cfg.NUM_POINTS-1
            % Restricciones para intrados
            if airfoil.z_upper(i) < airfoil.z_upper(i-1) && airfoil.z_upper(i) < airfoil.z_upper(i+1) || airfoil.z_upper(i) > airfoil.z_upper(i-1) + 0.001 && airfoil.z_upper(i) > airfoil.z_upper(i+1) + 0.001
                airfoil.z_upper(i) = (airfoil.z_upper(i-1) + airfoil.z_upper(i+1)) / 2;
            end
            % Restricciones para extrados
            if (airfoil.z_lower(i) < airfoil.z_lower(i-1) - 0.0002 && airfoil.z_lower(i) < airfoil.z_lower(i+1) - 0.0002)  || (airfoil.z_lower(i) > airfoil.z_lower(i-1) && airfoil.z_lower(i) > airfoil.z_lower(i+1))
                airfoil.z_lower(i) = (airfoil.z_lower(i-1) + airfoil.z_lower(i+1)) / 2;
            end
        end
    end
    
end