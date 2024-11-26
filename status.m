function status(population, pBestE, Cfg)
    population = population(~cellfun('isempty',population));
    E_target = zeros(1, length(population));
    for i = 1:length(population)
        if isempty(population{i}.E_target)
            E_target(i) = 0;
        else
            E_target(i) = population{i}.E_target;
        end
    end

    % Encabezados de la tabla
    fprintf(Cfg.log_file, '\t\t %-3s \t %-6s \t %-6s \t|\t  %-3s \t %-6s \t %-6s\n', 'IDs', 'Actual', 'MejorE', 'IDs', 'Actual', 'MejorE');
    fprintf('\n\t\t %-3s \t %-6s \t %-6s \t|\t  %-3s \t %-6s \t %-6s\n', 'IDs', 'Actual', 'MejorE', 'IDs', 'Actual', 'MejorE');
    
    for i = 1:2:length(population)
        if i < length(population)
            % Imprimir ambas columnas (izquierda y derecha)
            fprintf(Cfg.log_file,'\t\t %-3d \t%7.2f \t%7.2f \t|\t  %-3d \t%7.2f \t%7.2f\n', ...
                population{i}.id, E_target(i), pBestE(i), ...
                population{i+1}.id, E_target(i+1), pBestE(i+1));
            fprintf('\t\t %-3d \t%7.2f \t%7.2f \t|\t  %-3d \t%7.2f \t%7.2f\n', ...
                population{i}.id, E_target(i), pBestE(i), ...
                population{i+1}.id, E_target(i+1), pBestE(i+1));
        else
            % Si queda un solo elemento, imprimirlo solo en la izquierda
            fprintf(Cfg.log_file,'\t\t %-3d \t%7.2f \t%7.2f \t|\n', ...
                population{i}.id, E_target(i), pBest(i));
            fprintf('\t\t %-3d \t%7.2f \t%7.2f \t|\n', ...
                population{i}.id, E_target(i), pBest(i));
        end
    end
end
