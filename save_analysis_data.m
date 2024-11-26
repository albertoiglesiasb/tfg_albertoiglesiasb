function save_analysis_data(airfoil)
    % Nombre del archivo .dat
    output_folder = 'outputs\analysis_results';
    filename = fullfile(output_folder, sprintf('xfoil_result_airfoil_%s.dat', num2str(airfoil.id)));
    
    % Abrir el archivo para escribir
    fileID = fopen(filename, 'w');
    
    % Verificar si el archivo se abrió correctamente
    if fileID == -1
        error('Error al abrir el archivo.');
    end
    
    % Escribir las coordenadas en el archivo .dat
    fprintf(fileID, 'CL   CD   E   alpha\n');
    
    num_points = length(airfoil.CL);
    
    for i = 1:num_points
        fprintf(fileID, '%f   %f   %f   %f\n', ...
            airfoil.CL(i), airfoil.CD(i), airfoil.E(i), airfoil.alpha(i));
    end
    
    % Cerrar el archivo
    fclose(fileID);
end