function evolution_plot = get_evolution_plot(evolution_plot, population, iteration)
    % Inicializa la lista de puntuaciones para la iteración actual
    evolution_plot{iteration} = [];

    % Itera sobre cada miembro de la población
    for i = 1:length(population)
        member = population{i}; % Accede a la estructura dentro del cell array
        
        % Verifica si la puntuación es mayor que la penalización no factible
        if ~isempty(member.E_target)
            % Añade la puntuación a la lista de la iteración actual
            evolution_plot{iteration} = [evolution_plot{iteration}, member.E_target];
        end
    end
end
