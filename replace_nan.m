function new_coords = replace_nan(coords)
    % Reemplaza todos los valores NaN en el vector de coordenadas por 0
    % 
    % Inputs:
    %   coords - Vector de coordenadas que puede contener NaN
    %
    % Outputs:
    %   new_coords - Vector de coordenadas con NaN reemplazados por 0
    
    % Identificar índices de NaN
    nan_indices = isnan(coords);
    
    % Reemplazar NaN por 0
    coords(nan_indices) = 0;
    
    % Devolver el vector modificado
    new_coords = coords;
end
