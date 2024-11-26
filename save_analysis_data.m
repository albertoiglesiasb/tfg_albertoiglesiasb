function save_analysis_data(airfoil, analysis_results_folder, best_airfoil)
    % Nombre del archivo .dat
    dat_files = dir(fullfile(analysis_results_folder, '*.dat'));
    num_dat = max(length(dat_files)) + 1;
    if best_airfoil
        filename = fullfile(analysis_results_folder, 'xfoil_result_airfoil_best.dat');
    else
        filename = fullfile(analysis_results_folder, sprintf('xfoil_result_airfoil_%d_%d.dat', airfoil.id, num_dat));
    end
    
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