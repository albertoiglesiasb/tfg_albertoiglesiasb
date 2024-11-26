function idx = roulette_wheel_selection(probabilities)
    % roulette_wheel_selection Selección por ruleta
    %
    % Inputs:
    %   probabilities - Vector de probabilidades normalizadas
    %
    % Outputs:
    %   idx - Índice del individuo seleccionado

    % Generar un número aleatorio entre 0 y 1
    r = rand;
    
    % Acumulador de probabilidades
    cumulative_probabilities = cumsum(probabilities);
    
    % Encontrar el índice del primer individuo cuya probabilidad acumulada
    % es mayor o igual al número aleatorio generado
    idx = find(cumulative_probabilities >= r, 1, 'first');
end