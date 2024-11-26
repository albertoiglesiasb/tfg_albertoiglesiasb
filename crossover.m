function children = crossover(parents, member_id_count, Cfg)
    % do_crossover Aplica crossover a los padres para obtener los hijos
    %
    % Parameters
    % ----------
    % parents : cell array
    %     Cell array que contiene las estructuras de datos de cada padre.
    % member_id_count : int
    %     Identificador del próximo perfil alar generado.
    %
    % Returns
    % -------
    % children : cell array
    %     Cell array que contiene las estructuras de datos de cada hijo.
    % member_id_count : int
    %     Identificador del próximo perfil alar generado.

    % Número de hijos
    num_child = 1;
    children = cell(length(parents), 1);

    % Número de pares de padres
    num_pairs = floor(length(parents) / 2);

    for pair = 1:num_pairs
        % Seleccionar los índices de los padres
        parent_1_id = 2 * pair - 1;
        parent_2_id = 2 * pair;

        % Extraer la geometría de los padres
        parent_1_geometry = parents{parent_1_id};
        parent_2_geometry = parents{parent_2_id};

        % Extraer las líneas de espesor y curvatura de los padres
        upper_csapi_parent_1 = parent_1_geometry.upper_csapi;
        lower_csapi_parent_1 = parent_1_geometry.lower_csapi;
        upper_csapi_parent_2 = parent_2_geometry.upper_csapi;
        lower_csapi_parent_2 = parent_2_geometry.lower_csapi;

        % Crear las splines de uno de los hijos y sus coordenadas
        [Cfg.PERCENT_CROSS_1, Cfg.PERCENT_CROSS_2] = cross_percentage;
        children{num_child} = airfoil_crossover(upper_csapi_parent_1, lower_csapi_parent_1, upper_csapi_parent_2, lower_csapi_parent_2, Cfg);
        
        member_id_count = member_id_count + 1;
        children{num_child}.id = member_id_count;

        % Se escribe la información de uno de los hijos
        num_child = num_child + 1;
        fprintf(Cfg.log_file, '\t\t Hijo %-3d: ', member_id_count);
        fprintf(Cfg.log_file, '%2.2f%% Padre %-3d + ', Cfg.PERCENT_CROSS_1*100, parents{parent_1_id}.id);
        fprintf(Cfg.log_file, '%2.2f%% Padre %-3d\n', Cfg.PERCENT_CROSS_2*100, parents{parent_2_id}.id);
        fprintf('\t\t Hijo %-3d: ', member_id_count);
        fprintf('%2.2f%% Padre %-3d + ', Cfg.PERCENT_CROSS_1*100, parents{parent_1_id}.id);
        fprintf('%2.2f%% Padre %-3d\n', Cfg.PERCENT_CROSS_2*100, parents{parent_2_id}.id);
        % Crear las splines del otro hijo y sus coordenadas
        [Cfg.PERCENT_CROSS_1, Cfg.PERCENT_CROSS_2] = cross_percentage;
        children{num_child} = airfoil_crossover(upper_csapi_parent_2, lower_csapi_parent_2, upper_csapi_parent_1, lower_csapi_parent_1, Cfg);

        member_id_count = member_id_count + 1;
        children{num_child}.id = member_id_count;

        % Se escribe la información del otro hijo
        num_child = num_child + 1;
        fprintf(Cfg.log_file, '\t\t Hijo %-3d: ', member_id_count);
        fprintf(Cfg.log_file, '%2.2f%% Padre %-3d + ', Cfg.PERCENT_CROSS_1*100, parents{parent_2_id}.id);
        fprintf(Cfg.log_file, '%2.2f%% Padre %-3d\n', Cfg.PERCENT_CROSS_2*100, parents{parent_1_id}.id);
        fprintf('\t\t Hijo %-3d: ', member_id_count);
        fprintf('%2.2f%% Padre %-3d + ', Cfg.PERCENT_CROSS_1*100, parents{parent_2_id}.id);
        fprintf('%2.2f%% Padre %-3d\n', Cfg.PERCENT_CROSS_2*100, parents{parent_1_id}.id);
    end
end