function [population, discarted] = reduce_population(population, children)
    % Inicializar la estructura de descartados
    discarted = cell(length(children), 1);
    discarted_count = 1;

    % Obtener el tamaño de la población
    population_size = length(population);
    child_ids = 1:length(children);

    % Índice de rango inicial
    i_rank = population_size;

    % Reemplazar los miembros de menor rango por los hijos con mejor
    % eficiencia
    for child_id = child_ids
        for member_id = 1:population_size
            % Verificar el rango del miembro actual
            if population{member_id}.rank == i_rank
                % Comparar eficiencias
                if ~isempty(population{member_id}.E_target)
                    if children{child_id}.E_target > population{member_id}.E_target
                        % Añadir al diccionario de descartados
                        discarted{discarted_count} = population{member_id};
                        discarted_count = discarted_count + 1;
                        % Reemplazar con el hijo correspondiente
                        population{member_id} = children{child_id};
                        % Reducir el índice de rango
                        i_rank = i_rank - 1;
                        break;
                    else
                        break;
                    end
                else
                    % Añadir al diccionario de descartados
                    discarted{discarted_count} = population{member_id};
                    discarted_count = discarted_count + 1;
                    % Reemplazar con el hijo correspondiente
                    population{member_id} = children{child_id};
                    % Reducir el índice de rango
                    i_rank = i_rank - 1;
                    break;
                end
            end
        end
    end
end
