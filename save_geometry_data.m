function save_geometry_data(airfoil)
    % Nombre del archivo .dat
    output_folder = 'outputs\geometry_plots';
    filename = fullfile(output_folder, sprintf('airfoil_%s.dat', num2str(airfoil.id)));
    
    % Abrir el archivo para escribir
    fileID = fopen(filename, 'w');
    
    % Verificar si el archivo se abrió correctamente
    if fileID == -1
        error('Error al abrir el archivo.');
    end
    
    % Escribir las coordenadas en el archivo .dat
    fprintf(fileID, 'x_thickness   z_thickness   x_camber   z_camber   x_upper   z_upper   x_lower   z_lower\n');
    
    num_points = length(airfoil.x_thickness);
    
    for i = 1:num_points
        fprintf(fileID, '%f   %f   %f   %f   %f   %f   %f   %f\n', ...
            airfoil.x_thickness(i), airfoil.z_thickness(i), ...
            airfoil.x_camber(i), airfoil.z_camber(i), ...
            airfoil.x_upper(i), airfoil.z_upper(i), ...
            airfoil.x_lower(i), airfoil.z_lower(i));
    end
    
    % Cerrar el archivo
    fclose(fileID);
end