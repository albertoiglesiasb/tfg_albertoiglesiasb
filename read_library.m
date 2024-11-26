function airfoils_library = read_library(Cfg)
    % Obtener la lista de archivos en la carpeta
    files = dir(fullfile(Cfg.library_dir, '*.dat'));
    num_library = length(files);

    % Verificar que haya suficientes archivos en la carpeta
    if num_library < Cfg.NUM_AIRFOIL_LIBRARY
        airfoils_library = [];
        disp('No hay suficientes archivos en la carpeta para llenar la biblioteca de perfiles.');
        return
    end

    % Seleccionar aleatoriamente los archivos sin repetición
    selected_indices = randperm(num_library, Cfg.NUM_AIRFOIL_LIBRARY);

    % Inicializar la celda para almacenar los perfiles seleccionados
    airfoils_library = cell(Cfg.NUM_AIRFOIL_LIBRARY, 1);

    for i = 1:Cfg.NUM_AIRFOIL_LIBRARY

        % Leer el contenido del archivo
        file_path = fullfile(Cfg.library_dir, files(selected_indices(i)).name);
        fileID = fopen(file_path, 'r');
        data = textscan(fileID, '%f %f', 'HeaderLines', 1);
        fclose(fileID);

        x = data{1};
        z = data{2};
        length_z = length(z);

        % Separar las coordenadas de intradós y extradós
        search = find(z <= 0, 2);
        if search(1) == 1
            mid_point = search(2) - 1;
            x_upper = x(1:mid_point);
            z_upper = z(1:mid_point);
            mid_point = search(2);
            x_lower = x(mid_point:length_z);
            z_lower = z(mid_point:length_z);
        else
            mid_point = search(1)-1;
            x_upper = x(1:mid_point);
            z_upper = z(1:mid_point);
            mid_point = search(1);
            x_lower = x(mid_point:length_z);
            z_lower = z(mid_point:length_z);
        end

        % Se obtienen todas las curvas necesarias del perfil
        airfoils_library{i} = airfoil_geometry(x_upper, z_upper, x_lower, z_lower, Cfg.NUM_POINTS);
        Cfg.LAST_ID = Cfg.LAST_ID + 1;
        airfoils_library{i}.id = Cfg.LAST_ID;
        fprintf(Cfg.log_file, '\t Airfoil %s: %s\n', num2str(airfoils_library{i}.id), file_path);
    end
end