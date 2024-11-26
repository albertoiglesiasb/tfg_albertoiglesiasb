function predefinidos = read_predefined(Cfg)
    % Obtener la lista de archivos en la carpeta
    files = dir(fullfile(Cfg.predefined_dir, '*.txt'));
    
    % Inicializar la celda para almacenar los perfiles
    predefinidos = cell(length(files), 1);
    
    % Leer cada archivo y almacenar sus coordenadas
    for i = 1:length(files)
        file_path = fullfile(Cfg.predefined_dir, files(i).name);
        fileID = fopen(file_path, 'r');
        data = textscan(fileID, '%f %f', 'CollectOutput', 1);
        fclose(fileID);
        
        coordinates = data{1}; % Almacenar las coordenadas
        x = coordinates(:,1);
        z = coordinates(:,2);

        % Separar las coordenadas de intradós y extradós
        mid_point = round(length(x)/2);
        x_upper = x(1:mid_point);
        z_upper = z(1:mid_point);
        x_lower = x(mid_point:end);
        z_lower = z(mid_point:end);

        % Se obtienen todas las curvas necesarias del perfil
        predefinidos{i} = airfoil_geometry(x_upper, z_upper, x_lower, z_lower, Cfg.NUM_POINTS);
        predefinidos{i}.id = i;
        fprintf(Cfg.log_file, '\t Airfoil %s: %s\n', num2str(predefinidos{i}.id), file_path);
    end
    
end
