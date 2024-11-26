function parents = select_parents(population, Cfg)
    % select_parents Selecciona padres de una población basada en sus scores
    %
    % Inputs:
    %   population - Cell array de estructuras, cada una con un campo 'score'
    %   Cfg - Structura con el número de padres
    %
    % Outputs:
    %   parents - Cell array de estructuras seleccionadas como padres

    % Hacer una copia de la población para trabajar con ella
    population_copy = population;
    
    % Inicializar cell array para los padres seleccionados
    parents = cell(Cfg.NUMBER_PARENTS, 1);
    
    for i = 1:Cfg.NUMBER_PARENTS
        % Obtener el número de individuos restantes en la población copia
        num_individuals = length(population_copy);
        
        % Extraer los scores en un vector
        E_target = zeros(1, num_individuals);
        for j = 1:num_individuals
            if ~isempty(population_copy{j}.E_target) && population_copy{j}.E_target > 0
                E_target(j) = population_copy{j}.E_target;
            end
        end

        % Normalizar los scores para usarlos como probabilidades de selección
        normalized_E = E_target / sum(E_target);
        
        % Seleccionar un individuo basado en sus scores normalizados
        selected_idx = roulette_wheel_selection(normalized_E);
        
        % Añadir el individuo seleccionado a los padres
        parents{i} = population_copy{selected_idx};
        
        % Eliminar el individuo seleccionado de la población copia
        population_copy(selected_idx) = [];
    end
end
