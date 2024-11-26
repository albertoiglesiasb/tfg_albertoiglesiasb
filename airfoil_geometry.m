function output = airfoil_geometry(x_upper, z_upper, x_lower, z_lower, num_points)

    % Interpolar los puntos a una malla uniforme
    [output.x_upper, output.z_upper] = normalize_coordinates(x_upper, z_upper, num_points);
    [output.x_lower, output.z_lower] = normalize_coordinates(x_lower, z_lower, num_points);
    
     % Obtener los csapi para upper e lower
    output.upper_spline = spline(output.x_upper, output.z_upper); % Spline del upper
    output.lower_spline = spline(output.x_lower, output.z_lower); % Spline del lower

end
