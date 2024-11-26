function status(population, Cfg)
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
    fprintf(Cfg.log_file,'\t\t %-3s \t %-10s \t %-8s \t %-3s \t %-10s \t %-8s\n', 'IDs', 'Eficiencia', 'Ranking', 'IDs', 'Eficiencia', 'Ranking');
    fprintf('\t\t %-3s \t %-10s \t %-8s \t %-3s \t %-10s \t %-8s\n', 'IDs', 'Eficiencia', 'Ranking', 'IDs', 'Eficiencia', 'Ranking');
    
    for i = 1:2:length(population)
        if i < length(population)
            % Imprimir ambas columnas (izquierda y derecha)
            fprintf(Cfg.log_file,'\t\t %-3d \t %7.2f \t\t%4d \t\t %-3d \t %7.2f \t\t%4d\n', ...
                population{i}.id, E_target(i), population{i}.rank, ...
                population{i+1}.id, E_target(i+1), population{i+1}.rank);
            fprintf('\t\t %-3d \t %7.2f \t\t%4d \t\t %-3d \t %7.2f \t\t%4d\n', ...
                population{i}.id, E_target(i), population{i}.rank, ...
                population{i+1}.id, E_target(i+1), population{i+1}.rank);
        else
            % Si queda un solo elemento, imprimirlo solo en la izquierda
            fprintf(Cfg.log_file,'\t\t %-3d \t %7.2f \t\t%4d\n', ...
                population{i}.id, E_target(i), population{i}.rank);
            fprintf('\t\t %-3d \t %7.2f \t\t%4d\n', ...
                population{i}.id, E_target(i), population{i}.rank);
        end
    end
end
