function max_id = find_id(population)
    % find_id busca el id que sea más alto de la población
    %
    % Inputs:
    %   population - Cell array de estructuras, cada una con un campo 'id'
    %
    % Outputs:
    %   max_id - id más alto dentro de la población

    % Obtener el número de individuos en la población
    num_individuals = length(population);
    
    % Extraer los id en un vector
    id = zeros(1, num_individuals);
    for i = 1:num_individuals
        id(i) = population{i}.id;
    end
    
    % Obtener el id máximo
    max_id = max(id);

end