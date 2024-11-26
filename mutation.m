function children = mutation(children, Cfg)
    % do_mutation Muta la geometría de los perfiles alares de los hijos.
    %
    % Parameters
    % ----------
    % children : cell array
    %     Cell array que contiene las estructuras de datos de cada hijo.
    %
    % Returns
    % -------
    % children : cell array
    %     Cell array que contiene las estructuras de datos de cada hijo.

    % Iterar sobre cada hijo
    for child_id = 1:length(children)
        child = children{child_id};
        
        % Extraer coordenadas de intrados (lower) y extrados (upper)
        x_lower = child.x_lower; % Coordenadas X del intrados
        z_lower = child.z_lower; % Coordenadas Z del intrados
        x_upper = child.x_upper; % Coordenadas X del extrados
        z_upper = child.z_upper; % Coordenadas Z del extrados
        
        length_lower = length(x_lower);
        length_upper = length(x_upper);
        
        % Aplicar mutación a las coordenadas del intrados
        factor_z_lower = 0;
        if rand <= Cfg.PROB_MUTATION_Z
            factor_z_lower = normrnd(1.0, Cfg.WIDTH_MUTATION_Z / 2);
            z_lower = z_lower * factor_z_lower;
        end

        factor_x_lower = 0;
        if rand <= Cfg.PROB_MUTATION_X
            factor_x_lower = normrnd(0.0, Cfg.WIDTH_MUTATION_X / 2);
            for i = 1:length_lower
                factor_x_lower_i = factor_x_lower * sin(pi * x_lower(i));
                x_lower(i) = 1 - (1 - factor_x_lower_i) * (1 - x_lower(i));
            end
        end
        
        % Aplicar mutación a las coordenadas del extrados
        factor_z_upper = 0;
        if rand <= Cfg.PROB_MUTATION_Z
            factor_z_upper = normrnd(1.0, Cfg.WIDTH_MUTATION_Z / 2);
            z_upper = z_upper * factor_z_upper;
        end

        factor_x_upper = 0;
        if rand <= Cfg.PROB_MUTATION_X
            factor_x_upper = normrnd(0.0, Cfg.WIDTH_MUTATION_X / 2);
            for i = 1:length_upper
                factor_x_upper_i = factor_x_upper * sin(pi * x_upper(i));
                x_upper(i) = 1 - (1 - factor_x_upper_i) * (1 - x_upper(i));
            end
        end
        
        % Actualizar las coordenadas en la estructura del hijo
        child.x_lower = x_lower;
        child.z_lower = z_lower;
        child.x_upper = x_upper;
        child.z_upper = z_upper;

        % Actualizar los csapi para upper e lower
        child.upper_csapi = spline(child.x_upper, child.z_upper); % Spline del upper
        child.lower_csapi = spline(child.x_lower, child.z_lower); % Spline del lower
        
        % Guardar la estructura modificada
        children{child_id} = child;
        
        % Imprimir los factores de mutación para depuración en logfile
        fprintf(Cfg.log_file, '\t\t Hijo %d:', child.id);
        fprintf(Cfg.log_file, 'Factor z_lower = %.2f; ', factor_z_lower);
        fprintf(Cfg.log_file, 'Factor x_lower = %.2f;\n', factor_x_lower);
        fprintf(Cfg.log_file, '\t\t\t\t  Factor z_upper = %.2f; ', factor_z_upper);
        fprintf(Cfg.log_file, 'Factor x_upper = %.2f \n', factor_x_upper);
    
        % Imprimir los factores en la barra de comandos
        fprintf('\t\t Hijo %d:', child.id);
        fprintf('Factor z_lower = %.2f; ', factor_z_lower);
        fprintf('Factor x_lower = %.2f\n', factor_x_lower);
        fprintf('\t\t\t\t  Factor z_upper = %.2f; ', factor_z_upper);
        fprintf('Factor x_upper = %.2f\n', factor_x_upper);
    end
end
