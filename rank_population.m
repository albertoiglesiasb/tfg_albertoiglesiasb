function ranked_population = rank_population(population)
    % rank_population Ordena una población en función del score y añade ranking.
    % 
    % Inputs:
    %   population - Cell array de estructuras, cada una con un campo 'score'
    %
    % Outputs:
    %   ranked_population - Población ordenada con un campo adicional 'rank'

    % Obtener el número de individuos en la población
    num_individuals = length(population);
    
    % Extraer los scores en un vector
    E_target = zeros(1, num_individuals);
    for i = 1:num_individuals
        if isempty(population{i}.E_target)
            E_target(i) = 0;
        else
            E_target(i) = population{i}.E_target;
        end
    end
    
    % Ordenar los scores en orden descendente y obtener los índices
    [~, sorted_indices] = sort(E_target, 'descend');
    
    % Inicializar la población ordenada
    ranked_population = cell(num_individuals, 1);
    
    % Añadir el campo de ranking y ordenar la población
    for rank = 1:num_individuals
        idx = sorted_indices(rank);
        ranked_population{rank} = population{idx};
        ranked_population{rank}.rank = rank;
    end
end